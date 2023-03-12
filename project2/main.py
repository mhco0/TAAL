from src import linsolver as ls
from src import ui as ui

if __name__ == "__main__":
    # Example usage
    ui.connect_callbacks()
    ui.plt.show()

    points = ls.np.array(ui.get_clicked_points())
    #print(ui.get_clicked_points())

    print("Generated points:\n", points)

    if len(points) == 0:
        print("No point generated exiting")
        exit()
    
    x_coords = points[:, 0] # x-coordinates of the points
    #print(x_coords)
    y_coords = points[:, 1] # y-coordinates of the points
    #print(y_coords)
    coeffs = ls.poly_system(x_coords, y_coords, len(x_coords)-1) # Solve the polynomial function as a system of equations
    p = ls.np.poly1d(coeffs[::-1]) # Create a polynomial function from the coefficients
    
    print(p) # Print the polynomial function
    x = ls.np.linspace(ui.XMIN_LIMIT, ui.XMAX_LIMIT, 1000)
    print(p(x_coords))
    
    ui.plt.plot(x, p(x))
    ui.plt.scatter(x_coords, y_coords)

    ui.plt.show()

