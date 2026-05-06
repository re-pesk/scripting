///usr/bin/env rdmd "$0" "$@"; exit $?

module sys_upgrade;

import core.stdc.stdlib;
import std.array;
import std.process;
import std.stdio;

// Pagrindinė funkcija - programos įeigos taškas
void main()
{

  // Klaidų ir sėkmės pranešimų medis
  const auto messages = [
    "en.UTF-8": [
      "err": "Error! Script execution was terminated!",
      "succ": "Successfully finished!",
      "end": "End of execution."
    ],
    "lt_LT.UTF-8": [
      "err": "Klaida! Scenarijaus vykdymas sustabdytas!",
      "succ": "Komanda sėkmingai įvykdyta!",
      "end": "Scenarijaus vykdymas baigtas."
    ]
  ];

  // Aplinkos kalbos nustatymas
  const auto lang = environment.get("LANG");

  // Pranešimai, atitinkantys aplinkos kalbą
  const auto langMessages = messages[lang];

  // Funkcija spalvotiems pranešimams išvesti
  void printMessage(string key)
  {
    const auto color = key == "err" ? "31" : "32";
    const auto message = langMessages[key];
    const auto endLine = key == "succ" ? "" : "\n";
    writefln("\n\x1B[%sm%s\x1B[39m%s", color, message, endLine);
  }

  // Išorinių komandų iškvietimo funkcija
  void runCmd(string cmdStr)
  {
    // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
    const auto command = "sudo " ~ cmdStr;

    // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
    // replicate("-", ...) - simbolio kartojimas, command.length - komandos ilgis
    const auto separator = replicate("-", command.length);

    // Išvedama komandos eilutė, apsupta skirtuko eilučių
    writefln("\n%s\n%s\n%s\n", separator, command, separator);

    // Vykdoma komanda
    auto pipesPid = spawnShell(command);

    // Laukiama proceso pabaigos, išėjimo kodas isšaugomas į kintamąjį
    const auto exitCode = wait(pipesPid);

    // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiams programos vykdymas
    if (exitCode != 0)
    {
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
}
