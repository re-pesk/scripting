[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Clojure [<sup>&#x2B67;</sup>](https://clojure.org/index)

* Paskiausias leidimas: 1.12.0.1530
* Išleista: 2025-03-06

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/clojure/brew-install/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(clojure --version 2>/dev/null | awk '{print $NF}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

rm -rf ${HOME}/.opt/clojure
curl -Lo- https://github.com/clojure/brew-install/releases/latest/download/linux-install.sh \
| bash -s -- --prefix "${HOME}/.opt/clojure"

ln -fs ${HOME}/.opt/clojure/bin/clj -t ${HOME}/.local/bin
ln -fs ${HOME}/.opt/clojure/bin/clojure -t ${HOME}/.local/bin
ln -fs ${HOME}/.opt/clojure/share/man/man1/clj.1 -t ${HOME}/.local/man/man1
ln -fs ${HOME}/.opt/clojure/share/man/man1/clojure.1 -t ${HOME}/.local/man/man1

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(clojure --version 2>/dev/null | awk '{print $NF}')"

unset LATEST
```

## Paleistis

```bash
clojure -M kodo-failas.clj
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S clojure -M
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/clojure/clojure_readme.md "skriptai")
