[Grįžti &#x2BA2;](../proglangs_readme.md "Grįžti")

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

```bash
guile mano-modulis.scm
```

Be automatinio kompiliavimo

```bash
guile --no-auto-compile mano-modulis.scm
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S guile --no-auto-compile -s
!#
```

## Kompiliavimas (į baitkodą)

Įtepti į kodo-failas.scm failą eilutes:

```scheme
(define-module (mano-modulis)
  #:export (main))

(define (main)
  <ankstesnis kodas>
)

(main)
```

Kompiliuoti failą

```bash
guild compile --output=mano-modulis.go mano-modulis.scm
```

Paleisti sukompiliuotą failą:

```bash
guile -C "$PWD" -c "(use-modules (mano-modulis))"
```
