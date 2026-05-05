[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Arsh [<sup>&#x2B67;</sup>](https://github.com/sekiguchi-nagisa/arsh)

* Vėliausias leidimas: 0.40.0
* Išleista: 2025-12-30

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Diegimas

```bash
LATEST="$(
  curl -sL -o /dev/null -w "%{url_effective}" "https://github.com/sekiguchi-nagisa/arsh/releases/latest" \
    | xargs basename | cut -c 2-
)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(arsh --version 2> /dev/null | awk '{print $3}' | sed 's/,$//g')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

git clone https://github.com/sekiguchi-nagisa/arsh.git
mkdir -p arsh/build
cd arsh/build
cmake -DCMAKE_INSTALL_PREFIX=${HOME}/.opt/arsh ..
make -j4
rm -rf "${HOME}/.opt/arsh"
make install
cd ../../
rm -rf arsh

# Sukurti simbolines nuorodas į vykdomąjį skriptą.
ln -frsT "${HOME}/.bin/app-launcher" "${HOME}/.bin/arsh"
ln -frsT "${HOME}/.bin/app-launcher" "${HOME}/.bin/arshd"
ln -frsT "${HOME}/.bin/app-launcher" "${HOME}/.bin/arcolorize"

# Sukurti įrašus faile .app_map
grep -qP 'arshd:arsh' "${HOME}/.app_map" || printf $'arshd:arsh\n' >> "${HOME}/.app_map"
grep -qP 'arcolorize:arsh' "${HOME}/.app_map" || printf $'arcolorize:arsh\n' >> "${HOME}/.app_map"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(arsh --version 2> /dev/null | awk '{print $3}' | sed 's/,$//g')"

unset LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad skriptas `${HOME}/.opt/arsh/env.sh` sistemos apvalkale būtų vykdomas automatiškai.

## Paleistis

```bash
arsh kodo-failas.arsh
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S arsh
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/arsh/arsh_readme.md "skriptai")
