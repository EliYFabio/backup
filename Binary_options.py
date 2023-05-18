import numpy as np
import scipy.stats as si
from scipy.optimize import minimize

import functools
import numpy as np


def partial_derivative(func):
    def wrapper(self):
        h = 1e-6  # step size for numerical differentiation
        params = [getattr(self, attr) for attr in func.__code__.co_varnames[1:]]  # get the parameter values
        idx = func.__code__.co_varnames.index(
            'x') - 1  # get the index of the parameter to differentiate with respect to
        params[idx] += h
        fxh = func(self, *params)
        params[idx] -= 2 * h
        fxnh = func(self, *params)
        return (fxh - fxnh) / (2 * h)  # compute the numerical derivative

    return wrapper


# Options

class Option:
    def __init__(self, st, k, r, sigma, t1, t2):
        self.st = st
        self.k = k
        self.r = r
        self.sigma = sigma
        self.t1 = t1
        self.t2 = t2

    @staticmethod
    def d1_fun(st, k, r, sigma, t1, t2):
        return np.log(st / k) + (r + 0.5 * sigma ** 2) * (t2 - t1) / sigma * np.sqrt(t2 - t1)

    @property
    def d1(self):
        return np.log(self.st / self.k) + (self.r - 0.5 * self.sigma ** 2) * (self.t2 - self.t1) / self.sigma * np.sqrt(
            self.t2 - self.t1)

    @property
    def d2(self):
        return np.log(self.st / self.k) + (self.r - 0.5 * self.sigma ** 2) * (self.t2 - self.t1) / self.sigma * np.sqrt(
            self.t2 - self.t1)


# Binary Asset or Nothing


# Put
# S_t N(-d_1)

# Call
# S_t N(d_1)

class BinaryAssetOrNothing(Option):
    def fairvalueput(self):
        return self.st * si.norm.cdf(-self.d1)

    def fairvaluecall(self):
        return self.st * si.norm.cdf(self.d1)

    @partial_derivative
    def delta_call(self, st):
        return BinaryAssetOrNothing(st, self.k, self.r, self.sigma, self.t1, self.t2).fairvaluecall()


# Remember Put+Call=S_t N(-d_1)+S_t N(d_1)=St

# Binary Cash or Nothing

# Put
# ke^{-r(T-t)} N(-d_2)

# Call
# ke^{-r(T-t)} N(d_2)
class BinaryCashOrNothing(Option):
    def fairvalueput(self):
        return self.k * np.exp(-self.r * (self.t2 - self.t1)) * si.norm.cdf(-self.d2)

    def fairvaluecall(self):
        return self.k * np.exp(-self.r * (self.t2 - self.t1)) * si.norm.cdf(self.d2)


# Financial

# Put
# PutBin^{CN}-PutBin^{AN}


# Call
# CallBin^{AN}-CallBin^{CN}

class Financial(Option):
    def binarys(self):
        an = BinaryAssetOrNothing(self.st, self.k, self.r, self.sigma, self.t1, self.t2)
        cn = BinaryCashOrNothing(self.st, self.k, self.r, self.sigma, self.t1, self.t2)
        return [an, cn]

    def fairvalueput(self):
        bins = self.binarys()
        an = bins[0].fairvalueput()
        cn = bins[1].fairvalueput()
        return cn - an

    def fairvaluecall(self):
        bins = self.binarys()
        an = bins[0].fairvaluecall()
        cn = bins[1].fairvaluecall()
        return an - cn

    def delta_call(self):
        return self.fairvaluecall


st = 20
k = 20
r = 0.03
sigma = 0.3
t1 = 0
t2 = 1

fin = BinaryAssetOrNothing(st, k, r, sigma, t1, t2)
# print(BinaryAssetOrNothing.delta_call(20))
# Greeks

option = BinaryAssetOrNothing(100, 50, 0.05, 0.2, 0, 1)  # create an instance of the class
delta_call = partial_derivative(option.delta_call)  # apply the decorator to the delta_call method
#print(option.delta_call(20))  # call the original method to compute the function value
#print(delta_call(20))

def sum(a,b):
    return a+b

