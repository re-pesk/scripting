[Grįžti &#x2BA2;](../readme.md "Grįžti")

# SBCL [<sup>&#x2B67;</sup>](https://www.sbcl.org/)

## Diegimas

[Diegimas <sup>&#x2B67;</sup>](../../install/proglangs/sbcl/sbcl_readme.md "Diegimas")

## Paleistis

```bash
sbcl --script kodo-failas.lisp
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S sbcl --script
```

## Kompiliavimas

Užkomentuoti arba ištrinti vykdymo instrukciją `#!/usr/bin/env -S sbcl --script` pačioje failo pradžioje ir pagrindinės funkcijos iškvietimą `(main)` failo pabaigoje; vietoje `main` pagrindinė funkcijas gali turėti bet kurį kitą pavadinimą.

Įvykdyti terminale komandas:

```bash
sbcl --load kodo-failas.lisp --eval "(sb-ext:save-lisp-and-die \"vykdomasis-failas.bin\" :toplevel #'main :executable t)"
./vykdomasis-failas.bin
```

## Skriptai

* [color-output <sup>&#x2B67;</sup>](./sbcl_color_output.lisp "color-output") - spalvoto teksto išvedimas terminale
* [sys-upgrade <sup>&#x2B67;</sup>](./sbcl_sys-upgrade.lisp "sys-upgrade") - sistemos atnaujinimo skriptas
