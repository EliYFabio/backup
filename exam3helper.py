import pandas as pd
import numpy as np
import numpy_financial as npf
import scipy.stats as si


## class
class Project:
    def __init__(self,
                 revenue: list,
                 operating_cost: list,
                 available_capital: list,
                 investment: list):
        self.revenue = revenue
        self.operating_cost = operating_cost
        self.available_capital = available_capital
        self.investment = investment
        self.net = [i + e + a + u for i, e, a, u in zip(revenue, operating_cost, available_capital, investment)]
        self.df = pd.DataFrame({"Revenue": revenue,
                                "Operating cost": operating_cost,
                                "Available capital": available_capital,
                                "Investment": investment,
                                "Net": self.net}).T

    def __sub__(self, other: 'Project') -> 'Project':
        return Project([i - e for i, e in zip(self.revenue, other.revenue)],
                       [i - e for i, e in zip(self.operating_cost, other.operating_cost)],
                       [i - e for i, e in zip(self.available_capital, other.available_capital)],
                       [i - e for i, e in zip(self.investment, other.investment)])

    def NPV(self, risk_free_rate):
        return npf.npv(risk_free_rate, self.net)

    def TIR(self):
        return npf.irr(self.net)

    def call(self, risk_free_rate, sigma, t):
        f_cashflows = [0] + self.net[1:]
        s0 = npf.npv(risk_free_rate, f_cashflows)
        r_cont = np.log(1 + risk_free_rate)
        k = -self.net[0] * np.exp(t * r_cont)
        d1 = (np.log(s0 / k) + (r_cont + (sigma ** 2) / 2) * t) / (sigma * np.sqrt(t))

        d2 = d1 - sigma * np.sqrt(t)
        nd1 = si.norm.cdf(d1)
        nd2 = si.norm.cdf(d2)
        n_d1 = si.norm.cdf(-d1)
        n_d2 = si.norm.cdf(-d2)
        option = s0 * nd1 - k * np.exp(-r_cont * t) * nd2
        return option

    def put(self, risk_free_rate, sigma, t):
        return self.call(risk_free_rate, sigma, t) * -1

    def project_value_c(self, risk_free_rate, sigma, t):
        f_cashflows = [0] + self.net[1:]
        s0 = npf.npv(risk_free_rate, f_cashflows)
        r_cont = np.log(1 + risk_free_rate)
        k = -self.net[0] * np.exp(t * r_cont)
        option = self.call(risk_free_rate, sigma, t)
        project_value = option if s0 > k else option + self.NPV(risk_free_rate)
        return project_value


##problem 1

r = 0.10

# a) find the NVP for the four scenarios
c_rev = [0, 2392, 2356, 3493, 1527, 1395]
c_oc = [0, -1631.00, -1501.00, -1086.00, -1628.00, -1437.00]
c_ac = [2000, 0, 0, 0, 0, 0]
c_inv = [2000.00, 761.00, 855.00, 2407.00, -101.00, -42.00]
current = Project(c_rev, c_oc, c_ac, c_inv)

s1 = 0.45
p1_rev = [0, 4141.20, 4502.40, 1880.40, 4822.80, 5115.605]
p1_oc = [0, -1426.10, -1957.80, -2288.00, -1518.40, -2169.70]
p1_ac = [500, 0, 0, 0, 0, 0]
p1_inv = [-1500, 0, 0, 0, 0, 0]
p1 = Project(p1_rev, p1_oc, p1_ac, p1_inv)

s2 = 0.10
p2_rev = [0, 7092.40,	4525.40,	7597.30,	7303.20,	6665.70]
p2_oc = [0, -5060.80,	-3410.20,	-3495.20,	-3558.10,	-5045.60]
p2_ac = [0, 0, 0, 0, 0, 0]
p2_inv = [-2000, 0, 0, 0, 0, 0]
p2 = Project(p2_rev, p2_oc, p2_ac, p2_inv)

p1_dif = p1 - current
p2_dif = p2 - current
print("a) find the NVP for the four scenarios")
print("Current NVP: ", current.NPV(risk_free_rate=r))
print("Project 1 NVP: ", p1_dif.NPV(risk_free_rate=r))
print("Project 2 NVP: ", p2_dif.NPV(risk_free_rate=r))

# b) How much the company could invest in each scenario to have the possibility to develop each project? (Find the Value of the options)

print("b) Find the Value of the options")
print("Project 1 Call: ", p1_dif.call(risk_free_rate=r, sigma=s1, t=1))
print("Project 2 Call: ", p2_dif.call(risk_free_rate=r, sigma=s2, t=1))

# c) Find the value of projects.
print("c) Find the value of projects.")
print("Project 1 Call: ", p1_dif.project_value_c(risk_free_rate=r, sigma=s1, t=1))
print("Project 2 Call: ", p2_dif.project_value_c(risk_free_rate=r, sigma=s2, t=1))

# d) What scenario would you invest
print("d) What scenario would you invest")
projects = {"Project 1": p1_dif.project_value_c(risk_free_rate=r, sigma=s1, t=1),
            "Project 2": p2_dif.project_value_c(risk_free_rate=r, sigma=s2, t=1)}

max_project_key = max(projects, key=projects.get)
max_project_value = projects[max_project_key]
if max_project_value > 0:
    print(
        f"I would invest in {max_project_key} because it has the highest value of the project which is {max_project_value} .")
else:
    print("I wouldn't invest in any project since all of them have negative values")


#second

