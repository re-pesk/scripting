[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Zig [<sup>&#x2B67;</sup>](https://ziglang.org/)

* Paskiausias leidimas: 0.15.2
* Išleista: 2025-10-11

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

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Diegimas Linuxe (Ubuntu 24.04)

Paleidžiamas diegimo skriptas `zig_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(curl -Lso - https://ziglang.org/download/index.json |\
  jq -r 'keys - ["master"] | sort_by(split(".") | map(tonumber)) | last')"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(zig version 2> /dev/null)"

# Jeigu vėliausia programos versija nėra naujesnė nei įdiegtoji, diegimą nutraukti.

declare -A DATA="($(
  curl -s "https://ziglang.org/download/index.json" |\
  jq -r '.[] | select(.version == "'${LATEST}'") | .["x86-linux"] | "[tarball]=" + .tarball + " [shasum]=" + .shasum'
))"
URL="${DATA["tarball"]}"

curl -Lo "zig-x86_64-linux-${LATEST}.tar.xz" "${URL}"

printf 'SHA256 patikros sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "zig-x86_64-linux-${LATEST}.tar.xz" | awk '{print "\n"$1}')" \
  "${DATA["shasum"]}"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

rm -rf "${HOME}/.opt/zig"
tar --file="zig-x86_64-linux-${LATEST}.tar.xz" \
  --transform='flags=r;s/^zig[^\/]+/zig/x' \
  --show-transformed-names -xJC "${HOME}/.opt"
rm -f "zig-x86_64-linux-${LATEST}.tar.xz"

printf '%s\n' $'[[ -d "${HOME}/.opt/zig" ]] &&
  [[ ":${PATH}:" != *":${HOME}/.opt/zig:"* ]] &&
  export PATH="${HOME}/.opt/zig${PATH:+:${PATH}}"' > "${HOME}/.opt/zig/env.sh"
. "${HOME}/.opt/zig/env.sh"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(zig version 2> /dev/null)"

unset DATA URL LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad skriptas `${HOME}/.opt/zig/env.sh` sistemos apvalkale būtų vykdomas automatiškai.

## Paleistis

```bash
zig run --name vykdomasis-failas.bin kodo-failas.zig
```

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S zig run "$0" -- "$@"; exit $?
```

## Kompiliavimas

```bash
zig build-exe -O ReleaseSmall -static --name vykdomasis-failas.bin kodo-failas.zig
rm vykdomasis-failas.bin.o
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/zig/zig_readme.md "skriptai")
