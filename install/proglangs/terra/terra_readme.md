[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Brush [<sup>&#x2B67;</sup>](https://brush.sh/)

* Vėliausias leidimas: 0.3.0
* Išleista: 2025-11-17

## Parengimas

Jeigu nėra įdiegta, įdiekite [curl](../utils/curl.md) ir xarg

## Diegimas

```bash
LATEST="$(
  curl -sLo /dev/null -w "%{url_effective}" "https://github.com/terralang/terra/releases/latest" | \
  xargs basename | awk -F'-' '{print $NF}'
)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(terra -h 2> /dev/null | head -n 3 | tail -n 1 | awk '{print $NF}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

rm -rf "${HOME}/.opt/terra"
curl -sSLo - https://api.github.com/repos/terralang/terra/releases/latest \
  | jq -cr '.assets[].browser_download_url' \
  | grep -P "${APP_NAME,,}-$(uname -sm | sed -e 's/ /-/')-[^-]+\.tar.xz$" \
  | xargs curl -Lo - \
  | tar --transform "flags=r;s/^(terra)[^\/]+/\1/x" --show-transformed-names -xvC "${HOME}/.opt"

printf '%s\n' $'[[ -d "${HOME}/.opt/terra/bin" ]] && \
  && [[ ":${PATH}:" != *":${HOME}/.opt/terra/bin:"* ]] \
    && export PATH="${HOME}/.opt/terra/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/terra/env.sh"
. "${HOME}/.opt/terra/env.sh"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(terra -h 2> /dev/null | head -n 3 | tail -n 1 | awk '{print $NF}')"

unset LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad skriptas skriptas skriptas `${HOME}/.opt/terra/env.sh` sistemos apvalkale būtų vykdomas automatiškai.

## Paleistis

```bash
brush kodo-failas.sh
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S brush
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/terra/terra_readme.md "skriptai")
