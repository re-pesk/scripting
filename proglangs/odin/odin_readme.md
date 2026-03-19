[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Odin [<sup>&#x2B67;</sup>](ttps://odin-lang.org/)

## Diegimas

[Diegimas <sup>&#x2B67;</sup>](../../install/_proglangs/odin/odin_readme.md "Diegimas")

## Paleistis

```bash
odin run odin_sys-upgrade.odin -file -out:odin_sys-upgrade.bin
```

### Vykdymo eiluė

Norint *odin_sys-upgrade.odin* paversti vykdomuoju failu, reikia suteikti jam vykdymo teises ir failo pradžioje įrašyti eilutę:

```bash
///usr/bin/env odin run "$0" -file -out:"${0%.*}.bin" -- "$@"; exit $?
```

## Kompiliavimas

```bash
odin build odin_sys-upgrade.odin -file -out:odin_sys-upgrade.bin
./odin_sys-upgrade.bin
```

## Skriptai

* [sys-upgrade <sup>&#x2B67;</sup>](./odin_sys-upgrade.odin "sys-upgrade")
