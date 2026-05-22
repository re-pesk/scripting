#!/usr/bin/env -S runghc -- --

import System.Environment (getEnv)
import System.Exit (exitWith, ExitCode(..))
import System.Process (spawnProcess, waitForProcess)
import System.IO (hFlush, stdout)
import Data.Maybe (fromMaybe)
import Data.List (uncons)
import Text.XHtml (lang)

-- Klaidų ir sėkmės pranešimų medis
messages :: [(String, [(String, String)])]
messages = [
    ("en_US.UTF-8", [
      ("err", "Error! Script execution was terminated!"),
      ("succ", "Successfully finished!"),
      ("end", "End of execution.")
    ]),
    ("lt_LT.UTF-8", [
      ("err", "Klaida! Scenarijaus vykdymas sustabdytas!"),
      ("succ", "Komanda sėkmingai įvykdyta!"),
      ("end", "Scenarijaus vykdymas baigtas.")
    ])
  ]

-- Funkcija spalvotiems pranešimų tekstams išvesti
printMessage :: String -> [(String, String)] -> IO ()
printMessage key msgs = do
    -- Gaunamas pranešimo tekstas
    let msg = fromMaybe "Pranešimas nerastas" (lookup key msgs)
    -- Parenkama spalva pagal raktą
    let color = if key == "err" then "\ESC[31m" else "\ESC[32m"
    -- Išvedamas spalvotas prenšimas
    putStrLn $ "\n" ++ color ++ msg ++ "\ESC[39m"
    -- Jei raktas ne "succ", po pranešimo pridedama tuščia eilutė
    if key /= "succ"
        then putStrLn ""
        else return ()

-- Funkcija, kuri suskaido eilutę, naudodamą kaip skirtuką duotą simbolį
split :: String -> Char -> [String]
split [] delim = [""]
split (c:cs) delim
    | c == delim = "" : rest
    | otherwise = (c : maybe (error "...") fst (uncons rest)) : drop 1 rest
    where
        rest = split cs delim

-- Išorinių komandų iškvietimo funkcija
runCmd :: (String -> IO ()) -> String -> IO ()
runCmd printLangMessage cmdArg = do
  -- Sukuriama komandos tekstinė eilutė
  let command = "sudo " ++ cmdArg

  -- Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  let separator = replicate (length command) '-'

  -- Išvedama komandos eilutė, apsupta skirtuko eilučių
  putStrLn $ "\n" ++ separator ++ "\n" ++ command ++ "\n" ++ separator ++ "\n"

  hFlush stdout

  -- Įvykdoma komanda
  process <- spawnProcess "sudo" (split cmdArg ' ')
  exitCode <- waitForProcess process

  -- Gaunamos pranešimų eilutės pagal kalbos nuostatas
  -- let (errorMessage, successMessage) = getMessages lang

  -- Patikrinama, ar komanda buvo sėkminga
  -- Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  -- Kitu atveju išvedamas sėkmės pranešimas
  case exitCode of
    ExitSuccess -> printLangMessage "succ"
    ExitFailure _ -> do
      printLangMessage "err"
      exitWith (ExitFailure 99)

main :: IO ()
main = do

  -- Gaunama aplinkos kalbos nuostata
  lang <- getEnv "LANG"

  -- Gaunamos pranešimų eilutės pagal kalbos nuostatas
  let langMessages = fromMaybe [] (lookup lang messages)

  -- Sukuriama kalbos pranešimų išvedimo funkcija
  let printLangMessage key = printMessage key langMessages

  -- Komandų vykdymo funkcijos variantas su kalbos pranešimų išvedimu
  let runCmdLogging = runCmd printLangMessage

  -- Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
  runCmdLogging "apt-get update"
  runCmdLogging "apt-get upgrade -y"
  runCmdLogging "apt-get autoremove -y"
  runCmdLogging "snap refresh"

  -- Scenarijaus baigties pranešimas
  printLangMessage "end"

