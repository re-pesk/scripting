[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Groovy [<sup>&#x2B67;</sup>](https://groovy-lang.org/)

* Paskiausias leidimas: 5.0.4
* Išleista: 2025-02-25

## Parengimas

Jeigu nėra sukurtas, sukuriamas ~/.pathrc failas, į .bashrc failą įterpiama jo įkėlimo komanda

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

Jeigu nėra įdiegtos, įdiegiamos [curl](../curl/curl.md), unzip ir [xq](../xq/xq.md)

## Diegimas

Paleidžiamas diegimo skriptas `groovy_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$( curl -s https://groovy.apache.org/download.html#distro \
  | xq -q "button[id='big-download-button']" --attr "onclick" \
  | awk -F'["-]' '{print $(NF-1)}' | sed 's/\.zip$//' )"

printf '\nVersijos:\n  Vėliausia: v%s\n  Įdiegta:   v%s\n\n' \
  "${LATEST}" "$(groovy --version 2> /dev/null | awk '{print $3}')"

# Jeigu vėliausia programos versija nėra naujesnė nei įdiegtoji, diegimą nutraukti.

curl -sSLO "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-${LATEST}.zip"

printf 'sha256 kontrolinės sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "apache-groovy-sdk-${LATEST}.zip" | awk '{print $1}')" \
  "$(curl -sSL "https://downloads.apache.org/groovy/${LATEST}/distribution/apache-groovy-sdk-${LATEST}.zip.sha256" |\
  tr -d '\r')"

unzip "groovy-sdk-${LATEST}.zip"
rm -rf "${HOME}/.opt/groovy"
mv -T "groovy-${LATEST}" "${HOME}/.opt/groovy"
rm -f "groovy-sdk-${LATEST}.zip"

printf '%s\n' $'[ -z "$JAVA_HOME" ] && {
  JAVA_HOME="$(which java | xargs readlink -f | xargs dirname | xargs dirname)"
  export JAVA_HOME
}\n
[[ -d "${HOME}/.opt/groovy/bin" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/groovy/bin:"* ]] && \
    export PATH="${HOME}/.opt/groovy/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/groovy/env.sh"
. "${HOME}/.opt/groovy/env.sh"

printf '\nVersijos:\n  Vėliausia: v%s\n  Įdiegta:   v%s\n\n' \
  "${LATEST}" "$(groovy --version 2> /dev/null | awk '{print $3}')"

unset LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad skriptas `${HOME}/.opt/groovy/env.sh` sistemos apvalkale būtų vykdomas automatiškai.

arba

```bash
bash groovy_install.sh
```

## Paleistis

```bash
groovy kodo-failas.groovy
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S groovy
```

arba

```bash
///usr/bin/env groovy "$0" "$@"; exit $?
```
