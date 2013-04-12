class Foo(object): # Continue with @classmethods

	b = 0

	def __init__(self, a=0):
		self.b = a
	
	def show(self):
		print self.b

@classmethod
def show_foo(cls):
	print "foo!"


def main():
	foobar = Foo(777)
	foobar.show()
	foobar.show_foo()

if __name__ == "__main__":
	main()
		
