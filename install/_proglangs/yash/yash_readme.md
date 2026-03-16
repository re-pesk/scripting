[Grįžti &#x2BA2;](../proglangs_readme.md "Grįžti")

# Yash [<sup>&#x2B67;</sup>](https://magicant.github.io/yash/)

* Paskiausias leidimas: 2.58.1
* Išleista : 2025-02-04

## Vadovas

Yash vadovas [<sup>&#x2B67;</sup>](https://magicant.github.io/yash/doc/yash.html)

## Diegimas

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/magicant/yash/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(yash --version 2> /dev/null | head -n 1 | awk '{print $NF}')"

curl -sSLO "https://github.com/magicant/yash/releases/download/${LATEST}/yash-${LATEST}.tar.gz"

printf 'sha256 kontrolinės sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "yash-${LATEST}.tar.gz" | awk '{print $1}')" \
  "$(curl -sSL "https://github.com/magicant/yash/releases/expanded_assets/${LATEST}" \
| xq -q "li > div:has(a span:contains('yash-${LATEST}.tar.gz')) ~ div > div > span > span" \
| awk -F':' '{print $NF}')"

tar --file="yash-${LATEST}.tar.gz" -xzv
cd "yash-${LATEST}" || exit 1
./configure --prefix="${HOME}/.opt/yash"
make
make install
cd ..
rm -rf yash-${LATEST}*

printf '%s\n' $'[[ -d "${HOME}/.opt/yash/bin" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/yash/bin:"* ]] \
  && export PATH="${HOME}/.opt/yash/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/yash/env.sh"
. "${HOME}/.opt/yash/env.sh"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(yash --version 2> /dev/null | head -n 1 | awk '{print $NF}')"

unset LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad skriptas `${HOME}/.opt/yash/env.sh` sistemos apvalkale būtų vykdomas automatiškai.

## Paleistis

```bash
yash kodo-failas.sh
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env yash
```
