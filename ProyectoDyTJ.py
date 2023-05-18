import numpy as np
from scipy import sparse
from scipy.sparse.linalg import spsolve
import matplotlib.pyplot as plt
## set variables for the exercise

S0 = 80.0 # current price (spot)
X0 = np.log(S0) # logarithmic price
K = 100.0 # exercise price (strike)
T = 1.0 # maturity (years)
r = 0.05 # risk-free interest rate
sig = 0.1 # volatility

Nspace = 3000 # number of space steps
Ntime = 2000 # number of time steps

S_max = 3 * float(K) # maximum price
S_min = float(K) / 3 # minimum price

x_max = np.log(S_max) # upper limit of space grid
x_min = np.log(S_min) # lower limit of space grid

x, dx = np.linspace(x_min, x_max, Nspace, retstep=True) # discretize the space domain
T, dt = np.linspace(0, T, Ntime, retstep=True) # discretize the time domain
Payoffcall = np.maximum(np.exp(x) - K, 0) # call option payoff
Payoffput = np.maximum(K - np.exp(x), 0) # call option payoff


Vc = np.zeros((Nspace, Ntime)) # initialize the grid
Vp = np.zeros((Nspace, Ntime)) # initialize the grid
offsetc = np.zeros(Nspace - 2) # vector to be used for the boundary terms
offsetp = np.zeros(Nspace - 2) # vector to be used for the boundary terms


Vc[:, -1] = Payoffcall # terminal condition
Vc[-1, :] = np.exp(x_max) - K * np.exp(-r * T[::-1]) # boundary condition
Vc[0, :] = 0 # boundary condition

Vp[:, -1] = Payoffput # terminal condition
Vp[-1, :] = K * np.exp(-r * T[::-1]) - np.exp(x_max) # boundary condition
Vp[0, :] = 0 # boundary condition

sig2 = sig * sig # squared volatility
dxx = dx * dx # squared space step

a = ((dt / 2) * ((r - 0.5 * sig2) / dx - sig2 / dxx))
b = (1 + dt * (sig2 / dxx + r))
c = (-(dt / 2) * ((r - 0.5 * sig2) / dx + sig2 / dxx))

D = sparse.diags([a, b, c], [-1, 0, 1], shape=(Nspace - 2, Nspace - 2)).tocsc() # create sparse matrix

## Solve PDE backward in time

for i in range(Ntime-2,-1,-1):
    offsetc[0] = a * Vc[0,i]
    offsetc[-1] = c * Vc[-1,i]
    Vc[1:-1,i] = spsolve( D, (Vc[1:-1,i+1] - offsetc))
    offsetp[0] = a * Vp[0, i]
    offsetp[-1] = c * Vp[-1, i]
    Vp[1:-1, i] = spsolve(D, (Vp[1:-1, i + 1] - offsetp))

oPriceCall = np.interp(X0, x, Vc[:,0])# calculate option price at time t=0
oPricePut = np.interp(X0, x, Vp[:,0])# calculate option price at time t=0

print(oPriceCall,oPricePut)

S = np.exp(x) # convert log prices to original prices
fig = plt.figure(figsize=(15, 6)) # create a figure object
ax1 = fig.add_subplot(121) # create a subplot for a 2D plot
ax2 = fig.add_subplot(122, projection='3d') # create a subplot for a 3D plot


X, Y = np.meshgrid(T, S)
ax2.plot_surface(Y, X, Vc, cmap="CMRmap")
ax2.set_title("BS price surface V(s,t) Call")
ax2.set_xlabel("S"); ax2.set_ylabel("t"); ax2.set_zlabel("V")
ax2.view_init(20, -95) # this function rotates the 3d plot

# plot the 2D graph of price vs spot
ax1.plot(S, Payoffcall, color='red',label="Payoff (call)")
ax1.plot(S, Vc[:,0], color='green',label="BS curve")
ax1.set_xlim(60,170); ax1.set_ylim(0,50)
ax1.set_xlabel("S"); ax1.set_ylabel("price")
ax1.legend(loc='upper left'); ax1.set_title("BS price vs spot at t=0 Call")

plt.show()

fig2 = plt.figure(figsize=(15, 6)) # create a figure object
ax3 = fig2.add_subplot(121) # create a subplot for a 2D plot
ax4 = fig2.add_subplot(122, projection='3d') # create a subplot for a 3D plot

X, Y = np.meshgrid(T, S)
ax4.plot_surface(Y, X, Vp, cmap="CMRmap")
ax4.set_title("BS price surface V(s,t) Put")
ax4.set_xlabel("S"); ax4.set_ylabel("t"); ax4.set_zlabel("V")
ax4.view_init(20, -90) # this function rotates the 3d plot


ax3.plot(S, Payoffput, color='red', label="Payoff (put)")
ax3.plot(S, Vp[:, 0], color='green', label="BS curve")
ax3.set_xlim(60, 170); ax3.set_ylim(0, 50)
ax3.set_xlabel("S"); ax3.set_ylabel("price")
ax3.legend(loc='upper right'); ax3.set_title("BS price vs spot at t=0 Put")

plt.show()