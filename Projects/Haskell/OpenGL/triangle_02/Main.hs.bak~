-- This code is a translation of http://en.wikibooks.org/wiki/OpenGL_Programming/Modern_OpenGL_Tutorial_02
-- from C/C++ into Haskell

module Main where

import Graphics.Rendering.OpenGL
import Graphics.Rendering.OpenGL.Raw.Core31
import Graphics.UI.GLUT
import Foreign.Storable (sizeOf)
import Control.Concurrent (threadDelay)
import Control.Applicative
import TGA
import Graphics.GLUtil
import System.Exit (exitWith, ExitCode(ExitSuccess))
import Data.IORef (IORef, newIORef, readIORef, modifyIORef)

data Shaders = Shaders {  vertexShader   :: VertexShader
                        , fragmentShader :: FragmentShader
                        , program'       :: Program
                        , positionA      :: AttribLocation }

data Resources = Resources {  vertexBuffer  :: BufferObject
                            , elementBuffer :: BufferObject
                            , shaders       :: Shaders
                             , fadeFactor    :: GLfloat }

-- | GLfloat triangle_vertices[] = {
-- |     0.0,  0.8,
-- |    -0.8, -0.8,
-- |     0.8, -0.8,
-- |  };
vertexBufferData :: [GLfloat]
vertexBufferData =  [ 0.0,  0.8, 
                     -0.8, -0.8, 
                      0.8, -0.8]

elementBufferData :: [GLuint]
elementBufferData = [0..3]


  -- GLuint vs, fs;
  -- if ((vs = create_shader("shaders/triangle.v.glsl", GL_VERTEX_SHADER))   == 0) return 0;
  -- if ((fs = create_shader("shaders/triangle.f.glsl", GL_FRAGMENT_SHADER)) == 0) return 0;

  -- program = glCreateProgram();
  -- glAttachShader(program, vs);
  -- glAttachShader(program, fs);
  -- glLinkProgram(program);
initShaders :: IO Shaders
initShaders = do vs <- loadShader "shaders/hello-gl.vert"
                 fs <- loadShader "shaders/hello-gl.frag"
                 p  <- linkShaderProgram [vs] [fs]
                 Shaders vs fs p <$> get (attribLocation p "position")

-- | glGenBuffers(1, &vbo_triangle);
-- | glBindBuffer(GL_ARRAY_BUFFER, vbo_triangle);
-- | glBufferData(GL_ARRAY_BUFFER, sizeof(triangle_vertices), triangle_vertices, GL_STATIC_DRAW);
initResources :: IO Resources
initResources = Resources
              <$> makeBuffer ArrayBuffer vertexBufferData
             -- | makeBuffer is a GLUtil function, that wraps around
             -- | a code, functionally similar to glGenBuffers
             -- | glBindBuffer and glBufferData:
             -- |Allocate and fill a 'BufferObject' from a list of 'Storable's.
-- | makeBuffer :: Storable a => BufferTarget -> [a] -> IO BufferObject
-- | makeBuffer target elems = makeBufferLen target (length elems) elems

-- |Allocate and fill a 'BufferObject' from a list of 'Storable's
-- whose length is explicitly given. This is useful when the list is
-- of known length, as it avoids a traversal to find the length.
-- |makeBufferLen :: forall a. Storable a => 
-- |                 BufferTarget -> Int -> [a] -> IO BufferObject
-- |makeBufferLen target len elems = 
-- |    do [buffer] <- genObjectNames 1
       -- bindBuffer target $= Just buffer
       -- let n = fromIntegral $ len * sizeOf (undefined::a)
       -- arr <- newListArray (0, len - 1) elems
       -- withStorableArray arr $ \ptr -> 
       --   bufferData target $= (n, ptr, StaticDraw)
       -- return buffer 
               <*> makeBuffer ElementArrayBuffer elementBufferData
               <*> initShaders
               <*> pure 0.0


setupGeometry :: Resources -> IO ()
setupGeometry r = let posn = positionA (shaders r)
                      stride = fromIntegral $ sizeOf (undefined::GLfloat) * 2
                      vad = VertexArrayDescriptor 2 Float stride offset0
                  in do bindBuffer ArrayBuffer   $= Just (vertexBuffer r)
                        vertexAttribPointer posn $= (ToFloat, vad)
                        vertexAttribArray posn   $= Enabled

-- void onDisplay()
-- {
--   glClearColor(1.0, 1.0, 1.0, 1.0);
--   glClear(GL_COLOR_BUFFER_BIT);
draw :: IORef Resources -> IO ()
draw r' = do clearColor $= Color4 1 1 1 1
             clear [ColorBuffer]
             r <- readIORef r'
--           glUseProgram(program);
             currentProgram $= Just (program' (shaders r))
             setupGeometry r
             bindBuffer ElementArrayBuffer $= Just (elementBuffer r)
             drawElements TriangleStrip 4 UnsignedInt offset0
             swapBuffers

basicKMHandler :: Key -> KeyState -> Modifiers -> Position -> IO ()
basicKMHandler (Char '\27') Down _ _ = exitWith ExitSuccess
basicKMHandler _            _    _ _ = return ()


-- | int main(int argc, char* argv[]) {
main :: IO ()
main = do
-- |   glutInit(&argc, argv); is not reflected in Haskell code
       (progname,_) <- getArgsAndInitialize
-- |   Documentation on glutInitDisplayMode :http://www.opengl.org/documentation/specs/glut/spec3/node12.html
-- |   Documentation on initialDisplayMode  : http://hackage.haskell.org/packages/archive/GLUT/latest/doc/html/Graphics-UI-GLUT-Initialization.html#t:DisplayMode
-- |   glutInitDisplayMode(GLUT_RGBA|GLUT_ALPHA|GLUT_DOUBLE|GLUT_DEPTH);
       initialDisplayMode $= [RGBAMode, WithAlphaComponent, DoubleBuffered, WithDepthBuffer]
-- |   glutInitWindowSize(640, 480);
       initialWindowSize $= Size 640 480
-- |   glutCreateWindow("My Second Triangle");
       createWindow "My Second Triangle"
-- |   if (init_resources()) {
       r <- initResources >>= newIORef
-- |    glEnable(GL_BLEND);
-- |    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
       glEnable gl_BLEND
       glBlendFunc gl_SRC_ALPHA gl_ONE_MINUS_SRC_ALPHA
-- |   glutDisplayFunc(onDisplay);
       displayCallback $= draw r
       idleCallback $= Nothing
       keyboardMouseCallback $= Just basicKMHandler
-- |   glutMainLoop();
       mainLoop
