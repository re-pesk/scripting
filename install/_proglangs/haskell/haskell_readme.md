[Grįžti &#x2BA2;](../proglangs_readme.md "Grįžti")

# Haskell [<sup>&#x2B67;</sup>](https://www.haskell.org/)

* Paskiausias leidimas (ghc) 9.12.2
* Išleista: 2025-03-12

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

```bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
ghc --version
ghcup tui
```

## Paleistis

```bash
runghc -- -- kodo-failas.hs
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S runghc -- --
```

## Kompiliavimas

```bash
ghc -o vykdomasis-failas.bin kodo-failas.hs
rm vykdomasis-failas.{hi,o}
./vykdomasis-failas.bin
```
