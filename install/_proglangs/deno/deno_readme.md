[Grįžti &#x2BA2;](../proglangs_readme.md "Grįžti")

# Deno [<sup>&#x2B67;</sup>](https://deno.com/)

* Paskiausias leidimas: 5.9.3
* Išleista: 2025-10-01

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

Paleidžiamas diegimo skriptas `deno_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/denoland/deno/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(deno --version 2> /dev/null | head -n 1 | awk '{print "v"$2}')"

# Diegiant atsisakyti mofifikuoti konfigūracinius failus
curl -fsSL https://deno.land/install.sh | DENO_INSTALL="$HOME/.opt/deno" sh

printf '%s\n' $'[[ -d "${HOME}/.opt/deno/bin" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/deno/bin:"* ]] && \
    export PATH="${HOME}/.opt/deno/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/deno/env.sh"
. "${HOME}/.opt/deno/env.sh"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(deno --version 2> /dev/null | head -n 1 | awk '{print "v"$2}')"

unset LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad skriptas `${HOME}/.opt/deno/env.sh` sistemos apvalkale būtų vykdomas automatiškai.

## Paleistis

```bash
deno run kodo-failas.m{j,t}s
```

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S deno run --allow-run --allow-env "$0" "$@"; exit $?
```

### Kompiliavimas

```bash
deno compile --allow-run --allow-env --output vykdomasis-failas.bin kodo-failas.m{j,t}s
./vykdomasis-failas.bin
```
