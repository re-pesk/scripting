[Grįžti &#x2BA2;](../proglangs_readme.md "Grįžti")

# Euphoria [<sup>&#x2B67;</sup>](https://openeuphoria.org/)

* Paskiausias leidimas: 4.2 (darbinis)
* Atnaujintas: 2025-01-24

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

Paleidžiamas diegimo skriptas `go_install.sh` arba vykdomas rankiniu būdu.

Rankinis diegimas vyksta keliais etapais:

* Jeigu nėra įdiegti, įdiegiami reikalingi paketai

```bash
sudo apt install build-essential git
```

* Įdiegiama 4.1 versija, reikalinga 4.2 versijos kompiliavimui

```bash
LATEST="$(curl -sL -o /dev/null -w "%{url_effective}" "https://github.com/OpenEuphoria/euphoria/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: v%s\n  Instaliuota: %s\n\n' \
  "${LATEST}" "$(eui --version | head -n 1 | awk '{print $3}')"

FILE_NAME="$(curl -sL "https://api.github.com/repos/OpenEuphoria/euphoria/releases/latest" |\
  jq -r '.assets[].name | match("^euphoria-'"${LATEST}"'-Linux-x64-.*\\.tar\\.gz$") | .string'
)"

curl -sSLO "https://github.com/OpenEuphoria/euphoria/releases/download/${LATEST}/${FILE_NAME}"


[ -d "${HOME}/.opt/euphoria" ] && rm -rf "${HOME}/.opt/euphoria"

curl -sSLo - "${URL}" \
| tar --transform "flags=r;s/^(euphoria)-${LATEST}[^\/]+x64/\1/x" --show-transformed-names -xzC "${HOME}/.opt"

touch "${HOME}/.opt/euphoria/v${LATEST}.txt"

cd "${HOME}/.opt/euphoria/source"
./configure

find build -maxdepth 1 -type f -exec mv -t ../bin/ {} \+
rm --recursive --force build

sed -i 's/source\/build/bin/g' "${HOME}/.opt/euphoria/bin/eu.cfg"

for file in *.ex ; do
  echo "$file"
  [ -f "${file%.*}" ] && continue
  ./euc "$file"
  exit_code="$?"
  if [[ "$exit_code" -gt 0 ]]; then
    exit "$exit_code"
  fi
done

[[ -d "${HOME}/.opt/euphoria/bin" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/euphoria/bin:"* ]] \
  && export PATH="${HOME}/.opt/euphoria/bin${PATH:+:${PATH}}"

eui --version
euc --version

unset LATEST URL
```

* Diegiamas vėliausias 4.2 versijos kodas.

```bash
rm -rf "/tmp/euphoria"

cd "/tmp"

git clone https://github.com/OpenEuphoria/euphoria

cd "/tmp/euphoria/source"
./configure
make

find build -maxdepth 1 -type f ! -name "*.*" -exec mv -t ../bin/ {} \+
cd "/tmp/euphoria/bin"

for file in *.{ex,exw} ;do
  [ -f "${file%.*}" ] && continue
  ./euc "$file"
  exit_code="$?"
  if [[ "$exit_code" > 0 ]]; then
    exit "$exit_code"
  fi
done

cd "/tmp"

[ -d "${HOME}/.opt/euphoria" ] && mv -T "${HOME}/.opt/euphoria" "${HOME}/.opt/euphoria-4.1"
mv "/tmp/euphoria" ${HOME}/.opt/

eui --version
euc --version

cd "${HOME}/.opt/euphoria/source"
./configure
find build -maxdepth 1 -type f -exec mv -t "${HOME}/.opt/euphoria/bin/" {} \+
rm --recursive --force build
INIT_DIR="$PWD"
cd "${HOME}/.opt/euphoria/bin"
sed -i 's/source\/build/bin/g' eu.cfg

rm --recursive --force "${HOME}/.opt/euphoria-4.1"

cd "${INIT_DIR}"
```

* Siunčiamas pagalbinių programų eudoc ir creole kodas dokumentacijai generuoti

```bash
ADDONS=(eudoc creole)
for addon in ADDONS ;do
  cd "/tmp"

  [ -d "/tmp/${addon}" ] && rm --recursive --force "/tmp/${addon}"

  git clone https://github.com/OpenEuphoria/${addon}
  cd "/tmp/${addon}"
  printf '%s\n' "\nCurrent directory: $PWD\n"
  ./configure
  make
  cd "/tmp"
  mv "/tmp/${addon}/build/${addon}" "${HOME}/.opt/euphoria/bin"
  rm --recursive --force "/tmp/${addon}"
done
unset ADDONS
```

## Paleistis

```bash
eui kodo-failas.ex
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S eui
```

## Kompiliavimas

```bash
euc -o vykdomasis-failas.bin kodo-failas.ex
./vykdomasis-failas.bin
```
