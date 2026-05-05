[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Pike [<sup>&#x2B67;</sup>](https://pike.lysator.liu.se/)

## Diegimas

[Diegimas <sup>&#x2B67;</sup>](../../install/proglangs/pike/pike_readme.md "Diegimas")

## Paleistis

```bash
pike pike_sys-upgrade.pike
```

### Vykdymo instrukcija (shebang)

Norint *pike_sys-upgrade.pike* paversti vykdomuoju failu, reikia suteikti jam vykdymo teises ir failo pradžioje įrašyti vydymo eilutę.

Įprastinė eilutė:

```bash
#!/usr/bin/env -S pike
```

Bash'o* kodo eilutė:

```bash
///usr/bin/env -S pike "$0" "$@"; exit "$?"
```

## Skriptai

* [sys-upgrade <sup>&#x2B67;</sup>](./pike_sys-upgrade.pike "sys-upgrade")
