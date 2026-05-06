///usr/bin/env dart "$0" "$@"; exit $?

import 'dart:io';
import 'dart:convert';

// Klaidų ir sėkmės pranešimų medis
const messages = {
  'en.UTF-8': {
    'err': "Error! Script execution was terminated!",
    'succ': "Successfully finished!",
    'end': "End of execution.",
  },
  'lt_LT.UTF-8': {
    'err': "Klaida! Scenarijaus vykdymas sustabdytas!",
    'succ': "Komanda sėkmingai įvykdyta!",
    'end': "Scenarijaus vykdymas baigtas.",
  },
};

// Aplinkos kintamasis, nurodantis kalbą
Map<String, String> env = Platform.environment;
var lang = env["LANG"];

// Klaidų ir sėkmės pranešimų tekstai pagal pasirinktą kalbą
var langMessages = messages[lang]!;

// Funkcija spalvotiems pranešimams išvesti
printMessage(String key) {
  var color = key == "err" ? "31" : "32";
  var message = langMessages[key];
  var endLine = key == "succ" ? "" : "\n";
  print("\n\x1B[${color}m${message}\x1B[39m$endLine");
}

// Išorinių komandų iškvietimo funkcija
runCmd(String cmdArg) async {

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  var command = "sudo $cmdArg";

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // "-" * - simbolio kartojimas, command.length - komandos simbolių skaičius
  var separator = "-" * command.length;

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  print("\n$separator\n$command\n$separator");

  // Įvykdoma komandą, išvedimo srautai nukreipiami į pagrindinį procesą
  var process = await Process.start("sudo", cmdArg.split(' '));
  process.stdout
    .transform(utf8.decoder)
    .forEach(stdout.write);
  process.stderr
    .transform(utf8.decoder)
    .forEach(stderr.write);

  // išėjimo kodas išsaugomas į kintamąjį
  var exitCode = await process.exitCode;

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiams programos vykdymas
  if (exitCode > 0) {
    printMessage("err");
    exit(exitCode);
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  printMessage("succ");
}

// Pagrindinė funkcija - programos įeigos taškas
void main() async {

  // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
  await runCmd("apt-get update");
  await runCmd("apt-get upgrade -y");
  await runCmd("apt-get autoremove -y");
  await runCmd("snap refresh");

  // Scenarijaus baigties pranešimas
  printMessage("end");
}
