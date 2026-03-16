[Grįžti &#x2BA2;](../proglangs_readme.md "Grįžti")

# Dart [<sup>&#x2B67;</sup>](https://dart.dev/)

* Paskiausias leidimas: 3.7.2

## Diegimas

Paleidžiamas diegimo skriptas `dart_install.sh` arba terminale įvykdomos komandos:

```bash
sudo apt-get update

# Jeigu nėra instaliuotas, instaliuojamas paketas 'apt-transport-https'
dpkg -s apt-transport-https &>/dev/null || sudo apt install apt-transport-https

# Diegiamas raktas ir Darto šaltinis
wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub |\
  sudo gpg  --dearmor -o /usr/share/keyrings/dart.gpg
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/dart.gpg] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' |\
  sudo tee /etc/apt/sources.list.d/dart_stable.list

# Jeigu nėra instaliuota, instaliuojamas Dartas
sudo apt-get update && sudo apt-get install dart

# Tikrinamas Darto veikimas
echo ""

dart --version
```

arba

```bash
bash dart-install.sh
```

## Paleistis

```bash
dart kodo-failas.dart
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env dart
```

arba

```bash
///usr/bin/env dart "$0" "$@"; exit $?
```

## Kompiliavimas

```bash
dart compile exe -o vykdomasis-failas.bin kodo-failas.dart
./vykdomasis-failas.bin
```
