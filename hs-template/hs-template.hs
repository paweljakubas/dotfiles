module Main where

import System.Environment (getArgs)
import System.Directory (createDirectory, setCurrentDirectory)
import System.Process (system)

main :: IO ()
main = do
    args <- getArgs
    case args of
        [name] -> do
            createDirectory name
            setCurrentDirectory name
            let cabalFile = name ++ ".cabal"
                hsFile = name ++ ".hs"
                hieFile = "hie.yaml"
                readmeFile = "README.md"
            writeFile cabalFile $ cabalContent name
            writeFile hsFile $ hsContent name
            writeFile readmeFile $ readmeContent name
            _ <- system "gen-hie > hie.yaml"
            putStrLn $ "Created " ++ cabalFile ++ ", " ++ hsFile ++ ", " ++ readmeFile ++ " and " ++ hieFile
        _ -> putStrLn "Usage: hs-template <project-name>"

cabalContent :: String -> String
cabalContent name = unlines
    [ "cabal-version: 3.0"
    , "name: " ++ name
    , "version: 0.1.0.0"
    , "executable " ++ name
    , "  main-is: " ++ name ++ ".hs"
    , "  build-depends: base >=4.19 && <5, containers, HUnit"
    , "  default-language: Haskell2010"
    ]

hsContent :: String -> String
hsContent name = unlines
    [ "module Main where"
    , ""
    , "import Data.List (sort)"
    , "import Test.HUnit"
    , ""
    , "main :: IO ()"
    ,     "main = do"
    , "    runTestTT tests >> return ()"
    , "    input <- getContents"
    , "    let result = solve input"
    , "    putStr result"
    , ""
    , "solve :: String -> String"
    , "solve input = unlines $ map (show :: Int -> String) $ sort $ map (read :: String -> Int) $ filter (not . null) $ lines input"
    , ""
    , "tests :: Test"
    , "tests = TestList"
    , "    [ \"test1\" ~: sort [3,1,2] ~=? [1,2,3]"
    , "    ]"
    ]

readmeContent :: String -> String
readmeContent name = unlines
    [ "# " ++ name
    , ""
    , "## Build"
    , "```"
    , "cabal build"
    , "```"
    , ""
    , "## Run"
    , "```"
    , "cabal run"
    , "```"
    , ""
    , "## Run with input"
    , "```"
    , "echo -e \"3\\n1\\n2\" | cabal run"
    , "```"
    , ""
    , "## Test"
    , "Tests run automatically on startup."
    ]
