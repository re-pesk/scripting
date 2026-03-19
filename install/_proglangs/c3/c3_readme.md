[Grįžti &#x2BA2;](../readme.md "Grįžti")

# C3 [<sup>&#x2B67;</sup>](https://c3-lang.org/)

* Paskiausias leidimas: 0.7.8
* Išleista: 2025-12-06

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/c3lang/c3c/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(c3c --version 2>/dev/null | head -n 1 | awk '{print "v"$NF}')"

# Jeigu vėliausia programos versija nėra naujesnė nei įdiegtoji, diegimą nutraukti.

rm -rf "${HOME}/.opt/c3"
curl -fsSLo - "https://github.com/c3lang/c3c/releases/download/${LATEST}/c3-linux.tar.gz" \
| tar  --transform 'flags=r;s/^(c3)/\1/x' --show-transformed-names -xzvC "${HOME}/.opt"
ln -fs "${HOME}/.opt/c3/c3c" "${HOME}/.local/bin"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(c3c --version 2>/dev/null | head -n 1 | awk '{print "v"$NF}')"

unset LATEST
```

## Paleistis

```bash
c3c compile-run -o vykdomasis-failas.bin kodo-failas.c3
```

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S c3c compile-run -o "${0%.*}.bin" "$0" -- "$@"; exit $?
```

## Kompiliavimas

```bash
c3c compile -o vykdomasis-failas.bin kodo-failas.c3
./vykdomasis-failas.bin
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/c3/c3_readme.md "skriptai")
