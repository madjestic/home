from pylab import *

t = arange(0.0, 2.0, 0.01)
s = sin(2*pi*t)
u = cos(2*pi*t)

su = sin(cos(2*pi*t))
us = cos(sin(2*pi*t))


plot(t, su, linewidth=1.0)
plot(t, us, linewidth=1.0)

xlabel('time (s)')
ylabel('voltage (mV)')
title('About as simple as it gets, folks')
grid(True)
savefig("test.png")
show()
