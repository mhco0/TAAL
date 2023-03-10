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

func to_float(n1: MachineNumber) -> float:
	var res: float = 0
	var mexp: int = n1._exp
	
	for i in range(len(n1._mantisse)):
		#print("base: ", n1._base)
		#print("mantisse number: ", float(n1._mantisse[i]))
		#print("pow: ", pow(n1._base, mexp - 1))
		#print("mult: ", float(n1._mantisse[i]) * pow(n1._base, mexp - 1))
		res += float(n1._mantisse[i]) * pow(n1._base, mexp - 1)
		#print("sum %d : %f "% [i, res] )
		mexp -= 1
	
	if n1._sign:
		res = -res
	
	return res

func add(n1: MachineNumber, n2: MachineNumber) -> MachineNumber:
	n1 = MachineNumber.new(n1._base, PoolByteArray(n1._mantisse), n1._exp, n1._sign)
	n2 = MachineNumber.new(n2._base, PoolByteArray(n2._mantisse), n2._exp, n2._sign)
	if n1.is_zero():
		return n2;
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
	n2.normalize()
	return n2
	
func compare_mantisses(a: PoolByteArray, b: PoolByteArray) -> int:
	for i in range(min(a.size(), b.size())):
		if a[i] != b[i]:
			return a[i] - b[i]
	return a.size() - b.size()

func compare(a: MachineNumber, b: MachineNumber) -> int:
	if (a.is_zero() && b.is_zero()):
		return 0
	if (a.is_zero()):
		return -1 + 2*int(b._sign)
	if (b.is_zero()):
		return 1 - 2*int(a._sign)
	if a._sign != b._sign:
		return int(b._sign) - int(a._sign)
	if a._exp != b._exp:
		return a._exp - b._exp
	return compare_mantisses(a._mantisse, b._mantisse)

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
	if compare_mantisses(n1._mantisse, n2._mantisse) < 0:
		var temp = n2
		n2 = n1
		n1 = temp
		inv = !inv

	var borrow: int = 0
	for i in range(_mantisse_len):
		var x = _mantisse_len - i - 1
		var diff: int = int(n1._mantisse[x]) - int(n2._mantisse[x]) - borrow
		if diff < 0:
			diff += _base
			borrow = 1
		else:
			borrow = 0
		n1._mantisse[x] = diff
	n1.normalize()
	return n1

func mult(n1: MachineNumber, n2: MachineNumber) -> MachineNumber:
	n1 = MachineNumber.new(n1._base, PoolByteArray(n1._mantisse), n1._exp, n1._sign)
	n2 = MachineNumber.new(n2._base, PoolByteArray(n2._mantisse), n2._exp, n2._sign)
	var signa: bool = int(n1._sign) ^ int(n2._sign)
	var n3: MachineNumber = MachineNumber.new(n1._base, PoolByteArray(n1._mantisse), 0, false)
	n2._sign = 0
	n3.shift(_mantisse_len)
	#print("multiply %f %f"%[to_float(n1), to_float(n2)])

	#for i in range(n1._exp - 1, -1, -1):
	for i in range(_mantisse_len - 1, -1, -1):
			#print("%d -> "%[i])
			
			var n4: MachineNumber = represent(0)
			
			for j in range(int(n1._mantisse[i])):
				n4 = self.add(n4, n2)
			
			#n4._exp += n1._exp - i - 1
			
			n4._exp += n1._exp - (i + 1)
			#print("exp : ", n4._exp)
			n4.normalize()
			
			n3 = self.add(n3, n4)
	n3._sign = signa
	n3.normalize()
	
	return n3

func div(n1: MachineNumber, n2: MachineNumber) -> MachineNumber:
	var signa = int(n1._sign) ^ int(n2._sign)
	n1 = MachineNumber.new(n1._base, PoolByteArray(n1._mantisse), n1._exp, 0)
	n2 = MachineNumber.new(n2._base, PoolByteArray(n2._mantisse), n2._exp, 0)
	assert(!n2.is_zero(), "ERROR: You must give a non zero value.");
	if n1.is_zero():
		return n1
	var _exp = n1._exp - n2._exp + 1
	n1._exp = 0
	n2._exp = 0
	var _mantisse = PoolByteArray()
	var started = false
	#print("dividing %f %f"%[to_float(n1), to_float(n2)])
	while _mantisse.size() < _mantisse_len:
		var digit = 0
		var cur = represent(0)
		while compare(n1, add(cur, n2)) >= 0:
			cur = add(cur, n2)
			digit += 1
		if (started || digit != 0):
			_mantisse.push_back(digit)
			started = 1
		else:
			_exp -= 1
		n1 = sub(n1, cur)
		n1._exp += 1
	
	return MachineNumber.new(n1._base, _mantisse, _exp, signa)

func machine_sin(n1: float) -> MachineNumber:
	var tpot = represent(n1)
	var tsqr = mult(tpot, tpot)
	var fat = represent(1)
	var sum = represent(0)
	for i in range(1, 11):
		if (i-1) % 2 == 0:
			sum = add(sum, div(tpot, fat))
		else:
			sum = sub(sum, div(tpot, fat))
		#print(i, ": ")
		tpot = mult(tpot, tsqr)
		fat = mult(fat, mult(represent(2*i), represent(2*i+1)))

	#print("ok")
	return sum
	
func machine_cos(n1: float) -> MachineNumber:
	var tpot = represent(n1)
	var tsqr = mult(tpot, tpot)
	tpot = represent(1)
	var fat = represent(1)
	var sum = represent(0)
	for i in range(1, 11):
		#print(i, ": ")
		if (i - 1) % 2 == 0:
			sum = add(sum, div(tpot, fat))
		else:
			sum = sub(sum, div(tpot, fat))
		tpot = mult(tpot, tsqr)
		fat = mult(fat, mult(represent(2*i-1), represent(2*i)))

	sum.print()
	return sum
