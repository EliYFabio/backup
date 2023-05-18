from yahoofinancials import YahooFinancials
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

ticker = "IBM" 
yahoo_financials = YahooFinancials(ticker)
data = yahoo_financials.get_historical_price_data("2000-01-01", "2010-01-01", "daily")
df = pd.DataFrame(data[ticker]["prices"])

data = pd.DataFrame(df.adjclose)


data["R"]=data.adjclose.pct_change()
data["r"]=np.log(data.adjclose)-np.log(data.adjclose.shift(1))


data_1 = yahoo_financials.get_historical_price_data("2010-01-01", "2022-08-01", "daily")
df_1 = pd.DataFrame(data_1[ticker]["prices"])

data_1 = pd.DataFrame(df.adjclose)


data_1["R"]=data_1.adjclose.pct_change()
data_1["r"]=np.log(data_1.adjclose)-np.log(data_1.adjclose.shift(1))







from scipy import stats
data = data.dropna()
data_1 = data_1.dropna()
alfa = 0.05
#Ho: son igual
#ha: no son iguales

# prueba 1: validar que la varianza del retorno siemple y log son iguales
W, p2 = stats.levene(data.r, data_1.r)
if p2<alfa:
    print('Ho puede ser rechazada (No son iguales)')
else:
    print('Ho NO puede ser rechazada (Son iguales)')

# prueba 2: validar que la media del retorno siemple y log NO son iguales    
t, p = stats.ttest_ind(data.r, data_1.r, equal_var=True)

if p < alfa:
    print('Ho puede ser rechazada (no son iguales)')
else:
    print('Ho no puede ser rechazada (son iguales)')
    

print("LEFT: ", data.R.mean()-0.5*data.R.var())    
print("RIGHT: ", data.r.mean())    
print("dif: ", data.R.mean()-0.5*data.R.var()-data.r.mean())