
{-# LANGUAGE ForeignFunctionInterface #-}

module NucleoProf.Basic where


import qualified Data.ByteString as B

import Control.Monad(liftM)
import Foreign.C(CString, CDouble)
import Foreign.Ptr(Ptr)
import Foreign.Storable( peek, poke )

data Profile = Profile {
     guanine:: Double
    ,adenine:: Double
    ,thymine:: Double
    ,cytosine:: Double
    } deriving Show 

doProfile :: B.ByteString -> Profile
doProfile x = Profile 1 1 1 1

foreign export ccall doProfile_C :: CString -> 
        Ptr Double ->
        Ptr Double ->
        Ptr Double ->
        Ptr Double ->
            IO ()

doProfile_C s p_guanine p_adenine p_thymine p_cytosine = do
    csinput <- B.packCString s
    ( Profile g a t c ) <- return $ doProfile csinput
    poke p_guanine g
    poke p_adenine a 
    poke p_thymine t 
    poke p_cytosine c 
    return ()
 

