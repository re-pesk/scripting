[Atgal &#x2BA2;](./README.lt.md "Atgal")

# Rankinis diegimas / Manual Installation

*Skaityti kitomis kalbomis: [Anglų](./install.en.md)*

Šiame dokumente aprašoma, kaip rankiniu būdu įdiegti ir sukonfigūruoti `real-path` biblioteką nenaudojant `install.sh` scenarijaus.

---

## 1. Aplinkos paruošimas

Biblioteka naudoja aplinkos kintamąjį `APPS_LIB`, kad surastų savo modulius.

Jeigu sistemoje įdiegtas paketas `app-launcher`, `APPS_LIB` turi būti sukurtas. Tokiu atveju kopijuokite bibliotekos katalogą į katalogą, nurodytą kintamajame "${APPS_STORE}", ir vykdykite komandą:

```sh
  config-link "${APPS_STORE}/real-path/lib/real-path.sh" "${APPS_LIB}" "real-path-full.sh"
```

Jeigu `app-launcher` neįdiegtas, atlikite šiuos žingsnius:

1. Sukurkite bendrą bibliotekų katalogą (jei jo dar neturite), pavyzdžiui:

    ```sh
       mkdir -p "${HOME}/.apps/lib"
    ```

2. Pridėkite `APPS_LIB` eksportavimą į savo apvalkalo konfigūracijos failą (`~/.profile`, `~/.bashrc` arba `~/.zshrc`):

    ```sh
       export APPS_LIB="${HOME}/.apps/lib"
    ```

3. Pritaikykite pakeitimus dabartinei sesijai:

    ```sh
       . ~/.profile
    ```

## 2. Simbolinės nuorodos sukūrimas

Įkeliant biblioteką, pagrindinis failas `lib/real-path.sh` automatiškai išriša savo tikrąją fizinę vietą diske. Dėl to į `$APPS_LIB` katalogą reikia susieti **tik** `lib/real-path.sh` (failo `lib/real-path-list.sh` susieti nereikia – biblioteka jį pati suras pagal fizinį katalogą).

1. Pereikite į `real-path` projekto šakninį katalogą:

    ```sh
       cd /kelias/iki/real-path
    ```

2. Sukurkite simbolinę nuorodą su absoliučiu keliu:

    ```sh
       ln -frs "(pwd -P)/lib/real-path.sh" "{APPS_LIB}/real-path.sh"
    ```

## 3. Diegimo patikrinimas

1. Patikrinkite, ar nuoroda sukurta teisingai ir nėra sugadinta:

    ```sh
      ls -l "${APPS_LIB}/real-path.sh"
    ```

2. Paleiskite automatizuotus testus, kad įsitikintumėte, jog visi moduliai užsikrauna korektiškai:

    ```sh
    ./test/real-path-test.sh
    ```

## 4. Rankinis pašalinimas

1. Norėdami pašalinti biblioteką iš sistemos, tiesiog ištrinkite simbolinę nuorodą iš `$APPS_LIB` katalogo:

    ```sh
      rm -f "${APPS_LIB}/real-path.sh"
    ```
