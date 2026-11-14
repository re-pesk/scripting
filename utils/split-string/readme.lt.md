[\[&nbsp;&uarr;&nbsp;\]](../readme.lt.md "Eiti link pradinio puslapio")

*[Angliškai](readme.en.md)*

# Pagalbinės funkcijos `split-string.sh`

## split_string

Suskaido tekstą pagal duotą skirtuką ir gražina jo dalis, sujungtas join_with pateiktu skirtuku.

Argumentai:

```text
(-d=*|-delim=*|--delim=*)
: simbolių eilutė, pagal kurią skaidomas tekstas

(-j=*|-join_with=*|--join_with=*)
: simbolių eilutė, kuria sujungiamos teksto dalys (numatytoji reikšmė - "")

pozicinis argumentas
: tekstas, kurį reikia apdoroti
```

## normalize_indexes

Suskaido kableliais atskirtų indeksų rinkinį. Neigiami indeksai, rodantys, kiek vienetų trūksta iki skaičiaus, vienetu didesnio už didžiausią galimą indeksą, perskaičuojami į teigiamus. Indeksai gražinami sujungti nurodytu skirtuku.

Argumentai:

```text
(-m=*|-max=*|--max=*)
: didžiausia galima indekso reikšmė.

(-j=*|-join_with=*|--join_with=*)
: grąžinamos indeksų eilutės skirtukas (numatytasis - " ")

pozicinis argumentas
: kableliais atskirtų indeksų eilutė, kurią reikia apdoroti
```

## filter_text

Suskaido tekstą pagal duotą skirtuką, išrenka dalis su nurodytais indeksais ir grąžina jas, sujungtas nurodytais simboliais.

Argumentai:

```text
(-d=*|-delim=*|--delim=*)
: simbolių eilutė, pagal kurią dalinamas tekstas; jeigu ji tuščia, tekstas dalinamas po vieną simbolį

(-i=*|-incl=*|--incl=*)
: teksto dalių, kurias reikia gražinti, indeksai, atskirti kableliais

(-e=*|-excl=*|--excl=*)
: teksto dalių, kurias reikia praleisti, indeksai, atskirti kableliais

(-j=*|-join_with=*|--join_with=*)
: simbolių eilutė, kuria sujungiamos teksto dalys (numatytoji reikšmė - "")

pozicinis argumentas
: tekstas, kurį reikia apdoroti
```
