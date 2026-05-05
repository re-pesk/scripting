///usr/bin/env -S rm -f "./${0%.*}.bin"; chpl --output="${0%.*}.bin" "$0"; [[ $? == 0 ]] && "./${0%.*}.bin" "$@"; exit $?

use CTypes;
use OS.POSIX;
use Subprocess;

// Klaidų ir sėkmės pranešimų medis
var messages = [
  "en.UTF-8" => [
    "err" => "Error! Script execution was terminated!",
    "succ" => "Successfully finished!",
    "end" => "End of execution."
  ],
  "lt_LT.UTF-8" => [
    "err" => "Klaida! Scenarijaus vykdymas sustabdytas!",
    "succ" => "Komanda sėkmingai įvykdyta!",
    "end" => "Scenarijaus vykdymas baigtas."
  ]
];

// Aplinkos kalbos nuostata
const lang = string.createBorrowingBuffer(getenv("LANG"));

// Pranešimai pagal aplinkos kalbos nuostatą
const langMessages = messages[lang];

// Funkcija spalvotiems pranešimams išvesti
proc printMessage(key: string) {
  var color : string = "32";
  if key == "err" then color = "31";
  const message = langMessages[key];
  var endLine : string = "\n";
  if key == "succ" then end = "";
  writef("\n\x1B[%sm%s\x1B[39m\n%s", color, message, endLine);
}

// Išorinių komandų iškvietimo funkcija
proc runCmd(cmdArg: string) {

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  const command = "sudo " + cmdArg;

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // "-" * - kartoja '-' simbolį
  // command.size - paimamas komandinės eilutės ilgis
  const separator = "-" * command.size;

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  writef("\n%s\n%s\n%s\n\n", separator, command, separator);

  // Įvykdoma komanda, sulaukiama kol pasibaigs
  var sub = spawnshell(command);
  sub.wait();

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if !sub.running && sub.exitCode != 0 {
    printMessage("err");
    exit(99);
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  printMessage("succ");

}

// Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt-get update");
runCmd("apt-get upgrade -y");
runCmd("apt-get autoremove -y");
runCmd("snap refresh");

// Scenarijaus baigties pranešimas
printMessage("end");
