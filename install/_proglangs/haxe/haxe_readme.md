[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Haxe

* Haxe [<sup>&#x2B67;</sup>](https://haxe.org/)
  * Paskiausias leidimas: 4.3.7
  * Išleista: 2025-05-09

* Hashlink [<sup>&#x2B67;</sup>](https://hashlink.haxe.org/)
  * Paskiausias leidimas: 1.15.0
  * Išleista: 2025-03-23

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

Jeigu nėra įdiegtos, įdiegiamos [curl](../curl/curl.md) ir [xq](../xq/xq.md)

## Diegimas

Paleidžiamas diegimo skriptas `haxe_install.sh` arba vykdomos komandos terminale.

### Haxe diegimas

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/HaxeFoundation/haxe/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(haxe --version 2> /dev/null)"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

rm -rf "${HOME}/.opt/haxe"
curl -sSLo - "https://github.com/HaxeFoundation/haxe/releases/download/${LATEST}/haxe-${LATEST}-linux64.tar.gz" \
  | tar --transform "flags=r;s/^(haxe)[^\/]+/\1/x" --show-transformed-names -xzvC "${HOME}/.opt"
chmod u+w "${HOME}/.opt/haxe/haxe"

printf '%s\n' $'[[ -d "${HOME}/.opt/haxe" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/haxe:"* ]] && \
    export PATH="${HOME}/.opt/haxe${PATH:+:${PATH}}"' > "${HOME}/.opt/haxe/env.sh"
. "${HOME}/.opt/haxe/env.sh"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(haxe --version 2> /dev/null)"

unset LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad skriptas `${HOME}/.opt/haxe/env.sh` sistemos apvalkale būtų vykdomas automatiškai.

### HashLink virtualios mašinos diegimas

```bash
COMMIT="$(curl -s "https://github.com/HaxeFoundation/hashlink/releases/tag/latest" | xq -q "code:first-of-type")"
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" https://github.com/HaxeFoundation/hashlink/releases/latest | xargs basename).0"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(hl --version 2> /dev/null)"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -fsSLO "https://github.com/HaxeFoundation/hashlink/releases/download/latest/hashlink-${COMMIT}-linux-amd64.tar.gz"

printf 'sha256 patikros sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "hashlink-${COMMIT}-linux-amd64.tar.gz" | awk '{print $1}')" \
  "$(curl -fsSL "https://github.com/HaxeFoundation/hashlink/releases/expanded_assets/latest" \
      | xq -q "li > div:has(a span:contains('hashlink-latest-linux-amd64.tar.gz')) ~ div > div > span > span" \
      | awk -F':' '{print $NF}')"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

rm -rf "${HOME}/.opt/hashlink"
tar --file="hashlink-${COMMIT}-linux-amd64.tar.gz" \
  --transform='flags=r;s/^(hashlink)[^\/]+/\1/x' \
  --show-transformed-names -xzvC "${HOME}/.opt"
rm -f "hashlink-${COMMIT}-linux-amd64.tar.gz"

printf '%s\n' $'[[ -d "${HOME}/.opt/hashlink" ]] && \
[[ ":${PATH}:" != *":${HOME}/.opt/hashlink:"* ]] && \
  export PATH="${HOME}/.opt/hashlink${PATH:+:${PATH}}"' > "${HOME}/.opt/hashlink/env.sh"
. "${HOME}/.opt/hashlink/env.sh"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(hl --version 2> /dev/null)"

unset COMMIT LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad skriptas `${HOME}/.opt/hashlink/env.sh` sistemos apvalkale būtų vykdomas automatiškai.

## Paleistis

```bash
haxe --run Pagrindinė_klasė.hx
```

kur „Pagrindinė_klasė“ yra klasės su statiniu metodu „main“ pavadinimas. Failo, kuriame saugoma klasė, pavadinimas turi sutapti su pagrindinės klasės, o jo plėtinys turi būti „.hx“

### Vykdymo instrukcija (shebang)

Norint kodo failą paversti vykdomuoju failu, reikia suteikti jam vykdymo teises ir failo pradžioje įrašyti eilutę:

```bash
///usr/bin/env -S haxe --run "${0#.\/}" "$@"; exit $?
```

### Kompiliavimas

```bash
haxe -hl vykdomasis-failas.hl -main Pagrindinė_klasė.hx
hl vykdomasis-failas.hl
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/haxe/haxe_readme.md "skriptai")
