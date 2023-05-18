# -*- coding: utf-8 -*-
"""
Created on Tue Feb 14 15:19:49 2023

@author: Carlos Enrique Ruiz Moreno
"""

from yahoofinancials import YahooFinancials
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

ticker = "IBM"
yahoo_financials = YahooFinancials(ticker)
data = yahoo_financials.get_historical_price_data("2010-01-01", "2022-08-01", "daily")
df = pd.DataFrame(data[ticker]["prices"])

data = pd.DataFrame(df.adjclose)

# %%

data["R"] = data.adjclose.pct_change()
data["r"] = np.log(data.adjclose) - np.log(data.adjclose.shift(1))

So = data.iloc[0]
mu = data.R.mean()
sigma = data.R.std()

k = len(data)

data_model = np.zeros(k)
W = np.random.normal(loc=0, scale=1, size=k)
data_model[0] = So.iloc[0]

# %%





for i in range(1, k):
    data_model[i] = data_model[i - 1] * np.exp((mu - 0.5 * sigma ** 2) + sigma * W[i])

# %%
data_model = pd.DataFrame(data_model, columns=["adjclose"])
print(data_model)
# %%

data_model["R"] = data_model.adjclose.pct_change()
data_model["r"] = np.log(data_model.adjclose) - np.log(data_model.adjclose.shift(1))



data.adjclose.plot()
data_model.adjclose.plot()
plt.show()

data.R.plot(title=ticker)
data_model.R.plot(title=ticker)
plt.show()

data.R.hist()
plt.show()
data_model.R.hist()
plt.show()



mu1 = data_model.mean()
sigma1 = data_model.std()
# %%

from scipy import stats

data = data.dropna()
data_model = data_model.dropna()

'T-test, para probar medias'
alfa = 0.05
# Ho: son igual
# ha: no son iguales

# prueba 1: validar que la varianza del retorno simple y log son iguales
W, p2 = stats.levene(data.r, data_model.r)

if p2 < alfa:
    print('Ho puede ser rechazada (No son iguales)')
else:
    print('Ho NO puede ser rechazada (Son iguales)')

# prueba 2: validar que la media del retorno siemple y log NO son iguales  
# SI NO SE CUMPLE TENGO QUE VALIDAR Mr = Mr - 1/2*varianza^2  
t, p = stats.ttest_ind(data.r, data_model.r, equal_var=True)

if p < alfa:
    print('Ho puede ser rechazada (no son iguales)')
else:
    print('Ho NO puede ser rechazada (son iguales)')

k3, p3 = stats.normaltest(data.r)
if p3 < alfa:
    print("Ho puede ser rechazada, No es normal")
else:
    print("Ho NO puede ser rechazada, es normal")

k4, p4 = stats.normaltest(data_model.r)
if p4 < alfa:
    print("Ho puede ser rechazada, No es normal")
else:
    print("Ho NO puede ser rechazada, es normal")
