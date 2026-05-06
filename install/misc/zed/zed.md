[Grįžti &#x2BA2;](../readme.md "Grįžti")

# zed

Command-line JSON editor.

* Pagrindinis puslapis [<sup>&#x2B67;</sup>](https://zed.dev/)
* Pradinis kodas [<sup>&#x2B67;</sup>](https://github.com/zed-industries/zed)

## Diegimas

### Naujausios versijos diegimas iš repozitorijos

```bash
if ! command -v curl &> /dev/null; then
  printf '\n%s\n\n' "Curl neįdiegta! Įdiekite prieš tęsdami!"
fi

LATEST="$(
  curl -sSLo /dev/null -w "%{url_effective}" "https://github.com/zed-industries/zed/releases/latest" | \
  xargs basename
)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$( zed --version  | awk '{print "v"$2}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -f https://zed.dev/install.sh | sh

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$( zed --version  | awk '{print "v"$2}')"
