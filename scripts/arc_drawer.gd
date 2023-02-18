extends Node2D

var angle_to: float = 45
var radius: float = 40
var color: Color = Color(0.0, 0.0, 0.0)
var nb_points: int = 32

func _draw():
	var center: Vector2 = get_viewport_rect().size / 2 
	draw_circle_arc(center, radius, 0, - angle_to, color)

func _process(delta):
	update()

func draw_circle_arc(center: Vector2, radius: float, angle_from: float, angle_to: float, color: Color):
	var points_arc: PoolVector2Array = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])
	
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	
	draw_polygon(points_arc, colors)

func set_variables(r: float, angle: float, col: Color) -> void:
	radius = r
	angle_to = angle
	color = col
