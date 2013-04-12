
from __future__ import print_function 

import ctypes as ct

import os 
import os.path 

DLL_PATH = os.path.join( 
    os.environ.get("NUCLEOPROF_DIRECTORY", ""), # Hope for the better if the
                                                # variable is not defined                                                   
    "NucleoProf.so" )    

_dll = ct.cdll.LoadLibrary( DLL_PATH )


# Here's the function we want to call
doProfile_C = _dll.doProfile_C
doProfile_C.argtypes = [
    ct.c_char_p,
    ct.POINTER( ct.c_double ),
    ct.POINTER( ct.c_double ),
    ct.POINTER( ct.c_double ),
    ct.POINTER( ct.c_double ),
    ]
doProfile_C.restype = ct.c_voidp

# Init the Haskell runtime first
_dll.NucleoProf_init()
print("Runtime initialized")

def doProfile( s ):
    assert isinstance( s, str )
    g = ct.c_double(0)
    a = ct.c_double(0)
    t = ct.c_double(0)
    c = ct.c_double(0)    
    doProfile_C(
        ct.c_char_p( s ),
        ct.byref( g ),
        ct.byref( a ),
        ct.byref( t ),
        ct.byref( c )
    )        
    
    return (g.value, a.value, t.value, c.value)

if __name__ == '__main__':
    # Just let's do some tests
    
    print( doProfile( 'AGGAGG' ) )    
    