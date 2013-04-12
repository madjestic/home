-- "Guess the number from 0 to 10"
import Control.Monad(when)
import System.Random
import System.IO.Unsafe

--main = do
--    guessNumber randomNumber
    --putStrLn "hoi"


-- generate a random number generator
randomNumberIO :: IO Int
randomNumberIO = do
    gen <- getStdGen
-- generate a random number in the range (0,10)
    let number = (randomR (0,10) gen) :: (Int, StdGen)
    let bar = fst number-- return number
    return $ bar


ioToInt :: IO Int -> Int
ioToInt = unsafePerformIO


randomNumber :: Int
randomNumber = ioToInt randomNumberIO

-- run user input and compare it against pre-generated random number
-- if correct - exit,
--    otherwise - re-run the process

guessNumber :: Int -> IO ()
guessNumber number = do
    putStrLn "Which number did I guess?:"
    inputString <- getLine
    when (not $ null inputString) $ do
                                let userNumber = read inputString
                                if userNumber == number
                                    then putStrLn "Correct.  Exiting"
                                    else do
                                        putStrLn $ "Incorrect, it was:" ++ show number -- ++ "Repeating"
                                        newStdGen
                                        guessNumber number


