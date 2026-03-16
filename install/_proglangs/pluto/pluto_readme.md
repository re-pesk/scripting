[Grįžti &#x2BA2;](../readme.md "Grįžti")l_readme.md "Atgal")

# Pluto [<sup>&#x2B67;</sup>](https://pluto-lang.org/)

* Paskiausias leidimas: 0.10.4
* Išleista: 2025-02-15

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/PlutoLang/Pluto/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: v%s\n  Įdiegta:   v%s\n\n' \
  "${LATEST}" "$(pluto -v 2> /dev/null | head -n 1 | awk -F',? ' '{print $2}')"

curl -sSLo "tmp_.pluto-${LATEST}-linux-x64.zip" "https://github.com/PlutoLang/Pluto/releases/download/${LATEST}/Linux.X64.zip"

printf 'sha256 kontrolinės sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "tmp_.pluto-${LATEST}-linux-x64.zip" | awk '{print $1}')" \
  "$(curl -sSL "https://github.com/PlutoLang/Pluto/releases/expanded_assets/${LATEST}" |\
  xq -nq 'li:has(a[href$="Linux.X64.zip"]) clipboard-copy' --attr=value | awk -F':' '{printf $NF}')"

rm -r "${HOME}/.opt/pluto"
mkdir -p "${HOME}/.opt/pluto"
unzip -d "${HOME}/.opt/pluto" "tmp_.pluto-${LATEST}-linux-x64.zip"
rm -f "tmp_.pluto-${LATEST}-linux-x64.zip"
for filename in ${HOME}/.opt/pluto/pluto*; do ln -fs "$filename" -t "${HOME}/.local/bin"; done

printf '\nVersijos:\n  Vėliausia: v%s\n  Įdiegta:   v%s\n\n' \
  "${LATEST}" "$(pluto -v 2> /dev/null | head -n 1 | awk -F',? ' '{print $2}')"

unset LATEST
```

## Paleistis

```bash
pluto kodo-failas.pluto
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env pluto
```

## Kompiliavimas

Kompiliavimas į baitkodą ir vykdymas:

```bash
plutoc -o baitkodo-failas.bin kodo-failas.pluto
pluto baitkodo-failas.bin
```
