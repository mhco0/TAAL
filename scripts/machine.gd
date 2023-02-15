class_name Machine
extends Reference

var _base: int = 2
var _mantisse_len: int = 0
var _exp_min: int = 0
var _exp_max: int = 1

##
# @brief Initializes a new machine using the numbers of the @p base with @p mantisse.
# @param base The base of the system for this machine
# @param mantisse The amount of numbers to be used the mantisse of the system.
# @param exp1 The minimum value for the expoent
# @param exp2 The maximum value for the expoent
##
func _init(base, mantisse, exp1, exp2):
	assert(exp1 < exp2, "The first exp parameter should be the minimum value")
	_base = base
	_mantisse_len = mantisse
	_exp_min = exp1
	_exp_max = exp2

func represent(number: int) -> MachineNumber:
	return MachineNumber.new(0, [], 0, false)

func add(n1: MachineNumber, n2: MachineNumber) -> MachineNumber:
	return MachineNumber.new(0, [], 0, false)
	
func sub(n1: MachineNumber, n2: MachineNumber) -> MachineNumber:
	return MachineNumber.new(0, [], 0, false)

func mult(n1: MachineNumber, n2: MachineNumber) -> MachineNumber:
	return MachineNumber.new(0, [], 0, false)

func div(n1: MachineNumber, n2: MachineNumber) -> MachineNumber:
	return MachineNumber.new(0, [], 0, false)

func machine_sin(n1: int) -> MachineNumber:
	return MachineNumber.new(0, [], 0, false)
	
func machine_cos(n1: int) -> MachineNumber:
	return MachineNumber.new(0, [], 0, false)
