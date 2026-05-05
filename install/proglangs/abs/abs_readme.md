[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Abs [<sup>&#x2B67;</sup>](https://www.abs-lang.org/)

* Vėliausias leidimas: 2.7.2
* Išleista: 2025-04-27

## Parengimas

Jeigu nėra įdiegta, įdiekite app-launcher, [curl](../curl.md) ir xarg

## Diegimas

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/abs-lang/abs/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(abs --version 2> /dev/null)"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

rm -rf "${HOME}/.opt/abs"
mkdir -p "${HOME}/.opt/abs/bin"
bash <(curl -fsSL https://www.abs-lang.org/installer.sh)
mv -T abs "${HOME}/.opt/abs/bin/abs"
ln -frsT "${HOME}/.bin/app-launcher" "${HOME}/.bin/abs"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
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

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/abs/abs_readme.md "skriptai")
