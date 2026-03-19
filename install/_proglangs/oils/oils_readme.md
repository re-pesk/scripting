<!-- markdownlint-disable-file no-hard-tabs -->
[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Oils for Unix [<sup>&#x2B67;</sup>](https://www.oilshell.org/)

* Paskiausias leidimas: [0.37.0](https://oils.pub/release/latest/)
* Išleista: 2025-11-30

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

Paleidžiamas diegimo skriptas `oils_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(curl -sSLo - https://raw.githubusercontent.com/oils-for-unix/oils/refs/heads/master/oils-version.txt | head -n 1)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(osh --version | head -n 1 | awk '{print $2}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -sSLo - "https://oils.pub/download/oils-for-unix-${LATEST}.tar.gz" | tar -xzv

INIT_DIR="$PWD"
cd "oils-for-unix-${LATEST}" || exit 1
./configure --prefix "${HOME}/.opt/oils" --datarootdir "${HOME}/.opt/oils/share"
_build/oils.sh
[ -d "${HOME}/.opt/oils" ] && rm -rf "${HOME}/.opt/oils"
./install
cd "${INIT_DIR}"
rm -rf "oils-for-unix-${LATEST}"

ln -sfT "${HOME}/.opt/oils/bin/oils-for-unix" "${HOME}/.local/bin/osh"
ln -sfT "${HOME}/.opt/oils/bin/oils-for-unix" "${HOME}/.local/bin/ysh"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(osh --version | head -n 1 | awk '{print $2}')"

unset INIT_DIR LATEST
```

## Paleistis

```bash
osh osh-kodo-failas.oil
ysh ysh-kodo-failas.oil
```

### Vykdymo instrukcija (shebang)

Pagal skripto dialektą:

```bash
#!/usr/bin/env -S osh
#!/usr/bin/env -S ysh
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/oils/oils_readme.md "skriptai")
