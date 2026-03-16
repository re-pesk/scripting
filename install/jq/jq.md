[Grįžti &#x2BA2;](../readme.md "Grįžti")

# jq

jq is a lightweight and flexible command-line JSON processor.

* Pagrindinis puslapis [<sup>&#x2B67;</sup>](https://jqlang.org/)
* Pradinis kodas ir leidimai [<sup>&#x2B67;</sup>](https://github.com/jqlang/jq)

## Parengimas

Įdiegti `curl` į sistemą.

## Diegimas

### Naujausios versijos diegimas iš repozitorijos

```bash
if ! command -v curl &> /dev/null; then
  printf '\n%s\n\n' "Curl neįdiegta! Įdiekite prieš tęsdami!"
fi

LATEST="$( curl -sSLo /dev/null -w "%{url_effective}" "https://github.com/jqlang/jq/releases/latest" | xargs basename )"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$( jq --version )"

curl -sSLo - "https://github.com/jqlang/jq/releases/download/${LATEST}/${LATEST}.tar.gz" \
| tar  --transform 'flags=r;s/^('"${LATEST}"')/tmp-\1/x' --show-transformed-names -xz

cd "tmp-${LATEST}" || exit 1

./configure --with-oniguruma=builtin --prefix="${HOME}/.opt/jq"
make clean
make -j8
make check

rm -rf "${HOME}/.opt/jq"
make install
cd .. || exit 1
rm -rf "tmp-${LATEST}"

ln -sf "${HOME}/.opt/jq/bin/jq" "${HOME}/.local/bin"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$( jq --version )"

unset LATEST
```

### Oficialios Ubuntu versijos diegimas

```bash
dpkg -s jq &>/dev/null || sudo apt install jq -y
```
