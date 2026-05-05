///usr/bin/env -S haxe --run "${0#.\/}" "$@"; exit $?

// Klaidų ir sėkmės pranešimų medis
var messages = [
  'en.UTF-8' => [
    'err' => "Error! Script execution was terminated!",
    'succ' => "Successfully finished!",
    'end' => "End of execution.",
  ],
  'lt_LT.UTF-8' => [
    'err' => "Klaida! Scenarijaus vykdymas sustabdytas!",
    'succ' => "Komanda sėkmingai įvykdyta!",
    'end' => "Scenarijaus vykdymas baigtas.",
  ],
];

// Aplinkos kalbos nuostata
var lang = Sys.getEnv('LANG');

// Pranešimai pagal aplinkos kalbos nuostatą
var langMessages = messages.get(lang);

// Funkcija spalvotiems pranešimų tekstams išvesti
function printMessage(key) {
  var color = '32';
  if (key == 'err') {
    color = '31';
  }
  var message = langMessages.get(key);
  var end = '\n';
  if (key == 'succ') {
    end = '';
  }
  Sys.stderr().writeString('\n\x1b[${color}m${message}\x1b[39m\n${end}');
}

// Išorinių komandų iškvietimo funkcija
function runCmd(cmdArg) {

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  var command = 'sudo $cmdArg';

  // Sukuriamas skirtukas, komandos simbolius pakeičiant "-" simboliais
  var separator = (~/./g).replace(command, '-');

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  Sys.println('\n$separator\n$command\n$separator\n');

  // Įvykdoma komanda, išėjimo kodas išsaugomas į kintamąjį
  // final process = new sys.io.Process('sudo', cmdArg.split(' '));
  // final exitCode = process.exitCode();
  // process.close();
  final exitCode = Sys.command('sudo', cmdArg.split(' '));

  // Išvedamas buferio turinys
  Sys.stdout().flush();
  Sys.stderr().flush();

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if (exitCode != 0) {
    printMessage('err');
    Sys.exit(exitCode);
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  printMessage('succ');
}

// Pagrindinė klasė
class Haxe_sys_upgrade {
  // Pagrindinė funkcija - programos įeigos taškas
  static public function main():Void {

    // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
    runCmd("apt-get update");
    runCmd("apt-get upgrade -y");
    runCmd("apt-get autoremove -y");
    runCmd("snap refresh");

    // Scenarijaus baigties pranešimas
    printMessage('end');
  }
}

