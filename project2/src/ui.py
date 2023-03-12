import matplotlib.pyplot as plt


DIFFERENCE_TO_CONSIDER_SAME_X = 1e-3
clicked_points = []
fig, ax = plt.subplots()
ax.set_xlim(0, 10)
ax.set_ylim(0, 10)
scatter = ax.scatter([], [])

def on_scree_click(event):
    global clicked_points
    global DIFFERENCE_TO_CONSIDER_SAME_X

    # Checks if the click was in the plot
    if not event.inaxes:
        return

    # Checks if it was a mouse left button click
    if not event.button or event.button != 1: # 1 is the LEFT button on mouse
        return

    new_point = [event.xdata, event.ydata]

    #print(f"You clicked at ({new_point[0]:.2f}, {new_point[1]:.2f})")
    
    for point in clicked_points:
        if abs(point[0] - new_point[0]) <= DIFFERENCE_TO_CONSIDER_SAME_X:
            return # Don't add points on the same x position
    
    # Adding the new clicked point
    clicked_points.append(new_point)

    # Draws the new point on the plot
    scatter.set_offsets([*scatter.get_offsets(), new_point])
    plt.draw()
    

def connect_callbacks():
    global fig
    fig.canvas.mpl_connect('button_press_event', on_scree_click)

def get_clicked_points():
    global clicked_points
    
    return clicked_points
