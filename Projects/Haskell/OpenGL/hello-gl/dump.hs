module Main where

import Graphics.Rendering.OpenGL
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
                        , fadeFactorU    :: UniformLocation
                        , texturesU      :: [UniformLocation] 
                        , positionA      :: AttribLocation }

data Resources = Resources {  vertexBuffer  :: BufferObject
                            , elementBuffer :: BufferObject
                            , textures      :: [TextureObject] 
                            , shaders       :: Shaders
                            , fadeFactor    :: GLfloat }

vertexBufferData :: [GLfloat]
vertexBufferData = [-1, -1, 1, -1, -1, 1, 1, 1]

elementBufferData :: [GLuint]
elementBufferData = [0..3]

makeTexture :: FilePath -> IO TextureObject
makeTexture filename = 
     do (width,height,pixels) <- readTGA filename
        texture <- loadTexture $ texInfo width height TexBGR pixels
        textureFilter   Texture2D   $= ((Linear', Nothing), Linear')
        textureWrapMode Texture2D S $= (Mirrored, ClampToEdge)
        textureWrapMode Texture2D T $= (Mirrored, ClampToEdge)
        return texture

initShaders = do vs <- loadShader "hello-gl.vert"
                 fs <- loadShader "hello-gl.frag"
                 p  <- linkShaderProgram [vs] [fs]
                 Shaders vs fs p
                   <$> get (uniformLocation p "fade_factor") -- refactor witghout applicatives
                   <*> mapM (get . uniformLocation p)
                           ["textures[0]", "textures[1]"]
                   <*> get (attribLocation p "position")

makeResources :: IO Resources
makeResources =  Resources
              <$> makeBuffer ArrayBuffer vertexBufferData
              <*> makeBuffer ElementArrayBuffer elementBufferData
              <*> mapM makeTexture ["hello1.tga", "hello2.tga"]
              <*> initShaders
              <*> pure 0.0

setupTexturing :: Resources -> IO ()
setupTexturing r = let [t1, t2] = textures r
                       [tu1, tu2] = texturesU (shaders r)
                   in do activeTexture $= TextureUnit 0
                         textureBinding Texture2D $= Just t1
                         uniform tu1 $= Index1 (0::GLint)
                         activeTexture $= TextureUnit 1
                         textureBinding Texture2D $= Just t2
                         uniform tu2 $= Index1 (1::GLint)

setupGeometry :: Resources -> IO ()
setupGeometry r = let posn = positionA (shaders r)
                      stride = fromIntegral $ sizeOf (undefined::GLfloat) * 2
                      vad = VertexArrayDescriptor 2 Float stride offset0
                  in do bindBuffer ArrayBuffer   $= Just (vertexBuffer r)
                        vertexAttribPointer posn $= (ToFloat, vad)
                        vertexAttribArray posn   $= Enabled

draw :: IORef Resources -> IO ()
draw r' = do clearColor $= Color4 1 1 1 1
             clear [ColorBuffer]
             r <- readIORef r'
             currentProgram $= Just (program' (shaders r))
             uniform (fadeFactorU (shaders r)) $= Index1 (fadeFactor r)
             setupTexturing r
             setupGeometry r
             bindBuffer ElementArrayBuffer $= Just (elementBuffer r)
             drawElements TriangleStrip 4 UnsignedInt offset0
             swapBuffers

basicKMHandler :: Key -> KeyState -> Modifiers -> Position -> IO ()
basicKMHandler (Char '\27') Down _ _ = exitWith ExitSuccess
basicKMHandler _            _    _ _ = return ()

animate :: IORef Resources -> IdleCallback
animate r = do threadDelay 10000
               milliseconds <- fromIntegral <$> get elapsedTime
               let fade = sin (milliseconds * 0.001) * 0.5 + 0.5
               modifyIORef r (\x -> x { fadeFactor = fade })
               postRedisplay Nothing


main = do initialDisplayMode $= [DoubleBuffered]
          initialWindowSize $= Size 500 500
          (progname,_) <- getArgsAndInitialize
          createWindow "Chapter 2"
          r <- makeResources >>= newIORef
          displayCallback $= draw r
          idleCallback $= Just (animate r)
          keyboardMouseCallback $= Just basicKMHandler
          mainLoop
