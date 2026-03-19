[Grįžti &#x2BA2;](../readme.md "Grįžti")

# GNU Guile [<sup>&#x2B67;</sup>](https://www.gnu.org/software/guile/)

## Diegimas

[Diegimas <sup>&#x2B67;</sup>](../../install/_proglangs/guile/guile_readme.md "Diegimas")

## Paleistis

```bash
guile guile_sys-upgrade.scm
```

Be automatinio kompiliavimo

```bash
guile --no-auto-compile guile_sys-upgrade.scm
```

### Vykdymo instrukcija (shebang)

Su automatiniu kompiliavimu

```bash
#!/usr/bin/env -S guile --auto-compile -s
!#
```

Be automatinio kompiliavimo

```bash
#!/usr/bin/env -S guile --no-auto-compile -s
!#
```

## Kompiliavimas (į baitkodą)

```bash
guile -L . -c '(compile-file "guile_sys-upgrade.scm"  #:output-file "guile_sys-upgrade.go")'
guile -C . -c '(load-compiled "guile_sys-upgrade.go")'
```

## Skriptai

* [sys-upgrade <sup>&#x2B67;</sup>](./guile_sys-upgrade.scm "sys-upgrade")
