[Grįžti &#x2BA2;](../readme.md "Grįžti")

# CurlyPy [<sup>&#x2B67;</sup>](https://github.com/DevBoiAgru/CurlyPy)

## Parengimas

Jeigu nėra įdiegta, įdiegiamas python3 ir python3-venv paketai.

## Diegimas

Paleidžiamas diegimo skriptas `curlypy_install.sh` arba terminale įvykdomos komandos:

```bash
[ -d "${HOME}/.pyvenvs/tests" ] && source "${HOME}/.pyvenvs/tests/bin/activate"

printf '\nAtsakymas:\n  Laukiamas: %s\n  Gautas:    %s\n\n' \
  "${LATEST}" "$(curlypy --help 2> /dev/null | head -n 1 | awk '{print $2}')"

mkdir -p "${HOME}/.pyvenvs"
python3 -m venv ~/.pyvenvs/tests
source "${HOME}/.pyvenvs/tests/bin/activate"
python -m pip install curlypy

printf '\nAtsakymas:\n  Laukiamas: %s\n  Gautas:    %s\n\n' \
  "${LATEST}" "$(curlypy --help 2> /dev/null | head -n 1 | awk '{print $2}')"
```

## Paleistis

```bash
source "${HOME}/.pyvenvs/tests/bin/activate"
curlypy kodo-failas.cpy
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S curlypy
```
