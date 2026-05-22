@file:OptIn(kotlinx.cinterop.ExperimentalForeignApi::class)
import kotlinx.cinterop.ByteVar
import kotlinx.cinterop.CPointer
import kotlinx.cinterop.toKString
import kotlin.system.exitProcess
import platform.posix.getenv
import platform.posix.system

// Klaidų ir sėkmės pranešimų medis
val messages = hashMapOf(
  "en_US.UTF-8" to hashMapOf(
    "err" to "Error! Script execution was terminated!",
    "succ" to "Successfully finished!",
    "end" to "End of execution."
  ),
  "lt_LT.UTF-8" to hashMapOf(
    "err" to "Klaida! Scenarijaus vykdymas sustabdytas!",
    "succ" to "Komanda sėkmingai įvykdyta!",
    "end" to "Scenarijaus vykdymas baigtas."
  )
)

// Pranešimai pagal aplinkos kalbos nuostatą
val cpLang : CPointer<ByteVar>? = getenv("LANG")
val lang = cpLang?.toKString() ?: "en_US.UTF-8"
val langMessages = messages.get(lang) ?: messages.get("en_US.UTF-8")

// Funkcija spalvotiems pranešimams išvesti
fun printMessage(key : String) {
  val color = if (key == "err") { "31" } else { "32" }
  val message = langMessages?.get(key)
  val endLine = if (key == "succ") { "" } else { "\n" }
  print("\n\u001B[${color}m${message}\u001B[39m\n${endLine}")
}

// Išorinių komandų iškvietimo funkcija
fun runCmd(cmdArg : String) {

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  val command = "sudo ${cmdArg}"

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // "-".repeat(n) - kartoja '-' simbolį
  // command.length - paima komandinės eilutės ilgį
  val separator = "-".repeat(command.length)

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  println("\n$separator\n$command\n$separator\n")

  // Vykdoma komanda, išėjimo kodas išsaugomas į kintamąjį

  val exitCode = system(command);

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if (exitCode != 0) {
    printMessage("err")
    exitProcess(exitCode)
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  printMessage("succ")
}

//Pagrindinė funkcija
fun main() {

  // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
  runCmd("apt-get update")
  runCmd("apt-get upgrade -y")
  runCmd("apt-get autoremove -y")
  runCmd("snap refresh")

  // Scenarijaus baigties pranešimas
  printMessage("end")
}
