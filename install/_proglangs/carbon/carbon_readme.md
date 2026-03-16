[Grįžti &#x2BA2;](../proglangs_readme.md "Grįžti")

# Carbon [<sup>&#x2B67;</sup>](https://docs.carbon-lang.dev/)

* Paskiausias leidimas: nightly.2025.04.01

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

```bash
# Gauti paskutinės programos versijos numerį
LATEST="$(date -d yesterday +0.0.0-0.nightly.%Y.%m.%d)"

# Patikrinti, ar kompiuteryje įdiegta kuri nors programos versija. Sulyginti versijas
printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(carbon version 2>/dev/null | awk -F': |\+' '{print $2}')"

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
# Sukurti simbolinę nuorodą į vykdomajį failą.
rm -rf ${HOME}/.opt/carbon

# Pasirinkti archyvą iš https://github.com/carbon-language/carbon-lang/releases
curl -fsSLo - "https://github.com/carbon-language/carbon-lang/releases/download/v${LATEST}/carbon_toolchain-${LATEST}.tar.gz" | \
  tar --transform 'flags=r;s/^(carbon)[^\/]+/\1/x' --show-transformed-names -xzvC "${HOME}/.opt"
ln -fs ${HOME}/.opt/carbon/lib/carbon/carbon-busybox ${HOME}/.local/bin/carbon
(( $(apt list --installed 2>/dev/null | grep -c -P '^libgcc-11-dev') > 0 )) || sudo apt install libgcc-11-dev

# Patikrinti, ar kompiuteryje įdiegta Carbon versija yra vėliausia
printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(carbon version 2>/dev/null | awk -F': |\+' '{print $2}')"

# Ištrinti kintamuosius
unset LATEST
```

## Paleistis

### Vykdymo instrukcija (shebang)

Vykdymo instrukcijos formato, tinkamo carbono išeities kodo failams, išsiaiškinti nepavyko.

## Kompiliavimas

```bash
carbon compile --output=objektinis-failas.o kodo-failas.carbon
carbon link --output=vykdomasis-failas.bin objektinis-failas.o
./vykdomasis-failas.bin
```
