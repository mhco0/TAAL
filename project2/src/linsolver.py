import numpy as np

def generate_random_points(n, xmin, xmax, ymin, ymax):
    x = np.random.uniform(xmin, xmax, n)
    y = np.random.uniform(ymin, ymax, n)
    points = np.vstack((x, y)).T
    return points

# Example usage: generate 10 random points with x between 0 and 1 and y between -1 and 1

# https://pt.wikipedia.org/wiki/Matriz_de_Vandermonde
def poly_system(x, y, n):
    # Solve the polynomial function as a system of equations
    m = len(x)
    A = np.zeros((m, n + 1))
    for i in range(m):
        A[i, :] = [x[i] ** j for j in range(n + 1)]
    b = y
    coeffs = np.linalg.solve(A, b)
    return coeffs
