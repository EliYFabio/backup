import numpy as np
import scipy.stats as si
import matplotlib.pyplot as plt
import os

class Option:
    def __init__(self, S, r, K, v, T, c_type):
        self.S = S
        self.r = r
        self.K = K
        self.v = v
        self.T = T
        self.c_type = c_type

    import numpy as np

    def price_crr(self, n):
        dt = T / n
        u = np.exp(v * np.sqrt(dt))
        d = 1.0 / u
        p = (np.exp(r * dt) - d) / (u - d)

        # Calculate stock values
        j = np.arange(n + 1)
        stockvalue = S * u ** j * d ** (n - j)

        # Calculate option values
        if self.c_type =="call":
            optionvalue = np.maximum(stockvalue-K, 0)
        elif self.c_type=="put":
            optionvalue = np.maximum(K - stockvalue, 0)
        # Backward iteration for option pricing
        for i in range(n - 1, -1, -1):
            optionvalue[:-1] = np.exp(-r * dt) * (p * optionvalue[1:] + (1 - p) * optionvalue[:-1])

        return optionvalue[0]

    @property
    def bs_price(self):
        d1 = (np.log(self.S / self.K) + (self.r + 0.5 * self.v ** 2) * self.T) / (self.v * np.sqrt(self.T))
        d2 = d1 - self.v * np.sqrt(self.T)
        if self.c_type == 'call':
            return self.S * si.norm.cdf(d1) - self.K * np.exp(-self.r * self.T) * si.norm.cdf(d2)
        elif self.c_type == 'put':
            return self.K * np.exp(-self.r * self.T) * si.norm.cdf(-d2) - self.S * si.norm.cdf(-d1)

    def n_conversion(self, error):
        bs = self.bs_price
        se = 0
        x = []
        y = []
        i = 1
        for i in range(1, 10001):
            crr = self.price_crr(i)
            se += (crr - bs) ** 2
            mse = se / i
            if (i % 10 == 0):
                print(f"MSE at step {i}: {mse}")
                x += [i]
                y += [mse]
            if mse < error:
                break
        os.system("cls")
        plt.plot(x, y)
        plt.show()
        return i

    def price_crr_american(self, n):
        dt = T / n
        u = np.exp(self.v * np.sqrt(dt))
        d = 1.0 / u
        p = (np.exp(r * dt) - d) / (u - d)

        stockvalue = np.zeros((n + 1, n + 1))
        stockvalue[0, 0] = self.S

        for i in range(1, n + 1):
            stockvalue[i, 0] = stockvalue[i - 1, 0] * u
            for j in range(1, i + 1):
                stockvalue[i, j] = stockvalue[i - 1, j - 1] * d

        optionvalue = np.zeros((n + 1, n + 1))
        for j in range(n + 1):
            if self.c_type=="call":
                optionvalue[n, j] = max(stockvalue[n, j]-K, 0)
            elif self.c_type=="put":
                optionvalue[n, j] = max(K - stockvalue[n, j], 0)

        for i in range(n - 1, -1, -1):
            for j in range(i + 1):
                if self.c_type == "call":
                    exercise_value = max(stockvalue[i, j] - K, 0)
                elif self.c_type == "put":
                    exercise_value = max(K - stockvalue[i, j], 0)
                hold_value = np.exp(-r * dt) * (p * optionvalue[i + 1, j] + (1 - p) * optionvalue[i + 1, j + 1])
                optionvalue[i, j] = max(exercise_value, hold_value)

        return optionvalue[0, 0]




error=0.0001 #si quieres 0.0001 cambialo pero se va a tardar décadas porque es el mean squared error

S = 50  # initial underlying asset price
r = 0.05  # risk-free interest rate
K = 52  # strike price
v = 0.26  # volatility
T = 1
c_type = "put"

my_option = Option(S, r, K, v, T, c_type)
n = my_option.n_conversion(error)
print("Number of steps ",n)
print("BlackScholes Price (Europut)", my_option.bs_price)
print("CRR Price (Europut)", my_option.price_crr(n))
print("CRR Price (Ameriput)",my_option.price_crr_american(n))

call_option=Option(S, r, K, v, T, "call")
print("BlackScholes Price (Eurocall)", call_option.bs_price)
print("CRR Price (Eurocall)", call_option.price_crr(n))
print("CRR Price (Americall)",call_option.price_crr_american(n))

