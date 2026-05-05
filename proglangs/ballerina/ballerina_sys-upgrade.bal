///usr/bin/env -S bal run "$0" "$@"; exit $?

import ballerina/jballerina.java;
import ballerina/io;
import ballerina/os;

function ArrayList\.new() returns handle = @java:Constructor {
  'class: "java.util.ArrayList"
} external;

function ArrayList\.add(handle list, handle element) returns boolean = @java:Method {
  name: "add",
  'class: "java.util.ArrayList"
} external;

// Konstruktorius new ProcessBuilder(List<String> command)
function ProcessBuilder\.new(handle cmdArrList) returns handle = @java:Constructor {
  'class: "java.lang.ProcessBuilder",
  paramTypes: ["java.util.List"]
} external;

// Metodas redirectOutput(Redirect.INHERIT)
function ProcessBuilder\.redirectOutput(handle builder, handle redirect) returns handle = @java:Method {
  name: "redirectOutput",
  'class: "java.lang.ProcessBuilder",
  paramTypes: ["java.lang.ProcessBuilder$Redirect"]
} external;

// Metodas redirectError(Redirect.INHERIT)
function ProcessBuilder\.redirectError(handle builder, handle redirect) returns handle = @java:Method {
  name: "redirectError",
  'class: "java.lang.ProcessBuilder",
  paramTypes: ["java.lang.ProcessBuilder$Redirect"]
} external;

// Metodas: start()
function ProcessBuilder\.start(handle builder) returns handle|error = @java:Method {
  name: "start",
  'class: "java.lang.ProcessBuilder"
} external;

// Prieiga prie statinio lauko ProcessBuilder.Redirect.INHERIT
function ProcessBuilder\.Redirect\.INHERIT() returns handle = @java:FieldGet {
  name: "INHERIT",
  'class: "java.lang.ProcessBuilder$Redirect"
} external;

// Metodas waitFor()
function Process\.waitFor(handle process) returns int|error = @java:Method {
  name: "waitFor",
  'class: "java.lang.Process"
} external;

// Klaidų ir sėkmės pranešimų medis
map<map<string>> messages = {
  "en.UTF-8" : {
    "err" : "Error! Script execution was terminated!",
    "succ" : "Successfully finished!",
    "end" : "End of execution."
  },
  "lt_LT.UTF-8" : {
    "err" : "Klaida! Scenarijaus vykdymas sustabdytas!",
    "succ" : "Komanda sėkmingai įvykdyta!",
    "end" : "Scenarijaus vykdymas baigtas."
  }
};

// Aplinkos kalbos nuostata
string lang = os:getEnv("LANG");

// Pranešimai pagal aplinkos kalbos nuostatą
map<string>? langMessages = messages[lang];

function printMessage(string key) {
  string? message = langMessages[key];
  string color = key == "err" ? "31" : "32";
  string endLine = key == "succ" ? "" : "\n";
  io:println("\n\u{1B}[", color, "m", message,"\u{1B}[39m", endLine);
}

// Išorinių komandų iškvietimo funkcija
function runCmd(string cmdArg) returns int|error {

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  string command = "sudo " + cmdArg;

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // command.length() - paimamas komandinės eilutės ilgis
  // string:padStart - pildo eilutę "" iki komandinės eilutės ilgio '-' simboliais
  string separator = string:padStart("", command.length(), "-");

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  io:println("\n", separator, "\n", command, "\n", separator, "\n");

  // Komandos eilutė paverčiama java masyvu
  handle cmdArrList = ArrayList\.new();
  foreach string part in re ` `.split(command) {
    _ = ArrayList\.add(cmdArrList, java:fromString(part));
  }

  // Parengiamas proceso kurimo metodas
  handle processBuilder = ProcessBuilder\.new(cmdArrList);
  _ = ProcessBuilder\.redirectOutput(processBuilder, ProcessBuilder\.Redirect\.INHERIT());
  _ = ProcessBuilder\.redirectError(processBuilder, ProcessBuilder\.Redirect\.INHERIT());

  // Įvykdoma komanda, išėjimo kodas išsaugomas į kintamąjį
  handle process = check ProcessBuilder\.start(processBuilder);
  int|error exitCode = Process\.waitFor(process);

  // Jeigu išėjimo kodas yra klaidos tipo (proceso vykdymas nepavyko),
  // išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if exitCode is error {
    io:println(exitCode.message());
    printMessage("err");
    // Gražinamas išėjimo kodas 1 (klaida)
    return 1;
  }

  // Jeigu išėjimo kodas nelygus 0 (komanda užsibaigė klaida),
  // išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if exitCode != 0 {
    printMessage("err");
    // Gražinamas gautas išėjimo kodas
    return exitCode;
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  printMessage("succ");

  // Gražinamas išėjimo kodas 0 (sėkmė)
  return 0;
}

public function main() returns error? {
  // Komandų iškvietimo eilučių masyvas
  string[] commandArr = [
    "apt-get update",
    "apt-get upgrade -y",
    "apt-get autoremove -y",
    "snap refresh"
  ];

  // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
  foreach string command in commandArr {
    int|error result = runCmd(command);

    // Jeigu vykdant komandą įvyko klaida, programos vykdymas nutraukiamas
    if result is error || result > 0 {
      return;
    }
  }

  // Scenarijaus baigties pranešimas
  printMessage("end");
}
