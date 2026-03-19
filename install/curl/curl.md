[Grįžti &#x2BA2;](../readme.md "Grįžti")

# curl

Command line tool and library for transferring data with URLs

* Pradinis kodas [<sup>&#x2B67;</sup>](https://curl.se/)
* Statinis binarinis vykdomasis failas [<sup>&#x2B67;</sup>](https://github.com/stunnel/static-curl)
* Knyga *Everything curl* [<sup>&#x2B67;</sup>](https://everything.curl.dev/)

## Diegimas

### Naujausios versijos diegimas iš repozitorijos

```bash
LATEST="$(
  wget --server-response --spider "https://github.com/stunnel/static-curl/releases/latest" 2>&1 | \
  awk -F'[ \/]' '/Location:/ {print $NF}'
)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$( curl --version | head -n 1 | awk '{print $2}' )"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

wget -q "https://github.com/stunnel/static-curl/releases/download/${LATEST}/curl-linux-x86_64-musl-${LATEST}.tar.xz"

printf 'sha256 patikros sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "curl-linux-x86_64-musl-${LATEST}.tar.xz")" \
  "$( wget -O- "https://github.com/stunnel/static-curl/releases/expanded_assets/${LATEST}" 2> /dev/null | \
    grep -oP '(?<=<clipboard-copy id="clipboard-button-sha256:).+curl-linux-x86_64-musl-'"${LATEST}"'.tar.xz"' | \
    grep -oP '^[^"]+' )  https://github.com/stunnel/static-curl/releases/expanded_assets/${LATEST}"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

rm -rf "${HOME}/.opt/curl"
tar --file "curl-linux-x86_64-musl-${LATEST}.tar.xz" --transform 'flags=r;s/^(.+)$/curl\/\1/x' --show-transformed-names -xJvC "${HOME}/.opt"
ln -sf "${HOME}/.opt/curl/curl" "${HOME}/.local/bin/"
ln -sf "${HOME}/.opt/curl/trurl" "${HOME}/.local/bin/"
rm -rf "curl-linux-x86_64-musl-${LATEST}.tar.xz"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$( curl --version | head -n 1 | awk '{print $2}' )"

unset LATEST
```

### Oficialios Ubuntu versijos diegimas

```bash
dpkg -s curl &>/dev/null || sudo apt install curl -y
```
