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

if __name__ == "__main__":
    main()
