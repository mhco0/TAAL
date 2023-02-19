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

func shift(diff):
	var n: int = _mantisse.size()
	var src_mantisse = PoolByteArray(_mantisse)
	for i in range(n):
		var x = n-i-1
		_mantisse[x] = src_mantisse[x-diff] if x-diff >= 0 && x-diff < n else 0
	_exp += diff

func print():
	var mantisse: String = ""
	for x in _mantisse:
		mantisse += str(x)
	var result: String = "0." + ("-" if _sign else "") + mantisse + "E" + str(_exp)
	print(result)
