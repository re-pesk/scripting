///usr/bin/env -S go run $0 $@ ; exit $?

package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

func printMessage(key string, langMessages map[string]string) {
	color := "32"
	if key == "err" {
		color = "31"
	}
	message := langMessages[key]
	endLine := "\n"
	if key == "succ" {
		endLine = ""
	}
	fmt.Printf("\n\x1b[%sm%s\x1b[39m\n%s", color, message, endLine)
}

// Išorinių komandų iškvietimo funkcija
func runCmd(cmdArg string, langMessages map[string]string) {

	// Sukuriama komandos tekstinė eilutė iš funkcijos argumento
	command := strings.Join([]string{"sudo", cmdArg}, " ")

	// Sukuriamas komandos ilgio skirtukas iš "-" simbolių
	// strings.Repeat("-", n) - simbolio kartojimas, len(command) - komandos simbolių skaičius
	separator := strings.Repeat("-", len(command))

	// Išvedama komandos eilutė, apsupta skirtuko eilučių
	fmt.Printf("\n%v\n%v\n%v\n\n", separator, command, separator)

	// Komandos eilutę pverčia masyvu
	cmdArray := strings.Fields(command)

	// Sukuria procesą, jo išvedimo srautus nukreipia į pagrindinį procesą
	cmd := exec.Command(cmdArray[0], cmdArray[1:]...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	// Vykdoma komanda, klaidos būsena išaugoma į kintamąjį
	err := cmd.Run()

	// Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
	if err != nil {
		printMessage("err", langMessages)
		os.Exit(0)
	}

	// Kitu atveju išvedamas sėkmės pranešimas
	printMessage("succ", langMessages)
}

// Pagrindinė funkcija - programos įeigos taškas
func main() {

	// Klaidų ir sėkmės pranešimų medis
	messages := map[string]map[string]string{
		"en.UTF-8": {
			"err":  "Error! Script execution was terminated!",
			"succ": "Successfully finished!",
			"end":  "End of execution.",
		},
		"lt_LT.UTF-8": {
			"err":  "Klaida! Scenarijaus vykdymas sustabdytas!",
			"succ": "Komanda sėkmingai įvykdyta!",
			"end":  "Scenarijaus vykdymas baigtas.",
		},
	}

	// Pranešimai, atitinkantys aplinkos kalbą
	lang := os.Getenv("LANG")
	langMessages := messages[lang]

	// Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
	runCmd("apt-get update", langMessages)
	runCmd("apt-get upgrade -y", langMessages)
	runCmd("apt-get autoremove -y", langMessages)
	runCmd("snap refresh", langMessages)

  // Scenarijaus baigties pranešimas
	printMessage("end", langMessages)
}
