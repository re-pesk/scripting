[Grįžti &#x2BA2;](../readme.md "Grįžti")

# yq

`yq` is a lightweight and portable command-line YAML, JSON, INI and XML processor.

* Pradinis kodas [<sup>&#x2B67;</sup>](https://github.com/mikefarah/yq)
* Naudotojo vadovas [<sup>&#x2B67;</sup>](https://mikefarah.gitbook.io/yq/)

## Parengimas

Įdiegti `curl` į sistemą.

## Diegimas

### Naujausios versijos diegimas iš repozitorijos

```bash
if ! command -v curl &> /dev/null; then
  printf '\n%s\n\n' "Curl neįdiegta! Įdiekite prieš tęsdami!"
fi

LATEST="$(curl -sSLo /dev/null -w "%{url_effective}" "https://github.com/mikefarah/yq/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$( yq --version  | awk '{print $NF}' )"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -fsSLO "https://github.com/mikefarah/yq/releases/download/${LATEST}/yq_linux_amd64.tar.gz"
rm -rf "${HOME}/.opt/yq"

printf 'sha256 patikros sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "yq_linux_amd64.tar.gz")" \
  "$(curl -sSL "https://github.com/mikefarah/yq/releases/expanded_assets/${LATEST}" \
    | xq -q "li > div:has(a span:contains('yq_linux_amd64.tar.gz')) ~ div > div > span > span" \
    | awk -F':' '{print $NF}')  https://github.com/mikefarah/yq/releases/expanded_assets/${LATEST}"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

tar --file "yq_linux_amd64.tar.gz" --transform 'flags=r;s/^(.+)/yq\/\1/x' -xzC "${HOME}/.opt"
rm -rf "yq_linux_amd64.tar.gz"

mkdir -p "${HOME}/.opt/yq/bin" "${HOME}/.opt/yq/share/man/man1"
mv -T "${HOME}/.opt/yq/yq_linux_amd64" "${HOME}/.opt/yq/bin/yq"
mv "${HOME}/.opt/yq/yq.1" "${HOME}/.opt/yq/share/man/man1/"
ln -sf "${HOME}/.opt/yq/bin/yq" "${HOME}/.local/bin"
ln -sf "${HOME}/.opt/yq/share/man/man1/yq.1" "${HOME}/.local/share/man/man1/"
rm -rf "${HOME}/.opt/yq/install-man-page.sh"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$( yq --version  | awk '{print $NF}' )"

unset LATEST
```

### Oficialios Ubuntu versijos diegimas

```bash
dpkg -s yq &>/dev/null || sudo apt install yq -y
```
