[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Chapel [<sup>&#x2B67;</sup>](https://chapel-lang.org/)

## Parengimas

Operacinė sistema – Ubuntu 24.04

Jeigu nėra įdiegta, įdiekite [curl](../curl/curl.md) ir xargs (findutils).

## Diegimas

Paleidžiamas diegimo skriptas `chapel_install.sh` arba terminale įvykdomos komandos:

```bash
# Gauti paskutinės programos versijos numerį
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/chapel-lang/chapel/releases/latest" | xargs basename)"

# Patikrinti, ar kompiuteryje įdiegta kuri nors programos versija. Sulyginti versijas
printf '\nVersijos:\n  Vėliausia: v%s\n  Įdiegta:   v%s\n\n' \
  "${LATEST}" "$(chpl --version 2>/dev/null | head -n 1 | awk '{print $NF}')"

# Atsisiųsti failą iš repozitorijos
curl -sSLO "https://github.com/chapel-lang/chapel/releases/download/${LATEST}/chapel-${LATEST}-1.ubuntu24.amd64.deb"

# Sulyginti failo patikros sumą su tinklalapio patikros suma.
printf 'sha256 kontrolinės sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "chapel-${LATEST}-1.ubuntu24.amd64.deb" | awk '{print $1}')" \
  "$(curl -sL "https://github.com/chapel-lang/chapel/releases/expanded_assets/${LATEST}" |\
    xq -q "li > div:has(a span:contains('chapel-${LATEST}-1.ubuntu24.amd64.deb')) ~ div > div > span > span" |\
    awk -F ':' '{print $NF}')"

# Jeigu patikros sumos nesutampa, ištrinti atsisiųstą failą ir nutraukti diegimą

# Instaliuoti Chapel. Ištrinti atsisiųstą archyvą.
sudo dpkg -i "chapel-${LATEST}-1.ubuntu24.amd64.deb"
sudo apt-get install -f
rm -f "chapel-${LATEST}-1.ubuntu24.amd64.deb"

# Pataisyti failų privilegijas
sudo chown root:root /usr/bin/chpl*
sudo chown -R root:root /usr/share/chapel

# Patikrinti, ar kompiuteryje įdiegta Chapel versija yra vėliausia
printf '\nVersijos:\n  Vėliausia: v%s\n  Įdiegta:   v%s\n\n' \
  "${LATEST}" "$(chpl --version 2>/dev/null | head -n 1 | awk '{print $NF}')"

# Ištrinti kintamuosius
unset LATEST
```

## Paleistis

```bash
chpl --output="kodo-failas.bin" kodo-failas.chpl
./kodo-failas.bin
```

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S rm -f "./${0%.*}.bin"; chpl --output="${0%.*}.bin" "$0"; [[ $? == 0 ]] && "./${0%.*}.bin" "$@"; exit $?
```
