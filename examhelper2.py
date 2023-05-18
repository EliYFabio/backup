import pandas as pd
import numpy as np
import numpy_financial as npf
import scipy.stats as si
from sympy.solvers import solve
from sympy import Symbol


## problem 2

class Project:
    def __init__(self, s, k, r, t, sigma):
        self.s = s
        self.k = k
        self.r = r
        self.t = t
        self.sigma = sigma
        self.pv = False

    def t0(self):
        if self.pv == False:
            self.s = [self.s[i] / (1 + self.r) ** i for i in range(len(self.s))]
            self.k = [self.k[i] / (1 + self.r) ** i for i in range(len(self.k))]
            self.pv = True

    def NPV(self):
        if self.pv == True:
            self.s0=sum(self.s)
            self.k0= sum(self.k)
            return sum(self.s) - sum(self.k)
        else:
            self.s0 = npf.npv(self.r, self.s)
            self.k0 = npf.npv(self.r, self.k)
            return npf.npv(self.r, self.s) - npf.npv(self.r, self.k)

    def ROA_call(self):
        r_continua=np.log(1+self.r)
        d1 = (np.log(self.s0 / self.k0) + (r_continua + (self.sigma ** 2) / 2) * self.t) / (self.sigma * np.sqrt(self.t))
        d2 = d1 - self.sigma * np.sqrt(self.t)
        nd1 = si.norm.cdf(d1)
        nd2 = si.norm.cdf(d2)
        option = self.s0 * nd1 - self.k0 * np.exp(-r_continua * self.t) * nd2
        return option

    def project_value_c(self):
        project_value = self.ROA_call() if self.s0 > self.k0 else self.ROA_call()  + self.NPV()
        return project_value

t = 3
sigma = 0.45
r = .10

s = [0, 0, 0, 0, 150, 150, 150, 150, 150, 50, 50, 50, 50, 50]
k = [0, 0, 0, 800, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]


p = Project(s, k, r, t, sigma)
p.t0()
print(p.NPV())
print(p.ROA_call())
print(p.project_value_c())

def fun(k):
    t = 3
    sigma = 0.45
    r = .10
    s = [0, 0, 0, 0, 150, 150, 150, 150, 150, 50, 50, 50, 50, 50]
    k = [0, 0, 0, k, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    p = Project(s, k, r, t, sigma)
    p.NPV()
    return p.project_value_c()

x=np.linspace(897,900,100000)
i=0
j=1
while j>0.00001:
    j=fun(x[i])
    i+=1
k_p_eq_0=x[i-1]
err=j

print(k_p_eq_0)
print(j)