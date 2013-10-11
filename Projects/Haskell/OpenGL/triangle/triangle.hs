-- This is a minimal OpenGL template.  
-- It creates a blank wite window "Hello World"

module Main where

import Graphics.Rendering.OpenGL
import Graphics.UI.GLUT
import Data.IORef (IORef, newIORef, readIORef, modifyIORef)


initResources = return undefined

-- | this block makes animation possible
update r = do
  postRedisplay Nothing

display :: IO ()
display = do
  clearColor $= Color4 1 1 1 1 -- | glClearColor(1.0, 1.0, 1.0, 1.0);
  clear [ColorBuffer] -- | glClear(GL_COLOR_BUFFER_BIT);
  swapBuffers -- | glutSwapBuffers();

main = do 
  initialDisplayMode $= [DoubleBuffered]
  (progname,_) <- getArgsAndInitialize
  initialWindowSize $= Size 400 300
  createWindow "Hello World"
  r <- initResources >>= newIORef
  displayCallback $= display
  idleCallback $= Just (update r)
  mainLoop
