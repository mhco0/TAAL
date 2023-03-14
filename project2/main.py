from src import linsolver as ls
from src import ui as ui

def create_approximation():
    points = ls.np.array(ui.get_clicked_points())
    #print(ui.get_clicked_points())
    ui.plt.clf()


    print("Generated points:\n", points)

    if len(points) == 0:
        print("No point generated exiting")
        ui.plt.close()
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
    
    ui.plt.ylim([ui.YMIN_LIMIT, ui.YMAX_LIMIT])
    ui.plt.plot(x, p(x))
    ui.plt.scatter(x_coords, y_coords)

    ui.plt.draw()

if __name__ == "__main__":
    # Example usage
    ui.connect_callbacks()
    ui.set_creation_callback(create_approximation)
    ui.plt.show()

    

