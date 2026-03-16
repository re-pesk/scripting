[Grįžti &#x2BA2;](../proglangs_readme.md "Grįžti")

# D [<sup>&#x2B67;</sup>](https://dlang.org/)

* Paskiausias leidimas: 2.111.0
* Išleista: 2026-01-07

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

```bash
LATEST="$(curl -s https://downloads.dlang.org/releases/LATEST)"

# Patikrinti, ar kompiuteryje įdiegta kuri nors programos versija. Sulyginti versijas
printf '\nVersijos:\n  Vėliausia: v%s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(dmd --version 2>/dev/null | head -n 1 | awk '{print $NF}')"

# Atsisiųsti failą iš tinklalapio
curl -sSLO "https://downloads.dlang.org/releases/${LATEST%%.*}/${LATEST}/dmd_${LATEST}-0_amd64.deb"

# Įdiegti programą. Ištrinti laikiną aplanką.
sudo apt install "./dmd_${LATEST}-0_amd64.deb"
rm -rf "./dmd_${LATEST}-0_amd64.deb"

# Patikrinti, ar kompiuteryje įdiegta vėliausia programos versija. Sulyginti versijas
printf '\nVersijos:\n  Vėliausia: v%s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(dmd --version 2>/dev/null | head -n 1 | awk '{print $NF}')"

# Patikrinti kitų programų veikimą
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
