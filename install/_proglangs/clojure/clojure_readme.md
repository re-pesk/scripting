[Grįžti &#x2BA2;](../proglangs_readme.md "Grįžti")

# Clojure [<sup>&#x2B67;</sup>](https://clojure.org/index)

* Paskiausias leidimas: 1.12.0.1530
* Išleista: 2025-03-06

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

```bash
# Gauti paskutinės programos versijos numerį
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/clojure/brew-install/releases/latest" | xargs basename)"

# Patikrinti, ar kompiuteryje įdiegta kuri nors programos versija. Sulyginti versijas
printf '\nVersijos:\n  Vėliausia: v%s\n  Įdiegta:   v%s\n\n' \
  "${LATEST}" "$(clojure --version 2>/dev/null | awk '{print $NF}')"

# Ištrinti įdiegtą versiją. Atsisiųsti instaliavimo skriptą. Įdiegti programą.
rm -rf ${HOME}/.opt/clojure
curl -Lo- https://github.com/clojure/brew-install/releases/latest/download/linux-install.sh \
| bash -s -- --prefix "${HOME}/.opt/clojure"

# Sukurti simbolines nuorodas į vykdomuosius failus ir manualus
ln -fs ${HOME}/.opt/clojure/bin/clj -t ${HOME}/.local/bin
ln -fs ${HOME}/.opt/clojure/bin/clojure -t ${HOME}/.local/bin
ln -fs ${HOME}/.opt/clojure/share/man/man1/clj.1 -t ${HOME}/.local/man/man1
ln -fs ${HOME}/.opt/clojure/share/man/man1/clojure.1 -t ${HOME}/.local/man/man1

# Patikrinti, ar kompiuteryje įdiegta vėliausia programos versija. Sulyginti versijas
printf '\nVersijos:\n  Vėliausia: v%s\n  Įdiegta:   v%s\n\n' \
  "${LATEST}" "$(clojure --version 2>/dev/null | awk '{print $NF}')"

# Ištrinti sukurtus kintamuosius
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
