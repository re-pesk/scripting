[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Janet [<sup>&#x2B67;</sup>](https://janet-lang.org/)

* Paskiausias leidimas: 1.38.0
* Išleista: 2025-03-19

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

Paleidžiamas diegimo skriptas `janet_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/janet-lang/janet/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(janet --version 2> /dev/null | awk -F '-' '{print $1}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -LO "https://github.com/janet-lang/janet/releases/download/${LATEST}/janet-${LATEST}-linux-x64.tar.gz"

printf 'sha256 patikros sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "janet-${LATEST}-linux-x64.tar.gz" | awk '{print $1}')" \
  "$(curl -sL "https://github.com/janet-lang/janet/releases/expanded_assets/${LATEST}" \
| xq -q "li > div:has(a span:contains('janet-${LATEST}-linux-x64.tar.gz')) ~ div > div > span > span" \
| awk -F ':' '{print $NF}')"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

rm -rf "${HOME}/.opt/janet"
tar --file="janet-${LATEST}-linux-x64.tar.gz" \
  --transform 'flags=r;s/^\.\/(janet)[^\/]+/\1/x' \
  --show-transformed-names -xzC "${HOME}/.opt"

rm -f "janet-${LATEST}-linux-x64.tar.gz"

ln -sf "${HOME}/.opt/janet/bin/janet" "${HOME}/.local/bin/"
ln -sf "${HOME}/.opt/janet/man/man1/janet.1" "${HOME}/.local/man/man1/"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(janet --version 2> /dev/null | awk -F '-' '{print $1}')"

unset LATEST
```

## Paleistis

```bash
janet kodo-failas.janet
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env janet
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/janet/janet_readme.md "skriptai")
