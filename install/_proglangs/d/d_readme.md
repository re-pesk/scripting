[Grįžti &#x2BA2;](../readme.md "Grįžti")

# D [<sup>&#x2B67;</sup>](https://dlang.org/)

* Paskiausias leidimas: 2.111.0
* Išleista: 2026-01-07

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

```bash
LATEST="$(curl -s https://downloads.dlang.org/releases/LATEST)"

printf '\nVersijos:\n  Vėliausia: v%s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(dmd --version 2>/dev/null | head -n 1 | awk '{print $NF}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -LO "https://downloads.dlang.org/releases/${LATEST%%.*}/${LATEST}/dmd_${LATEST}-0_amd64.deb"

sudo apt install "./dmd_${LATEST}-0_amd64.deb"
rm -rf "./dmd_${LATEST}-0_amd64.deb"

printf '\nVersijos:\n  Vėliausia: v%s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(dmd --version 2>/dev/null | head -n 1 | awk '{print $NF}')"

rdmd --version
dub --version

unset LATEST
```

## Paleistis

```bash
rdmd kodo_failas.d
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
rdmd --build-only -release -of=vykdomasis_failas.bin kodo_failas.d
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/d/d_readme.md "skriptai")
