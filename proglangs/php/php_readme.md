[Grįžti &#x2BA2;](../readme.md "Grįžti")

# PHP [<sup>&#x2B67;</sup>](https://www.php.net/)

## Diegimas

[Diegimas <sup>&#x2B67;</sup>](../../install/_proglangs/php/php_readme.md "Diegimas")

## Paleistis

```bash
php php_sys-upgrade.php
```

### Vykdymo instrukcija (shebang)

Norint *php_sys-upgrade.php* paversti vykdomuoju failu, reikia suteikti jam vykdymo teises ir failo pradžioje įrašyti vydymo eilutę.

Įprastinė eilutė:

```bash
#!/usr/bin/env php
```

Bash'o* kodo eilutė:

```bash
///usr/bin/env php -r "$(tail -n +1 "$0")" "$@"; exit "$?"
//<?php
```

arba

```bash
///usr/bin/env php "$0" -- "$@"; exit "$?"
<?php
```
