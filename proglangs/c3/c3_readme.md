[Grįžti &#x2BA2;](../readme.md "Grįžti")

# C3 [<sup>&#x2B67;</sup>](https://c3-lang.org/)

## Diegimas

[Diegimas <sup>&#x2B67;</sup>](../../install/_proglangs/c3/c3_readme.md "Diegimas")

## Paleistis

```bash
c3c compile-run -o c3_sys-upgrade.bin c3_sys-upgrade.c3
```

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env c3c compile-run -o "${0%.*}.bin" "$0" -- "$@"; exit $?
```

## Kompiliavimas

```bash
c3c compile -o c3_sys-upgrade.bin c3_sys-upgrade.c3
./c3_sys-upgrade.bin
```

## Skriptai

* [sys-upgrade <sup>&#x2B67;</sup>](./c3_sys-upgrade.c3 "sys-upgrade")
