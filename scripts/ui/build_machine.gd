extends Control

onready var base_input = $CenterContainer/PanelContainer/VBoxContainer/BaseLabel/SpinBox
onready var mantisse_input = $CenterContainer/PanelContainer/VBoxContainer/MantisseLabel/SpinBox
onready var expmax_input = $CenterContainer/PanelContainer/VBoxContainer/ExpMaxLabel/SpinBox
onready var use_rounding_input = $CenterContainer/PanelContainer/VBoxContainer/UseRounding/CheckBox
onready var create_button = $CenterContainer/PanelContainer/VBoxContainer/CreateButton

func _ready():
	var error = create_button.connect("pressed", self, "_on_create_button_pressed")
	if (error != OK):
		print("Couldn't connect signal pressed in create_button on BuildMachine scene")


func _on_create_button_pressed():
	var base: int = int(base_input.get_line_edit().text)
	var mantisse_len: int = int(mantisse_input.get_line_edit().text)
	var expmax: int = int(expmax_input.get_line_edit().text)
	var use_rounding: bool = use_rounding_input.pressed
	
	var machine: Machine = Machine.new(base, mantisse_len, expmax, use_rounding)
	
	print("Count of representable numbers on machine: %f" % [machine.representable_elements()])
	
	ProgramParameters.set_machine(machine)
	get_tree().change_scene("res://scenes/machine_circle_calc.tscn")
