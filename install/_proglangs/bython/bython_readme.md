[Grįžti &#x2BA2;](../proglangs_readme.md "Grįžti")

# Bython [<sup>&#x2B67;</sup>](https://github.com/prushton2/bython)

## Parengimas

Jeigu nėra įdiegta, įdiegiamas python3 ir python3-venv paketai.

## Diegimas

Paleidžiamas diegimo skriptas `bython_install.sh` arba terminale įvykdomos komandos:

```bash
[ -d "${HOME}/.pyvenvs/tests" ] && source "${HOME}/.pyvenvs/tests/bin/activate"

printf '\nAtsakymas:\n  Laukiamas: %s\n  Gautas:    %s\n\n' \
  "${LATEST}" "$(bython --help 2> /dev/null | head -n 1 | awk '{print $2}')"

mkdir -p "${HOME}/.pyvenvs"
python3 -m venv ~/.pyvenvs/tests
source "${HOME}/.pyvenvs/tests/bin/activate"
python -m pip install bython-prushton
printf '%s\n' $'#!/usr/bin/env -S bash\n\npython -m bython-prushton "$@"' > "${HOME}/.pyvenvs/tests/bin/bython"
chmod +x "${HOME}/.pyvenvs/tests/bin/bython"

printf '\nAtsakymas:\n  Laukiamas: %s\n  Gautas:    %s\n\n' \
  "${LATEST}" "$(bython --help 2> /dev/null | head -n 1 | awk '{print $2}')"
```

## Paleistis

```bash
source "${HOME}/.pyvenvs/tests/bin/activate"
bython kodo-failas.cpy
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S bython
```
