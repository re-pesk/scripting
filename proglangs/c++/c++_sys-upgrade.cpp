///usr/bin/env -S g++ -Wno-sizeof-array-argument -std=c++2b -o "${0%.*}.bin" "$0"; "./${0%.*}.bin" "$@"; exit $?
#include <format>
#include <iostream>
#include <map>

using namespace std;

map<string, string> messages = {
  {"en.UTF-8.err", "Error! Script execution was terminated!"},
  {"en.UTF-8.succ", "Successfully finished!"},
  {"en.UTF-8.end", "End of execution."},
  {"lt_LT.UTF-8.err", "Klaida! Scenarijaus vykdymas sustabdytas!"},
  {"lt_LT.UTF-8.succ", "Komanda sėkmingai įvykdyta!"},
  {"lt_LT.UTF-8.end", "Scenarijaus vykdymas baigtas."}
};

// Paimama aplinkos kalbos nuostata
string lang = getenv("LANG");

// Funkcija spalvotiems pranešimams išvesti
void printMessage(string key) {
  string color = (key == "err") ? "31" : "32";
  string message = ::messages[lang + "." + key];
  string endLine = (key == "succ") ? "" : "\n";
  cout << format("\n\033[{}m{}\033[39m\n{}", color, message, endLine);
}

// Išorinių komandų iškvietimo funkcija
void runCmd(string cmdArg) {

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  string command = "sudo " + cmdArg;

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // string(n, char) - pakartoja simbolį '-' n kartų
  string separator = string(command.length(), '-');

  cout << format("\n{}\n{}\n{}\n\n", separator, command, separator);

  // Įvykdoma komanda, iėjimo kodas išsaugomas į kintamąjį
  int exitCode = system(command.c_str());

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if (exitCode > 0 ) {
    printMessage("err");
    exit(99);
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  printMessage("succ");
}

// Pagrindinė funkcija - programos įeigos taškas
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
