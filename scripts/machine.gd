class_name Machine
extends Reference

var _base: int = 2
var _mantisse_len: int = 0
var _exp_min: int = 0
var _exp_max: int = 1
var _use_rounding: bool = false # Uses truncate

##
# @brief Initializes a new machine using the numbers of the @p base with @p mantisse.
# @param base The base of the system for this machine
# @param mantisse The amount of numbers to be used the mantisse of the system.
# @param expmax The maximum value for the expoent
##
func _init(base, mantisse, expmax, use_rounding):
	assert(expmax > 0, "The first exp parameter should be a positive value")
	_base = base
	_mantisse_len = mantisse
	_exp_min = 1 - expmax
	_exp_max = expmax
	_use_rounding = use_rounding

##
# @brief Get the number of representable elements that can be represent by this machine
# @return The number of representable elements
##
func representable_elements() -> float:
	return float (2 * (_base - 1) * pow(_base, _mantisse_len - 1) * (_exp_max - _exp_min + 1)) + 1

##
# @brief Returns the minimum representable number
# @return The minimum representable number
## 
func min_representable_number() -> float:
	return pow(_base, _exp_min)
	
##
# @brief Returns the maximum representable number
# @return The maximum representable number
## 
func max_representable_number() -> float:
	return (1 - pow(_base, -_mantisse_len) * pow(_base, _exp_max + 1))

# Divide the number by its base and get the full representation in the mantisse 
func represent(flt: float) -> MachineNumber:
	var signa: bool = flt < 0
	flt = abs(flt)
	var mantissa: float = 0.0
	var exponent: int = 0

	# Extract the mantissa and exponent of the number
	if flt != 0:
		exponent = floor(log(flt) / log(_base))+1
		mantissa = flt / pow(_base, exponent)
	else:
		mantissa = 0

	# Convert the mantissa to the chosen base
	var mantissa_str: PoolByteArray = []
	var cnt: int = 0
	while cnt < _mantisse_len:
		var digit: int = floor(mantissa * _base)
		mantissa_str.push_back(digit)
		mantissa = (mantissa * _base) - digit
		cnt += 1
	# Combine the sign, mantissa, and exponent into the final representation

	return MachineNumber.new(_base, mantissa_str, exponent, signa) 

func add(n1: MachineNumber, n2: MachineNumber) -> MachineNumber:
	if n1._exp < n2._exp:
		var temp = n2
		n2 = n1
		n1 = temp
	var diff = n1._exp - n2._exp
	n2.shift(diff)
	
	var n3 = MachineNumber.new(n1._base, PoolByteArray(n1._mantisse), n1._exp, n1._sign)
	
	var carry_out: int = 0
	for i in range(_mantisse_len):
		var x = n2._mantisse_len - i - 1
		var d = int(n1._mantisse[x]) + int(n2._mantisse[x]) + carry_out
		carry_out = d/_base
		d %= _base
		n3._mantisse[x] = d
	if carry_out:
		n3.shift(-1)
		n3._mantisse[0] = 1
		
	return n3

func sub(n1: MachineNumber, n2: MachineNumber) -> MachineNumber:
	if n1._exp < n2._exp:
		var temp = n2
		n2 = n1
		n1 = temp
	var diff = n1._exp - n2._exp
	n2.shift(diff)
	if n1._mantisse < n2._mantisse:
		var temp = n2
		n2 = n1
		n1 = temp
	
	for i in range(_mantisse_len):
		var x = n2._mantisse_len - i - 1
		
	return MachineNumber.new(0, [], 0, false)

func mult(n1: MachineNumber, n2: MachineNumber) -> MachineNumber:
	return MachineNumber.new(0, [], 0, false)

func div(n1: MachineNumber, n2: MachineNumber) -> MachineNumber:
	return MachineNumber.new(0, [], 0, false)

func machine_sin(n1: float) -> MachineNumber:
	
	return MachineNumber.new(0, [], 0, false)
	
func machine_cos(n1: float) -> MachineNumber:
	return MachineNumber.new(0, [], 0, false)
