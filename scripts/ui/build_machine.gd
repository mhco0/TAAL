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
	
	print("Count of representable numbers on machine: %d" % [machine.representable_elements()])
	var n1 = machine.represent(21.0);
	var n2 = machine.represent(-30.0);
	n1.print()
	n2.print()
	var n3 = machine.mult(n1, n2)
	n3.print()
	
	machine.mult(machine.represent(10), machine.represent(0)).print()
	#print(machine.to_float(machine.represent(3.14151617)))
	#print(machine.to_float(machine.machine_cos(3.141516)))
	#machine.machine_sin(3.14156).print()
	#print("sin 2pi -> ", machine.to_float(machine.machine_sin(2 * 3.141516)))
	#print("sin pi -> ", machine.to_float(machine.machine_sin(3.141516)))
	#print("sin pi/2 -> ", machine.to_float(machine.machine_sin(3.141516 / 2)))
	print("sin pi/3 -> ", machine.to_float(machine.machine_sin(3.141516 / 3)))
	print("cos pi/3 -> ", machine.to_float(machine.machine_cos(3.141516 / 3)))
	#print("sin pi/4 -> ", machine.to_float(machine.machine_sin(3.141516 / 4)))
	
	#ProgramParameters.set_machine(machine)
	#get_tree().change_scene("res://scenes/machine_circle_calc.tscn")
