#! /usr/bin/env -S zsh

# Klaidų ir sėkmės pranešimų medis
declare -A messages=(
    [en_US.UTF-8.err]="Error! Script execution was terminated!"
    [en_US.UTF-8.succ]="Successfully finished!"
    [en_US.UTF-8.end]="End of execution."
    [lt_LT.UTF-8.err]="Klaida! Scenarijaus vykdymas sustabdytas!"
    [lt_LT.UTF-8.succ]="Komanda sėkmingai įvykdyta!"
    [lt_LT.UTF-8.end]="Scenarijaus vykdymas baigtas."
)

# Išsaugomi pranešimai, atitinkantys aplinkos kalbą
declare -A langMessages=()
for key in "${(k)messages[@]}"; do
    [[ "$key" == "${LANG}"* ]] || continue
    langMessages[${key//${LANG}./}]="${messages[$key]}"
done
declare -p langMessages
errorMessage="${messages[$LANG.err]}"
successMessage="${messages[$LANG.succ]}"

# Funkcija spalvotiems pranešimams išvesti
printMessage() {
    local key="$1"
    local color="32"
    [[ "$key" == "err" ]] && color="31"
    local message="${langMessages[$key]}"
    printf '\n\033[%sm%s\033[39m\n' "$color" "$message" >&2
    if [ "$key" != "succ" ]; then
        printf '\n'
    fi
}

# Išorinių komandų iškvietimo funkcija
runCmd() {

    # Sukuriama komandos tekstinė eilutė iš funkcijos argumento
    command="sudo $@"

    # Generuoja skirtuką, visus komandos simbolius pakeisdamas "-" simboliu
    separator=${command//?/'-'}

    # Išvedama komandos eilutė, apsupta skirtuko eilučių
    printf '\n%s\n%s\n%s\n\n' "$separator" "$command" "$separator"

    # Vykdoma komanda
    (sudo $@)

    # Išsaugo įvykdytos komandos išėjimo kodą
    exitCode="$?"

    # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiams programos vykdymas
    if [ $exitCode -gt 0 ]; then
        printMessage "err"
        exit $exitCode
    fi

    # Kitu atveju išvedamas sėkmės pranešimas
    printMessage "succ"
}

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd apt-get update
runCmd apt-get upgrade -y
runCmd apt-get autoremove -y
runCmd snap refresh

# Scenarijaus baigties pranešimas
printMessage "end"
