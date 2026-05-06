[Grįžti &#x2BA2;](../readme.md "Grįžti")

# C++ [<sup>&#x2B67;</sup>](https://cplusplus.com/doc/tutorial/)

## Diegimas

[Diegimas <sup>&#x2B67;</sup>](../../install/proglangs/c++/c++_readme.md "Diegimas")

## Paleistis

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S g++ -Wno-sizeof-array-argument -std=c++2b -o "${0%.*}.bin" "$0"; "./${0%.*}.bin" "$@"; exit $?
```

## Kompiliavimas

```bash
g++ -static -Wno-sizeof-array-argument -std=c++2b -o c++_sys-upgrade.bin c++_sys-upgrade.cpp
./c++_sys-upgrade.bin
```

## Skriptai

* [sys-upgrade <sup>&#x2B67;</sup>](./c++_sys-upgrade.cpp "sys-upgrade")
