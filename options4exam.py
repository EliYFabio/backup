import numpy as np
import scipy.stats as st
import pandas as pd
import matplotlib.pyplot as plt
import scipy.stats as si
import sympy as sy
from sympy.stats import Normal, cdf
from scipy.stats import multivariate_normal as mvn
from scipy.optimize import minimize


class Option:
    def __init__(self, S, K, r, v, T):
        self.S = S
        self.K = K
        self.r = r
        self.v = v
        self.T = T

    def __repr__(self):
        rep = f"\n" \
              f"Option fairvalues at s={self.S}, K={self.K}, r={self.r}, v={self.v}, T={self.T}\n" \
              f"---------------------------------------------------------------------\n" \
              f"BS call (European): {self.Call_Fin()}   BS put (European): {self.Put_Fin()} \n" \
              f"CRR call (European): {self.European_CRR(20, 'call')},  CRR put (European): {self.European_CRR(20, 'put')} \n" \
              f"CRR call (American): {self.American_CRR(20, 'call')}, CRR put (American): {self.American_CRR(20, 'put')}"

        return rep

    # Call Fair Price
    def Call_Fin(self):
        S = self.S
        K = self.K
        r = self.r
        v = self.v
        T = self.T
        d1 = (np.log(S / K) + (r + 0.5 * v ** 2) * (T)) / (v * np.sqrt(T))
        d2 = (np.log(S / K) + (r - 0.5 * v ** 2) * (T)) / (v * np.sqrt(T))
        Call_F = S * st.norm.cdf(d1) - np.exp(-r * T) * K * st.norm.cdf(d2)
        return round(Call_F, 5)

    # Put Fair Price
    def Put_Fin(self):
        S = self.S
        K = self.K
        r = self.r
        v = self.v
        T = self.T
        d1 = (np.log(S / K) + (r + 0.5 * v ** 2) * (T)) / (v * np.sqrt(T))
        d2 = (np.log(S / K) + (r - 0.5 * v ** 2) * (T)) / (v * np.sqrt(T))
        Put_F = K * np.exp(-r * T) * st.norm.cdf(-d2) - S * st.norm.cdf(-d1)
        return round(Put_F, 5)

    def European_CRR(self, n, type="call" or "put"):
        # Inputs
        S = self.S
        K = self.K
        r = self.r
        v = self.v
        T = self.T
        dt = T / n
        u = np.exp(v * np.sqrt(dt))
        d = 1. / u
        p = (np.exp(r * dt) - d) / (u - d)

        # Binomial price tree
        stockvalue = np.zeros((n + 1, n + 1))
        decision = np.zeros((n + 1, n + 1))

        stockvalue[0, 0] = S
        for i in range(1, n + 1):
            stockvalue[i, 0] = stockvalue[i - 1, 0] * u
            for j in range(1, i + 1):
                stockvalue[i, j] = stockvalue[i - 1, j - 1] * d

        # option value at final node
        optionvalue = np.zeros((n + 1, n + 1))
        for j in range(n + 1):
            if type == "call":
                optionvalue[n, j] = max(stockvalue[n, j] - K, 0)  # Call
            elif type == "put":
                optionvalue[n, j] = max(K - stockvalue[n, j], 0)  # Put
        # backward calculation for option price
        for i in range(n - 1, -1, -1):
            for j in range(i + 1):
                if type == "call":
                    F1 = np.exp(-r * dt) * (p * optionvalue[i + 1, j] + (1 - p) * optionvalue[i + 1, j + 1])
                    F2 = max(stockvalue[i, j] - K, 0)

                elif type == "put":
                    F1 = np.exp(-r * dt) * (p * optionvalue[i + 1, j] + (1 - p) * optionvalue[i + 1, j + 1])
                    F2 = max(K - stockvalue[i, j], 0)

                optionvalue[i, j] = max(F1, F2)

        # backward calculation for option price
        for i in range(n - 1, -1, -1):
            for j in range(i + 1):
                optionvalue[i, j] = np.exp(-r * dt) * (p * optionvalue[i + 1, j] + (1 - p) * optionvalue[i + 1, j + 1])
        return round(optionvalue[0, 0], 5)

    def American_CRR(self, n, type="call" or "put"):
        S = self.S
        K = self.K
        r = self.r
        v = self.v
        T = self.T
        dt = T / n
        u = np.exp(v * np.sqrt(dt))
        d = 1. / u
        p = (np.exp(r * dt) - d) / (u - d)

        # Binomial price tree
        stockvalue = np.zeros((n + 1, n + 1))
        decision = np.zeros((n + 1, n + 1))

        stockvalue[0, 0] = S
        for i in range(1, n + 1):
            stockvalue[i, 0] = stockvalue[i - 1, 0] * u
            for j in range(1, i + 1):
                stockvalue[i, j] = stockvalue[i - 1, j - 1] * d

        # option value at final node
        optionvalue = np.zeros((n + 1, n + 1))
        for j in range(n + 1):
            if type == "call":
                optionvalue[n, j] = max(stockvalue[n, j] - K, 0)  # Call
            elif type == "put":
                optionvalue[n, j] = max(K - stockvalue[n, j], 0)  # Put

        # backward calculation for option price
        for i in range(n - 1, -1, -1):
            for j in range(i + 1):
                if type == "call":
                    F1 = np.exp(-r * dt) * (p * optionvalue[i + 1, j] + (1 - p) * optionvalue[i + 1, j + 1])
                    F2 = max(stockvalue[i, j] - K, 0)  # call
                elif type == "put":
                    F1 = np.exp(-r * dt) * (p * optionvalue[i + 1, j] + (1 - p) * optionvalue[i + 1, j + 1])
                    F2 = max(K - stockvalue[i, j], 0)  # put
                optionvalue[i, j] = max(F1, F2)
        return round(optionvalue[0, 0], 5)


class Compound:
    def __init__(self, S, X1, X2, T1, T2, r, sigma):
        self.S = S
        self.X1 = X1
        self.X2 = X2
        self.r = r
        self.sigma = sigma
        self.T1 = T1
        self.T2 = T2

    def __repr__(self):
        t = 0
        rep = f"\n" \
              f"Compound option at S={self.S}, X1={self.X1}, X2={self.X2}, r={self.r}, sigma={self.sigma}, T1={self.T1}, T2={self.T2}\n" \
              f"---------------------------------------------------------------------------\n" \
              f"Call_call: {self.Call_call(t)}\n" \
              f"Call_put: {self.Call_put(t)}\n" \
              f"Put_call: {self.Put_call(t)}\n" \
              f"Put_put: {self.Put_put(t)}"
        return rep

    def e_put(self, S, K, T, r, sigma):
        d1 = (np.log(S / K) + (r + 0.5 * sigma ** 2) * T) / (sigma * np.sqrt(T))
        d2 = (np.log(S / K) + (r - 0.5 * sigma ** 2) * T) / (sigma * np.sqrt(T))
        e_put = K * np.exp(-r * T) * st.norm.cdf(-d2) - S * st.norm.cdf(-d1)
        return e_put

    def e_call(self, S, K, T, r, sigma):
        d1 = (np.log(S / K) + (r + 0.5 * sigma ** 2) * T) / (sigma * np.sqrt(T))
        d2 = (np.log(S / K) + (r - 0.5 * sigma ** 2) * T) / (sigma * np.sqrt(T))
        e_call = (S * si.norm.cdf(d1, 0.0, 1.0) - K * np.exp(-r * T) * si.norm.cdf(d2, 0.0, 1.0))
        return e_call

    def SOpt_call(self):
        S = self.S
        X1 = self.X1
        X2 = self.X2
        r = self.r
        sigma = self.sigma
        T1 = self.T1
        T2 = self.T2
        tau = T2 - T1
        bounds = [[0, None]]
        apply_constraint1 = lambda S: self.e_call(S, X2, tau, r, sigma) - X1
        my_constraints = ({'type': 'eq', "fun": apply_constraint1})
        a = minimize(self.e_call, S, bounds=bounds, constraints=my_constraints,
                     method='SLSQP', args=(X2, tau, r, sigma))
        SOpt_call = a.x[0]
        return SOpt_call

    def SOpt_put(self):
        S = self.S
        X1 = self.X1
        X2 = self.X2
        r = self.r
        sigma = self.sigma
        T1 = self.T1
        T2 = self.T2
        tau = T2 - T1
        bounds = [[0, None]]
        apply_constraint1 = lambda S: self.e_put(S, X2, tau, r, sigma) - X1
        my_constraints = ({'type': 'eq', "fun": apply_constraint1})
        a = minimize(self.e_put, S, bounds=bounds, constraints=my_constraints,
                     method='SLSQP', args=(X2, tau, r, sigma))
        SOpt_put = a.x[0]
        return SOpt_put

    def Call_call(self, t):
        S = self.S
        X1 = self.X1
        X2 = self.X2
        r = self.r
        sigma = self.sigma
        T1 = self.T1
        T2 = self.T2
        SOptcall = self.SOpt_call()
        D1 = (np.log(S / SOptcall) + (r + 0.5 * sigma ** 2) * (T1 - t)) / (sigma * np.sqrt(T1 - t))
        D2 = D1 - sigma * np.sqrt(T1 - t)
        E1 = (np.log(S / X2) + (r + 0.5 * sigma ** 2) * (T2 - t)) / (sigma * np.sqrt(T2 - t))
        E2 = E1 - sigma * np.sqrt(T2 - t)

        Corr = np.sqrt(T1 / T2)
        dist = mvn(mean=np.array([0, 0]), cov=np.array([[1, Corr], [Corr, 1]]))
        N2D1E1 = dist.cdf(np.array([D1, E1]))
        N2D2E2 = dist.cdf(np.array([D2, E2]))
        ND2 = si.norm.cdf(D2, 0, 1)

        # El precio del call-call
        Call_call = S * N2D1E1 - X2 * np.exp(-r * (T2 - t)) * N2D2E2 - X1 * np.exp(-r * (T1 - t)) * ND2
        return Call_call

    def Call_put(self, t):
        S = self.S
        X1 = self.X1
        X2 = self.X2
        r = self.r
        sigma = self.sigma
        T1 = self.T1
        T2 = self.T2
        SOptcall = self.SOpt_call()
        print(SOptcall)
        D1 = (np.log(S / SOptcall) + (r + 0.5 * sigma ** 2) * (T1 - t)) / (sigma * np.sqrt(T1 - t))
        D2 = D1 - sigma * np.sqrt(T1 - t)
        E1 = (np.log(S / X2) + (r + 0.5 * sigma ** 2) * (T2 - t)) / (sigma * np.sqrt(T2 - t))
        E2 = E1 - sigma * np.sqrt(T2 - t)

        Corr = np.sqrt(T1 / T2)
        dist = mvn(mean=np.array([0, 0]), cov=np.array([[1, Corr], [Corr, 1]]))
        N2D1E1 = dist.cdf(np.array([-D1, -E1]))
        N2D2E2 = dist.cdf(np.array([-D2, -E2]))
        ND2 = si.norm.cdf(-D2, 0, 1)
        # El precio del call-put
        Call_put = -S * N2D1E1 + X2 * np.exp(-r * (T2 - t)) * N2D2E2 - X1 * np.exp(-r * (T1 - t)) * ND2
        return Call_put

    def Put_call(self, t):
        S = self.S
        X1 = self.X1
        X2 = self.X2
        r = self.r
        sigma = self.sigma
        T1 = self.T1
        T2 = self.T2
        SOptput = self.SOpt_put()
        D1 = (np.log(S / SOptput) + (r + 0.5 * sigma ** 2) * (T1 - t)) / (sigma * np.sqrt(T1 - t))
        D2 = D1 - sigma * np.sqrt(T1 - t)
        E1 = (np.log(S / X2) + (r + 0.5 * sigma ** 2) * (T2 - t)) / (sigma * np.sqrt(T2 - t))
        E2 = E1 - sigma * np.sqrt(T2 - t)

        Corr = -np.sqrt(T1 / T2)
        dist = mvn(mean=np.array([0, 0]), cov=np.array([[1, Corr], [Corr, 1]]))
        N2D1E1 = dist.cdf(np.array([-D1, E1]))
        N2D2E2 = dist.cdf(np.array([-D2, E2]))
        ND2 = si.norm.cdf(-D2, 0, 1)

        # El precio del put-call
        Put_call = -S * N2D1E1 + X2 * np.exp(-r * (T2 - t)) * N2D2E2 + X1 * np.exp(-r * (T1 - t)) * ND2
        return Put_call

    def Put_put(self, t):
        S = self.S
        X1 = self.X1
        X2 = self.X2
        r = self.r
        sigma = self.sigma
        T1 = self.T1
        T2 = self.T2
        SOptput = self.SOpt_put()
        print(SOptput)
        D1 = (np.log(S / SOptput) + (r + 0.5 * sigma ** 2) * (T1 - t)) / (sigma * np.sqrt(T1 - t))
        D2 = D1 - sigma * np.sqrt(T1 - t)
        E1 = (np.log(S / X2) + (r + 0.5 * sigma ** 2) * (T2 - t)) / (sigma * np.sqrt(T2 - t))
        E2 = E1 - sigma * np.sqrt(T2 - t)

        Corr = -np.sqrt(T1 / T2)
        dist = mvn(mean=np.array([0, 0]), cov=np.array([[1, Corr], [Corr, 1]]))
        N2D1E1 = dist.cdf(np.array([D1, -E1]))
        N2D2E2 = dist.cdf(np.array([D2, -E2]))
        ND2 = si.norm.cdf(D2, 0, 1)

        # El precio del put-put
        Put_put = S * N2D1E1 - X2 * np.exp(-r * (T2 - t)) * N2D2E2 + X1 * np.exp(-r * (T1 - t)) * ND2
        return Put_put

"""
St = 500
K = 200
T = 2
sigma = 0.3
r = 0.1
n = 20
print(Option(St, K, r, sigma, T))
"""

S = 200
x1 = 20
x2 = 250
r = 0.05
sigma = 0.5
t2 = 3
t1 = 2
t = 0
geske=Compound(S, x1, x2, t1, t2, r, sigma)
print(geske.Call_put(t))
