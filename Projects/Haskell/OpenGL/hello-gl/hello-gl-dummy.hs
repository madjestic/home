module Main where

import Graphics.Rendering.OpenGL
import Graphics.UI.GLUT
import Data.IORef (IORef, newIORef, readIORef, modifyIORef)


makeResources = return undefined

update r = do
  postRedisplay Nothing

display :: IO ()
display = do
  clearColor $= Color4 1 1 1 1
  clear [ColorBuffer]
  swapBuffers

main = do 
  initialDisplayMode $= [DoubleBuffered]
  (progname,_) <- getArgsAndInitialize
  initialWindowSize $= Size 400 300
  createWindow "Hello World"
  r <- makeResources >>= newIORef
  displayCallback $= display
  idleCallback $= Just (update r)
  mainLoop
