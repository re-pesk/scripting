[Grįžti &#x2BA2;](../readme.md "Grįžti")

# C [<sup>&#x2B67;</sup>](https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html)

## Diegimas

[Diegimas <sup>&#x2B67;</sup>](../../install/proglangs/c/c_readme.md "Diegimas")

## Paleistis

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S gcc -o "${0%.*}.bin" "$0"; "./${0%.*}.bin" "$@"; exit $?
```

## Kompiliavimas

```bash
gcc -static -o c_sys-upgrade.bin c_sys-upgrade.c
./c_sys-upgrade.bin
```

## Skriptai

* [sys-upgrade <sup>&#x2B67;</sup>](./c_sys-upgrade.c "sys-upgrade")
