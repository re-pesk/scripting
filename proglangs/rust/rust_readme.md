[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Rust [<sup>&#x2B67;</sup>](https://www.rust-lang.org/)

## Diegimas

[Diegimas <sup>&#x2B67;</sup>](../../install/proglangs/rust/rust_readme.md "Diegimas")

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
rustc -o rust_sys-upgrade.bin rust_sys-upgrade.rs
./rust_sys-upgrade.bin
```

## Skriptai

* [sys-upgrade <sup>&#x2B67;</sup>](./rust_sys-upgrade.rs "sys-upgrade")
