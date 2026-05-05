[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Hilbish [<sup>&#x2B67;</sup>](https://rosettea.github.io/Hilbish/)

* Vėliausias leidimas: 2.3.4
* Išleista: 2024-12-29

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

Paleidžiamas diegimo skriptas `hilbish_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" https://github.com/Rosettea/Hilbish/releases/latest | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(hilbish --version 2> /dev/null | head -n 1 | awk '{print $2}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -LO "https://github.com/sammy-ette/Hilbish/releases/download/${LATEST}/hilbish-${LATEST}-linux-amd64.tar.gz"
printf '%s\n%s\n\n' \
  "$(md5sum "hilbish-${LATEST}-linux-amd64.tar.gz" | awk '{print $1}')" \
  "$(curl -sSL "https://github.com/sammy-ette/Hilbish/releases/download/${LATEST}/hilbish-${LATEST}-linux-amd64.tar.gz.md5")"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

rm -rf "${HOME}/.opt/hilbish"
tar --file="hilbish-${LATEST}-linux-amd64.tar.gz" \
  --transform 'flags=r;s/^/hilbish\//x' --show-transformed-names -xzvC "${HOME}/.opt"
rm -f "hilbish-${LATEST}-linux-amd64.tar.gz"

ln -sf "${HOME}/.opt/hilbish/hilbish" "${HOME}/.local/bin/"

mkdir "${HOME}/.config/hilbish"
cp -T "${HOME}/.opt/hilbish/.hilbishrc.lua" "${HOME}/.config/hilbish/init.lua"
echo "hilbish.opts.tips = false" >> "${HOME}/.config/hilbish/init.lua"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(hilbish --version 2> /dev/null | head -n 1 | awk '{print $2}')"

unset LATEST
```

## Paleistis

```bash
hilbish kodo-failas.lua
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S hilbish
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/hilbish/hilbish_readme.md "skriptai")
