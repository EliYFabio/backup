import numpy as np
import pandas as pd
import scipy as sc

data=pd.read_csv("C:/Users/fabio/Downloads/15843604B-1-2023.csv")
data.pop(data.columns[0])
print(data.std())
print(data.mean())
print(data.min())
print(data.max())
