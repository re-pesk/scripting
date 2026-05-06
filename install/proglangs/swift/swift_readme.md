[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Swift [<sup>&#x2B67;</sup>](https://www.swift.org/)

* Paskiausias leidimas: 6.1
* Išleista: 2025-03-30

## Parengimas

Jeigu nėra sukurtas, sukuriamas ~/.pathrc failas, įterpiama jo įkėlimo komanda į .bashrc failą.

```bash
[ -f "${HOME}/.pathrc" ] || touch "${HOME}/.pathrc"
(( $(grep -c '# begin include .pathrc' < ${HOME}/.bashrc) > 0 )) \
|| echo '# begin include .pathrc

# include .pathrc if it exists
if [ -f "${HOME}/.pathrc" ]; then
  . "${HOME}/.pathrc"
fi

# end include .pathrc' >> ${HOME}/.bashrc
```

## Diegimas

Paleidžiamas diegimo skriptas `swift_install.sh` arba terminale įvykdomos komandos:

```bash
for name in curl gnupg2 libcurl4-openssl-dev libpython3-dev libstdc++-13-dev; do
  dpkg -s "${name}" &> /dev/null || sudo apt install -y "${name}"
done

# Visos failų versijos yra <https://www.swift.org/install/linux/> puslapyje.

# Atsiunčiama, išpakuojama ir paleidžiama swiftly - swift'o diegimo tvarkyklė
TMP_DIR=$(mktemp -p . -d -t swiftly_.XXXXXXXXXX | xargs realpath)
curl -o - https://download.swift.org/swiftly/linux/swiftly-$(uname -m).tar.gz \
| tar xzxC "${TMP_DIR}"
export SWIFTLY_HOME_DIR="${HOME}/.opt/swiftly"
export SWIFTLY_BIN_DIR="${HOME}/.opt/swiftly/bin"
export SWIFTLY_TOOLCHAINS_DIR="${HOME}/.opt/swiftly/toolchains"
"${TMP_DIR}/swiftly" init
. "${HOME}/.opt/swiftly/env.sh"
hash -r
rm -rf "${TMP_DIR}"

swiftly --version
swift --version

unset TMP_DIR
```

## Atnaujinimas

```bash
swiftly self-update
swiftly update
```

## Paleistis

```bash
swift kodo-failas.swift
```

### Vykdymo instrukcija (shebang)

```bash
#! /usr/bin/env -S swift
```

arba

```bash
///usr/bin/env -S swift "$0" "$@"; exit $?
```

## Kompiliavimas

```bash
# Statinių vykdomųjų failų kompiliavimui Ubuntu 24.04 sistemoje
sudo ln -fs /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/lib/libstdc++.so

swiftc -static-executable -o vykdomasis-failas.bin kodo-failas.swift
./vykdomasis-failas.bin
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/swift/swift_readme.md "skriptai")
