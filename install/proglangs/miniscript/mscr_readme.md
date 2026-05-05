[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Miniscript [<sup>&#x2B67;</sup>](https://miniscript.org/)

* Paskiausias leidimas: 1.6.2
* Atnaujintas: 2024-02-18

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md), xargs (findutils) ir [xq](../xq/xq.md).

## Diegimas

Paleidžiamas diegimo skriptas `mscr_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(curl -sSL https://github.com/JoeStrout/miniscript/tags | \
  xq -q "div[id^=header]:contains('Tags') ~ div a[href*='miniscript/releases']")"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(miniscript -? 2> /dev/null | tail -n +2 | head -n 1 | awk '{print $5}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

rm -rf "${HOME}/.opt/miniscript"
curl -sSLo - https://miniscript.org/files/miniscript-linux.tar.gz | \
  tar --transform "flags=r;s//miniscript\//x" -xzC "${HOME}/.opt/" 2> /dev/null

# Sukurti simbolinę nuorodą į vykdomąjį failą
ln -sf "${HOME}/.opt/miniscript/miniscript" -t "${HOME}/.local/bin/"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(miniscript -? 2> /dev/null | tail -n +2 | head -n 1 | awk '{print $5}')"

unset LATEST
```

## Paleistis

```bash
miniscript kodo-failas.ms
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S miniscript
```

arba

```bash
///usr/bin/env -S miniscript "$0" "$@"; exit "$?"
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/mscr/mscr_readme.md "skriptai")
