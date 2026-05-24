[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Crystal [<sup>&#x2B67;</sup>](https://crystal-lang.org/)

* Paskiausias leidimas: 1.19.1
* Išleista: 2026-01-20

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../../misc/curl/curl.md) ir libyaml-dev

## Diegimas

```bash
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/crystal-lang/crystal/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(crystal --version 2> /dev/null | head -n 1 | awk '{print $2}')"

rm -rf "${HOME}/.opt/crystal"
curl -fsSLo - "https://github.com/crystal-lang/crystal/releases/download/${LATEST}/crystal-${LATEST}-1-linux-x86_64-bundled.tar.gz" \
| tar  --transform 'flags=r;s/^(\.\/crystal)[^\/]*/\1/x' --show-transformed-names -xzvC "${HOME}/.opt"

printf '#!/usr/bin/env -S bash\n
"$HOME/.opt/crystal/bin/crystal" "$@"
' > "$HOME/.local/bin/crystal"

printf '#!/usr/bin/env -S bash\n
"$HOME/.opt/crystal/bin/shards" "$@"
' > "$HOME/.local/bin/shards"

chmod +x "$HOME/.local/bin/crystal"
chmod +x "$HOME/.local/bin/shards"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(crystal --version 2> /dev/null | head -n 1 | awk '{print $2}')"

unset LATEST
```

## Paleistis

```bash
crystal run kodo-failas.cr
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S crystal run
```

## Kompiliavimas

```bash
crystal build --release --progress --static -o vykdomasis-failas.bin kodo-failas.cr
./vykdomasis-failas.bin
```

## Scenarijai

* [sys-upgrade <sup>&#x2B67;</sup>](../../../scripts/sys-upgrade/crystal/crystal_readme.md "sys-upgrade")
