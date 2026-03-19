[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Rust [<sup>&#x2B67;</sup>](https://www.rust-lang.org/)

* Paskiausias leidimas: 1.93.1
* Išleista: 2026-02-11

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install cargo-script
rustc --version
```

## Atnaujinimas

```bash
rustup update
```

## Paleistis

```bash
cargo script rust_sys-upgrade.rs
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S run-cargo-script
```

arba

```bash
///usr/bin/env -S cargo script "$0" "$@"; exit $?
```

## Kompiliavimas

```bash
rustc -o vykdomasis-failas.bin kodo-failas.rs
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/rust/rust_readme.md "skriptai")
