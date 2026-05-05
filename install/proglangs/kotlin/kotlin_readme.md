[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Kotlin [<sup>&#x2B67;</sup>](https://kotlinlang.org/)

* Paskiausias leidimas: 2.3.0
* Išleista: 2025-12-16

## Parengimas

Jeigu nėra sukurtas, sukuriamas ~/.pathrc failas, įterpiamas jo įkėlimo komanda į .bashrc failą

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

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

Paleidžiamas diegimo skriptas `kotlin_install.sh` arba terminale įvykdomos komandos:

```bash
sudo snap install --classic kotlin
kotlin -version

LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/JetBrains/kotlin/releases/latest" \
  | xargs basename | sed 's/v//')"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(kotlinc-native -version 2> /dev/null | awk '{print $NF}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -LO "https://github.com/JetBrains/kotlin/releases/download/v${LATEST}/kotlin-native-prebuilt-linux-x86_64-${LATEST}.tar.gz"
curl -LO "https://github.com/JetBrains/kotlin/releases/download/v${LATEST}/kotlin-native-prebuilt-linux-x86_64-${LATEST}.tar.gz.sha256"

printf 'sha256 patikros sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "kotlin-native-prebuilt-linux-x86_64-${LATEST}.tar.gz" | awk '{print $1}')" \
  "$(cat "kotlin-native-prebuilt-linux-x86_64-${LATEST}.tar.gz.sha256")"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

rm -rf "${HOME}/.opt/kotlin-native"
tar --file="kotlin-native-prebuilt-linux-x86_64-${LATEST}.tar.gz" \
  --transform 'flags=r;s/^(kotlin-native)[^\/]+/\1/x' --show-transformed-names -xzvC "${HOME}/.opt"
rm -f kotlin-native-prebuilt-linux-x86_64-${LATEST}.tar.gz*

printf '%s\n' $'[[ -d "${HOME}/.opt/kotlin-native/bin" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/kotlin-native/bin:"* ]] \
  && export PATH="${HOME}/.opt/kotlin-native/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/kotlin-native/env.sh"
. "${HOME}/.opt/kotlin-native/env.sh"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(kotlinc-native -version 2> /dev/null | awk '{print $NF}')"

unset LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad skriptas `${HOME}/.opt/kotlin-native/env.sh` sistemos apvalkale būtų vykdomas automatiškai.

## Paleistis

Failo pavadinimo plėtinys būtinai turi būti „.kts“!

```bash
kotlinc -script kotlin_sys-upgrade.kts
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S kotlinc -script
```

arba

```bash
///usr/bin/env -S kotlinc -script "$0" "$@"; exit $?
```

## Kompiliavimas

Kompiliuojant kodas turi būti pagrindinėje „main“ funkcijoje. Failo pavadinimo plėtinys būtinai turi būti „.kt“!

### Klasės failas

```bash
kotlinc kodo-failas.kt
kotlin Kodo_failasKt
```

### Binarinis failas

```bash
kotlinc-native -o vykdomasis-failas.bin.kexe kodo-failas.bin.kt
./vykdomasis-failas.bin.kexe
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/kotlin/kotlin_readme.md "skriptai")
