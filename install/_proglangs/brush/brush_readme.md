[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Brush [<sup>&#x2B67;</sup>](https://brush.sh/)

* Vėliausias leidimas: 0.3.0
* Išleista: 2025-11-17

## Parengimas

Jeigu nėra įdiegta, įdiekite [curl](../curl/curl.md) ir xarg

## Diegimas

Paleidžiamas diegimo skriptas `brush_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(
  curl -sLo /dev/null -w "%{url_effective}" "https://github.com/reubeno/brush/releases/latest" | \
  xargs basename | awk -F'-' '{print $NF}'
)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(brush --version 2> /dev/null | awk '{print $2}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

URL="https://github.com/reubeno/brush/releases/download/brush-shell-${LATEST}/brush-x86_64-unknown-linux-musl"
curl -Lo "tmp_brush-x86_64-unknown-linux-musl.tar.gz" "${URL}.tar.gz"

printf 'sha256 patikros sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "tmp_brush-x86_64-unknown-linux-musl.tar.gz")" \
  "$(curl -sSL "${URL}.sha256")"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

rm -rf "${HOME}/.opt/brush"
tar --file "tmp_brush-x86_64-unknown-linux-musl.tar.gz" \
  --transform 'flags=r;s//brush\//x' \
  --show-transformed-names -xzC "${HOME}/.opt"

ln -fs "${HOME}/.opt/brush/brush" -t "${HOME}/.local/bin/"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(brush --version 2> /dev/null | awk '{print $2}')"

unset LATEST
```

## Paleistis

```bash
brush kodo-failas.sh
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S brush
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/brush/brush_readme.md "skriptai")
