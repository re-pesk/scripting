[\[&nbsp;&uarr;&nbsp;\]](./README.md "Eiti link pradinio puslapio")

<!-- &#x2BA2; -->

# real-path

*Skaityti kitomis kalbomis: [English](README.md)*

Gryna POSIX `sh` biblioteka, skirta patikimam ir greitam fizinių failų bei katalogų kelių išrišimui. Biblioteka automatiškai seka simbolinių nuorodų grandines, ieško failų per `$PATH` bei `$APPS_LIB` ir dinamiškai prisitaiko prie sistemoje esančių įrankių (`realpath`, `readlink` arba `ls -ld`).

## Savybės

* **100 % POSIX `sh` suderinamumas.** Veikia `dash`, `ash`, `bash`, `zsh` ir kituose standartiniuose interpretatoriuose.
* **Saugumas ir izoliacija.** Visos funkcijos vykdomos sub-shell aplinkoje `( ... )`, todėl neužteršia pagrindinio skripto globalių kintamųjų ir nepakeičia darbinio katalogo.
* **Lokalizuoti pranešimai.** Klaidų ir pagalbos pranešimai automatiškai išvedami lietuvių (`lt_LT`) arba anglų kalba priklausomai nuo `$LANG` aplinkos kintamojo.
* **Modulinis įkėlimas.** Galima įkelti tik bazines vieno failo funkcijas arba visą biblioteką su masinio apdorojimo įrankiais.

## Projekto struktūra

```text
real-path/
├── lib/
│   ├── real-path.sh        # Pagrindinis įkėlimo failas (get_real_path, get_real_dir)
│   └── real-path-list.sh   # Masinio apdorojimo funkcijos (map ir list)
├── test/
│   └── real-path-tests.sh  # Automatizuotas testų rinkinys
├── install.sh              # Automatinio diegimo/šalinimo skriptas
├── install.lt.md           # Lietuviškos rankinio diegimo instrukcijos
├── install.en.md           # Angliškos rankinio diegimo instrukcijos
├── README.md               # Pradinis puslapis
├── README.lt.md            # Lietuviškas aprašymas
└── README.en.md            # Angliškas aprašymas
```

## Diegimas ir įkėlimas

Prieš diegdami įsitikinkite, kad aplinkos kintamasis `$APPS_LIB` yra nustatytas ir nurodo į egzistuojantį jūsų bibliotekų katalogą.

### Rankinis diegimas

*Jei biblioteką norite įdiegti rankiniu būdu be scenarijaus, skaitykite [install.lt.md](install.lt.md).*

### Automatinis diegimas (`install.sh`)

Naudokite pridėtą `install.sh` scenarijų simbolinei nuorodai į `lib/real-path.sh` sukurti arba pašalinti `$APPS_LIB` kataloge:

```sh
  chmod +x install.sh
  ./install.sh
```

#### Galimos vėliavėlės

* **`--install`**, **`-install`**, **`-i`** – Sukuria arba atnaujina simbolinę nuorodą `$APPS_LIB` kataloge (numatytasis veiksmas nenurodžius jokių argumentų).
* **`--uninstall`**, **`-uninstall`**, **`-u`** – Saugiai pašalina simbolinę nuorodą iš `$APPS_LIB` katalogo.
* **`--help`**, **`-help`**, **`-h`** – Išveda naudojimo instrukciją.

### Įkėlimas į scenarijus

Biblioteka skirta tik įterpimui (angl. *sourcing*) į kitus scenarijus per `.` komandą.

#### 1. Bazinis režimas (tik vieno failo funkcijos)

Įkelia tik `get_real_path` ir `get_real_dir`:

```sh
  . "${APPS_LIB}/real-path.sh"
```

#### 2. Pilnas režimas (visos funkcijos)

Papildomai įkelia masinio apdorojimo funkcijas iš `real-path-list.sh`:

```sh
  REAL_PATH_MODE="full" . "${APPS_LIB}/real-path.sh"
```

## Išeities kodai (Exit Codes)

Visos bibliotekos funkcijos laikosi griežtos klaidų kodų sistemos:

* **`0`** – Visi nurodyti keliai sėkmingai išrišti.
* **`1`** – Trūksta būtinų argumentų (išvedamas naudojimo pavyzdys į `stderr`).
* **`2`** – Bent vienas failas nerastas, raktas neegzistuoja arba simbolinė nuoroda yra sugadinta (išvedamas klaidos pranešimas į `stderr`).

---

## Funkcijų aprašymas ir pavyzdžiai

### Vieno failo funkcijos (`real-path.sh`)

#### `get_real_path <failas>`

Suranda ir išveda tikrąjį fizinį kelią iki vieno nurodyto failo.

```sh
  tikras_failas="$(get_real_path "./mano_nuoroda.sh")"
  echo "${tikras_failas}"
  # Išvestis: /home/vartotojas/projektas/skriptas.sh
```

#### `get_real_dir <failas>`

Suranda ir išveda tikrąjį fizinį kelią iki failo katalogo (be paties failo pavadinimo).

```sh
  SKRIPTO_KATALOGAS="$(get_real_dir "$0")"
  echo "${SKRIPTO_KATALOGAS}"
  # Išvestis: /home/vartotojas/projektas
```

---

### Masinio apdorojimo funkcijos (`real-path-list.sh`)

Kad būtų išvengta problemų su tarpais ar naujomis eilutėmis failų pavadinimuose, visos sąrašų funkcijos elementus skiria **ASCII Record Separator (`RS` / `\036`)** simboliu (be skyriklio pabaigoje). Neradus failo, įterpiama tuščia reikšmė tarp skyriklių, kad elementų skaičius visada atitiktų argumentų skaičių.

#### `get_real_path_map <failas1> [failas2 ...]`

Grąžina `raktas:tikras_kelias` porų, atskirtų `RS` simboliu, masyvą.

```sh
  keliu_masyvas="$(get_real_path_map "failas.txt" "nerastas.txt")"
  # Turinys: 'failas.txt:/kelias/iki/failo/failas.txt[RS]nerastas.txt:'
```

#### `get_real_path_list_by_key <keliu_lentele> <raktas1> [raktas2 ...]`

Išgauna tikruosius kelius iš anksčiau sugeneruoto masyvą pagal nurodytus raktus.

```sh
  keliai="$(get_real_path_list_by_key "${keliu_lentele}" "failas.txt" "nerastas.txt")"
  # Turinys: '/kelias/iki/failo/failas.txt[RS]'
```

#### `get_real_path_list <failas1> [failas2 ...]`

Tiesiogiai išriša kelių failų kelius vienu kartu ir grąžina juos atskirtus `RS` simboliu.

```sh
  keliai="$(get_real_path_list "failas.txt" "nuoroda.sh" "nerastas.txt")"
  # Turinys: '/kelias/iki/failo/failas.txt[RS]/kelias/iki/nuorodos/taikinio/taikinys.sh[RS]'
```

#### `get_real_dir_list <failas1> [failas2 ...]`

Tiesiogiai išgauna kelių failų katalogų kelius vienu kartu ir grąžina juos atskirtus `RS` simboliu.

```sh
  katalogai="$(get_real_dir_list "failas.txt" "nuoroda.sh")"
  #Turinys: '/kelias/iki/failo[RS]/kelias/iki/nuorodos/taikinio'
```

### Kaip saugiai nuskaityti `RS` atskirtą sąrašą

```sh
  likutis="$(get_real_path_list "a.txt" "b.txt")"
  turi_daugiau=1
  
  while [ "${turi_daugiau}" -eq 1 ]; do
    case "${likutis}" in
      ( *"${RS}"* )
        kelias="${likutis%%"${RS}"*}"
        likutis="${likutis#*"${RS}"}"
        ;;
      ( * )
        kelias="${likutis}"
        turi_daugiau=0
        ;;
    esac
    echo "Išrištas kelias: '${kelias}'"
  done
```

## Testavimas

Norėdami paleisti automatizuotą testų rinkinį, vykdykite šias komandas (būtina, kad aplinkos kintamasis `APPS_LIB` jau būtų nustatytas):

```sh
  chmod +x test/real-path-test.sh
  ./test/real-path-test.sh
```
