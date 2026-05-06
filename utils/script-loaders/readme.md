[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Kodo paleidimo scenarijai

## PHP kodo paleidimo skriptas

Linux sistemose įprastiniai PHP failai gali būti paverčiami vydomaisiais naudojant vykdymo instrukciją (shebangą):

```bash
#!/usr/bin/env php
```

Įkėlimo skriptas _php-script.sh_ leidžia vykdyti PHP kodo failus be `<?php` tago. Jeigu _php-script.sh_ yra kataloge, įtrauktame į sistemos kelią, faile įrašoma šitokia vykdymo instrukcija:

```bash
#!/usr/bin/env php-script.sh
```

Ši vykdymo instrukcija leidžia vykdyti PHP kodo failus be `<?php` tago tame pačiame kataloge, kuriame yra _php-script.sh_:

```bash
#!./php-script.sh
```

## Atnaujinta: PHP failų vykdymas be įkėlimo skripto

PHP failai gali būti vykdomi su šia kodo eilute failo pradžioje:

```bash
///usr/bin/env php "$0" -- "$@"; exit "$?"
```

PHP kodo failus be PHP tago ir be loaderio leidžia vykdyti ši kodo eilutė pačioje failo pradžioje:

```bash
///usr/bin/env php -r "$(tail -n +1 "$0")" -- "$@"; exit "$?"
```
