///usr/bin/env -S deno run --allow-run --allow-env "$0" "$@"; exit $?

// Klaidų ir sėkmės pranešimų medis
const messages = {
  'en.UTF-8': {
    'err': "Error! Script execution was terminated!",
    'succ': "Successfully finished!",
    'end': "End of execution.",
  },
  'lt_LT.UTF-8': {
    'err': "Klaida! Scenarijaus vykdymas sustabdytas!",
    'succ': "Komanda sėkmingai įvykdyta!",
    'end': "Scenarijaus vykdymas baigtas.",
  },
}

// Aplinkos kalbos nuostata
const LANG = Deno.env.get("LANG")

// Pranešimai pagal aplinkos kalbos nuostatą
const langMessages = messages[LANG]

// Funkcija spalvotiems pranešimams išvesti
const printMessage = (key) => {
  const color = (key === 'err') ? '31' : '32'
  const message = langMessages[key]
  console.log(`\n\x1B[${color}m${message}\x1B[39m`)
}


// Įvykdoma išeinant iš scenarijaus
globalThis.addEventListener("unload", () => {
  console.log();
});

// Išorinių komandų iškvietimo funkcija
const runCmd = (cmdArg) => {

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  let command = `sudo ${cmdArg}`

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // "-".repeat() - kartojamas '-' simbolis
  // command.length - gaunamas komandos ilgis
  let separator = "-".repeat(command.length)

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  console.log(`\n${separator}\n${command}\n${separator}\n`)

  // Įvykdoma komandas, procesas išsaugomas į kintamąjį
  const child_proc = new Deno.Command('sudo', {
    args: [...cmdArg.split(' ')],
    stdin: 'inherit',
    stdout: 'inherit',
    stderr: 'inherit'
  });

  // Išsaugomas įvykdytos komandos išėjimo kodas
  const { code } = child_proc.outputSync();

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if (code !== 0) {
    printMessage('err')
    Deno.exit(99)
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  printMessage('succ')

}

// Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt-get update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")

// Scenarijaus baigties pranešimas
printMessage('end')
