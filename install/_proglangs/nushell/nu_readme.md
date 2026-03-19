[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Nushell [<sup>&#x2B67;</sup>](https://www.nushell.sh/)

* Paskiausias leidimas: 0.103.0
* Išleista: 2025-03-19

## Parengimas

Jeigu nėra sukurtas, sukuriamas ~/.pathrc failas, įterpiamas jo įkėlimo komanda į .bashrc failą

```bash
[ -f "${HOME}/.pathrc" ] || touch "${HOME}/.pathrc"
(( $(grep -c '#begin include .pathrc' < ${HOME}/.bashrc) > 0 )) \
|| echo '#begin include .pathrc

# include .pathrc if it exists
if [ -f "${HOME}/.pathrc" ]; then
  . "${HOME}/.pathrc"
fi

#end include .pathrc' >> ${HOME}/.bashrc
```

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

Paleidžiamas diegimo skriptas `nu_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/nushell/nushell/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(nu -v 2> /dev/null)"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -LO "https://github.com/nushell/nushell/releases/download/${LATEST}/nu-${LATEST}-x86_64-unknown-linux-gnu.tar.gz"

printf 'sha256 patikros sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "nu-${LATEST}-x86_64-unknown-linux-gnu.tar.gz" | awk '{print $1}')" \
  "$(curl -sSL "https://github.com/nushell/nushell/releases/expanded_assets/${LATEST}" |\
  xq -q "li > div:has(a span:contains('nu-${LATEST}-x86_64-unknown-linux-gnu.tar.gz')) ~ div > div > span > span" |\
  awk -F ':' '{print $NF}')"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

rm -rf "${HOME}/.opt/nu"
tar --file="nu-${LATEST}-x86_64-unknown-linux-gnu.tar.gz" \
  --transform 'flags=r;s/nu.+gnu/nu/x' --show-transformed-names -xzv -C "${HOME}/.opt"
rm -f "nu-${LATEST}-x86_64-unknown-linux-gnu.tar.gz"

printf '%s\n' $'[[ -d "${HOME}/.opt/nu" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/nu:"* ]] && \
    export PATH="${HOME}/.opt/nu${PATH:+:${PATH}}"' > "${HOME}/.opt/nu/env.sh"
. "${HOME}/.opt/nu/env.sh"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(nu -v 2> /dev/null)"

unset LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad skriptas `${HOME}/.opt/nu/env.sh` sistemos apvalkale būtų vykdomas automatiškai.

## Paleistis

```bash
nu kodo-failas.nu
```

### Vykdymo instrukcija (shebang)

```bash
#! /usr/bin/env -S nu
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/nushell/nu_readme.md "skriptai")
