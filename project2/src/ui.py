import matplotlib.pyplot as plt
from matplotlib.widgets import Button

DIFFERENCE_TO_CONSIDER_SAME_X = 1e-3
XMIN_LIMIT = 0
YMIN_LIMIT = 0
XMAX_LIMIT = 10
YMAX_LIMIT = 10
clicked_points = []
fig, ax = plt.subplots()
ax.set_xlim(XMIN_LIMIT, XMAX_LIMIT)
ax.set_ylim(YMIN_LIMIT, XMAX_LIMIT)
scatter = ax.scatter([], [])

button_ax = plt.axes([0.05, 0.01, 0.2, 0.1])
button_ax2 = plt.axes([0.35, 0.01, 0.2, 0.1])
button = Button(button_ax, "Try build function")
button_clear = Button(button_ax2, "Clear points")
plt.subplots_adjust(bottom=0.3, right=0.9)

button_callback = None

def on_scree_click(event):
    global clicked_points
    global DIFFERENCE_TO_CONSIDER_SAME_X
    global scatter

    # Checks if the click was in the plot
    if not event.inaxes or event.inaxes != ax:
        return

    # Checks if it was a mouse left button click
    if not event.button or event.button != 1: # 1 is the LEFT button on mouse
        return
    
    # Checks if the click was a double click or not
    if not event.dblclick: 
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

def on_button_click(event):
    global button
    global button_clear
    del button
    del button_clear
    #plt.close()

    button_callback()
    plt.draw()

def on_clear_button_click(event):
    global scatter
    global ax

    ## Clear logical points
    clear_points()

    ## Clear view
    ax.cla()
    ax.set_xlim(XMIN_LIMIT, XMAX_LIMIT)
    ax.set_ylim(YMIN_LIMIT, XMAX_LIMIT)
    scatter = ax.scatter([], [])
    plt.draw()

def connect_callbacks():
    global fig
    global button
    global button_clear

    button.on_clicked(on_button_click)
    button_clear.on_clicked(on_clear_button_click)
    fig.canvas.mpl_connect('button_press_event', on_scree_click)
    
def get_clicked_points():
    global clicked_points
    
    return clicked_points

def clear_points():
    global clicked_points

    clicked_points.clear()


def set_creation_callback(f):
    global button_callback

    button_callback = f