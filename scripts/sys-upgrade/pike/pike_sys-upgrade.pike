///usr/bin/env -S pike "$0" "$@"; exit "$?"

// Klaidų ir sėkmės pranešimų medis
mapping messages = ([
  "en.UTF-8":([
    "err" : "Error! Script execution was terminated!",
    "succ" : "Successfully finished!",\
    "end" : "End of execution."
  ]),
  "lt_LT.UTF-8":([
    "err" : "Klaida! Scenarijaus vykdymas sustabdytas!",
    "succ" : "Komanda sėkmingai įvykdyta!",
    "end" : "Scenarijaus vykdymas baigtas."
  ])
]);

// Išrenkami pranešimai, atitinkantys aplinkos kalbą
string LANG = getenv("LANG");
mapping langMessages = messages[LANG];

// Funkcija spalvotiems pranešimams išvesti
void printMessage(string key) {
  int color = key == "err" ? 31 : 32;
  string message = langMessages[key];
  string endLine = key == "succ" ? "" : "\n";
  write("\n\e[%dm%s\e[39m%s\n", color, message, endLine);
}

// Išorinių komandų iškvietimo funkcija
void runCmd(string cmdArg) {
  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  string command = sprintf("sudo %s", cmdArg);

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // "-" * n => generuoja n ilgio separatorių iš '-' simbolių
  // sizeoff(command) => paima komandinės eilutės ilgį
  string separator = "-" * sizeof(command);

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  write("\n%s\n%s\n%s\n\n", separator, command, separator);

  // Vykdoma komanda, išėjimo kodas išsaugomas į kintamąjį
  int exitCode = Process.system(command);

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if (exitCode > 0) {
    printMessage("err");
    exit(99);
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  printMessage("succ");
};

int main() {
  // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
  runCmd("apt-get update");
  runCmd("apt-get upgrade -y");
  runCmd("apt-get autoremove -y");
  runCmd("snap refresh");

  // Scenarijaus baigties pranešimas
  printMessage("end");
  return 0;
}

