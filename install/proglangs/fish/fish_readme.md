[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Fish shell [<sup>&#x2B67;</sup>](https://fishshell.com/)

* Paskiausias leidimas: 4.0.2
* Išleista: 2025-04-20

## Diegimas

```bash
# Jeigu sąraše nėra, pridedama repozitorija
(( "$(add-apt-repository -L | grep -c 'fish-shell')" > 0 )) \
|| sudo add-apt-repository ppa:fish-shell/release-4
sudo apt update

# Jeigu nėra instaliuota, diegiama paketas 'fish'
dpkg -s fish &>/dev/null && sudo apt upgrade || sudo apt install fish

# Išvedama įdiegta 'fish' versija
fish --version
```

## Paleistis

```bash
fish kodo-failas.fish
```

### Vykdymo instrukcija (shebang)

```bash
#! /usr/bin/env -S fish
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/fish/fish_readme.md "skriptai")
