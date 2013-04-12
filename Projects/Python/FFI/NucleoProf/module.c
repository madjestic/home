#include <HsFFI.h>

static char *argv[] = {"NucleoProf", "", "", 0};
static int argc = 1;

HsBool NucleoProf_init(void){

    // Initialize Haskell runtime
    char **p = argv;
    hs_init(&argc,  &p );

    return HS_BOOL_TRUE;
}

void NucleoProf_end(void){
    hs_exit();
}
