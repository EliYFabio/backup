from typing import Callable
import numpy as np
import matplotlib.pyplot as plt
import sys
from typing import Iterable, Union, List
from numbers import Number

from mpl_toolkits.mplot3d import Axes3D

class Vector(list):
    def __init__(self, data: Union[Iterable, List[Iterable]]) -> None:
        if isinstance(data[0], Iterable):
            super().__init__([Vector(sub_data) for sub_data in data])
        else:
            super().__init__(data)

    def __sub__(self, other: Union[Iterable, Number]) -> 'Vector':
        if isinstance(other, Iterable):
            other = Vector(other)
            if len(self) != len(other):
                raise ValueError("vectors must have the same length")
            return Vector([a - b for a, b in zip(self, other)])
        elif isinstance(other, Number):
            return Vector([a - other for a in self])
        else:
            raise TypeError("unsupported operand type(s) for -: 'Vector' and '{}'".format(type(other).__name__))

    def __add__(self, other: Union[Iterable, Number]) -> 'Vector':
        if isinstance(other, Iterable):
            other = Vector(other)
            if len(self) != len(other):
                raise ValueError("vectors must have the same length")
            return Vector([a + b for a, b in zip(self, other)])
        elif isinstance(other, Number):
            return Vector([a + other for a in self])
        else:
            raise TypeError("unsupported operand type(s) for +: 'Vector' and '{}'".format(type(other).__name__))

    def __mul__(self, other: Union[Iterable, Number]) -> 'Vector':
        if isinstance(other, Iterable):
            other = list(other)
            if len(self) != len(other):
                raise ValueError("vectors must have the same length")
            return Vector([a * b for a, b in zip(self, other)])
        elif isinstance(other, Number):
            return Vector([a * other for a in self])
        else:
            raise TypeError("unsupported operand type(s) for *: 'Vector' and '{}'".format(type(other).__name__))

    def __truediv__(self, other: Union[Iterable, Number]) -> 'Vector':
        if isinstance(other, Iterable):
            other = list(other)
            if len(self) != len(other):
                raise ValueError("vectors must have the same length")
            return Vector([a / b for a, b in zip(self, other)])
        elif isinstance(other, Number):
            return Vector([a / other for a in self])
        else:
            raise TypeError("unsupported operand type(s) for /: 'Vector' and '{}'".format(type(other).__name__))

    def __pow__(self, other: Union[Iterable, Number]) -> 'Vector':
        if isinstance(other, Iterable):
            other = list(other)
            if len(self) != len(other):
                raise ValueError("vectors must have the same length")
            return Vector([a ** b for a, b in zip(self, other)])
        elif isinstance(other, Number):
            return Vector([a ** other for a in self])
        else:
            raise TypeError("unsupported operand type(s) for **: 'Vector' and '{}'".format(type(other).__name__))

    def transpose(self) -> 'Vector':
        if isinstance(self[0], Iterable):
            return Vector([Vector(col) for col in zip(*self)])
        else:
            return self

    @staticmethod
    def meshvec(x: Iterable, y: Iterable) -> 'Vector':
        V = Vector([[[xi for xi in x] for _ in y], [[yi for _ in x] for yi in y]])
        return V

    @property
    def ndim(self):
        counter = 1
        if isinstance(self[0], Iterable):
            counter += self[0].ndim

        return counter

    def vplot(self) -> None:
        if not isinstance(self[0], Iterable):
            plt.plot(self)
            plt.show()
        elif len(self) == 2:
            plt.plot(self[0], self[1])
            plt.show()

        elif len(self) == 3:
            fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
            ax.plot_surface(self[0], self[1], self[2], cmap='coolwarm',
                            linewidth=0, antialiased=False)

            plt.show()


def larger(x: Iterable, y: Union[Iterable, Number]) -> Vector:
    if isinstance(y, Iterable):
        if Vector(x).ndim == 1:
            return Vector([max(i, j) for i, j in zip(x, y)])
        else:
            return Vector([larger(i, j) for i, j in zip(x, y)])
    elif isinstance(y, Number):
        if Vector(x).ndim == 1:
            return Vector([max(i, y) for i in x])
        else:
            return Vector([larger(i, y) for i in x])


class BlackScholes:
    def __init__(self,
                 fun: Callable[[Vector, Vector], Vector],
                 s: Vector,
                 t: Vector,
                 r: float,
                 K: float,
                 sigma: float,
                 der_step: float = 0.0001):
        self.V = fun
        self.s = s
        self.t = t
        self.r = r
        self.K = K
        self.sigma = sigma
        self.der_step = der_step

    @property
    def dVdt(self) -> Callable[[Vector, Vector], Vector]:
        def partial(s: Vector, t: Vector) -> Vector:
            h = Vector([self.der_step] * len(s))
            return (self.V(s, t + h) - self.V(s, t)) / h

        return partial

    @property
    def dVds(self) -> Callable[[Vector, Vector], Vector]:
        def partial(s: Vector, t: Vector) -> Vector:
            h = Vector([self.der_step] * len(s))
            return (self.V(s + h, t) - self.V(s, t)) / h

        return partial

    @property
    def d2Vds2(self) -> Callable[[Vector, Vector], Vector]:
        def partial(s: Vector, t: Vector) -> Vector:
            h = Vector([self.der_step] * len(s))
            return (self.dVds(s + h, t) - self.dVds(s, t)) / h

        return partial

    @property
    def solution(self) -> Callable[[Vector, Vector], Vector]:
        def solu(s: Vector, t: Vector) -> Vector:
            return (self.dVdt(s, t) + (self.d2Vds2(s, t) / 2) * self.sigma ** 2 * s ** 2 + \
                    self.dVds(s, t) * self.r * s - self.V(s, t) * self.r)*-1

        return solu


v1 = Vector([2, 4, 6, 8, 10, 12, 14, 16, 18, 20])
v2 = Vector([1, 1, 1, 1, 1, 1, 1, 1, 1, 1])


def C(s, t):
    k = 1
    return (s - k * np.exp(1) ** t)


k = 10

s, t = Vector.meshvec(np.linspace(-10, 20, 10), np.linspace(-10, 20, 10))
B = BlackScholes(C, s, t, 0.05, k, .3)
sol = B.solution


Vector([s,t,sol(s, t)]).vplot()
Vector([s,t,C(s,t)]).vplot()
#Vector([s,t,sol(s, t)-C(s,t)]).vplot()

# c = Vector([s,t,z])
# print(c)
# c.vplot()

# print(C(v1, v2))
# Vector([v1,C(v1,v2)]).vplot()
