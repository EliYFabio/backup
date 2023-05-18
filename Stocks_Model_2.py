
"""
Created on Tue Feb 14 18:15:10 2023

@author: 001684781

"""

#lnSn = lnSn_n-1 + (mu - (sigma^s/2))n + sigma*Wn
# E[lnSn] = E[lnSn_n-1 + (mu - (sigma^s/2))n + sigma*Wn]

#MODEL 2
# ST = St * e^[(mu-simga^2/2) (T-t) + sigma(T-t)]

#MODEL 3
# dlnSti = (mu - sigma^2/2)dti + sigma * dWti


#%% Model 2

from yahoofinancials import YahooFinancials
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

ticker = "AMZN" # GOOG  #HPQ   #HPE
yahoo_financials = YahooFinancials(ticker)
data = yahoo_financials.get_historical_price_data("2010-02-01", "2022-02-01", "daily")
df = pd.DataFrame(data[ticker]["prices"])

data=pd.DataFrame(df.adjclose)

#%%

data["R"] = data.adjclose.pct_change()
data["r"] = np.log(data.adjclose) - np.log(data.adjclose.shift(1))

So = data.iloc[0,0] #
mu = data.R.mean()
sigma = data.R.std()

mu_Y = (1 + mu)**(360/1)-1 #convertir el valor de mu diario a anual
sigma_Y = sigma * np.sqrt(252)

T = 0.5
t = 0


#%%
W1 = np.random.normal(loc = 0, scale = 1, size = 1)
ST = So * np.exp(((mu_Y - 0.5 * sigma_Y**2)*(T-t)) + sigma_Y * np.sqrt(T - t) * W1)

#%% for k simulation

k = 100
ST_array = np.zeros(k)
ST_array[0] = So
W1_array =  np.random.normal(loc = 0, scale = 1, size = k)

for i in range(1, k-1):
    
    ST_array[i] = So * np.exp(((mu_Y - 0.5 * sigma_Y**2)*(T-t)) + sigma_Y * np.sqrt(T - t) * W1_array[i])

from scipy.stats import norm   
T = 0.001
   
Mu_logST = np.log(So)+(mu_Y-0.5*sigma_Y**2)*(T-t)
sigma_logST=np.sqrt((sigma_Y**2)*(T-t))

# P(St > 10) la probabilidad de que el precio sea mayor a 10.
# z = (10 - mu)/sigma
Q1 = 1 - norm.cdf(np.log(So), loc = Mu_logST, scale = sigma_logST)
print(T,"; ",Q1)


T = 0.25
   
Mu_logST = np.log(So)+(mu_Y-0.5*sigma_Y**2)*(T-t)
sigma_logST=np.sqrt((sigma_Y**2)*(T-t))

# P(St > 10) la probabilidad de que el precio sea mayor a 10.
# z = (10 - mu)/sigma
Q1 = 1 - norm.cdf(np.log(So), loc = Mu_logST, scale = sigma_logST)
print(T,"; ",Q1)

T = 0.5
   
Mu_logST = np.log(So)+(mu_Y-0.5*sigma_Y**2)*(T-t)
sigma_logST=np.sqrt((sigma_Y**2)*(T-t))

# P(St > 10) la probabilidad de que el precio sea mayor a 10.
# z = (10 - mu)/sigma
Q1 = 1 - norm.cdf(np.log(So), loc = Mu_logST, scale = sigma_logST)
print(T,"; ",Q1)


T = 1
   
Mu_logST = np.log(So)+(mu_Y-0.5*sigma_Y**2)*(T-t)
sigma_logST=np.sqrt((sigma_Y**2)*(T-t))

# P(St > 10) la probabilidad de que el precio sea mayor a 10.
# z = (10 - mu)/sigma
Q1 = 1 - norm.cdf(np.log(So), loc = Mu_logST, scale = sigma_logST)
print(T,"; ",Q1)

T = 1

Mu_logST = np.log(So) + (mu_Y - 0.5 * sigma_Y ** 2) * (T - t)
sigma_logST = np.sqrt((sigma_Y ** 2) * (T - t))

# P(St > 10) la probabilidad de que el precio sea mayor a 10.
# z = (10 - mu)/sigma
Q2 =  norm.cdf(np.log(11), loc=Mu_logST, scale=sigma_logST) - norm.cdf(np.log(7), loc=Mu_logST, scale=sigma_logST)
print(T, "; ", Q2)