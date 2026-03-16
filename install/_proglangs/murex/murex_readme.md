[Grįžti &#x2BA2;](../readme.md "Grįžti")

# NGS [<sup>&#x2B67;</sup>](https://nojs.murex.rocks/)

* Paskiausias leidimas: 6.4.2063
* Išleista: 2025-01-16

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

Paleidžiamas diegimo skriptas `murex_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/lmorg/murex/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(murex --version | head -n 1 | awk '{print $2}')"

rm -r "${HOME}/.opt/murex"
mkdir -p "${HOME}/.opt/murex"
curl "https://nojs.murex.rocks/bin/latest/murex-linux-amd64.gz" | gunzip -cf - > "${HOME}/.opt/murex/murex"
chmod +x "${HOME}/.opt/murex/murex"

ln -sf "${HOME}/.opt/murex/murex" "${HOME}/.local/bin/"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(murex --version | head -n 1 | awk '{print $2}')"

unset LATEST
```

## Paleistis

```bash
murex kodo-failas.murex
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env murex
```
