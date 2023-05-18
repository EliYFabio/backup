import math

class Option:
    def __init__(self, type, spot, strike, t, r, sigma):
        self.type = type
        self.spot = spot
        self.strike = strike
        self.t = t
        self.r = r
        self.sigma = sigma

    def d1(self):
        return (math.log(self.spot/self.strike) + (self.r + 0.5 * self.sigma**2) * self.t) / (self.sigma * math.sqrt(self.t))

    def d2(self):
        return (math.log(self.spot/self.strike) + (self.r - 0.5 * self.sigma**2) * self.t) / (self.sigma * math.sqrt(self.t))

    def blackscholes(self):
        d1 = self.d1()
        d2 = self.d2()

        if self.type == "call":
            return self.spot * math.exp(-self.r * self.t) * math.norm.cdf(d1) - self.strike * math.exp(-self.r * self.t) * math.norm.cdf(d2)
        else:
            return self.strike * math.exp(-self.r * self.t) * math.norm.cdf(-d2) - self.spot * math.exp(-self.r * self.t) * math.norm.cdf(-d1)

    def delta(self):
        d1 = self.d1()

        if self.type == "call":
            return math.exp(-self.r * self.t) * math.norm.cdf(d1)
        else:
            return math.exp(-self.r * self.t) * (math.norm.cdf(d1) - 1)

    def theta(self):
        d1 = self.d1()
        d2 = self.d2()

        if self.type == "call":
            return -self.spot * math.exp(-self.r * self.t) * math.norm.pdf(d1) * self.sigma / (2 * math.sqrt(self.t)) - self.r * self.strike * math.exp(-self.r * self.t) * math.norm.cdf(d2) + self.r * self.spot * math.exp(-self.r * self.t) * math.norm.cdf(d1)
        else:
            return -self.spot * math.exp(-self.r * self.t) * math.norm.pdf(d1) * self.sigma / (2 * math.sqrt(self.t)) + self.r * self.strike * math.exp(-self.r * self.t) * math.norm.cdf(-d2) - self.r * self.spot * math.exp(-self.r * self.t) * math.norm.cdf(-d1
