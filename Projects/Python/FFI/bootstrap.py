
from __future__ import print_function

import argparse
import os 
import re
import sys
import os.path 
import shutil

def main():
    oparser = argparse.ArgumentParser(
        description="Create project infra-structure for projects of type " + PROJECT_CLASS,
        epilog="""The new project will be created in a subdirectory of the current dir, 
and the new directory name will be set to the NEW_PROJECT_NAME. """
    ) 
    oparser.add_argument( "project_name", metavar='NEW_PROJECT_NAME', type=str,
                          help="Name of the new project" )
    oparser.add_argument( "--overwrite", dest='overwrite', action='store_const', const=True, default=False, help="""Over-write 
the target directory... you don't want to do that in live cases, but might be useful
for testing
    """)
    options = oparser.parse_args()
    # Now I need all the variables defining files here, I have set for the 
    # convention F_<key>_TEXT and F_<key>_FILENAME
    project_name = options.project_name
    
    all_module_vars = globals()
    file_vars = []
    for varname in all_module_vars:
        mo =re.match( r'F_([A-Za-z0-9])+_TEXT', varname ) 
        if mo:
            file_vars.append( mo.group(1) )
    
    project_name_lowercase = project_name.lower()
    project_name_uppercase = project_name.upper()
    
    if os.path.exists( project_name ) and not options.overwrite:
        print("Target directory already exists, bailing out", file=sys.stderr)
        exit( 2 )
    elif os.path.exists( project_name ):
        shutil.rmtree( project_name )
    # And now just re-generate   the file structure
    try:
        os.mkdir( project_name )
    except OSError:
        print("Could not create directory, bailing out", file=sys.stderr)
        exit(2)
        
    for file_var in file_vars:
        rel_filename_template = all_module_vars[ 'F_' + file_var + '_FILENAME' ]
        try:
            rel_filename = rel_filename_template.format(
                project_name = project_name,
                project_name_lowercase = project_name_lowercase,
                project_name_uppercase = project_name_uppercase
                )
        except KeyError:
            print("At ", rel_filename_template, file = sys.stderr )
            raise 
        
        pattern_text = all_module_vars[ 'F_' + file_var + '_TEXT' ]
        
        complete_path = os.path.join( project_name, rel_filename )
        try:
            complete_text = pattern_text.format(
                project_name = project_name,
                project_name_lowercase = project_name_lowercase,
                project_name_uppercase = project_name_uppercase
                )
        except KeyError:
            print("At ", complete_path, file = sys.stderr )
            raise 
        
        dir_section = os.path.dirname( complete_path )
        if not os.path.exists( dir_section ):
            os.makedirs( dir_section )
        
        with open( complete_path, 'w') as out:
            out.write( complete_text )
    
    
F_0_FILENAME='makeenv'
F_0_TEXT='# This is a convenience file for getting quick shortcuts\n# to different project actions\n\n# Change these to match your ghc compiler\nGHC_LIBS_PREFIX=/usr/lib/ghc\nGHC_VERSION=7.4.1\nGHC_RUNTIME=""\n\n\n# With this line, we get the directory where the containing\n# `makeenv\' file is.\n_current_dir=$(dirname `readlink -f ${{BASH_SOURCE[0]}}`)\n\n# It is a good idea to export the current project directory,\n# so that other tools can also use it. In this case I\'m using \n# `NUCLEOPROF_\' as a prefix for exported, project-specific \n# variables. That should reduce clutter a little bit.\nexport NUCLEOPROF_DIRECTORY=$_current_dir\n\n# But a short alias for the above variable is more convenient in \n# the rest of this bash-script file.\nH=$_current_dir\n\nif [ "$GHC_RUNTIME" = "" ] ; then\n    GHC_RUNTIME_FSUFFIX=HSrts-ghc${{GHC_VERSION}}\nelse\n    GHC_RUNTIME_FSUFFIX=HSrts_${{GHC_RUNTIME}}-ghc${{GHC_VERSION}}\nfi\nGHC_RUNTIME_FILE=lib${{GHC_RUNTIME_FSUFFIX}}.so\n\nif [ -e $GHC_LIBS_PREFIX/$GHC_RUNTIME_FILE ] ; then \n    echo "All good, runtime found"\nelse\n    echo "WARNING: The runtime has not been found. Check that you "\\\n         "have installed ghc, and that the directories in this file "\\\n         "are set correctly."\nfi\n\n# This function defines a short alias, `mk\', for quickly building\n# the program\nfunction mk(){{\n    if [ "$H/module.c" -nt "$H/build/module.o" ] ; then\n        echo "Compiling module.c"\n        ghc -fPIC -c $H/module.c -o $H/build/module.o || exit\n    fi\n    ghc \\\n            -shared -dynamic -fPIC -no-hs-main \\\n            -optl-Wl,-rpath,$GHC_LIBS_PREFIX -l$GHC_RUNTIME_FSUFFIX \\\n            --make NucleoProf.Basic \\\n            \\\n            $H/build/module.o \\\n            -i$H/hs -odir $H/build -hidir $H/built_hi \\\n            \\\n            -o $H/NucleoProf.so\n}}\n\n'

F_1_FILENAME='module.c'
F_1_TEXT='#include <HsFFI.h>\n\nstatic char *argv[] = {{"NucleoProf", "", "", 0}};\nstatic int argc = 1;\n\nHsBool NucleoProf_init(void){{\n\n    // Initialize Haskell runtime\n    char **p = argv;\n    hs_init(&argc,  &p );\n\n    return HS_BOOL_TRUE;\n}}\n\nvoid NucleoProf_end(void){{\n    hs_exit();\n}}\n'

F_2_FILENAME='py/{project_name}/Basic.py'
F_2_TEXT='\nfrom __future__ import print_function \n\nimport ctypes as ct\n\nimport os \nimport os.path \n\nDLL_PATH = os.path.join( \n    os.environ.get("NUCLEOPROF_DIRECTORY", ""), # Hope for the better if the\n                                                # variable is not defined                                                   \n    "NucleoProf.so" )    \n\n_dll = ct.cdll.LoadLibrary( DLL_PATH )\n\n\n# Here\'s the function we want to call\ndoProfile_C = _dll.doProfile_C\ndoProfile_C.argtypes = [\n    ct.c_char_p,\n    ct.POINTER( ct.c_double ),\n    ct.POINTER( ct.c_double ),\n    ct.POINTER( ct.c_double ),\n    ct.POINTER( ct.c_double ),\n    ]\ndoProfile_C.restype = ct.c_voidp\n\n# Init the Haskell runtime first\n_dll.NucleoProf_init()\nprint("Runtime initialized")\n\ndef doProfile( s ):\n    assert isinstance( s, str )\n    g = ct.c_double(0)\n    a = ct.c_double(0)\n    t = ct.c_double(0)\n    c = ct.c_double(0)    \n    doProfile_C(\n        ct.c_char_p( s ),\n        ct.byref( g ),\n        ct.byref( a ),\n        ct.byref( t ),\n        ct.byref( c )\n    )        \n    \n    return (g.value, a.value, t.value, c.value)\n\nif __name__ == \'__main__\':\n    # Just let\'s do some tests\n    \n    print( doProfile( \'AGGAGG\' ) )    \n    '

F_3_FILENAME='py/{project_name}/__init__.py'
F_3_TEXT=''

F_4_FILENAME='hs/{project_name}/Basic.hs'
F_4_TEXT='\n{{-# LANGUAGE ForeignFunctionInterface #-}}\n\nmodule {project_name}.Basic where\n\n\nimport qualified Data.ByteString as B\n\nimport Control.Monad(liftM)\nimport Foreign.C(CString, CDouble)\nimport Foreign.Ptr(Ptr)\nimport Foreign.Storable( peek, poke )\n\ndata Profile = Profile {{\n     guanine:: Double\n    ,adenine:: Double\n    ,thymine:: Double\n    ,cytosine:: Double\n    }} deriving Show \n\ndoProfile :: B.ByteString -> Profile\ndoProfile x = Profile 1 1 1 1\n\nforeign export ccall doProfile_C :: CString -> \n        Ptr Double ->\n        Ptr Double ->\n        Ptr Double ->\n        Ptr Double ->\n            IO ()\n\ndoProfile_C s p_guanine p_adenine p_thymine p_cytosine = do\n    csinput <- B.packCString s\n    ( Profile g a t c ) <- return $ doProfile csinput\n    poke p_guanine g\n    poke p_adenine a \n    poke p_thymine t \n    poke p_cytosine c \n    return ()\n \n\n'

PROJECT_CLASS='python-and-haskell'

if __name__ == '__main__':
    main()

