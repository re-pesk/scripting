[\[&nbsp;&uarr;&nbsp;\]](../../readme.lt.md "Eiti link pradinio puslapio")

*[Angliškai](readme.en.md)*

# Nautilaus scenarijai

Nautilaus failų naršyklės scenarijai

* Copy File Location
  Kopijuoja failo pavadinimą su visu failo keliu nuo šakninio katalogo

## Diegimas

Kataloge, kuriame yra šis failas, įvykdyti komandas

```bash
cp -r -t ${HOME}/.local/share/nautilus .local/share/nautilus/scripts
```

### Klaidų sekimas

```bash
nautilus -q
G_MESSAGES_DEBUG=all NAUTILUS_DEBUG=Window nautilus
```
