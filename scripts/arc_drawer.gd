extends Node2D

var angle_to: float = 45 # The angle for the circunference based on the x axis
var radius: float = 40 # The radius for the circunference
var color: Color = Color(0.0, 0.0, 0.0) # The color for the circunference
var nb_points: int = 32 # The number of points used on the circunference

##
# @brief Drawing function. Made the draw of the circle
##
func _draw():
	var center: Vector2 = get_viewport_rect().size / 2 
	draw_circle_arc(center, radius, 0, - angle_to, color)

##
# @brief Updates the draw of the circle
##
func _process(delta):
	update()

##
# @brief Draws a Arc with the center on @p center, using radius @p radius, from\
# the angle @p angle_from to angle @p angle_to and colors ir with @p color
# @param center The center of the circunference
# @param radius The radius for the circunference
# @param angle_from The angle from to draw the arc
# @param angle_to The angle to to draw the arc
# @param color The color to draw the arc
## 
func draw_circle_arc(center: Vector2, radius: float, angle_from: float, angle_to: float, color: Color):
	var points_arc: PoolVector2Array = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])
	
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	
	draw_polygon(points_arc, colors)

##
# @brief Sets the parameters for the circunference
# @param r The radius of the circunference
# @param angle The angle for the circunference
# @param col The color for the circunference
##
func set_variables(r: float, angle: float, col: Color) -> void:
	radius = r
	angle_to = angle
	color = col
