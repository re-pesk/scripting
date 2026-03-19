[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Onyx [<sup>&#x2B67;</sup>](https://onyxlang.io/)

## Diegimas

[Diegimas <sup>&#x2B67;</sup>](../../install/_proglangs/onyx/onyx_readme.md "Diegimas")

## Paleistis

```bash
onyx run onyx_sys-upgrade.onyx
```

### Vykdymo eiluė

Norint kodo failą paversti vykdomuoju failu, reikia suteikti jam vykdymo teises ir failo pradžioje įrašyti eilutę:

```bash
///usr/bin/env -S onyx run "$0" "$@"; exit $?
```

## Kompiliavimas

```bash
onyx build -o onyx_sys-upgrade.wasm onyx_sys-upgrade.onyx
onyx run onyx_sys-upgrade.wasm
```

## Skriptai

* [sys-upgrade <sup>&#x2B67;</sup>](./onyx_sys-upgrade.onyx "sys-upgrade")
