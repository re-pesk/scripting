[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Aria [<sup>&#x2B67;</sup>](https://arialang.github.io/)

## Diegimas

Paleidžiamas diegimo skriptas `aria_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(curl -sSLo /dev/null -w "%{url_effective}" "https://github.com/arialang/aria/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(aria --version 2> /dev/null | awk '{print "v"$2}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

URL="https://github.com$(
  curl -sSL "https://github.com/arialang/aria/releases/expanded_assets/${LATEST}" | \
  xq -q "a[href*='aria-${LATEST#v}-x86_64-unknown-linux-gnu-'][href$='.tgz']" --attr href
)"
FILE_NAME="tmp_.$(basename "${URL}")"

curl -Lo "${FILE_NAME}" "${URL}"
curl -Lo "${FILE_NAME}.sha256" "${URL}.sha256"

printf 'sha256 patikros sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "${FILE_NAME}" | awk '{print $1}')" \
  "$(cat "${FILE_NAME}.sha256" | awk '{print $1}')"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

rm -rf "${HOME}/.opt/aria"
tar --file "${FILE_NAME}" \
  --transform 'flags=r;s/^(aria)[^\/]+/\1/x' \
  --show-transformed-names -xzC "${HOME}/.opt"
rm -f "${FILE_NAME}"*

ln -fs "${HOME}/.opt/aria/bin/aria" "${HOME}/.local/bin/"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(aria --version 2> /dev/null | awk '{print "v"$2}')"

unset FILE_NAME LATEST URL
```

## Paleistis

```bash
aria kodo-failas.aria
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S aria
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/aria/aria_readme.md "skriptai")
