[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Deno [<sup>&#x2B67;</sup>](https://deno.com/)

* Paskiausias leidimas: 5.9.3
* Išleista: 2025-10-01

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/nvm-sh/nvm/releases/latest" | xargs basename)"

printf '\nnvm versijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(nvm --version &> /dev/null && printf 'v%s\n' "$(nvm --version 2> /dev/null)")"

rm -rf "${HOME}/.opt/nvm"
mkdir -p "${HOME}/.opt/nvm"
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${LATEST}/install.sh" \
  | NVM_DIR="${HOME}/.opt/nvm" PROFILE='/dev/null' bash

printf '%s\n' $'export NVM_DIR="$HOME/.opt/nvm"
[ -s "${NVM_DIR}/nvm.sh" ] && . "${NVM_DIR}/nvm.sh"
[ -s "${NVM_DIR}/bash_completion" ] && . "${NVM_DIR}/bash_completion"' > "${HOME}/.opt/nvm/env.sh"
. "${HOME}/.opt/nvm/env.sh"

printf 'nvm versijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(nvm --version &> /dev/null && printf 'v%s\n' "$(nvm --version 2> /dev/null)")"

LATEST="$(nvm version-remote --lts 2> /dev/null)"

printf 'Node versijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(node --version 2> /dev/null)"

nvm install --lts
nvm use --lts
nvm install-latest-npm

printf 'Node versijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(node --version 2> /dev/null)"

unset LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad skriptas `${HOME}/.opt/nvm/env.sh` sistemos apvalkale būtų vykdomas automatiškai.

## Paleistis

```bash
node node_sys-upgrade.mjs
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S node
```

arba

```bash
///usr/bin/env -S node "$0" "$@"; exit $?
```
