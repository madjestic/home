module Paths_Dump (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [0,0,1], versionTags = []}
bindir, libdir, datadir, libexecdir :: FilePath

bindir     = "/home/madjestic/.cabal/bin"
libdir     = "/home/madjestic/.cabal/lib/Dump-0.0.1/ghc-7.6.3"
datadir    = "/home/madjestic/.cabal/share/Dump-0.0.1"
libexecdir = "/home/madjestic/.cabal/libexec"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = catchIO (getEnv "Dump_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "Dump_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "Dump_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "Dump_libexecdir") (\_ -> return libexecdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
