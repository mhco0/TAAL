extends Control


onready var base_input = $CenterContainer/PanelContainer/VBoxContainer/BaseLabel/SpinBox
onready var mantisse_input = $CenterContainer/PanelContainer/VBoxContainer/MantisseLabel/SpinBox
onready var exp1_input = $CenterContainer/PanelContainer/VBoxContainer/Exp1Label/SpinBox
onready var exp2_input = $CenterContainer/PanelContainer/VBoxContainer/Exp2Label/SpinBox
onready var use_rounding_input = $CenterContainer/PanelContainer/VBoxContainer/UseRounding/CheckBox
onready var create_button = $CenterContainer/PanelContainer/VBoxContainer/CreateButton

func _ready():
	var error = create_button.connect("pressed", self, "_on_create_button_pressed")
	if (error != OK):
		print("Couldn't connect signal pressed in create_button on BuildMachine scene")


func _on_create_button_pressed():
	var base: int = int(base_input.get_line_edit().text)
	var mantisse_len: int = int(mantisse_input.get_line_edit().text)
	var exp1: int = int(exp1_input.get_line_edit().text)
	var exp2: int = int(exp2_input.get_line_edit().text)
	var use_rounding: bool = use_rounding_input.pressed
	
	var machine: Machine = Machine.new(base, mantisse_len, exp1, exp2, use_rounding)
	
	print("Count of representable numbers on machine: %d" % [machine.representable_elements()])
	var n1 = machine.represent(0.9999999999);
	n1.print()
	n1.shift(1)
	n1.print()
