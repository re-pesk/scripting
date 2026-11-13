[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Pagalbinės funkcijos split_strings.sh

## split_string

Suskaido tekstą pagal duotą skirtuką ir gražina jo dalis, sujungtas join_with pateiktu skirtuku.

Argumentai:

(-d=\*|-delim=\*|--delim=\*)
: simbolių eilutė, pagal kurią skaidomas tekstas

(-j=\*|-join_with=\*|--join_with=\*)
: simbolių eilutė, kuria sujungiamos teksto dalys (numatytoji reikšmė - "")

Pozicinis argumentas
: tekstas, kurį reikia apdoroti

## normalize_indexes

Suskaido kableliais atskirtų indeksų rinkinį. Neigiami indeksai, rodantys, kiek vienetų trūksta iki skaičiaus, vienetu didesnio už didžiausią galimą indeksą, perskaičuojami į teigiamus. Indeksai gražinami sujungti nurodytu skirtuku.

Argumentai:

(-m=\*|-max=\*|--max=\*)
: didžiausia galima indekso reikšmė.

(-j=\*|-join_with=\*|--join_with=\*)
: grąžinamos indeksų eilutės skirtukas (numatytasis - " ")

Pozicinis argumentas
: kableliais atskirtų indeksų eilutė, kurią reikia apdoroti

## filter_text

Suskaido tekstą pagal duotą skirtuką, išrenka dalis su nurodytais indeksais ir grąžina jas, sujungtas nurodytais simboliais.

Argumentai:

(-d=\*|-delim=\*|--delim=\*)
: simbolių eilutė, pagal kurią dalinamas tekstas; jeigu ji tuščia, tekstas dalinamas po vieną simbolį

(-i=\*|-incl=\*|--incl=\*)
: teksto dalių, kurias reikia gražinti, indeksai, atskirti kableliais

(-e=\*|-excl=\*|--excl=\*)
: teksto dalių, kurias reikia praleisti, indeksai, atskirti kableliais

(-j=\*|-join_with=\*|--join_with=\*)
: simbolių eilutė, kuria sujungiamos teksto dalys (numatytoji reikšmė - "")

Pozicinis argumentas
: tekstas, kurį reikia apdoroti
