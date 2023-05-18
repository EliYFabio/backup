import pandas as pd
import numpy as np
from scipy.stats import norm

s0 = 50
k = 52
t = 1
r = 0.05
u = 1.2
d = 0.8
n = 2
dt = t / n
sigma = np.log(u) / np.sqrt(dt)
sigma = np.round(sigma, 2)


def d1_(S, k, r, sigma, t, T):
    return (np.log(S / k) + (r + 0.5 * sigma ** 2) * (T - t)) / (sigma * np.sqrt(T - t))


def d2_(S, k, r, sigma, t, T):
    return d1_(S, k, r, sigma, t, T) - sigma * np.sqrt(T - t)


d1 = d1_(s0, k, r, sigma, 0, t)
d2 = d2_(s0, k, r, sigma, 0, t)

nd1=norm.cdf(d1)
nd2=norm.cdf(d2)

n_d1=norm.cdf(-d1)
n_d2=norm.cdf(-d2)


option=s0*nd1-k*np.exp(-r*t)*nd2
u=np.exp(sigma*np.sqrt(dt))
d=1/u


print(d)
