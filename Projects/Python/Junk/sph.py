import math
import os
import sys

def foo():
    return 42

def bar():
    print("4")


def coeffs_to_lm(k): # k := coefficient index
    lm = [None, None]
    i = 0
    for l in range(10):
        for m in range(-l, l+1):
            if i > k: break
            lm[0]=l
            lm[1]=m
            print ("l: {0}, m: {1}, index: {2}".format(l,m,i)) 
            i+=1
    return lm

def Ms(l):
    ms = []
    for i in range(-l, l+1):
        ms.append(i)
    print("m seq: {0}".format(ms))
    return ms


def K(l,m):
    m = abs(m)
    tmp_up = (2*l+1)*math.factorial(l-m)
    tmp_btm= 4.0*math.pi*math.factorial(l+m)
    return math.sqrt(tmp_up/tmp_btm) 


def Ks(l):
    for i in range(l+1):
        print("l = {0}".format(i))
        ks = []
        for j in Ms(i):
            ks.append(K(i,j))

        for member in ks:
            print(member)#"{0}".format(member))

def main():
    k = int(sys.argv[1])
    #Ks(k)
    print coeffs_to_lm(k)

if __name__ == "__main__":
    main()
