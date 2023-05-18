import matplotlib.pyplot as plt
import numpy as np
import tkinter as tk
from scipy.stats import norm, uniform, expon

def plot_distribution(dist, params):
    fig, ax = plt.subplots()
    if dist == "Normal":
        mu, sigma = params
        x = np.linspace(mu - 3*sigma, mu + 3*sigma, 100)
        y = norm.pdf(x, mu, sigma)
        ax.plot(x, y, label="Normal Distribution")
    elif dist == "Uniform":
        a, b = params
        x = np.linspace(a, b, 100)
        y = uniform.pdf(x, a, b-a)
        ax.plot(x, y, label="Uniform Distribution")
    elif dist == "Exponential":
        lam = params[0]
        x = np.linspace(0, 5/lam, 100)
        y = expon.pdf(x, 0, 1/lam)
        ax.plot(x, y, label="Exponential Distribution")
    ax.legend()
    plt.show()

def select_distribution():
    dist = var.get()
    params = []
    if dist == "Normal":
        mu = float(entry_mu.get())
        sigma = float(entry_sigma.get())
        params = [mu, sigma]
    elif dist == "Uniform":
        a = float(entry_a.get())
        b = float(entry_b.get())
        params = [a, b]
    elif dist == "Exponential":
        lam = float(entry_lam.get())
        params = [lam]
    plot_distribution(dist, params)

app = tk.Tk()
app.title("Distribution Plotter")

var = tk.StringVar()
var.set("Normal")

tk.Label(app, text="Distribution:").grid(row=0, column=0)

dist_menu = tk.OptionMenu(app, var, "Normal", "Uniform", "Exponential")
dist_menu.grid(row=0, column=1)

frame = tk.Frame(app)
frame.grid(row=1, column=0, columnspan=2)

tk.Label(frame, text="Mean (μ):").grid(row=0, column=0)
entry_mu = tk.Entry(frame)
entry_mu.grid(row=0, column=1)
entry_mu.insert(0, "0")

tk.Label(frame, text="Standard Deviation (σ):").grid(row=1, column=0)
entry_sigma = tk.Entry(frame)
entry_sigma.grid(row=1, column=1)
entry_sigma.insert(0, "1")

tk.Label(frame, text="Start (a):").grid(row=0, column=2)
entry_a = tk.Entry(frame)
entry_a.grid(row=0, column=3)
entry_a.insert(0, "0")

tk.Label(frame, text="End (b):").grid(row=1, column=2)
entry_b = tk.Entry(frame)
entry_b.grid(row=1, column=3)
entry_b.insert(0, "1")

tk.Label(frame, text="Lambda (λ):").grid(row=0, column=4)
entry_lam = tk.Entry(frame)
entry_lam.grid(row=0, column=5)
entry_lam.insert(0, "1")

button = tk.Button(app, text="Plot", command=select_distribution)
button.grid(row=2, column=0, columnspan=2, pady=10)

app.mainloop()