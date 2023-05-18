from yahoofinancials import YahooFinancials
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

ticker = "IBM" 
yahoo_financials = YahooFinancials(ticker)
data = yahoo_financials.get_historical_price_data("2010-01-01", "2022-08-01", "daily")
df = pd.DataFrame(data[ticker]["prices"])

data=pd.DataFrame(df.adjclose)
data["R"]=data.adjclose.pct_change()
data["r"]=np.log(data.adjclose)-np.log(data.adjclose.shift(1))

So=data.iloc[0]
mu=data.R.mean()
sigma=data.R.std()

k=len(data)
data_model = np.zeros(k)

data_model[0] = So.iloc[0]

W=np.random.normal(loc=0,scale=1,size=k)

for i in range(1,k):
    data_model[i] = data_model[i-1]*np.exp((mu-0.5*sigma**2)+sigma*W[i])

data=pd.DataFrame({"adjclose":data_model})

#%% Quick Report
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

#%%
data["R"]=data.adjclose.pct_change()
data["r"]=np.log(data.adjclose)-np.log(data.adjclose.shift(1))
data.adjclose.plot(title=ticker)
plt.show()


data.R.plot(title=ticker)
plt.show()
data.R.hist()
plt.show()
#%%

data.r.plot(title=ticker, color='g')
plt.show()
data.r.hist(color='g')
plt.show()

Report = dqr(data)


#%%

from scipy import stats

data = data.dropna()
'T-test, para probar medias'
alfa = 0.05
#Ho: son igual
#ha: no son iguales

# prueba 1: validar que la varianza del retorno siemple y log son iguales
W, p2 = stats.levene(data.r, data.R)
if p2<alfa:
    print('Ho puede ser rechazada (No son iguales)')
else:
    print('Ho NO puede ser rechazada (Son iguales)')

# prueba 2: validar que la media del retorno siemple y log NO son iguales    
t, p = stats.ttest_ind(data.r, data.R, equal_var=True)

if p < alfa:
    print('Ho puede ser rechazada (no son iguales)')
else:
    print('Ho No puede ser rechazada (Son iguales)')
    

print("LEFT: ", data.R.mean()-0.5*data.R.var())    
print("RIGHT: ", data.r.mean())    
print("dif: ", data.R.mean()-0.5*data.R.var()-data.r.mean())