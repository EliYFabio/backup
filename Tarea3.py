import numpy as np


n = 10000
rf = 0.02
m = 0.1

alfa = np.random.normal(loc=.08, scale=.05, size=n)
beta = np.random.uniform(low=.5, high=1, size=n)

i = 0
rf = .02
m = .1
capm = alfa + beta * (m - rf) + rf
print((capm.mean()))
print((capm.std())**2)