[Grįžti &#x2BA2;](../readme.md "Grįžti")

# S-Lang [<sup>&#x2B67;</sup>](https://www.jedsoft.org/slang/index.html)

* Paskiausias leidimas: pre2.3.4-20
* Išleista: 2025-09-15

## Parengimas

Jeigu nėra sukurtas, sukuriamas ~/.pathrc failas ir įterpiama jo įkėlimo komanda į .bashrc failą

```bash
[ -f "${HOME}/.pathrc" ] || touch "${HOME}/.pathrc"
(( $(grep -c '# begin include .pathrc' < ${HOME}/.bashrc) > 0 )) \
|| echo '# begin include .pathrc

# include .pathrc if it exists
if [ -f "${HOME}/.pathrc" ]; then
  . "${HOME}/.pathrc"
fi
' >> ${HOME}/.bashrc
```

Jeigu neidiegtos, įdiegiamos `curl`, `unzip`, `xargs`, `xq` programos.

## Diegimas

Paleidžiamas diegimo skriptas `s-lang_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://www.jedsoft.org/snapshots/#slang" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(slsh --version | head -n 1 | awk '{print $NF}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -Lo "tmp_.slang-${LATEST}.tar.gz" "https://www.jedsoft.org/snapshots/slang-${LATEST}.tar.gz"

printf 'md5 patikros sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(md5sum "tmp_.slang-${LATEST}.tar.gz" | awk '{print $1}')" \
  "$(curl -sSL "https://www.jedsoft.org/snapshots/#slang" \
    | xq -q "dd:has(a[href^='slang']) > em:contains('md5:') + span")"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

tar --file="tmp_.slang-${LATEST}.tar.gz" --transform 'flags=r;s/^(slang-[^\/]+)/tmp_.\1/x' --show-transformed-names -xzv
cd "tmp_.slang-${LATEST}" || exit 1

./configure --prefix="${HOME}/.opt/slang"
make -j"$(nproc)"
rm -rf "${HOME}/.opt/slang"
make install
cd ..
rm -rf tmp_.slang-${LATEST}*

printf '%s\n' $'[[ -d "${HOME}/.opt/slang/bin" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/slang/bin:"* ]] && \
    export PATH="${HOME}/.opt/slang/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/slang/env.sh"
. "${HOME}/.opt/slang/env.sh"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(slsh --version | head -n 1 | awk '{print $NF}')"

unset LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad skriptas `${HOME}/.opt/slang/env.sh` sistemos apvalkale būtų vykdomas automatiškai.

## Paleistis

```bash
slsh kodo-failas.sl
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S slsh
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/s-lang/s-lang_readme.md "skriptai")
