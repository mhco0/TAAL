import matplotlib.pyplot as plt
from src import linsolver as ls
from src import ui as ui

if __name__ == "__main__":
    # Example usage

    ui.connect_callbacks()

    ui.plt.show()

    #points = ls.generate_random_points(10, 0, 10, 0, 10)
    points = ls.np.array(ui.get_clicked_points())
    print(type(points))
    #print(type(ls.np.array(points_ui)))

    print("Generated points:\n", points)

    x_coords = points[:, 0] # x-coordinates of the points
    print(x_coords)
    y_coords = points[:, 1] # y-coordinates of the points
    print(y_coords)
    coeffs = ls.poly_system(x_coords, y_coords, len(x_coords)-1) # Solve the polynomial function as a system of equations
    p = ls.np.poly1d(coeffs[::-1]) # Create a polynomial function from the coefficients
    print(p) # Print the polynomial function
    x = ls.np.linspace(0, 10, 1000)
    print(p(x_coords))
    plt.plot(x, p(x))
    plt.scatter(x_coords, y_coords)

    plt.show()

