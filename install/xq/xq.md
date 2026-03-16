[Grįžti &#x2BA2;](../readme.md "Grįžti")

# xq

Command-line XML and HTML beautifier and content extractor.

* Pradinis kodas [<sup>&#x2B67;</sup>](https://github.com/sibprogrammer/xq)

## Parengimas

Įdiegti `curl` į sistemą.

## Diegimas

### Naujausios versijos diegimas iš repozitorijos

```bash
if ! command -v curl &> /dev/null; then
  printf '\n%s\n\n' "Curl neįdiegta! Įdiekite prieš tęsdami!"
fi

LATEST="$(curl -sSLo /dev/null -w "%{url_effective}" "https://github.com/sibprogrammer/xq/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   v%s\n\n' \
  "${LATEST}" "$( xq --version  | awk '{print $3}')"

rm -rf "${HOME}/.opt/xq"
curl -fsSLo - "https://github.com/sibprogrammer/xq/releases/download/${LATEST}/xq_${LATEST#v}_linux_amd64.tar.gz" \
| tar --transform 'flags=r;s/^(.+)$/xq\/\1/x' --show-transformed-names -xzvC "${HOME}/.opt"
ln -sf "${HOME}/.opt/xq/xq" "${HOME}/.local/bin/"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   v%s\n\n' \
  "${LATEST}" "$( xq --version  | awk '{print $3}')"

unset LATEST
```

### Oficialios Ubuntu versijos diegimas

```bash
dpkg -s xq &>/dev/null || sudo apt install xq -y
```
