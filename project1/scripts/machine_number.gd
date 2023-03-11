class_name MachineNumber
extends Reference

var _base: int = 2
var _mantisse: PoolByteArray = []
var _sign: bool = false
var _exp: int = 0

##
# @brief Initializes a new number using the Machine Representation for it.
# @param base The base of the system for this machine
# @param mantisse The amount of numbers to be used the mantisse of the system.
# @param exp The value for the expoent
##
func _init(base, mantisse, mexp, msign):
	_base = base
	_mantisse = mantisse
	_exp = mexp
	_sign = msign
	normalize()

func shift(diff):
	var n: int = _mantisse.size()
	var src_mantisse = PoolByteArray(_mantisse)
	for i in range(n):
		var x = n-i-1
		_mantisse[x] = src_mantisse[x-diff] if x-diff >= 0 && x-diff < n else 0
	_exp += diff

func is_zero() -> bool:
	for x in _mantisse:
		if x != 0:
			return false;
	return true;

func print():
	var mantisse: String = ""
	for x in _mantisse:
		mantisse += str(x)
	var result: String = ("-" if _sign else "") + "0." + mantisse + "E" + str(_exp)
	print(result)

func normalize() -> void:
	if (is_zero()):
		_exp = 0
		_sign = 0
		return
	
	var should_shift: int = 0
	for d in _mantisse:
		if d == 0:
			should_shift -= 1
		else:
			break
	
	shift(should_shift)
	
