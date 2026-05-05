[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Bython [<sup>&#x2B67;</sup>](https://github.com/prushton2/bython)

## Parengimas

Jeigu nėra įdiegta, įdiegiamas python3 ir python3-venv paketai.

## Diegimas

Paleidžiamas diegimo skriptas `bython_install.sh` arba terminale įvykdomos komandos:

```bash
[ -d "${HOME}/.pyvenvs/tests" ] || {
  mkdir -p "${HOME}/.pyvenvs"
  python3 -m venv ~/.pyvenvs/tests
}

[ -d "${HOME}/.pyvenvs/tests" ] && source "${HOME}/.pyvenvs/tests/bin/activate"
pip install bython-prushton --upgrade
printf '%s\n\n%s\n' '#!/usr/bin/env -S bash' 'python -m bython-prushton "$@"' > "${HOME}/.pyvenvs/tests/bin/bython"
chmod +x "${HOME}/.pyvenvs/tests/bin/bython"
deactivate
```

## Paleistis

```bash
source "${HOME}/.pyvenvs/tests/bin/activate"
bython kodo-failas.by
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S bython
```

## Skriptai

* [Skriptai <sup>&#x2B67;</sup>](../../../proglangs/bython/bython_readme.md "skriptai")
