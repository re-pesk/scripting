
#!/usr/bin/env python3

import os

# Klaidų ir sėkmės pranešimų medis
messages = {
    "en.UTF-8": {
        "err": "Error! Script execution was terminated!",
        "succ": "Successfully finished!",
        "end": "End of execution.",
    },
    "lt_LT.UTF-8": {
        "err": "Klaida! Scenarijaus vykdymas sustabdytas!",
        "succ": "Komanda sėkmingai įvykdyta!",
        "end": "Scenarijaus vykdymas baigtas.",
    },
}

# Pranešimai pagal aplinkos kalbos nuostatą
lang = os.environ["LANG"]
langMessages = messages[lang]

def printMessage(key):
    color = "31" if key == "err" else "32"
    message = langMessages[key]
    endLine = "" if key == "succ" else "\n"
    print(f"\n\033[{color}m{message}\033[39m{endLine}")

import subprocess

## Išorinių komandų iškvietimo funkcija
def runCmd(cmdArg):

    # Sukuriama komandos tekstinė eilutė iš funkcijos argumento
    command = f"sudo {cmdArg}"

    # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
    # "-" * - simbolio "-" kartojimas
    # len(command) - komandos eilutės ilgis
    separator = "-" * len(command)

    # Išvedama komandos eilutė, apsupta skirtuko eilučių
    print(f"\n{separator}\n{command}\n{separator}\n")

    # Vykdoma komanda, komandos vykdymo rezultatą išsaugo į kintamąjį
    exitCode = subprocess.run(command.split(' ')).returncode

    # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
    if(exitCode != 0):
        printMessage("err")
        exit(exitCode)

    # Jeigu klaidos nėra, išveda sėkmės pranešimą
    printMessage("succ")

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd('apt update')
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd('snap refresh')

# Scenarijaus baigties pranešimas
printMessage("end")
