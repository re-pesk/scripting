[Grįžti &#x2BA2;](../proglangs_readme.md "Grįžti")

# Abs [<sup>&#x2B67;</sup>](https://www.abs-lang.org/)

* Vėliausias leidimas: 2.7.2
* Išleista: 2025-04-27

## Parengimas

Jeigu nėra įdiegta, įdiekite [curl](../curl.md) ir xarg

## Diegimas

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/abs-lang/abs/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: v%s\n  Įdiegta:   v%s\n\n' \
  "${LATEST}" "$(abs --version 2> /dev/null)"

[[ -d "${HOME}/.opt/abs" ]] && rm -rf "${HOME}/.opt/abs"
mkdir -p "${HOME}/.opt/abs"
bash <(curl -fsSL https://www.abs-lang.org/installer.sh)
mv -T abs "${HOME}/.opt/abs/abs"
ln -fs "${HOME}/.opt/abs/abs" "${HOME}/.local/bin"

printf '\nVersijos:\n  Vėliausia: v%s\n  Įdiegta:   v%s\n\n' \
  "${LATEST}" "$(abs --version 2> /dev/null)"

unset LATEST
```

## Paleistis

```bash
abs kodo-failas.abs
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env abs
```
