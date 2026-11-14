[\[&nbsp;&uarr;&nbsp;\]](./readme.md "Eiti link pradinio puslapio")

*[Angliškai](./install.en.md)*

*Skaityti aprašymą: [lietuviškai](./readme.lt.md), [angliškai](./readme.en.md).*

# `real-path` diegimas

Šiame dokumente aprašoma, kaip įdiegti ir sukonfigūruoti `real-path` biblioteką.

---

## Diegimas su `app-launcher`

Biblioteka naudoja aplinkos kintamąjį `APPS_LIB`, kad surastų savo modulius.

Jeigu sistemoje įdiegtas paketas `app-launcher`, `APPS_LIB` turi būti jau sukurtas. Tokiu atveju atsisiųskite ir išskleiskite bibliotekos failus į katalogą, nurodytą kintamajame `APPS_STORE`:

```sh
  curl -sSLo - "https://github.com/re-pesk/scripting/archive/refs/heads/main.tar.gz" \
  | tar -xz --strip-components=2 -C "${APPS_STORE}" scripting-main/utils/real-path
  config-link "${APPS_STORE}/real-path/lib/real-path.sh" "${APPS_LIB}" "real-path-full.sh"
```

Diegimas baigtas.

## Diegimas be `app-launcher`

### 1. Aplinkos parengimas

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

### 2. Bibliotekos išskleidimas ir simbolinės nuorodos kūrimas

Įkeliant biblioteką, pagrindinis failas `lib/real-path.sh` automatiškai išriša savo tikrąją fizinę vietą diske. Dėl to į `$APPS_LIB` katalogą reikia susieti **tik** `lib/real-path.sh` (failo `lib/real-path-list.sh` susieti nereikia – biblioteka jį pati suras pagal fizinį katalogą).

1. Pereikite į katalogą, kuriame bus išskleisti bibliotekos katalogai ir failai. Atsisiųskite ir išskleiskite bibliotekos failus:

    ```sh
      cd /katalogas/kuriame/bus/išskleista/biblioteka 
      curl -sSLo - "https://github.com/re-pesk/scripting/archive/refs/heads/main.tar.gz" \
      | tar -xz --strip-components=2 -C . scripting-main/utils/real-path
    ```

2. Pereikite į `real-path` bibliotekos šakninį katalogą:

    ```sh
       cd real-path
    ```

3. Sukurkite simbolinę nuorodą su santykiniu keliu:

    ```sh
       ln -frs "(pwd -P)/lib/real-path.sh" "{APPS_LIB}/real-path.sh"
    ```

## Diegimo patikrinimas

1. Patikrinkite, ar nuoroda sukurta teisingai ir nėra sugadinta:

    ```sh
      ls -l "${APPS_LIB}/real-path.sh"
    ```

2. Paleiskite automatizuotus testus, kad įsitikintumėte, jog visi moduliai užsikrauna korektiškai:

    * jeigu naudojamas `app-launcher`:

    ```sh
      "${APPS_STORE}/real-path/test/real-path-test.sh"
    ```

    * be `app-launcher`

    ```sh
      /kelias/iki/real-path/test/real-path-test.sh
    ```

## Išdiegimas

Norėdami pašalinti biblioteką iš sistemos

1. ištrinkite simbolinę nuorodą iš `$APPS_LIB` katalogo

    ```sh
      rm -f "${APPS_LIB}/real-path.sh"
    ```

2. pašalinkite bibliotekos katalogą:

    * jeigu naudojamas `app-launcher`:

    ```sh
      rm -rf -- "${APPS_STORE}/real-path/"
    ```

    * be `app-launcher`

    ```sh
      rm -rf -- /kelias/iki/real-path
    ```
