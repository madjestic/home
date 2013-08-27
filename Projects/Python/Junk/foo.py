def foo(i):
    print i
    if i < 10:
        foo(i+1)
    else: pass 


def loop(i,j):
    for _i in range(i):
        for _j in range(j):
            print _i*j+_j 

def main():
    bar()

def bar():
	""" fuck 
		you"""

def g (n):
	if n > 0 : 
		return n - g(g(n-1))
	else	 : return 0


gg_foo = []

def gg (n):
	if n > 1 : 
		gg_foo.append(n)
		gg_foo.append(gg(g(n)))
		return gg_foo
	else 	 :
		return 1 


if __name__ == "__main__":
    main()
