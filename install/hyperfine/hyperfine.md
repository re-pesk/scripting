[Grįžti &#x2BA2;](../readme.md "Grįžti")

# hyperfine

Command-line benchmarking tool.

* Pradinis kodas [<sup>&#x2B67;</sup>](https://github.com/sharkdp/hyperfine)

## Diegimas

### Naujausios versijos diegimas iš repozitorijos

```bash
if ! command -v curl &> /dev/null; then
  printf '\n%s\n\n' "Curl neįdiegta! Įdiekite prieš tęsdami!"
fi

LATEST="$(
  curl -sSLo /dev/null -w "%{url_effective}" "https://github.com/sharkdp/hyperfine/releases/latest" | \
  xargs basename
)"
FILE_NAME="hyperfine-${LATEST}-x86_64-unknown-linux-gnu.tar.gz"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$( hyperfine --version  | awk '{print "v"$NF}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -fsSLO "https://github.com/sharkdp/hyperfine/releases/download/${LATEST}/${FILE_NAME}"
curl -fsSL "https://github.com/sharkdp/hyperfine/releases/expanded_assets/${LATEST}" \
| xq -q "li > div:has(a span:contains('${FILE_NAME}')) ~ div > div > span > span" \
| awk -F':' '{print $NF}' > "${FILE_NAME}.sha256"

printf 'sha256 patikros sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "${FILE_NAME}" | awk '{print $1}')" \
  "$(cat "${FILE_NAME}.sha256")"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

rm -rf "${HOME}/.opt/hyperfine"
tar --file "${FILE_NAME}" --transform 'flags=r;s/^(hyperfine)[^\/]+/\1/x' -xzC "${HOME}/.opt"
rm -f ${FILE_NAME}*

ln -fs "${HOME}/.opt/hyperfine/hyperfine" "${HOME}/.local/bin"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$( hyperfine --version  | awk '{print "v"$NF}')"

unset FILE_NAME LATEST
