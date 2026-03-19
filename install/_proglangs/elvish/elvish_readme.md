[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Elvish shell [<sup>&#x2B67;</sup>](https://elv.sh/)

* Paskiausias leidimas: 0.21.0
* Išleista: 2024-08-14

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

Paleidžiamas diegimo skriptas `elvish_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/elves/elvish/releases/latest" | xargs basename )"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(elvish --version | awk -F '+' '{print "v"$1}')"

# Jeigu vėliausia programos versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -LO "https://dl.elv.sh/linux-amd64/elvish-${LATEST}.tar.gz"

printf 'sha256 patikros sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "elvish-${LATEST}.tar.gz")" \
  "$(curl -sSL "https://dl.elv.sh/linux-amd64/elvish-${LATEST}.tar.gz.sha256sum")"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

rm -rf "${HOME}/.opt/elvish"
tar -f "elvish-${LATEST}.tar.gz" --transform 'flags=r;s/^/elvish\//x' --show-transformed-names -xzvC "${HOME}/.opt"
rm -f elvish-${LATEST}.tar.gz*

ln -fs "${HOME}/.opt/elvish/elvish" "${HOME}/.local/bin"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(elvish --version | awk -F '+' '{print "v"$1}')"

unset LATEST
```

## Paleistis

```bash
elvish kodo-failas.elv
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env elvish
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/elvish/elvish_readme.md "skriptai")
