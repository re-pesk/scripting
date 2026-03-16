[Grįžti &#x2BA2;](../proglangs_readme.md "Grįžti")

# Lua [<sup>&#x2B67;</sup>](https://www.lua.org/)

* Paskiausias leidimas: 5.4.7
* Išleista: 2024-06-13

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

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

Paleidžiamas diegimo skriptas `lua_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/lua/lua/releases/latest" | xargs basename | sed 's/^v//')"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(lua -v 2> /dev/null | awk '{print $2}')"

curl -sSLRO "https://www.lua.org/ftp/lua-${LATEST}.tar.gz"

printf 'sha256 kontrolinės sumos:\n%s\n%s\n\n' \
  "$(sha256sum "lua-${LATEST}.tar.gz")" \
  "$(curl -sL https://lua.org/ftp/ | \
    xq -q "body > table:first-of-type td.name:has(a:contains('lua-${LATEST}.tar.gz')) ~ td.sum")  https://lua.org/ftp/"

tar --file "lua-${LATEST}.tar.gz" -xz

INIT_DIR="$PWD"
cd "lua-${LATEST}"
make all test
rm -rf "${HOME}/.opt/lua"
make install INSTALL_TOP="${HOME}/.opt/lua"
cd $INIT_DIR
rm -rf lua-${LATEST}*

printf '%s\n' $'[[ -d "${HOME}/.opt/lua/bin" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/lua/bin:"* ]] \
  && export PATH="${HOME}/.opt/lua/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/lua/env.sh"
. "${HOME}/.opt/lua/env.sh"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(lua -v 2> /dev/null | awk '{print $2}')"

unset INIT_DIR LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad skriptas `${HOME}/.opt/lua/env.sh` sistemos apvalkale būtų vykdomas automatiškai.

## Paleistis

```bash
lua kodo-failas.lua
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S lua
```

## Kompiliavimas

```bash
luac -o vykdomasis-failas.bin kodo-failas.lua
lua kodo-failas.bin
```
