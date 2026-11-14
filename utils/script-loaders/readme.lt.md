[\[&nbsp;&uarr;&nbsp;\]](../readme.lt.md "Eiti link pradinio puslapio")

*[Angliškai](readme.en.md)*

# Kodo paleidimo scenarijai

## PHP kodo paleidimo skriptas

Linux sistemose įprastiniai PHP failai gali būti paverčiami vydomaisiais naudojant vykdymo instrukciją (shebangą):

```bash
#!/usr/bin/env -S php
```

Įkėlimo skriptas *php-script.sh* leidžia vykdyti PHP kodo failus be `<?php` tago. Jeigu *php-script.sh* yra kataloge, įtrauktame į sistemos kelią, faile įrašoma šitokia vykdymo instrukcija:

```bash
#!/usr/bin/env -S php-script.sh
```

Ši vykdymo instrukcija leidžia vykdyti PHP kodo failus be `<?php` tago tame pačiame kataloge, kuriame yra *php-script.sh*:

```bash
#!./php-script.sh
```

### Atnaujinta: PHP failų vykdymas be įkėlimo skripto

PHP failai gali būti vykdomi su šia kodo eilute failo pradžioje:

```bash
///usr/bin/env php "$0" -- "$@"; exit "$?"
```

PHP kodo failus be PHP tago ir be loaderio leidžia vykdyti ši kodo eilutė pačioje failo pradžioje:

```bash
///usr/bin/env php -r "$(tail -n +1 "$0")" -- "$@"; exit "$?"
```

## Odino kodo paleidimo skriptas

Ši vykdymo instrukcija leidžia vykdyti Odin'o kodo failus tame pačiame kataloge, kuriame yra *odin-script.sh*:

```bash
#!./odin-script.sh
```

### Atnaujinta: Odin'o failų vykdymas be įkėlimo skripto

Odin;o kodo failus be loaderio leidžia vykdyti ši kodo eilutė pačioje failo pradžioje:

///usr/bin/env -S odin run "$0" -file -out:"${0%.*}.bin" -- "$@"; exit $?
