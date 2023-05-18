import numpy as np
from scipy.stats import norm

class FairValue:
    def __init__(self, st, k, r, sigma, t1, t2):
        self.st = st
        self.k = k
        self.r = r
        self.sigma = sigma
        self.t1 = t1
        self.t2 = t2
    def european_call(self, call: bool = True):
        if call:
            return black_scholes(self.st, self.k, self.r, self.sigma, self.t1, self.t2)
        else:
            return -black_scholes(self.st, self.k, self.r, -self.sigma, self.t1, self.t2)




class Derivative:
    def __init__(self, func):
        self.func = func

    def __call__(self, obj, *args, var_index=0, h=0.00001):
        new_args = list(args)
        x = new_args[var_index]
        new_args[var_index] = x + h
        f1 = self.func(obj, *new_args)
        new_args[var_index] = x - h
        f2 = self.func(obj, *new_args)
        return (f1 - f2) / (2 * h)



def d1(st, k, r, sigma, t1, t2):
    numerator = np.log(st / k) + (r + 0.5 * sigma ** 2) * (t2 - t1)
    denominator = sigma * np.sqrt(t2 - t1)
    d = numerator / denominator
    return d


def d2(st, k, r, sigma, t1, t2):
    numerator = np.log(st / k) + (r - 0.5 * sigma ** 2) * (t2 - t1)
    denominator = sigma * np.sqrt(t2 - t1)
    d = numerator / denominator
    return d


def black_scholes(st, k, r, sigma, t1, t2):
    d_1 = d1(st=st, k=k, r=r, sigma=sigma, t1=t1, t2=t2)
    d_2 = d2(st=st, k=k, r=r, sigma=sigma, t1=t1, t2=t2)
    c = st * norm.cdf(d_1) - k * np.exp(-r * (t2 - t1)) * norm.cdf(d_2)
    print(d_1,d_2)
    return c


class Option:
    def __init__(self, st, k, r, sigma, t1, t2):
        self.st = st
        self.k = k
        self.r = r
        self.sigma = sigma
        self.t1 = t1
        self.t2 = t2

    def __repr__(self):
        return f"Option(st={self.st},k={self.k},r={self.r},sigma={self.sigma},t1={self.t1},t2={self.t2})"

    @property
    def d1(self):
        d = d1(st=self.st, k=self.k, r=self.r, sigma=self.sigma, t1=self.t1, t2=self.t2)
        return d

    @property
    def d2(self):
        d = d2(st=self.st, k=self.k, r=self.r, sigma=self.sigma, t1=self.t1, t2=self.t2)
        return d

    def fair_value(self, call: bool = True):
        if call:
            return black_scholes(self.st, self.k, self.r, self.sigma, self.t1, self.t2)
        else:
            return -black_scholes(self.st, self.k, self.r, -self.sigma, self.t1, self.t2)






st_1 = 20
k_1 = 20
r_1 = 0.03
sigma_1 = 0.3
t1_1 = 0
t2_1 = 1



