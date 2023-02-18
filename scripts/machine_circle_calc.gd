extends Node

onready var hud = $HUD
onready var arc_drawer = $ArcDrawer

func _ready():
	var err = hud.radius_angle_input.connect("input_change", self, "_on_input_change")
	if err != OK:
		printerr("Couldn't connect input_change signal in radius input on MainProgram")

func _on_input_change(radius, angle, color) -> void:
	arc_drawer.set_variables(radius, angle, color)
