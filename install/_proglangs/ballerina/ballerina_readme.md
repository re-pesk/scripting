[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Ballerina [<sup>&#x2B67;</sup>](https://ballerina.io/)

## Parengimas

Operacinė sistema – Ubuntu 24.04

Jeigu nėra sukurtas, sukuriamas ~/.pathrc failas ir įterpiama jo įkėlimo komanda į .bashrc failą

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

Jeigu nėra įdiegta, įdiekite [curl](../curl/curl.md), unzip ir xargs (findutils).

## Diegimas

Paleidžiamas diegimo skriptas `balerina_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(
  curl -sLo /dev/null -w "%{url_effective}" "https://github.com/ballerina-platform/ballerina-distribution/releases/latest" | \
  xargs basename |  cut -c 2-
)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(bal --version 2>/dev/null | head -n 1 | awk '{print $2}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -LO "https://github.com/ballerina-platform/ballerina-distribution/releases/download/v${LATEST}/ballerina-${LATEST}-swan-lake.zip"
curl -LO "https://github.com/ballerina-platform/ballerina-distribution/releases/download/v${LATEST}/ballerina-${LATEST}-swan-lake.zip.sha256"

printf 'sha256 patikros sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "ballerina-${LATEST}-swan-lake.zip")" \
  "$(cat "ballerina-${LATEST}-swan-lake.zip.sha256" | awk -F'\(|\)= |\/| ' '{print $NF"  "$5".sha256"}')"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

unzip -q "ballerina-${LATEST}-swan-lake.zip"
rm -rf "${HOME}/.opt/ballerina"
mv -T "./ballerina-${LATEST}-swan-lake" "${HOME}/.opt/ballerina"
rm -f ballerina-${LATEST}-swan-lake.zip*

printf '%s\n' $'[[ -d "${HOME}/.opt/ballerina/bin" ]] && \
  && [[ ":${PATH}:" != *":${HOME}/.opt/ballerina/bin:"* ]] \
    && export PATH="${HOME}/.opt/ballerina/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/ballerina/env.sh"
. "${HOME}/.opt/ballerina/env.sh"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(bal --version 2>/dev/null | head -n 1 | awk '{print $2}')"

unset LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad skriptas `${HOME}/.opt/ballerina/env.sh` sistemos apvalkale būtų vykdomas automatiškai.

## Paleistis

```bash
bal run kodo-failas.bal
```

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S bal run "$0" "$@"; exit $?
```

## Kompiliavimas

```bash
bal build kodo-failas.bal
bar run kodo-failas.jar
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/ballerina/ballerina_readme.md "skriptai")
