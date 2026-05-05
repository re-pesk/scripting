///usr/bin/env -S cargo script "$0" "$@"; exit $?

use std::collections::HashMap;
use std::env;
use std::process::{Command, exit};
use std::sync::OnceLock;

// Statinis kintamasis pranešimams pagal aplinkos kalbą saugoti
static LANG_MESSAGES: OnceLock<HashMap<&'static str, &'static str>> = OnceLock::new();

fn init_lang_messages() -> HashMap<&'static str, &'static str> {
    // Gauti aplinkos kalbos nuostatą
    let default_lang : String = "en_US.UTF-8".to_string();
    let lang = env::var("LANG").unwrap_or_else(|_| default_lang.clone());

    // Pranešimų medis
    let mut all_messages = HashMap::from([
        ("en_US.UTF-8", HashMap::from([
            ("err", "Error! Script execution was terminated!"),
            ("succ", "Successfully finished!"),
            ("end", "End of execution."),
        ])),
        ("lt_LT.UTF-8", HashMap::from([
            ("err", "Klaida! Scenarijaus vykdymas sustabdytas!"),
            ("succ", "Komanda sėkmingai įvykdyta!"),
            ("end", "Scenarijaus vykdymas baigtas."),
        ])),
    ]);

    // Gaunami pranešimai, atitinkantys aplinkos kalbą
    all_messages.remove(lang.as_str())
        .or_else(|| all_messages.remove(default_lang.as_str()))
        .unwrap_or_else(|| {
            eprintln!("Klaida: Nepavyko rasti pranešimų šakos!");
            exit(1);
        })
}

fn print_message(key: &str) {
    // Gauname spalvos kodą
    let code = if key == "err" { "31" } else { "32" };

    // Gaunama pranešimo tekstas
    let message = LANG_MESSAGES
        .get_or_init(init_lang_messages) // Jei tuščia, iškviečia init_lang_messages()
        .get(key)
        .copied()
        .unwrap_or_else(|| {
            eprintln!("Kritinė klaida: pranešimas '{}' nerastas.", key);
            exit(1);
        });
    eprintln!("\n\x1b[{}m{}\x1b[39m", code, message);

    // Jei raktas nėra "succ", pridedame tuščią eilutę
    if key != "succ" {
        eprintln!();
    }
}

// Komandų vykdymo funkcijos iškvietimai
fn run_cmd(cmd_arg: &str) {
    // Sukuriama komandos tekstinė eilutė
    let command = format!("sudo {}", cmd_arg);

    // Sukuriamas skirtukas iš "-" simbolių
    let separator = "-".repeat(command.len());

    // Išvedama komanda ir skirtukas
    println!("\n{}\n{}\n{}\n", separator, command, separator);

    // Paleidžiama komanda
    let status = Command::new("sudo")
        .args(cmd_arg.split(' '))
        .status()
        .expect("Failed to execute command");

    // Tikrinamas komandos vykdymo statusas
    if !status.success() {
        print_message("err");
        exit(99);
    }

    print_message("succ");
}

// Pagrindinė funkcija
fn main() {

    // Komandų vykdymo funkcijos iškvietimai
    run_cmd("apt-get update");
    run_cmd("apt-get upgrade -y");
    run_cmd("apt-get autoremove -y");
    run_cmd("snap refresh");

    // Scenarijaus baigties pranešimas
    print_message("end");
}

