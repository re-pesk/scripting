[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Chapel [<sup>&#x2B67;</sup>](https://chapel-lang.org/)

## Parengimas

Jeigu nėra įdiegta, įdiekite [curl](../curl/curl.md) ir xargs (findutils).

## Diegimas

Paleidžiamas diegimo skriptas `chapel_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/chapel-lang/chapel/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(chpl --version 2>/dev/null | head -n 1 | awk '{print $NF}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -LO "https://github.com/chapel-lang/chapel/releases/download/${LATEST}/chapel-${LATEST}-1.ubuntu24.amd64.deb"

printf 'sha256 patikros sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "chapel-${LATEST}-1.ubuntu24.amd64.deb" | awk '{print $1}')" \
  "$(curl -sL "https://github.com/chapel-lang/chapel/releases/expanded_assets/${LATEST}" |\
    xq -q "li > div:has(a span:contains('chapel-${LATEST}-1.ubuntu24.amd64.deb')) ~ div > div > span > span" |\
    awk -F ':' '{print $NF}')"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

sudo dpkg -i "chapel-${LATEST}-1.ubuntu24.amd64.deb"
sudo apt-get install -f
rm -f "chapel-${LATEST}-1.ubuntu24.amd64.deb"

sudo chown root:root /usr/bin/chpl*
sudo chown -R root:root /usr/share/chapel

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
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

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/chapel/chapel_readme.md "skriptai")
