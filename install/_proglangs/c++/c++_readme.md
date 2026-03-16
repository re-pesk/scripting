[Grįžti &#x2BA2;](../proglangs_readme.md "Grįžti")

# C++ [<sup>&#x2B67;</sup>](https://cplusplus.com/doc/tutorial/)

* Paskiausias leidimas (gcc): 14.2.
* Išleista: 2024-08-01

## Diegimas

g++ instaliuojamas su Ubuntu 24.04 operacine sistema

## Paleistis

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S g++ -o "${0%.*}.bin" "$0"; "./${0%.*}.bin" "$@"; exit $?
```

## Kompiliavimas

```bash
g++ -static -Wno-sizeof-array-argument -std=c++2b -o vykdomasis-failas.bin kodo-failas.cpp
./vykdomasis-failas.bin
```
