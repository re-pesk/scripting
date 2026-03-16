[Grįžti &#x2BA2;](../proglangs_readme.md "Grįžti")

# Io [<sup>&#x2B67;</sup>](https://iolanguage.org/)

* Paskiausias leidimas: 2017-09-06 (nebevystoma)

## Diegimas

```bash
INIT_DIR="$PWD"
git clone --recursive https://github.com/IoLanguage/io.git tmp_.io
mkdir -p tmp_.io/build
cd tmp_.io/build/
cmake ..
make
sudo make install
cd "${INIT_DIR}"
rm -rf tmp_.io
io --version
```

## Paleistis

```bash
io kodo-failas.io
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S io
```
