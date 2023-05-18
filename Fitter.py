from fitter import Fitter ,get_common_distributions, get_distributions

import pandas as pd


RawData = pd.read_csv('Data_OilCompany.csv')


data = RawData.iloc[:,1]

dist = ['gamma', 'lognorm', 'beta', 'burr', 'norm']
dist = get_common_distributions()

f = Fitter(data, distributions = dist)

f.fit()

f.summary()

print(f.get_best())