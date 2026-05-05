[Grįžti &#x2BA2;](../readme.md "Grįžti")

# PHP [<sup>&#x2B67;</sup>](https://www.php.net/)

* Paskiausias leidimas: 8.5.3
* Išleista: 2026-02-12

## Diegimas

Paleidžiamas diegimo skriptas `php_install.sh` arba terminale įvykdomos komandos:

```bash
if (( $(add-apt-repository -L ondrej/php | grep -c "ondrej/php") < 1 )); then
  sudo add-apt-repository ppa:ondrej/php
  sudo apt update
fi

LATEST="$(curl -sSLo /dev/null -w "%{url_effective}" "https://github.com/php/php-src/releases/latest" \
| xargs basename | sed 's/^php-//')"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(php -v 2> /dev/null | head -n 1 | awk '{print $2}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

MINOR="${LATEST%.*}"

sudo apt install "php${MINOR} php${MINOR}-mbstring php${MINOR}-curl php${MINOR}-phpdbg php${MINOR}-xdebug" -y

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(php -v 2> /dev/null | head -n 1 | awk '{print $2}')"

unset LATEST
```

arba

```bash
bash php_install.sh
```

## Paleistis

```bash
php kodo-failas.php
```

### Vykdymo instrukcija (shebang)

Norint *kodo-failas.php* paversti vykdomuoju failu, reikia suteikti jam vykdymo teises ir failo pradžioje įrašyti vykdymo instrukciją (shebangą):

```bash
#!/usr/bin/env php
```

arba

```bash
///usr/bin/env php -r "$(tail -n +1 "$0")" "$@"; exit "$?"
//<?php
```

arba

```bash
///usr/bin/env php "$0" -- "$@"; exit "$?"
<?php
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/php/php_readme.md "skriptai")
