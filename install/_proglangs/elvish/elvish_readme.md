[Grįžti &#x2BA2;](../proglangs_readme.md "Grįžti")

# Elvish shell [<sup>&#x2B67;</sup>](https://elv.sh/)

* Paskiausias leidimas: 0.21.0
* Išleista: 2024-08-14

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

Paleidžiamas diegimo skriptas `elvish_install.sh` arba terminale įvykdomos komandos:

```bash
# Gauti programos paskutinės versijos numerį
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/elves/elvish/releases/latest" | xargs basename )"

# Patikrinti, ar kompiuteryje įdiegta kuri nors programos versija. Sulyginti versijas
printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   v%s\n\n' \
  "${LATEST}" "$(elvish --version | awk -F '+' '{print $1}')"

# Jeigu vėliausia programos versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

# Atsisiųsti failą iš svetainės
curl -sSLO "https://dl.elv.sh/linux-amd64/elvish-${LATEST}.tar.gz"

# Sulyginti failo patikros sumą su tinklalapio patikros suma.
printf 'sha256 kontrolinės sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "elvish-${LATEST}.tar.gz")" \
  "$(curl -sSL "https://dl.elv.sh/linux-amd64/elvish-${LATEST}.tar.gz.sha256sum")"

# Jeigu patikros sumos nesutampa, ištrinti atsisiųstą failą ir nutraukti diegimą

# Ištrinti įdiegtą versiją.
# Išskleisti iš atsisiųstą archyvą į diegimo katalogą.
# Ištrinti atsisiųstą archyvą.
rm -rf "${HOME}/.opt/elvish"
tar -f "elvish-${LATEST}.tar.gz" --transform 'flags=r;s/^/elvish\//x' --show-transformed-names -xzvC "${HOME}/.opt"
rm -f elvish-${LATEST}.tar.gz*

# Sukurti simbolinę nuorodą į vykdomąjį failą.
ln -fs "${HOME}/.opt/elvish/elvish" "${HOME}/.local/bin"

# Patikrinti, ar kompiuteryje įdiegta vėliausia programos versija. Sulyginti versijas
printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   v%s\n\n' \
  "${LATEST}" "$(elvish --version | awk -F '+' '{print $1}')"

# Ištrinti kintamuosius
unset LATEST
```

## Paleistis

```bash
elvish kodo-failas.elv
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env elvish
```
