[Grįžti &#x2BA2;](../readme.md "Grįžti")

# glow [<sup>&#x2B67;</sup>](https://github.com/charmbracelet/glow)

* Glow is a terminal based markdown reader designed from the ground up to bring out the beauty—and power—of the CLI.\
  \
  Use it to discover markdown files, read documentation directly on the command line. Glow will find local markdown files in subdirectories or a local Git repository.\
  &nbsp;
* Glow'as yra terminalams skirta markdown'o failų skaitymo   programa, sukurta nuo nulio, siekiant atskleisti komandinės eilutės sąsajos grožį ir galią.\
  \
  Naudokite ją markdown'o failams atrasti, dokumentacijai skaityti tiesiogiai komandinėje eilutėje. Glow'as ras vietinius markdown'o failus pakatalogiuose arba vietinėje Git'o saugykloje.

## Parengimas

Jeigu nėra įdiegta, įdiegiama [app-launcher](../../../utils/app-launcher/readme.md), [curl](../../misc/curl/curl.md) ir xargs (findutils).

## Diegimas

Terminale įvykdomos komandos:

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/charmbracelet/glow/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(glow --version | awk '{print "v"$3}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

FILE_NAME="glow_${LATEST#v}_Linux_x86_64.tar.gz"

curl -Lo "tmp_.${FILE_NAME}" "https://github.com/charmbracelet/glow/releases/download/${LATEST}/${FILE_NAME}"
curl -Lo "tmp_.checksums.txt" "https://github.com/charmbracelet/glow/releases/download/${LATEST}/checksums.txt"

printf 'sha256 patikros sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "tmp_.${FILE_NAME}" | awk '{print $1}')" \
  "$(cat "tmp_.checksums.txt" | grep -P "${FILE_NAME}$" | awk '{print $1}')"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

tar --file "tmp_.${FILE_NAME}" \
  --transform 'flags=r;s/^(glow)[^\/]+/tmp\1/x' \
  --show-transformed-names -xz # C "${APPS_STORE}"
mkdir -p "./glow/share/man/"
mv -T "glow/manpages" "glow/share/man/man1"
mkdir -p "./glow/bin"
mv -T "glow/glow" "glow/bin/glow"
rm -rf "${APPS_STORE}/glow"
mv -T "glow" "${APPS_STORE}/glow"
rm -rf tmp_.*

config-link "${APPS_BIN}/app-launcher" "${APPS_BIN}" glow
config-insert "${HOME}/.app_paths.conf" "glow=${APPS_STORE}/glow/bin"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(glow --version | awk '{print "v"$3}')"

unset FILE_NAME LATEST
```
