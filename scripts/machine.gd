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
	n1 = MachineNumber.new(n1._base, PoolByteArray(n1._mantisse), n1._exp, n1._sign)
	n2 = MachineNumber.new(n2._base, PoolByteArray(n2._mantisse), n2._exp, n2._sign)
	if n1.is_zero():
		return n2
	if n2.is_zero():
		return n1
	if (n1._sign != n2._sign):
		n2 = MachineNumber.new(n2._base, PoolByteArray(n2._mantisse), n2._exp, !n2._sign)
		return sub(n1, n2)
	if n1._exp < n2._exp:
		var temp = n2
		n2 = n1
		n1 = temp
	n2 = MachineNumber.new(n2._base, PoolByteArray(n2._mantisse), n2._exp, n2._sign)
	n2.shift(n1._exp - n2._exp)

	var carry_out: int = 0
	for i in range(_mantisse_len):
		var x = _mantisse_len - i - 1
		var d = int(n1._mantisse[x]) + int(n2._mantisse[x]) + carry_out
		carry_out = d/_base
		d %= _base
		n2._mantisse[x] = d
	if carry_out:
		n2.shift(1)
		n2._mantisse[0] = carry_out
		
	return n2
	
func compare_mantises(a: PoolByteArray, b: PoolByteArray) -> int:
	for i in range(min(a.size(), b.size())):
		if a[i] != b[i]:
			return a[i] - b[i]
	return a.size() - b.size()

func compare(a: MachineNumber, b: MachineNumber) -> int:
	if a._sign != b._sign:
		return int(b._sign) - int(a._sign)
	if a._exp != b._exp:
		return a._exp - b._exp
	return compare_mantises(a._mantisse, b._mantisse)

func sub(n1: MachineNumber, n2: MachineNumber) -> MachineNumber:
	n1 = MachineNumber.new(n1._base, PoolByteArray(n1._mantisse), n1._exp, n1._sign)
	n2 = MachineNumber.new(n2._base, PoolByteArray(n2._mantisse), n2._exp, !n2._sign)
	if n1.is_zero():
		return n2
	if n2.is_zero():
		return n1
	if (n1._sign == n2._sign):
		return add(n1, n2)
	
	var inv: bool = false
	if n1._exp < n2._exp:
		var temp = n2
		n2 = n1
		n1 = temp
		inv = !inv
	n2.shift(n1._exp - n2._exp)
	if compare_mantises(n1._mantisse, n2._mantisse) < 0:
		var temp = n2
		n2 = n1
		n1 = temp
		inv = !inv

	var borrow: int = 0
	var maxx: int = 0
	for i in range(_mantisse_len):
		var x = _mantisse_len - i - 1
		var diff: int = int(n1._mantisse[x]) - int(n2._mantisse[x]) - borrow
		if diff < 0:
			diff += _base
			borrow = 1
		else:
			borrow = 0
		n1._mantisse[x] = diff
		if (diff):
			maxx = x
	n1.shift(-maxx)
	return n1

func mult(n1: MachineNumber, n2: MachineNumber) -> MachineNumber:
	n1 = MachineNumber.new(n1._base, PoolByteArray(n1._mantisse), n1._exp, n1._sign)
	n2 = MachineNumber.new(n2._base, PoolByteArray(n2._mantisse), n2._exp, n2._sign)
	var n3: MachineNumber = MachineNumber.new(n1._base, PoolByteArray(n1._mantisse), \
												0, int(n1._sign) ^ int(n2._sign))
	
	# Gets the first non zero by its right
	var should_shift_from_right: int = 0
	for i in range(_mantisse_len):
		var x = _mantisse_len - i - 1
		if(n1._mantisse[x] == 0):
			should_shift_from_right += 1
		else:
			break
	
	n1.shift(should_shift_from_right)
	n1.print()
	should_shift_from_right = 0
	
	for i in range(_mantisse_len):
		var x = _mantisse_len - i - 1
		if(n2._mantisse[x] == 0):
			should_shift_from_right += 1
		else:
			break
	
	n2.shift(should_shift_from_right)
	n2.print()
	
	n3.shift(_mantisse_len)
	
	for i in range(_mantisse_len):
			var x = _mantisse_len - i - 1
			var n4: MachineNumber = MachineNumber.new(n2._base, PoolByteArray(n2._mantisse), \
												0, false)
			n4.shift(_mantisse_len)
			
			for j in range(int(n1._mantisse[x])):
				n4 = self.add(n4, n2)
			
			n4._exp += i
			
			n3 = self.add(n3, n4)
	
	n3.normalize()
	
	return n3

func div(n1: MachineNumber, n2: MachineNumber) -> MachineNumber:
	return MachineNumber.new(0, [], 0, false)

func machine_sin(n1: float) -> MachineNumber:
	
	return MachineNumber.new(0, [], 0, false)
	
func machine_cos(n1: float) -> MachineNumber:
	return MachineNumber.new(0, [], 0, false)
