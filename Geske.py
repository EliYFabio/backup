import numpy as np
import scipy.stats as si
import sympy as sy
from sympy.stats import Normal, cdf

from scipy.stats import multivariate_normal as mvn
from scipy.optimize import minimize


def e_call(S, K, T, r, sigma):
    d1 = (np.log(S / K) + (r + 0.5 * sigma ** 2) * T) / (sigma * np.sqrt(T))
    d2 = (np.log(S / K) + (r - 0.5 * sigma ** 2) * T) / (sigma * np.sqrt(T))
    call = (S * si.norm.cdf(d1, 0.0, 1.0) - K * np.exp(-r * T) * si.norm.cdf(d2, 0.0, 1.0))
    return call


def SOpt_call(S, X1, X2, T1, T2, r, sigma):
    tau = T2 - T1
    call = e_call(S, X2, tau, r, sigma)
    bounds = [[None, None]]
    apply_constraint1 = lambda S: e_call(S, X2, tau, r, sigma) - X1
    my_constraints = ({'type': 'eq', "fun": apply_constraint1})

    a = minimize(e_call, S, bounds=bounds, constraints=my_constraints, method="SLSQP", args=(X2, tau, r, sigma))
    SOpt = a.x[0]
    return SOpt


def Call_call(S, X1, X2, T1, T2, r, sigma):
    SOpt = SOpt_call(S, X1, X2, T1, T2, r, sigma)
    D1 = (np.log(S / SOpt) + (r + 0.5 * sigma ** 2) * (T1 - t)) / (sigma * np.sqrt(T1 - t))
    D2 = D1 - sigma * np.sqrt(T1 - t)

    E1 = (np.log(S / X2) + (r + 0.5 * sigma ** 2) * (T2 - t)) / (sigma * np.sqrt(T2 - t))
    E2 = E1 - sigma * np.sqrt(T2 - t)

    Corr = np.sqrt(T1 / T2)
    dist = mvn(mean=np.array([0, 0]), cov=np.array([[1, Corr], [Corr, 1]]))
    N2D1E1 = dist.cdf(np.array([D1, E1]))
    N2D2E2 = dist.cdf(np.array([D2, E2]))
    ND2 = si.norm.cdf(D2, 0.0, 1.0)

    Call_call = S * N2D1E1 - X2 * np.exp(-r * (T2 - t)) * N2D2E2 - X1 * np.exp(-r * (T1 - t)) * ND2
    return Call_call


S, r, sigma = 80, 0.05, 0.3

T2 = 3
T1 = 1
X1 = 10
X2 = 100
t = 0

print(Call_call(S, X1, X2, T1, T2, r, sigma))
# print(SOpt,D1,D2,E1,E2)

S, r, sigma = 100, 0.05, 0.3

T2 = 3
T1 = 1
X1 = 10
X2 = 100
t = 0
EscA = e_call(S, X2, T2, r, sigma)
EscB = Call_call(S, X1, X2, T1, T2, r, sigma)

SOpt=SOpt_call(S, X1, X2, T1, T2, r, sigma)
Eva_T1=e_call(80,X2,T2-T1,r,sigma)

print(EscA, EscB)
