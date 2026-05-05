///usr/bin/env c3c compile-run -q -o "${0%.*}.bin" "$0" -- "$@"; exit $?

import libc;
import std::collections::elastic_array;
import std::collections::map;
import std::core::string;
import std::io;
import std::os::env;

alias LangMessages = HashMap { String, String }; // Atskiros kalbos pranešimų tipas
alias Messages = HashMap { String, LangMessages }; // Bendras pranešimų medis
alias Separator = ElasticArray { char, 255 }; // Dinaminis masyvas, naudojamas separatoriui paruošti

// Separatoriaus užpildymo metodas
fn void Separator.fill(&self, char x, String* str) @dynamic {
  for (int i = 0; i < str.len; i++) {
    self.push(x);
  }
}

// Separatoriaus konvertavimo į tekstinę eilutę metodas
fn String Separator.toString(&self) @dynamic {
  return (String)(self.entries[0:self.size]);
}

// Funkcija spalvotiems pranešimams išvesti
fn void printMessage(String key, LangMessages langMessages) {
  String color = key == "err" ? "31" : "32";
  String message = langMessages[key] ?? "";
  String endLine = key == "succ" ? "" : "\n";
  io::eprintfn("\n\x1B[%sm%s\x1B[39m%s", color, message, endLine);
}

// Išorinių komandų iškvietimo funkcija
fn void runCmd(String cmdArg, LangMessages langMessages) {

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  String command = string::join(tmem, {"sudo", cmdArg}, " ");

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  Separator sepArray = {};
  sepArray.fill('-', &command);
  String separator = sepArray.toString();

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  io::printfn("\n%s\n%s\n%s\n", separator, command, separator);

  // Komanda paverčiama į C eilutę
  ZString zCommand = (ZString)command;

  // Vykdoma komanda, komandos išėjimo kodas išsaugomas į kintamąjį
  CInt exitCode = (uint)libc::system(zCommand);

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiams programos vykdymas
  if (exitCode != 0) {
    printMessage("err", langMessages);
    libc::exit(99);
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  printMessage("succ", langMessages);
}

// Pagrindinė funkcija - programos įeigos taškas
fn void main() {

  // Kalbos pranešimų medis
  Messages messages = *(Messages){}.tinit_with_key_values(
    "en.UTF-8", *(LangMessages){}.tinit_with_key_values(
      "err", "Error! Script execution was terminated!",
      "succ" , "Successfully finished!",
      "end" , "End of execution."
    ),
    "lt_LT.UTF-8", *(LangMessages){}.tinit_with_key_values(
      "err" , "Klaida! Scenarijaus vykdymas sustabdytas!",
      "succ" , "Komanda sėkmingai įvykdyta!",
      "end" , "Scenarijaus vykdymas baigtas.",
    ),
  );

  // Gaunamas sistemos kalbos nustatymas
  String lang = env::tget_var("LANG") ?? "";

  // Išsaugomi pranešimai, atitinkantys aplinkos kalbą
  LangMessages langMessages = messages[lang] ?? (LangMessages){};

  // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis ir pranešimais
  runCmd("apt-get update", langMessages);
  runCmd("apt-get upgrade -y", langMessages);
  runCmd("apt-get autoremove -y", langMessages);
  runCmd("snap refresh", langMessages);

  // Scenarijaus baigties pranešimas
  printMessage("end", langMessages);
}
