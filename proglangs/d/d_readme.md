[Grįžti &#x2BA2;](../readme.md "Grįžti")

# D [<sup>&#x2B67;</sup>](https://dlang.org/)

## Diegimas

[Diegimas <sup>&#x2B67;</sup>](../../install/_proglangs/d/d_readme.md "Diegimas")

## Paleistis

```bash
rdmd d_sys-upgrade.d
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env rdmd
```

arba

```bash
///usr/bin/env rdmd "$0" "$@"; exit $?
```

## Kompiliavimas

```bash
rdmd --build-only -release -of=d_sys-upgrade.bin d_sys-upgrade.d
```

## Skriptai

* [sys-upgrade <sup>&#x2B67;</sup>](./d_sys-upgrade.d "sys-upgrade")
