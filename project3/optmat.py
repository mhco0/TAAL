import numpy as np

# Define the functions
f1 = lambda x: x**2
f2 = lambda x: np.log(x+1)
f3 = lambda x: np.sqrt(x)
f4 = lambda x: np.exp(-x**2)

f = lambda x: 4*x/(1 + 10*x**2)

# Define the data
x = np.linspace(0, 1, 101)
y = f(x)

# Define the matrix A
A = np.vstack([f1(x), f2(x), f3(x), f4(x)]).T

# Compute the least squares solution for the coefficients
c = np.linalg.pinv(A) @ y

# Construct the approximate function
f = lambda x: c[0]*f1(x) + c[1]*f2(x) + c[2]*f3(x) + c[3]*f4(x)

# Print the coefficients and the approximate function
print("Coefficients:", c)
print("Approximate function:", f)