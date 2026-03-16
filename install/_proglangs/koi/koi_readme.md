[Grįžti &#x2BA2;](../proglangs_readme.md "Grįžti")

# Köi [<sup>&#x2B67;</sup>](https://koi-lang.dev/)

* Paskiausias leidimas: 1.8.0
* Išleista: 2022-04-29 (nebevystoma)

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" https://github.com/eliaperantoni/Koi/releases/latest | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(koi --version 2> /dev/null | awk '{print $NF}')"

rm -rf "${HOME}/.opt/koi"
mkdir -p "${HOME}/.opt/koi"
curl -sSLo "${HOME}/.opt/koi/koi" "https://github.com/eliaperantoni/Koi/releases/download/v1.8.0/koi"
chmod +x "${HOME}/.opt/koi/koi"
ln -sf "${HOME}/.opt/koi/koi" "${HOME}/.local/bin/"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(koi --version 2> /dev/null | awk '{print $NF}')"

unset LATEST
```

## Paleistis

```bash
koi kodo-failas.koi
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S koi
```
