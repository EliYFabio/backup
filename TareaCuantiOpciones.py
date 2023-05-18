import numpy as np
import scipy.stats as si
import matplotlib.pyplot as plt
from scipy.stats import norm


def crr_price(S, K, T, r, sigma, n, option_type):
    delta_t = T / n
    u = np.exp(sigma * np.sqrt(delta_t))
    d = 1 / u
    p = (np.exp(r * delta_t) - d) / (u - d)
    f = np.zeros((n + 1, n + 1))
    for j in range(n + 1):
        f[n, j] = max(0, (1 if option_type == 'call' else -1) * (S * u * j * d * (n - j) - K))
    for i in range(n - 1, -1, -1):
        for j in range(i + 1):
            f[i, j] = np.exp(-r * delta_t) * (p * f[i + 1, j + 1] + (1 - p) * f[i + 1, j])
            if option_type == 'call':
                f[i, j] = max(f[i, j], S * u * j * d * (i - j) - K)
            else:
                f[i, j] = max(f[i, j], K - S * u * j * d * (i - j))
    return f[0, 0]


def bs_price(S, K, T, r, sigma, option_type):
    d1 = (np.log(S / K) + (r + 0.5 * sigma ** 2) * T) / (sigma * np.sqrt(T))
    d2 = d1 - sigma * np.sqrt(T)
    if option_type == 'call':
        return S * si.norm.cdf(d1) - K * np.exp(-r * T) * si.norm.cdf(d2)
    else:
        return K * np.exp(-r * T) * si.norm.cdf(-d2) - S * si.norm.cdf(-d1)


def crr_american_price(S, K, T, r, sigma, n, option_type):
    delta_t = T / n
    u = np.exp(sigma * np.sqrt(delta_t))
    d = 1 / u
    p = (np.exp(r * delta_t) - d) / (u - d)
    f = np.zeros((n + 1, n + 1))
    for j in range(n + 1):
        f[n, j] = max(0, (1 if option_type == 'call' else -1) * (S * u * j * d * (n - j) - K))
    for i in range(n - 1, -1, -1):
        for j in range(i + 1):
            f[i, j] = np.exp(-r * delta_t) * (p * f[i + 1, j + 1] + (1 - p) * f[i + 1, j])
            if option_type == 'call':
                f[i, j] = max(f[i, j], S * u * j * d * (i - j) - K)
            else:
                f[i, j] = max(f[i, j], K - S * u * j * d * (i - j))
            if option_type == 'call':
                early_exercise = S * u * j * d * (i - j) - K
            else:
                early_exercise = K - S * u * j * d * (i - j)
            f[i, j] = max(f[i, j], early_exercise)
    return f[0, 0]


S = 100
K = 90
T = 1
r = 0.05
sigma = 0.2
tolerance = 0.0001

n_put = 10
n_call = 10
crr_put_prices = []
crr_call_prices = []
errors_put = []
errors_call = []
bs_put_price_n = bs_price(S, K, T, r, sigma, 'put')
bs_call_price_n = bs_price(S, K, T, r, sigma, 'call')

while True:
    crr_put_price_n = crr_price(S, K, T, r, sigma, n_put, 'put')
    crr_put_prices.append(crr_put_price_n)
    errors_put.append(abs(crr_put_price_n - bs_put_price_n))
    if errors_put[-1] < tolerance:
        break
    n_put += 10

while True:
    crr_call_price_n = crr_price(S, K, T, r, sigma, n_call, 'call')
    crr_call_prices.append(crr_call_price_n)
    errors_call.append(abs(crr_call_price_n - bs_call_price_n))
    if errors_call[-1] < tolerance:
        break
    n_call += 10

print(f'Convergence for Put option achieved after {n_put} steps')
plt.plot(range(10, n_put + 1), crr_put_prices[10:], label='CRR')
plt.hlines(bs_put_price_n, label='B&S')
plt.xlabel('Number of steps')
plt.ylabel('Option price')
plt.title('Convergence of CRR model to B&S model (put option)')
plt.legend()
plt.show()

print(f'Convergence for Call option achieved after {n_call} steps')
plt.plot(range(10, n_call + 1), crr_call_prices[10:], label='CRR')
plt.hlines(bs_call_price_n, label='B&S')
plt.xlabel('Number of steps')
plt.ylabel('Option price')
plt.title('Convergence of CRR model to B&S model (put option)')
plt.legend()
plt.show()

american_call_price = crr_american_price(S, K, T, r, sigma, n_call, 'call')
american_put_price = crr_american_price(S, K, T, r, sigma, n_put, 'put')

print(f'American call CRR model price: {american_call_price:.4f}')
print(f'American put CRR model price: {american_put_price:.4f}')

american_call_price = crr_price(S, K, T, r, sigma, n_call, 'call')
american_put_price = crr_price(S, K, T, r, sigma, n_put, 'put')

print(f'American call CRR model price: {american_call_price:.4f}')
print(f'American put CRR model price: {american_put_price:.4f}')

american_call_price = crr_price(S, K, T, r, sigma, n_call, 'call')
american_put_price = crr_price(S, K, T, r, sigma, n_put, 'put')

print(f'European call CRR model price: {american_call_price:.4f}')
print(f'European put CRR model price: {american_put_price:.4f}')

european_call_price = bs_price(S, K, T, r, sigma, 'call')
european_put_price = bs_price(S, K, T, r, sigma, 'put')

print(f'European call price: {european_call_price:.4f}')
print(f'European put price: {european_put_price:.4f}')


def n_conversion(self, error):
    bs = self.bs_price
    se = 0
    x = []
    y = []
    i = 1
    for i in range(1, 10001):
        crr = self.price_crr(i)
        se += (crr - bs) ** 2
        mse = se / i
        if (i % 10 == 0):
            print(f"MSE at step {i}: {mse}")
            x += [i]
            y += [mse]
        if mse < error:
            break
    os.system("cls")
    plt.plot(x, y)
    plt.show()
    return i



error=0.001 #si quieres 0.0001 cambialo pero se va a tardar décadas porque es el mean squared error

S = 50  # initial underlying asset price
r = 0.05  # risk-free interest rate
K = 52  # strike price
v = 0.26  # volatility
T = 1
c_type = "call"

call_option = Option(S, r, K, v, T, c_type)
n = call_option.n_conversion(error)
print("Number of steps: ", n)
print("BlackScholes Price (Eurocall): ", call_option.bs_price)
print("CRR Price (Eurocall): ", call_option.price_crr(n))
print("CRR Price (Americall)",call_option.price_crr_american(n))
put_option = Option(S, r, K, v, T, "put")
print("BlackScholes Price (Europut): ", put_option.bs_price)
print("CRR Price (Europut): ", put_option.price_crr(n))
print("CRR Price (Ameriput)",put_option.price_crr_american(n))
