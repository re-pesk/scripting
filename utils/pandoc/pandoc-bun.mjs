///usr/bin/env -S bun run "$0" "$@"; exit $?

// ./pandoc-bun.mjs --opt=įvesties-formatas/išvesties-formatas failo-pavadinimas-be-plėtinio

const { spawnSync } = Bun;
import { parseArgs } from "util";

const standalone = "--standalone"
const prefix = "lua-"
const filterfile = "" //"remove-attr.lua" // filtras
const options = {
  asciidoc: { ext: "adoc", },
  context: { ext: "ctex", },
  djot: { ext: "dj", },
  docx: { ext: "docx", },
  haddock: { ext: "hie", },
  html: { ext: "html", },
  ipynb: { ext: "ipynb", },
  jats: { ext: "jats", },
  json: { ext: "json", },
  latex: { ext: "tex", },
  markdown: { ext: "md", opt: "+abbreviations+emoji+mark", },
  muse: { ext: "muse", },
  native: { ext: "hs", },
  pdf: { ext: "pdf", },
  odt: { ext: "odt", },
  rst: { ext: "rst", },
  texinfo: { ext: "txi", },
  textile: { ext: "textile", },
  typst: { ext: "typ", },
}

const { values, positionals } = parseArgs({
  args: Bun.argv,
  options: {
    opt: {
      type: 'string',
    },
  },
  strict: true,
  allowPositionals: true,
})

// tikrina, ar iškvietimo eilutė turi reikalingą argumentą - failo pavadinimą be plėtinio 
if (positionals.length < 3) {
  console.log("\nError! There is no filename! Script execution was terminated!\n")
  process.exit(99)
}

// paima iškvietimo eilutės argumentą
const filename = positionals[2]

// tikrina, ar iškvietimo eilutė turi reikalingą argumentą - tikslinį formatą 
if (values.opt == undefined) {
  console.log("\nError! There is no options! Script execution was terminated!\n")
  process.exit(99)
}

const [fromArg, toArg] = values.opt.split("/")

// tikrina, ar egzistuoja pradinio formato duomenys  
if (!Object.hasOwn(options, fromArg)) {
  console.log(`\nError! There is no data for ${fromArg}! Script execution was terminated!\n`)
  process.exit(99)
}

// tikrina, ar egzistuoja tikslinio formato duomenys  
if (!Object.hasOwn(options, toArg)) {
  console.log(`\nError! There is no data for ${toArg}! Script execution was terminated!\n`)
  process.exit(99)
}

const fromExt = options[fromArg].ext
const fromOpt = options[fromArg]?.opt ?? ""
const toExt = options[toArg].ext
const toOpt = options[toArg]?.opt ?? ""

// paima dabartinį darbinį katalogą
const CURDIR = process.cwd()

const filter = `${filterfile ? `--${prefix}filter=${CURDIR}/${filterfile}` : ''}`
const fileFrom = `${CURDIR}/${filename}.${fromExt}`
const fileTo = `--output=${CURDIR}/${filename}.${toExt}`
const formatFrom = `--from=${fromArg}${fromOpt}`
const formatTo = `--to=${toArg}${toOpt}`

// Sukuria komandos tekstinę eilutę
const command = `pandoc ${fileFrom} ${standalone} ${filter} ${formatFrom} ${formatTo} ${fileTo}`

// spausdina komandos eilutę
console.log(command.replaceAll(/[ ]+/g, '\n\t'))

// vykdo komandą, komandos vykdymo rezultatą išsaugo į kintamąjį 
const exitCode = spawnSync(command.split(' '), { stdio: ['inherit', 'inherit', 'inherit'], shell: true }).exitCode

// jeigu komanda įvykdyta nesėkmingai, spausdina išėjimo kodą ir išeina iš programos
if (exitCode !== 0) {
  console.log(exitCode)
  process.exit(exitCode)
}

// Spasdina sėkmės pranešimą
console.log(`Failas ${fileFrom} sėkmingai konvertuotas į ${toArg}${toOpt} formatą!`)
