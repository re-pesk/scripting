#!/usr/bin/env -S slsh

% Klaidų ir sėkmės pranešimų medis
variable messages = Assoc_Type[Assoc_Type];
messages["en.UTF-8"] = Assoc_Type[String_Type];
messages["lt_LT.UTF-8"] = Assoc_Type[String_Type];

% Pranešimų tekstai
messages["en.UTF-8"]["err"] = "Error! Script execution was terminated!";
messages["en.UTF-8"]["succ"] = "Successfully finished!";
messages["lt_LT.UTF-8"]["err"] = "Klaida! Scenarijaus vykdymas sustabdytas!";
messages["lt_LT.UTF-8"]["succ"] = "Komanda sėkmingai įvykdyta!";

% Pranešimų tekstai pagal aplinkos kalbos nuostatą LANG
variable errorMessage=messages["${LANG}"$]["err"];
variable successMessage=messages["${LANG}"$]["succ"];

% Išorinių komandų iškvietimo funkcija
define runCmd(cmdArg)  {

  % Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  variable command = "sudo ${cmdArg}"$;

  % Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  % strcharlen(command) - gaunamas komandinės eilutės ilgis
  % sprintf("% ${len}s"$,"") - konstruojama tuščia eilutė, kurios ilgis toks pats kaip komandinės eilutės
  % strreplace(..., " ", "-") - tuščioje eilutėje pakeisti tarpus į "-" simbolius
  variable len = strcharlen(command);
  variable separator = strreplace(sprintf("% ${len}s"$,""), " ", "-");

  % Išvedama komandos eilutė, apsupta skirtuko eilučių
  vmessage("%s\n%s\n%s\n", separator, command, separator);

  % Vykdoma komanda, išėjimo kodas išsaugomas
  variable exitCode = system("sudo ${cmdArg}"$);

  % Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if (exitCode > 0) {
    vmessage("\n\x1b[31m%s\x1b[39m\n", errorMessage);
    exit(exitCode);
  }

  % Kitu atveju išvedamas sėkmės pranešimas
  vmessage("\n\x1b[32m%s\x1b[39m\n", successMessage);
}

message("");

% Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt update");
runCmd("apt-get upgrade -y");
runCmd("apt-get autoremove -y");
runCmd("snap refresh");
