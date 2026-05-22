#!/usr/bin/perl
use strict;
use warnings;

# Klaidų ir sėkmės pranešimų medis
my $messages = {
  'en.UTF-8' => {
    'err' => "Error! Script execution was terminated!",
    'succ' => "Successfully finished!",
    'end' => "End of execution.",
  },
  'lt_LT.UTF-8' => {
    'err' => "Klaida! Scenarijaus vykdymas sustabdytas!",
    'succ' => "Komanda sėkmingai įvykdyta!",
    'end' => "Scenarijaus vykdymas baigtas.",
  },
};

# Aplinkos kalbos nuostata
my $lang = $ENV{'LANG'};

# Pranešimai, atitinkantys aplinkos kalbą
my $langMessages = $messages->{$lang};

# Funkcija spalvotiems pranešimams išvesti
sub printMessage {
  my ($key) = @_;
  my $color = $key eq "err" ? "31" : "32";
  my $message = $langMessages->{$key};
  my $endLine = $key eq "succ" ? "" : "\n";
  print "\n\e[${color}m${message}\e[39m${endLine}\n";
}

# Išorinių komandų iškvietimo funkcija
sub runCmd {

  #Funkcijos argumentas išsaugomas į kintamajame
  my ($cmdArg) = @_;

  # Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  my $command = "sudo $cmdArg";

  # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  # length($command) - komandos ilgis
  my $separator = "-" x length($command);

  # Išvedama komandos eilutė, apsupta skirtuko eilučių
  print "\n$separator\n$command\n$separator\n\n";

  # Įvykdoma komanda, įvykdytos komandos išėjimo kodas išsaugomas kintamajame
  my $exitCode = system($command);

  # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiams programos vykdymas
  if ($exitCode > 0) {
    printMessage("err");
    exit($exitCode);
  }

  # Kitu atveju išvedamas sėkmės pranešimas
  printMessage("succ");
}

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt-get update");
runCmd("apt-get upgrade -y");
runCmd("apt-get autoremove -y");
runCmd("snap refresh");

# Scenarijaus baigties pranešimas
printMessage("end");
