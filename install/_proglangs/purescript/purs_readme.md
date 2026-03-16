[Grįžti &#x2BA2;](../proglangs_readme.md "Grįžti")

# PureScript [<sup>&#x2B67;</sup>](https://www.purescript.org/)

## Pairengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

Paleidžiamas diegimo skriptas `purs_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/purescript/purescript/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "v$(purs --version 2> /dev/null)"

curl -sSLo tmp_.purs.linux64.tar.gz "https://github.com/purescript/purescript/releases/download/${LATEST}/linux64.tar.gz"
curl -sSLo tmp_.purs.linux64.sha "https://github.com/purescript/purescript/releases/download/${LATEST}/linux64.sha"

printf 'sha1 kontrolinės sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha1sum "tmp_.purs.linux64.tar.gz" | awk '{print $1}')" \
  "$(cat "tmp_.purs.linux64.sha" | awk '{print $1}')"

rm -rf "${HOME}/.opt/purescript"
tar -f "tmp_.purs.linux64.tar.gz" -xzvC "${HOME}/.opt"
rm -f tmp_.purs.linux64.*

ln -fs "${HOME}/.opt/purescript/purs" -t "${HOME}/.local/bin/"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "v$(purs --version 2> /dev/null)"
```

## Paleistis ir kompiliavimas

Purescripto programos pirmiau yra kompiliuojamos į Javascriptą, o ne tiesiogiai vykdomos, todėl Purescriptas netinka scenarijų kalbos vaidmeniui.
