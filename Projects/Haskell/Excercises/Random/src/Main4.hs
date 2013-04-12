-- "Guess the number from 0 to 10"
import Control.Monad(when)
import System.Random
import System.IO.Unsafe

--main = do
--    guessNumber randomNumber
    --putStrLn "hoi

guessNumber :: IO ()
guessNumber = do
    putStrLn "Which number did I guess?:"
    inputString <- getLine
    when (not $ null inputString) $ do
                                gen <- newStdGen
                                let randomNumber = show $ fst $ ((randomR (0,10) gen) :: (Int, StdGen))
                                if inputString == randomNumber
                                    then putStrLn "Correct.  Exiting"
                                    else do
                                        putStrLn $ "Incorrect, it was: " ++ randomNumber -- ++ "Repeating
                                        guessNumber
