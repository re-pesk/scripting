[Grįžti &#x2BA2;](../readme.md "Grįžti")

# SBCL [<sup>&#x2B67;</sup>](https://www.sbcl.org/)

* Paskiausias leidimas: 2.6.2
* Išleista: 2026-02-27

## Parengimas

Operacinė sistema – Ubuntu 24.04

Jeigu nėra sukurtas, sukuriamas ~/.pathrc failas ir įterpiama jo įkėlimo komanda į .bashrc failą

```bash
[ -f "${HOME}/.pathrc" ] || touch "${HOME}/.pathrc"
(( $(grep -c '#begin include .pathrc' < ${HOME}/.bashrc) > 0 )) \
|| echo '#begin include .pathrc

# include .pathrc if it exists
if [ -f "${HOME}/.pathrc" ]; then
  . "${HOME}/.pathrc"
fi
' >> ${HOME}/.bashrc
```

## Diegimas

Paleidžiamas diegimo skriptas `s-lang_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(
  curl -sSL https://www.sbcl.org/platform-table.html \
  | xq -q "table > tbody > tr.system-header > th:contains('linux') ~ td > a[href$='x86-64-linux-binary.tar.bz2']" \
  | awk '{print $1}'
)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(sbcl --version | awk '{print $NF}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -sSLo - "http://prdownloads.sourceforge.net/sbcl/sbcl-${LATEST}-x86-64-linux-binary.tar.bz2" \
  | tar --transform "flags=r;s/^[^\/]+/tmp_.sbcl-${LATEST}/x" --show-transformed-names -xjv
curl -sSLo - "http://prdownloads.sourceforge.net/sbcl/sbcl-${LATEST}-documentation-html.tar.bz2" \
  | tar --transform "flags=r;s/^[^\/]+/tmp_.sbcl-${LATEST}/x" --show-transformed-names -xjv

cd "tmp_.sbcl-${LATEST}" || exit 1
rm -rf "${HOME}/.opt/sbcl"
INSTALL_ROOT="${HOME}/.opt/sbcl" sh install.sh
cd ..
rm -rf tmp_.sbcl-${LATEST}*

printf '%s\n' $'[[ -d "${HOME}/.opt/sbcl/bin" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/sbcl/bin:"* ]] && \
    export PATH="${HOME}/.opt/sbcl/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/sbcl/env.sh"
. "${HOME}/.opt/sbcl/env.sh"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(sbcl --version | awk '{print $NF}')"

unset LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad skriptas `${HOME}/.opt/sbcl/env.sh` sistemos apvalkale būtų vykdomas automatiškai.

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
sbcl --load kodo-faila.lisp --eval "(sb-ext:save-lisp-and-die \"vykdomasis-failas.bin\" :toplevel #'main :executable t)"
./vykdomasis-failas.bin
```

## Skriptai

[Skriptai <sup>&#x2B67;</sup>](../../../proglangs/sbcl/sbcl_readme.md "Skriptai")
