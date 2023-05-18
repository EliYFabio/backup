from optiontools.options import European
opt = European(So=50, K=52, rf=0.01, sigma=0.15, T=1, option_type='call')
print(opt.price())
print(opt.delta())

a=[1,2,0,0]
A=2
b=[3,4,5]
B=3
print(a[:A]+b[:B])