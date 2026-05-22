///usr/bin/env php -r "$(tail -n +1 "$0")" "$@"; exit "$?"
//<?php

// Klaidų ir sėkmės pranešimų medis
$messages = [
  'en.UTF-8' => [
    'err' => "Error! Script execution was terminated!",
    'succ' => "Successfully finished!",
    'end' => "End of execution."
  ],
  'lt_LT.UTF-8' => [
    'err' => "Klaida! Scenarijaus vykdymas sustabdytas!",
    'succ' => "Komanda sėkmingai įvykdyta!",
    'end' => "Scenarijaus vykdymas baigtas."
  ],
];

// Pranešimai, atitinkantys aplinkos kalbą
$LANG = getenv("LANG");
$langMessages = $messages[$LANG];

// Funkcija spalvotiems pranešimams išvesti
function printMessage($key) {
  global $langMessages;
  $color = ($key === "err" ) ? "31" : "32";
  $message = $langMessages[$key];
  $endLine = ($key === "succ" ) ? "" : "\n";
  echo "\n\x1B[{$color}m{$message}\x1B[39m\n{$endLine}";
}

// Išorinių komandų iškvietimo funkcija
function runCmd($cmdArg) {

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  $command = "sudo {$cmdArg}";

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // str_repeat("-", n) - generuoja komandinės eilutės ilgio separatorių iš '-' simbolių
  // strlen($command) - paima komandinės eilutės ilgį
  $separator = str_repeat("-", strlen($command));

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  echo "\n{$separator}\n{$command}\n{$separator}\n\n";

  // Vykdoma komanda, išėjimo kodas išsaugomas į kintamąjį
  $exitCode = null;
  system($command, $exitCode);

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if ($exitCode > 0) {
      printMessage("err");
      exit(99);
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  printMessage("succ");
};

// Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt-get update");
runCmd("apt-get upgrade -y");
runCmd("apt-get autoremove -y");
runCmd("snap refresh");

// Scenarijaus baigties pranešimas
printMessage("end");
