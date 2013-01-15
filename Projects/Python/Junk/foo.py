def foo(i):
    print i
    if i < 10:
        foo(i+1)
    else: pass 


def main():
    foo(1)

if __name__ == "__main__":
    main()
