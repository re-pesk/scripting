[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Phix [<sup>&#x2B67;</sup>](http://phix.x10.mx/index.php)

* Paskiausias leidimas: 1.0.5
* Išleista: 2024-06-01

## Parengimas

Jeigu nėra sukurtas, sukuriamas ~/.pathrc failas, įterpiamas jo įkėlimo komanda į .bashrc failą

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

## Diegimas

Paleidžiamas diegimo skriptas `phix_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(curl http://phix.x10.mx/download.php 2> /dev/null | \
  xq -nq 'body > div#wrap > div#content > div#left > p:first-of-type' | \
  head -n 1 | awk '{print $3}')"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(p -version 2> /dev/null)"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

part_array=("" 1 2 3 4)
for part in "${part_array[@]}";do wget "http://phix.x10.mx/phix.${LATEST}${part:+.$part}.zip"; done
for part in "${part_array[@]}";do unzip "phix.${LATEST}${part:+.$part}.zip" -d tmp_.phix; done
wget http://phix.x10.mx/p64; chmod 777 p64; mv p64 tmp_.phix/p
wget http://phix.x10.mx/p32; chmod 777 p32; mv p32 tmp_.phix/p32

mkdir -p "${HOME}/.opt/phix/bin"
mv -T tmp_.phix "${HOME}/.opt/phix/phix"
mv -T "${HOME}/.opt/phix/phix/builtins" "${HOME}/.opt/phix/bin/builtins"
mv -T "${HOME}/.opt/phix/phix/test" "${HOME}/.opt/phix/bin/test"
mv -T "${HOME}/.opt/phix/phix/demo" "${HOME}/.opt/phix/bin/demo"

cd "${HOME}/.opt/phix/bin" || exit 1
find "${HOME}/.opt/phix" -type f -executable -exec ln -s {} \;

printf '%s\n' $'[[ -d "${HOME}/.opt/phix/bin" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/phix/bin:"* ]] \
    && export PATH="${HOME}/.opt/phix/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/phix/env.sh"
. "${HOME}/.opt/phix/env.sh"

p -test

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(p -version 2> /dev/null)"

rm -f phix.*.zip
unset LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad skriptas `${HOME}/.opt/phix/env.sh` sistemos apvalkale būtų vykdomas automatiškai.

## Paleistis

```bash
p kodo-failas.exw
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S p
```

## Kompiliavimas

```bash
p -c kodo-failas.exw
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/phix/phix_readme.md "skriptai")
