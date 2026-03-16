[Grįžti &#x2BA2;](../readme.md "Grįžti")

# PowerShell [<sup>&#x2B67;</sup>](https://learn.microsoft.com/en-us/powershell/)

* Pasiausias leidimas: 7.5.4
* Išleista: 2025-01-23

## Diegimas

Paleidžiamas diegimo skriptas `pwsh_install.sh` arba terminale įvykdomos komandos:

```bash
for name in wget apt-transport-https software-properties-common; do
  dpkg -s "${name}" &> /dev/null || sudo apt-get install -y "${name}"
done

dpkg -s packages-microsoft-prod &> /dev/null || (
  source /etc/os-release
  wget -q "https://packages.microsoft.com/config/${NAME,,}/${VERSION_ID}/packages-microsoft-prod.deb"
  sudo dpkg -i packages-microsoft-prod.deb
  sudo apt-get update
  sudo apt-get install -f
  rm -f packages-microsoft-prod.deb
)

sudo apt-get update
dpkg -s powershell &> /dev/null || sudo apt-get install -y powershell

pwsh -Version
```

## Paleistis

```bash
pwsh pwsh_sys-upgrade.ps1
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S pwsh
```
