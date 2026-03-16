[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Chapel [<sup>&#x2B67;</sup>](https://chapel-lang.org/)

## Diegimas

[Diegimas <sup>&#x2B67;</sup>](../../install/_proglangs/chapel/chapel_readme.md "Diegimas")

## Kompiliavimas ir paleistis

```bash
chpl --output=chapel_sys-upgrade.bin chapel_sys-upgrade.chpl
./chapel_sys-upgrade.bin
```

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S rm -f "./${0%.*}.bin"; chpl --output="${0%.*}.bin" "$0"; [[ $? == 0 ]] && "./${0%.*}.bin" "$@"; exit $?
```
