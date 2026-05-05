///usr/bin/env java --source 21 --enable-preview "$0" "$@"; exit $?

import java.util.Map;

// Privaloma klasė vienišuose skritpuose
class Main {

  // Klaidų ir sėkmės pranešimų medis
  Map<String, Map<String, String>> messages = Map.of(
    "en.UTF-8", Map.of(
        "err" , "Error! Script execution was terminated!",
        "succ", "Successfully finished!",
        "end", "End of execution."
    ),
    "lt_LT.UTF-8", Map.of(
      "err", "Klaida! Scenarijaus vykdymas sustabdytas!",
      "succ", "Komanda sėkmingai įvykdyta!",
      "end", "Scenarijaus vykdymas baigtas."
    )
  );

  // Pranešimai pagal aplinkos kalbos nuostatą
  String lang = System.getenv("LANG");
  Map<String, String> langMessages = messages.get(lang);

  void printMessage(String key) {
    String color = "32";
    if (key.equals("err")) {
      color = "31";
    }
    String message = langMessages.get(key);
    String end = "\n";
    if (key.equals("succ")) {
      end = "";
    }
    System.out.printf("\n\033[%sm%s\033[39m\n%s", color, message, end);
  }

  // Išorinių komandų iškvietimo funkcija
  void runCmd(String cmdArg) {

    // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
    String command = String.join(" ", "sudo", cmdArg);

    // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
    String separator = "-".repeat(command.length());

    // Išvedama komandos eilutė, apsupta skirtuko eilučių
    System.out.printf("\n%s\n%s\n%s\n\n", separator, command, separator);

    // Sukuriamas procesas ir išsaugomas į kintamąjį
    ProcessBuilder processBuilder = new ProcessBuilder(command.split(" "));

    // Išvedimas mukreipiamas į esamą procesą
    processBuilder.inheritIO();
    int exitCode = 0;

    // Įvykdoma komanda, išėjimo kodas išasugomas kintamajame
    // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
    try {
      exitCode = processBuilder.start().waitFor();
    } catch (Exception e) {
      // System.out.println(e.getMessage());
      printMessage("err");
      System.exit(99);
    }

    // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
    if (exitCode != 0) {
      printMessage("err");
      System.exit(99);
    }

    // Kitu atveju išvedamas sėkmės pranešimas
    printMessage("succ");
  }

  // Pagrindinis klasės metodas - programos įeigos taškas
  void main(String[] args) {
    // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
    this.runCmd("apt-get update");
    this.runCmd("apt-get upgrade -y");
    this.runCmd("apt-get autoremove -y");
    this.runCmd("snap refresh");

    // Scenarijaus baigties pranešimas
    this.printMessage("end");
  }

}
