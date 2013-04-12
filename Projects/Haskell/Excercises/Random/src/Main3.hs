-- "Guess the number from 0 to 10"
import Control.Monad(when)
import System.Random
import System.IO.Unsafe

--main = do
--    guessNumber randomNumber
    --putStrLn "hoi"


-- randomNumber :: IO StdGen -> Int

            -- return $ randomNumberIO gen
            -- foo <-

-- run user input and compare it against pre-generated random number
-- if correct - exit,
--    otherwise - re-run the process

guessNumber :: IO ()
guessNumber = do
    putStrLn "Which number did I guess?:"
    inputString <- getLine
    when (not $ null inputString) $ do
                                gen <- newStdGen
                                let randomNumber = fst $ ((randomR (0,10) gen) :: (Int, StdGen))
                                let userNumber = read $ inputString
                                if userNumber == randomNumber
                                    then putStrLn "Correct.  Exiting"
                                    else do
                                        putStrLn $ "Incorrect, it was: " ++ show randomNumber -- ++ "Repeating
                                        guessNumber
