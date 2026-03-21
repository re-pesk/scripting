[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Scala [<sup>&#x2B67;</sup>](https://scala-lang.org/)

* Paskiausias leidimas: 3.8.1
* Išleista: 2026-01-22

## Parengimas

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

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

Paleidžiamas diegimo skriptas `scala_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/scala/scala3/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(scala version 2> /dev/null | tail -n +2 | awk '{print $NF}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -LO "https://github.com/scala/scala3/releases/download/${LATEST}/scala3-${LATEST}-x86_64-pc-linux.tar.gz"
curl -LO "https://github.com/scala/scala3/releases/download/${LATEST}/scala3-${LATEST}-x86_64-pc-linux.tar.gz.sha256"

sha256sum "scala3-${LATEST}-x86_64-pc-linux.tar.gz" | awk '{print $1}'
cat "scala3-${LATEST}-x86_64-pc-linux.tar.gz.sha256" | awk '{print $1}'

rm -rf "${HOME}/.opt/scala3"
tar --file="scala3-${LATEST}-x86_64-pc-linux.tar.gz" \
  --transform='flags=r;s/^(scala3)[^\/]+/\1/x' \
  --show-transformed-names -xzvC "${HOME}/.opt"
rm -f scala3-${LATEST}-x86_64-pc-linux.tar.gz*

printf '%s\n' $'[[ -d "${HOME}/.opt/scala3/bin" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/scala3/bin:"* ]] && \
    export PATH="${HOME}/.opt/scala3/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/scala3/env.sh"
. "${HOME}/.opt/scala3/env.sh"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(scala version 2> /dev/null | tail -n +2 | awk '{print $NF}')"

unset LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad skriptas `${HOME}/.opt/scala3/env.sh` sistemos apvalkale būtų vykdomas automatiškai.

## Paleistis

```bash
scala run scala_sys-upgrade.scala
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S scala shebang
```

arba

```bash
///usr/bin/env -S scala shebang "$0" "$@"; exit $?
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/scala/scala_readme.md "skriptai")
