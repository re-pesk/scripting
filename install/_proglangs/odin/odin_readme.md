[Grįžti &#x2BA2;](../proglangs_readme.md "Grįžti")

# Odin [<sup>&#x2B67;</sup>](https://odin-lang.org/)

* Paskiausias leidimas: dev-2025-03
* Išleista: 2025-03-05

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

Paleidžiamas diegimo skriptas `odin_install.sh` arba terminale įvykdomos komandos:

```bash
dpkg -s clang &>/dev/null || sudo apt install clang

LATEST="$(curl -sSLo /dev/null -w "%{url_effective}" "https://github.com/odin-lang/Odin/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(odin version 2> /dev/null | awk -F'[ -]' '{print $3"-"$4"-"$5}')"

curl -sSLO "https://github.com/odin-lang/Odin/releases/download/${LATEST}/odin-linux-amd64-${LATEST}.tar.gz"

printf 'sha256 kontrolinės sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "odin-linux-amd64-${LATEST}.tar.gz" | awk '{print $1}')" \
  "$(curl -sSLo - "https://github.com/odin-lang/Odin/releases/expanded_assets/${LATEST}" \
  | xq -q "li > div:has(a span:contains('odin-linux-amd64-${LATEST}.tar.gz')) ~ div > div > span > span" \
  | awk -F':' '{print $NF}')"

rm -rf "${HOME}/.opt/odin"
tar --file "odin-linux-amd64-${LATEST}.tar.gz" \
  --transform 'flags=r;s/^(odin)[^\/]+/\1/x' \
  --show-transformed-names -xzC "${HOME}/.opt"
rm -f "odin-linux-amd64-${LATEST}.tar.gz"

ln -fs "${HOME}/.opt/odin/odin" "${HOME}/.local/bin/"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(odin version 2> /dev/null | awk -F'[ -]' '{print $3"-"$4"-"$5}')"

unset LATEST
```

arba

```bash
bash odin_install.sh
```

## Paleistis

```bash
odin run kodo-failas.odin -file -out:vykdomasis-failas.bin
```

### odin-script.sh

Odino failų paleidimą supaprastina pagalbinis failas _odin-script.sh_. Jis turi būti arba tame pačiame kataloge kaip ir leidžiamas failas, arba viename iš katalogų, nurodytų aplinkos kintamajame `PATH`.

```bash
./odin-script.sh kodo-failas.odin
```

### Vykdymo eiluė

Norint kodo failą paversti vykdomuoju failu, reikia suteikti jam vykdymo teises ir failo pradžioje įrašyti eilutę:

```bash
///usr/bin/env odin run "$0" -file -out:"${0%.*}.bin" -- "$@"; exit $?
```

## Kompiliavimas

```bash
odin build kodo-failas.odin -file -out:vykdomasis-failas.bin
./vykdomasis-failas.bin
```
