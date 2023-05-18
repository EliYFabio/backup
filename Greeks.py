import numpy as np
import scipy.stats as si


def d1_(S, k, r, sigma, t, T):
    return (np.log(S / k) + (r + 0.5 * sigma ** 2) * (T - t)) / (sigma * np.sqrt(T - t))


def d2_(S, k, r, sigma, t, T):
    return d1_(S, k, r, sigma, t, T) - sigma * np.sqrt(T - t)


class greeks:
    def __init__(self, S, k, r, sigma, t, T):

        self.S = S
        self.k = k
        self.r = r
        self.sigma = sigma
        self.t = t
        self.T = T
        self.tau = T - t

        self.d1 = d1_(S, k, r, sigma, t, T)
        self.d2 = d2_(S, k, r, sigma, t, T)

    # First order
    def delta(self, type):
        if type == 'call':
            return si.norm.cdf(self.d1)
        elif type == 'put':
            return -si.norm.cdf(-self.d1)

    def vega(self):
        return S * si.norm.pdf(self.d1) * np.sqrt(self.tau)

    def theta(self, type):
        if type == 'call':
            return ((self.S * si.norm.pdf(self.d1) * self.sigma) / (2 * np.sqrt(self.tau))) - self.r * self.k * np.exp(
                -self.r * self.tau) * si.norm.cdf(self.d2) + self.r * self.S * si.norm.cdf(self.d1)
        elif type == 'put':
            return ((self.S * si.norm.pdf(self.d1) * self.sigma) / (2 * np.sqrt(self.tau))) + self.r * self.k * np.exp(
                -self.r * self.tau) * si.norm.cdf(-self.d2) - self.r * self.S * si.norm.cdf(-self.d1)

    def rho(self, type):
        if type == 'call':
            return self.k * self.tau * np.exp(-self.r * self.tau) * si.norm.cdf(self.d2)
        elif type == 'put':
            return -self.k * self.tau * np.exp(-self.r * self.tau) * si.norm.cdf(-self.d2)

    def epsilon(self, type):
        if type == 'call':
            return -self.S * self.tau * si.norm.cdf(self.d1)
        elif type == 'put':
            return self.S * self.tau * si.norm.cdf(-self.d1)

    def gamma(self):
        return (si.norm.pdf(self.d1)) / (self.S * self.sigma * np.sqrt(self.tau))

    def vanna(self):
        return si.norm.pdf(self.d1) * (self.d2 / self.sigma)

    def charm(self):
        return si.norm.pdf(self.d1) * ((2 * self.r * self.tau - self.d2 * self.sigma * np.sqrt(self.tau)) / (
                2 * self.tau * sigma * np.sqrt(self.tau)))

    def vomma(self):
        return self.vega() * ((self.d1 * self.d2) / self.sigma)

    def psi(self):
        return np.exp(-self.r * self.tau) * (1 / self.k) * (
                1 / np.sqrt(2 * np.pi * self.sigma ** 2 * self.tau)) * np.exp(
            -(1 / (2 * self.sigma ** 2 * self.tau)) * (
                    np.log(self.k / self.S) - (self.r - (1 / 2) * (self.sigma ** 2)) * self.tau) ** 2)

    def speed(self):
        return (-self.gamma() / self.S) * ((self.d1 / (self.sigma * np.sqrt(self.T - self.t))) + 1)

    # Third order

    def zomma(self):
        return self.gamma() * ((self.d1 * self.d2 - 1) / (self.sigma))

    def color(self):
        return -((si.norm.pdf(self.d1)) / (2 * self.S * self.tau * self.sigma * np.sqrt(self.tau))) * (1 + (
                    (2 * self.r * self.tau - self.d2 * self.sigma * np.sqrt(self.tau)) / (
                        self.sigma * np.sqrt(self.tau))) * self.d1)

    def ultima(self):
        return (-self.vega() / self.sigma ** 2) * (
                    self.d1 * self.d2 * (1 - self.d1 * self.d2) + self.d1 ** 2 + self.d2 ** 2)


# Parameters
S = np.array([20, 10])
k = np.array([20, 10])
r = np.array([0.03, 0.02])
sigma = np.array([0.3, 0.2])
t = np.array([0, 1])
T = np.array([1, 2])

G = greeks(S, k, r, sigma, t, T)
print(G.delta("call"))
print(G.delta("put"))
print(G.vega())
print(G.theta('call'))
print(G.theta('put'))
print(G.rho('call'))
print(G.rho('put'))
print(G.epsilon('call'))
print(G.epsilon('put'))
print(G.gamma())
print(G.vanna())
print(G.charm())
print(G.vomma())
print(G.psi())
print(G.speed())
print(G.zomma())
print(G.color())
print(G.ultima())
