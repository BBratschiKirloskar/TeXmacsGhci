import Language.Haskell.Ghcid
import System.Environment (getArgs)
import Control.Monad
import Control.Monad.Trans
import System.IO
import System.Process
import Control.Concurrent (threadDelay)
import Control.Error -- from the 'errors' package


{-# ANN module ("HLint: ignore Parse error"::String) #-}


main :: IO ()
main = do

    let path = "/Applications/TeXmacs-1.99.11.app/Contents/Resources/share/TeXmacs/plugins/haskell/temps/"
    (g, _) <- startGhci "stack ghci" (Just ".") (\_ _-> return ())
    let prinInFile cont = writeFile (path++"output.txt") cont
    let executeStatement = exec g
    let exit = mzero
    let pseudoHead co li
           | li == [] = co
           | otherwise = head li
    forever $ do
           command <- readFile (path++"input.txt")
           when (command == "exit" || command == "stop") exit
           when (command /= "waiting\n") $ do
                   executeStatement command >>= prinInFile . (pseudoHead command)
    stopGhci g



