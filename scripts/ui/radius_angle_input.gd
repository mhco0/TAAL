extends PanelContainer

signal input_change(radius, angle, color) # emitted when any of the input change

onready var radius_input = $VBoxContainer/RadiusInput/SpinBox
onready var angle_input = $VBoxContainer/AngleInput/SpinBox
onready var color_input = $VBoxContainer/ColorPickerButton

func _ready():
	var err = radius_input.connect("value_changed", self, "_on_spin_input_change")
	if err != OK:
		printerr("Couldn't connect changed signal in radius input on RadiusAngleInput")
		
	err = angle_input.connect("value_changed", self, "_on_spin_input_change")
	if err != OK:
		printerr("Couldn't connect changed signal in angle input on RadiusAngleInput")
	
	err = color_input.connect("color_changed", self, "_on_color_input_change")
	if err != OK:
		printerr("Couldn't connect color_changed signal in color input on RadiusAngleInput")

##
# @brief Callback function called when the input from a spin box change
# @param val The new value from the spin box
##
func _on_spin_input_change(val) -> void:
	_on_any_input_change()

##
# @brief Callback function called when a new color is picked 
# @param col The new color
##
func _on_color_input_change(col) -> void:
	_on_any_input_change()

##
# @brief Callback function called when any input has a change
##
func _on_any_input_change():
	var radius: float = float(radius_input.get_line_edit().text)
	var angle: float = float(angle_input.get_line_edit().text)
	
	
	emit_signal("input_change", radius, angle, color_input.color)
