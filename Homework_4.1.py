# -*- coding: utf-8 -*-
"""
Created on Tue Feb 14 11:53:36 2023

@author: Carlos Enrique Ruiz Moreno
"""

from yahoofinancials import YahooFinancials
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


#%% Pull data and compute simple and log-normal return

ticker = "IBM" 
yahoo_financials = YahooFinancials(ticker)
data = yahoo_financials.get_historical_price_data("2002-01-01", "2012-08-01", "daily")
df = pd.DataFrame(data[ticker]["prices"])

data=pd.DataFrame(df.adjclose)

data["R"]=data.adjclose.pct_change()
data["r"]=np.log(data.adjclose)-np.log(data.adjclose.shift(1))

#%% Compute descriptive statistic for Rt and rt

def dqr(data):
    
    cols = pd.DataFrame(list(data.columns.values),
                           columns=['Name'],
                           index=list(data.columns.values))
    dtyp = pd.DataFrame(data.dtypes,columns=['Type'])
    misval = pd.DataFrame(data.isnull().sum(),
                                  columns=['N/A value'])
    presval = pd.DataFrame(data.count(),
                                  columns=['Count values'])
    unival = pd.DataFrame(columns=['Unique values'])
    minval = pd.DataFrame(columns=['Min'])
    maxval = pd.DataFrame(columns=['Max'])
    mean =pd.DataFrame(data.mean(), columns=['Mean']) 
    Std =pd.DataFrame(data.std(), columns=['Std']) 
    Var =pd.DataFrame(data.var(), columns=['Var']) 
    median =pd.DataFrame(data.median(), columns=['Median']) 
    
    skewness = pd.DataFrame(data.skew(), columns=['Skewness']) 
    kurtosis = pd.DataFrame(data.kurtosis(), columns=['Kurtosis']) 

    for col in list(data.columns.values):
        unival.loc[col] = [data[col].nunique()]
        try:
            minval.loc[col] = [data[col].min()]
            maxval.loc[col] = [data[col].max()]
        except:
            pass
    
    # Juntar todas las tablas
    return cols.join(dtyp).join(misval).join(presval).join(unival).join(minval).join(maxval).join(mean).join(Std).join(Var).join(median).join(skewness).join(kurtosis)

Report = dqr(data)

#%% Plot histograms for both Rt and rt

data.R.plot(title=ticker)
plt.show()
data.R.hist()

data.r.plot(title=ticker)
plt.show()
data.r.hist()

#%% Data 1

yahoo_financials = YahooFinancials(ticker)
data1 = yahoo_financials.get_historical_price_data("2010-01-01", "2020-08-01", "daily")
df1 = pd.DataFrame(data1[ticker]["prices"])

data1=pd.DataFrame(df1.adjclose)

data1.adjclose.plot(title=ticker)

data1["R"]=data.adjclose.pct_change()
data1["r"]=np.log(data.adjclose)-np.log(data.adjclose.shift(1))

#%% Perform statistical inferences

from scipy import stats

data = data.dropna()
data1 = data1.dropna()

'T-test, para probar medias'
alfa = 0.05
#Ho: son igual
#ha: no son iguales

# prueba 1: validar que la varianza del retorno simple y log son iguales
W, p2 = stats.levene(data.r, data1.r)
if p2<alfa:
    print('Ho puede ser rechazada (No son iguales)')
else:
    print('Ho NO puede ser rechazada (Son iguales)')

# prueba 2: validar que la media del retorno siemple y log NO son iguales  
# SI NO SE CUMPLE TENGO QUE VALIDAR Mr = Mr - 1/2*varianza^2  
t, p = stats.ttest_ind(data.r, data1.r, equal_var=True)

if p < alfa:
    print('Ho puede ser rechazada (no son iguales)')
else:
    print('Ho NO puede ser rechazada (son iguales)')
    

k3, p3 = stats.normaltest(data.r)
if p3 < alfa:
    print("Ho puede ser rechazada, No es normal") 
else:
    print("Ho NO puede ser rechazada, es normal")

k4, p4 = stats.normaltest(data1.r)
if p4 < alfa:
    print("Ho puede ser rechazada, No es normal") 
else:
    print("Ho NO puede ser rechazada, es normal")
    
#%% Comments and conclusions
# As we can see in the statistical inferences tests, the behaviour of the
# variance of the simple returns and the logarithmic returns of the IBM
# stocks are the same, meanwhile the mean of this returns is different,
# telling us that the null hypothesis cannot be rejected. Also, the ML is
# telling us that the distribution of the returns doesn't belong to a 
# normal distribution, so we can reject the null hypothesis.

sigma = data["adjclose"].var()
rt = data["R"] - (sigma * np.exp(2))/2
rt