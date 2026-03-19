[Grįžti &#x2BA2;](../readme.md "Grįžti")

# GNU Guile [<sup>&#x2B67;</sup>](https://www.gnu.org/software/guile/)

* Paskiausias leidimas: 3.0.10
* Išleista: 2024-06-24

## Diegimas

```bash
sudo apt-get install guile-3.0
guile --version

sudo apt-get install guile-3.0-dev
guild --version
```

## Paleistis

Be automatinio kompiliavimo

```bash
guile --no-auto-compile kodo-failas.scm
```

Su automatiniu kompiliavimu

```bash
guile --auto-compile kodo-failas.scm
```

### Vykdymo instrukcija (shebang)

Be automatinio kompiliavimo

```bash
#!/usr/bin/env -S guile --no-auto-compile -s
!#
```

Su automatiniu kompiliavimu

```bash
#!/usr/bin/env -S guile --auto-compile -s
!#
```

## Kompiliavimas (į baitkodą)

```bash
guile -L . -c '(compile-file "kodo-failas.scm"  #:output-file "baitkodo-failas.go")'
guile -C . -c '(load-compiled "baitkodo-failas.go")'
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/guile/guile_readme.md "skriptai")
