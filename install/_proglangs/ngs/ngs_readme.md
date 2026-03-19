[Grįžti &#x2BA2;](../readme.md "Grįžti")

# NGS [<sup>&#x2B67;</sup>](https://ngs-lang.org/)

* Paskiausias leidimas: 0.2.17
* Išleista: 2025-04-05 (atnaujinta)

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

Paleidžiamas diegimo skriptas `ngs_install.sh` arba terminale įvykdomos komandos:

```bash
if ! command -v curl &> /dev/null; then
  printf '\n%s\n\n' "Curl neįdiegta! Įdiekite prieš tęsdami!"
fi

LATEST="$(
  curl -sSLo /dev/null -w "%{url_effective}" "https://github.com/ngs-lang/ngs/releases/latest" | \
  xargs basename
)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(ngs --version 2> /dev/null | awk '{print "v"$0}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl https://ngs-lang.org/install.sh | bash

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(ngs --version 2> /dev/null | awk '{print "v"$0}')"

unset LATEST
```

## Paleistis

```bash
ngs kodo-failas.ngs
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S ngs
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/ngs/ngs_readme.md "skriptai")
