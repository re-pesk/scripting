[Grįžti &#x2BA2;](../readme.md "Grįžti")

# V [<sup>&#x2B67;</sup>](https://vlang.io/)

* Paskiausias leidimas: 0.4.10
* Išleista: 2025-03-20

## Parengimas

Jeigu nėra įdiegtos, įdiegiamos [curl](../curl/curl.md), realpath (coreutils), unzip, xargs (findutils) ir xq.

```bash
  # Išvedamos neįdiegtus komandos
  printf "%s\n" curl realpath unzip xargs xq | sort -u | grep -Fvxf <(compgen -c | sort -u)
```

## Diegimas

Paleidžiamas diegimo skriptas `v_install.sh` arba terminale įvykdomos komandos:

```bash
TAG="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/vlang/v/releases/latest" | xargs basename)"
COMMIT="$(curl -sSL "https://github.com/vlang/v/releases/tag/${TAG}" | xq -q "div:has(span:contains('${TAG}')) ~ div > a > code")"
LATEST="V $(curl -sSL "https://raw.githubusercontent.com/vlang/v/refs/heads/master/v.mod" |
awk -F"[' ]" '/version: / {print $3}') ${COMMIT}"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(v -v 2> /dev/null)"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -Lo "tmp_.v_${TAG}_linux.zip" "https://github.com/vlang/v/releases/download/${TAG}/v_linux.zip"
curl -sSL "https://github.com/vlang/v/releases/expanded_assets/${TAG}" |
  xq -q "li > div:has(a span:contains('v_linux.zip')) ~ div > div > span > span" |
  awk -F':' '{print $NF}' > "tmp_.v_${TAG}_linux.zip.sha256"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

printf '\nsha256 patikros sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "tmp_.v_${TAG}_linux.zip" | awk '{print $1}')" \
  "$(cat "tmp_.v_${TAG}_linux.zip.sha256")"

rm -rf "${HOME}/.opt/v"
unzip "tmp_.v_${TAG}_linux.zip" -d "${HOME}/.opt"

ln -fs "${HOME}/.opt/v/v" -t "${HOME}/.local/bin"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(v -v 2> /dev/null)"

unset COMMIT LATEST TAG
```

arba

```bash
bash v_install.sh
```

## Paleistis

```bash
v run v_sys-upgrade.v
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S v run
```

arba

```bash
///usr/bin/env -S v run "$0" "$@"; exit $?
```

## Kompiliavimas

```bash
v -o vykdomasis-failas.bin kodo-failas.v
./vykdomasis-failas.bin
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/v/v_readme.md "skriptai")
