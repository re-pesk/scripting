[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Racket [<sup>&#x2B67;</sup>](https://racket-lang.org/)

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

#end include .pathrc' >> ${HOME}/.bashrc
```

Jeigu nėra įdiegta, įdiekite [curl](../curl/curl.md), unzip ir xargs (findutils).

## Diegimas

Paleidžiamas diegimo skriptas `racket_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(curl -sL https://download.racket-lang.org/releases/ | xq -q "tbody > tr:first-of-type a" --attr href)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "v${LATEST}" "$(racket --version 2>/dev/null | awk '{print $4}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -Lo "tmp_.racket-${LATEST}.sh" "https://download.racket-lang.org/releases/${LATEST}/installers/racket-${LATEST}-x86_64-linux-buster-cs.sh"

printf 'sha256 patikros sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "tmp_.racket-${LATEST}.sh" | awk '{print $1}')" \
  "$(curl -sL https://download.racket-lang.org/releases/9.1/ \
    | xq -q "tr > td:has(span > a[href*='racket-9.1-x86_64-linux-buster']) ~ td span.checksum")"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

"tmp_.racket-${LATEST}.sh" --in-place --dest "${HOME}/.opt/racket"
rm -f "tmp_.racket-${LATEST}.sh"

printf '%s\n' $'[[ -d "${HOME}/.opt/racket/bin" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/racket/bin:"* ]] \
    && export PATH="${HOME}/.opt/racket/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/racket/env.sh"
. "${HOME}/.opt/racket/env.sh"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "v${LATEST}" "$(racket --version 2>/dev/null | awk '{print $4}')"

unset LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad skriptas `${HOME}/.opt/racket/env.sh` sistemos apvalkale būtų vykdomas automatiškai.

## Konfigūravimas

```bash
# Pakeisti numatytąjį paketų paaplankį diegimo aplanke.
raco pkg config --scope user --set default-scope installation

# Diegti paketą į diegimo katalogą
raco pkg install --installation <paketo pavadinimas>
#arba
raco pkg install -i <paketo pavadinimas>

# Diegti paketą į vartotojo katalogą
raco pkg install --user <paketo pavadinimas>
#arba
raco pkg install -u <paketo pavadinimas>

# Rodyti paketo diegimo kelią
raco pkg show -ld <paketo pavadinimas>
```

## Paleistis

```bash
racket kodo-failas.rkt
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S racket
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/racket/racket_readme.md "skriptai")
