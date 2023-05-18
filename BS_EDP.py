import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D


# Parameters
S_max = 200  # Maximum stock price
N = 200      # Number of time steps
M = 200      # Number of price steps
r = 0.01     # Risk-free interest rate
sigma = 0.3  # Volatility
T = 1.0      # Time to maturity
K = 100


# Define the grid
dS = S_max / M
dt = T / N

# Build the matrix
diagonal = np.zeros(M - 1)
upper_diagonal = np.zeros(M - 2)
lower_diagonal = np.zeros(M - 2)

for i in range(M - 1):
    diagonal[i] = 1 + r * dt + (sigma ** 2) * (i + 1) ** 2 * dt
    if i < M - 2:
        lower_diagonal[i] = -0.5 * (sigma ** 2) * (i + 1) ** 2 * dt + 0.5 * r * (i + 1) * dt
        upper_diagonal[i] = -0.5 * (sigma ** 2) * (i + 1) ** 2 * dt - 0.5 * r * (i + 1) * dt

A = np.diag(diagonal) + np.diag(upper_diagonal, 1) + np.diag(lower_diagonal, -1)

# Solve the system of equations
P = np.zeros((M + 1, N + 1))
S = np.linspace(0, S_max, M + 1)
P[:, 0] = np.maximum(S - K, 0)

for j in range(N):
    P[1:M, j + 1] = np.dot(A, P[1:M, j])

# Plot the results
fig = plt.figure(figsize=(10, 6))
ax = fig.add_subplot(111, projection='3d')

X, Y = np.meshgrid(np.linspace(0, T, N + 1), S)
ax.plot_surface(X, Y, P.T, cmap='coolwarm')
ax.set_xlabel('Time')
ax.set_ylabel('Stock Price')
ax.set_zlabel('Option Price')
plt.show()
