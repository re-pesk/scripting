[Grįžti &#x2BA2;](../proglangs_readme.md "Grįžti")

# Julia [<sup>&#x2B67;</sup>](https://julialang.org/)

* Paskiausias leidimas: 1.12.4

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../curl/curl.md)

## Diegimas

```bash
curl -fsSL https://install.julialang.org | sh
julia --version
```

<!--Kompiliatorius reikalingas tik kompiliuojant. Eksperimentinė versija <https://jbytecode.github.io/juliac>.

```bash
juliaup add nightly
julia +nightly --version
bash juliac_download.sh
```
-->

## Paleistis

```bash
julia kodo-failas.jl
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S julia
```

<!-- ## Kompiliavimas

```bash
julia +nightly juliac.jl --output-exe julia_sys-upgrade.bin --trim julia_sys-upgrade.jl --experimental
```
-->
