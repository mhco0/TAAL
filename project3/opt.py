import numpy as np
from scipy.optimize import minimize

# Define the functions to be used in the approximation
def f1(x):
    return x**2

def f2(x):
    return np.log(x + 1)

def f3(x):
    return np.sqrt(x)

def f4(x):
    return np.exp(-x**2)

# Define the function to be approximated
def f(x):
    return 4*x / (1 + 10*x**2)

# Define the linear combination of functions
def F(x, a):
    return a[0]*f1(x) + a[1]*f2(x) + a[2]*f3(x) + a[3]*f4(x)

# Define the sum of squared errors
def S(a):
    error = 0
    for i in range(len(x_data)):
        error += (F(x_data[i], a) - y_data[i])**2
    return error

# Define the initial guess for the coefficients
a0 = [1, 1, 1, 1]

# Define the data points
x_data = np.linspace(0, 1, 101)
y_data = f(x_data)

# Find the coefficients that minimize the sum of squared errors
res = minimize(S, a0)

# Print the coefficients and the approximate function
print("Coefficients:", res.x)
print("Approximate function: F(x) = {:.3f}x^2 + {:.3f}ln(x+1) + {:.3f}sqrt(x) + {:.3f}e^(-x^2)".format(*res.x))
print(S(res.x))