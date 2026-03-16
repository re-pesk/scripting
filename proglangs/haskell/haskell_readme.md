[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Haskell [<sup>&#x2B67;</sup>](https://www.haskell.org/)

## Diegimas

[Diegimas <sup>&#x2B67;</sup>](../../install/_proglangs/haskell/haskell_readme.md "Diegimas")

## Paleistis

```bash
runghc -- -- haskell_sys-upgrade.hs
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S runghc -- --
```

## Kompiliavimas

```bash
ghc -o haskell_sys-upgrade.bin haskell_sys-upgrade.hs
rm haskell_sys-upgrade.{hi,o}
./haskell_sys-upgrade.bin
```
