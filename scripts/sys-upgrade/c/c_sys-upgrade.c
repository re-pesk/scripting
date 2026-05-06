///usr/bin/env -S gcc -o "${0%.*}.bin" "$0"; "${0%.*}.bin" "$@"; exit $?

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Pagalbiniai makrosai
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
#define MALLOC_SIZE(len) malloc (sizeof (char) * len + 1)

//Medžio šakos struktūra
struct Message {
  char* key;
  char* value;
};

// Klaidų ir sėkmės pranešimų medis
struct Message messages[] = (struct Message[]){
  (struct Message) {"en_US.UTF-8.err", "Error! Script execution was terminated!"},
  (struct Message) {"en_US.UTF-8.succ", "Successfully finished!"},
  (struct Message) {"en_US.UTF-8.end", "End of execution."},
  (struct Message) {"lt_LT.UTF-8.err", "Klaida! Scenarijaus vykdymas sustabdytas!"},
  (struct Message) {"lt_LT.UTF-8.succ", "Komanda sėkmingai įvykdyta!"},
  (struct Message) {"lt_LT.UTF-8.end", "Scenarijaus vykdymas baigtas."}
};

// Funkcija, suliejanti dvi duotas teksto eilutes ir grąžinanti naują eilutę
char* strMerge(char* first, char* second, char* separator) {
  size_t len = strlen(first) + strlen(second) + strlen(separator);
  char* mergedString = MALLOC_SIZE(len);
  strcpy(mergedString, first);
  strcat(mergedString, separator);
  strcat(mergedString, second);
  return mergedString;
}

// Funkcija pranešimui iš masyvo paimti pagal raktą
char* getMessage(char* key) {
  char* lang = getenv("LANG");
  if (lang == NULL) lang = "en_US";
  // Išsaugom sugeneruotą raktą į kintamąjį
  char* fullKey = strMerge(lang, key, ".");
  int index = -1;
  for (int i = 0; i < ARRAY_SIZE(messages); i++) {
    if (strcmp(messages[i].key, fullKey) != 0) continue;
    index = i;
    break;
  }
  // Atlaisviname atmintį prieš išeidami iš funkcijos
  free(fullKey);
  return (index > -1) ? messages[index].value : "";
}

// Funkcija spalvotiems pranešimams išvesti
void printMessage(char* key) {
  char* color = (strcmp(key, "err") == 0) ? "31" : "32";
  char* message = getMessage(key);
  char* endLine = (strcmp(key, "succ") == 0) ? "" : "\n";
  printf("\n\033[%sm%s\033[39m\n%s", color, message, endLine);
}

// Funkcija, pakeičianti visus eilutės simbolius nurodytu simboliu ir grąžinanti naują eilutę
char* strReplace(char* str, char character) {
  char* newString = strMerge(str, "", "");
  for (int i = 0; i < strlen(newString); i++) {
    newString[i] = character;
  }
  return newString;
}

// Pagrindinė funkcija - programos įeigos taškas
int main() {
  // Paimama aplinkos kalbos nuostata
  char* lang = getenv("LANG");

  // Išorinių komandų iškvietimo funkcija
  void runCmd(char* cmdArg) {

    // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
    char* command = strMerge("sudo ", cmdArg, "");

    // Sukuriamas skirtukas, visus komandos kopijos simbolius pakeičiant "-" simboliu
    char* separator = strReplace(command, '-');

    printf("\n%s\n%s\n%s\n\n", separator, command, separator);

    // Įvykdoma komanda, iėjimo kodas išsaugomas į kintamąjį
    int exitCode = system(command);

    // Išlaisvinama alokuota atmintis
    free(command); free(separator);

    // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
    if (exitCode > 0 ) {
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

  return 0;
}
