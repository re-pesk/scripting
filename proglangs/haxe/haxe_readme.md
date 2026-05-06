[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Haxe [<sup>&#x2B67;</sup>](https://haxe.org/)

* Paskiausias leidimas: 4.3.6
* Išleista: 2024-08-07

## Diegimas

[Diegimas <sup>&#x2B67;</sup>](../../install/proglangs/haxe/haxe_readme.md "Diegimas")

## Paleistis

```bash
haxe --run Haxe_sys_upgrade.hx
```

kur „Pagrindinė_klasė“ yra klasės su statiniu metodu „main“ pavadinimas. Failo, kuriame saugoma klasė, pavadinimas turi sutapti su pagrindinės klasės, o jo plėtinys turi būti „.hx“

### Vykdymo eiluė

Norint kodo failą paversti vykdomuoju failu, reikia suteikti jam vykdymo teises ir failo pradžioje įrašyti eilutę:

```bash
///usr/bin/env -S haxe --run "${0#.\/}" "$@"; exit $?
```

### Kompiliavimas

```bash
haxe -hl haxe_sys-upgrade.hl -main Haxe_sys_upgrade.hx
hl haxe_sys-upgrade.hl
```

## Skriptai

* [sys-upgrade <sup>&#x2B67;</sup>](./haxe_sys-upgrade.hx "sys-upgrade")
