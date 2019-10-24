from brial import *
import time

start_time = time.time()
def next_X(X, number_of_bits, f_in_ds):
	if len(f_in_ds) == 1:
		sum = 0
	elif len(f_in_ds) == 2:
		sum = 1
	else:
		print("ERROR")
		exit()
	for monomial_ds in f_in_ds[-1]:
		prod = 1
		for variable_ds in monomial_ds:
			prod = prod * X[int(variable_ds)]
		sum = prod + sum
	# Now the result of computing f is stored in sum.
	for i in range(len(X)-1):
		X[len(X)-i-1] = X[len(X)-i-2]
	X[0] = sum
	return X


def brute_force_attack(X, X0, number_of_bits, f_in_ds):
	count = 1
	while (X!=X0):
		count = count + 1
		if count < 5:
			print(X)
		X = next_X(X, number_of_bits, f_in_ds)
	print(count)


def poly_to_ds(f):
	tmp = str(f).replace("(","")
	tmp = tmp.replace(")","")
	tmp = tmp.split(" + ")
	l = []
	if len(tmp) < 1:
		print("error")
		return
	length = len(tmp)
	if '1' in tmp:
		length = length - 1
		l.append(int('1'))
	l1 = []
	for i in range(length):
		tp = tmp[i]
		tp = tp.split("*")
		l2 = []
		for j in tp:
			l2.append(int(j[1:]))
		l1.append(l2)
	l1 = sorted(l1)
	len_list = []
	for i in l1:
		if len(i) not in len_list:
			len_list.append(len(i))
	l3 = []
	for i in len_list:
		for j in l1:
			if len(j) == i:
				l3.append(j)
	#print(l3)
	l.append(l3)
	return l


number_of_bits = input("number_of_bits:")
declare_ring([Block("x",number_of_bits)])
print([r.variable(i) for i in xrange(r.n_variables())])


X  = [r.variable(i) for i in xrange(r.n_variables())] #[0,0,1,0,1,0,1,0,1,1,1]
X0 = [r.variable(i) for i in xrange(r.n_variables())]


try:
	f = x(10) + x(9) + x(8) #Make sure the number of bits is atleast 1 greater than the highest x suffix in f. The try except blocks do not help much.
except Exception:
	print("Number of bits is less than the highest suffix in f")

f_in_ds = poly_to_ds(f)

X = next_X(X, number_of_bits, f_in_ds)

brute_force_attack(X, X0, number_of_bits, f_in_ds)

print("Time = " + str(time.time() - start_time))