[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Go [<sup>&#x2B67;</sup>](https://go.dev/)

* Paskiausias leidimas: 1.25.5
* Išleista: 2025-12-02

## Parengimas

Jeigu nėra sukurtas, sukuriamas ~/.pathrc failas, į .bashrc failą įterpiama jo įkėlimo komanda.

```bash
[ -f "${HOME}/.pathrc" ] || touch "${HOME}/.pathrc"
(( $(grep -c '# begin include .pathrc' < ${HOME}/.bashrc) > 0 )) \
|| echo '# begin include .pathrc

# include .pathrc if it exists
if [ -f "${HOME}/.pathrc" ]; then
  . "${HOME}/.pathrc"
fi

# end include .pathrc' >> ${HOME}/.bashrc
```

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md), xargs (findutils) ir [xq](../xq/xq.md).

## Diegimas

Paleidžiamas diegimo skriptas `go_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(curl -sSL https://go.dev/dl/ \
| xq -q "a.downloadBox[href$='.linux-amd64.tar.gz']" --attr href \
| xargs basename | sed -E 's/^(go[0-9\.]+)\..+$/\1/')"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(go version 2> /dev/null | awk '{print $3}')"

# Jeigu vėliausia programos versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -LO "https://go.dev//dl/${LATEST}.linux-amd64.tar.gz"

printf 'sha256 patikros sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "${LATEST}.linux-amd64.tar.gz" | awk '{print $1}')" \
  "$(curl -sL https://go.dev/dl/ | xq -q "td:has(a:contains('${LATEST}.linux-amd64.tar.gz')) ~ td:last-of-type tt")"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

rm -rf "${HOME}/.opt/go"
tar -f "${LATEST}.linux-amd64.tar.gz" -xz -C "${HOME}/.opt"
rm -f "${LATEST}.linux-amd64.tar.gz"

printf '%s\n' $'[[ -d "${HOME}/.opt/go/bin" ]] &&
  [[ ":${PATH}:" != *":${HOME}/.opt/go/bin:"* ]] &&
  export PATH="${HOME}/.opt/go/bin${PATH:+:${PATH}}"\n
[[ -d "${HOME}/go/bin" ]] &&
  [[ ":${PATH}:" != *":${HOME}/go/bin:"* ]] &&
  export PATH="${HOME}/go/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/go/env.sh"
. "${HOME}/.opt/go/env.sh"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(go version 2> /dev/null | awk '{print $3}')"

unset LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad skriptas `${HOME}/.opt/go/env.sh` sistemos apvalkale būtų vykdomas automatiškai.

## Paleistis

```bash
go run go_sys-upgrade.go
```

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S go run $0 $@ ; exit
```

## Kompiliavimas

```bash
go build -o vykdomasis-failas.bin kodo-failas.go
./vykdomasis-failas.bin
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/go/go_readme.md "skriptai")
