[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Amber [<sup>&#x2B67;</sup>](https://amber-lang.com/)

„Amber“ yra programavimo kalba, kompiliuojama į Bash scenarijus. Ji pasižymi modernia sintakse, saugos funkcijomis, tipų saugumu ir praktiškomis galimybėmis, kurių „Bash“ negali pasiūlyti.

## Parengimas

Jeigu nėra sukurtas, sukuriamas ~/.pathrc failas ir įterpiama jo įkėlimo komanda į .bashrc failą

```bash
[ -f "${HOME}/.pathrc" ] || touch "${HOME}/.pathrc"
(( $(grep -c '#begin include .pathrc' < ${HOME}/.bashrc) > 0 )) \
  || echo $'#begin include .pathrc\n
# include .pathrc if it exists
if [ -f "${HOME}/.pathrc" ]; then
  . "${HOME}/.pathrc"
fi\n
#end include .pathrc' >> ${HOME}/.bashrc
```

Jeigu nėra įdiegta, įdiekite [curl](../curl/curl.md), unzip ir xargs (findutils).

## Diegimas

Paleidžiamas diegimo skriptas `amber_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/amber-lang/amber/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(amber --version 2> /dev/null | awk '{print $2}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

FILE_NAME="amber-$(
  uname -s | sed -E 's/^(.)/\L\1/'
)-$(
  (( $(find /lib /usr/lib -name "ld-musl-*.so.1" | wc -l ) > 0 )) && echo "musl" || echo "gnu"
)-$(uname -m).tar.xz"

curl -Lo "tmp_.${FILE_NAME}" "https://github.com/amber-lang/amber/releases/download/${LATEST}/${FILE_NAME}"

printf 'sha256 patikros sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "tmp_.${FILE_NAME}" | awk '{print $1}')" \
  "$(curl -sL "https://github.com/amber-lang/amber/releases/expanded_assets/${LATEST}" \
    | xq -q "li > div:has(a span:contains('${FILE_NAME}')) ~ div > div > span > span" \
    | awk -F':' '{print $NF}')"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

rm -rf "${HOME}/.opt/amber"
tar --file "tmp_.${FILE_NAME}" \
  --transform "flags=r;s/^/amber\/lib\/$(uname -m)\/amber\//x" \
  --show-transformed-names -xvC "${HOME}/.opt"
rm -f "tmp_.${FILE_NAME}"*

mkdir -p "${HOME}/.opt/amber/bin"
ln -frs "${HOME}/.opt/amber/lib/x86_64/amber/amber" "${HOME}/.opt/amber/bin/"
ln -fs "${HOME}/.opt/amber/bin/amber" "${HOME}/.local/bin/"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(amber --version 2> /dev/null | awk '{print $2}')"

unset FILE_NAME LATEST
```

## Paleistis

```bash
amber run kodo-failas.ab
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S amber run
```

arba

```bash
///usr/bin/env -S amber run "$0" "$@"; exit $?
```

## Kompiliavimas į bash'ą

```bash
amber build kodo-failas.ab
bash kodo-failas.sh
```

## Skriptai

* [sys-upgrade <sup>&#x2B67;</sup>](./amber_sys-upgrade.ab "sys-upgrade")
