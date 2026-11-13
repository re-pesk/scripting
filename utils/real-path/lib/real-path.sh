# shellcheck shell=sh

# Saugiklis, užtikrinantis kad šis failas bus naudojamas tik kaip įteptoji biblioteka
# Vykdant tiesiogiai, $0 saugomas failo pavadinimas atitinka šį saugiklį.
# Guard clause to ensure this file is ONLY used as a sourced library.
# If executed directly, $0 will contain the script name, matching this guard.
script_name="${0##*/}"
case "${script_name}" in
  (real-path.sh)
    case "${LANG%".UTF-8"}" in
      (lt_LT) printf 'Error: Šis failas - tai biblioteka, tad negali būti vydomas tiesiogiai.\nĮterpkite jį kaip šaltinį: . %s\n' "${script_name}" >&2 ;;
      (*)     printf 'Error: This file is a library and cannot be executed directly.\nPlease source it instead: . %s\n' "${script_name}" >&2 ;;
    esac
    exit 1
    ;;
esac

# Jeigu REAL_PATH_LIB_DIR kintamasis sukurtas ir nėra tuščias, failo įterpimas nutraukiamas
# If variable REAL_PATH_LIB_DIR exists ans is not empty, sourcing of file is terminated.
if [ -n "${REAL_PATH_LIB_DIR}" ]; then
  if [ "${DEBUG}" = 1 ]; then
    # shellcheck disable=SC2016
    case "${LANG%".UTF-8"}" in
      (lt_LT) printf 'Saugiklis: failas `%s` jau buvo įkeltas. Ciklas nutrauktas.' 'real-path.sh' >&2 ;;
      (*)     printf 'Safeguard: file `%s` has already been loaded. The cycle was terminated.' 'real-path.sh' >&2 ;;
    esac
  fi
  # shellcheck disable=SC2317
  return 0 2>/dev/null || exit 1
fi

# Vieną kartą bibliotekos įkėlimo metu patikriname įrankių prieinamumą (0 - yra, 1 - nėra)
# Check tool availability once when loading the library (0 - exists, 1 - missing)
command -v realpath >/dev/null 2>&1
REAL_PATH_HAS_REALPATH=$?

command -v readlink >/dev/null 2>&1
REAL_PATH_HAS_READLINK=$?

# ==============================================================================
# Funkcija: get_real_path
# Aprašymas: Suranda ir išveda tikrąjį fizinį kelią iki vieno nurodyto failo.
#            Trūkstant argumentų grąžina kodą 1. Neradus failo ar esant sugadintai
#            nuorodai – išveda klaidą į stderr ir grąžina kodą 2.
#
# Function: get_real_path
# Description: Resolves and outputs the real physical path for a single file.
#              Returns exit code 1 if arguments are missing, and code 2 if the file
#              is missing or a symlink is broken.
# ==============================================================================
get_real_path() (
  # Tikrinama, ar pateiktas argumentas
  # Check if the file argument is provided
  if [ $# -eq 0 ]; then
    case "${LANG%".UTF-8"}" in
      ( lt_LT ) printf '%s\n' 'Klaida: Trūksta argumento! Naudojimas: get_real_path <failas>' >&2 ;;
      ( * )     printf '%s\n' 'Error: Missing argument! Usage: get_real_path <file>' >&2 ;;
    esac
    return 1
  fi

  file_name="$1"
  target="${file_name}"

  # Paverčiame kelią į absoliutų, jei įvestas santykinis
  # Convert input path to absolute if it is relative
  case "${target}" in
    ( /* ) ;;
    ( * )  target="$(pwd)/${target}" ;;
  esac

  # Tikriname, ar failas arba nuoroda egzistuoja nurodytame kelyje
  # Check if the file or symlink exists at the specified path
  if [ ! -e "${target}" ] && [ ! -L "${target}" ]; then
    # Ieškome vykdomojo failo sistemos $PATH keliuose
    # Search for the executable in system $PATH directories
    target="$(command -v "${file_name}")"

    case "${target}" in
      ( /* ) ;;
      ( * )
        # Tikriname, ar failas egzistuoja $APPS_LIB kataloge
        # Check if the file exists inside the $APPS_LIB directory
        if [ -z "${APPS_LIB}" ] || [ ! -e "${APPS_LIB}/${file_name}" ]; then
          case "${LANG%".UTF-8"}" in
            ( lt_LT ) printf '%s\n' "Klaida: Failas '${file_name}' neegzistuoja." >&2 ;;
            ( * )     printf '%s\n' "Error: File '${file_name}' does not exist." >&2 ;;
          esac
          return 2
        fi
        target="${APPS_LIB}/${file_name}"
        ;;
    esac
  fi

  # --------------------------------------------------------------------------
  # 1. VARIANTAS: Tiesioginis kelio išrišimas naudojant 'realpath'
  # VARIANT 1: Direct path resolution using 'realpath'
  # --------------------------------------------------------------------------
  if [ "${REAL_PATH_HAS_REALPATH:-1}" -eq 0 ] || command -v realpath >/dev/null 2>&1; then
    full_path="$(realpath -- "${target}" 2>/dev/null)"
    if [ -z "${full_path}" ] || [ ! -e "${full_path}" ]; then
      case "${LANG%".UTF-8"}" in
        ( lt_LT ) printf '%s\n' "Klaida: Nuoroda '${file_name}' yra sugadinta arba failas neegzistuoja." >&2 ;;
        ( * )     printf '%s\n' "Error: Symlink '${file_name}' is broken or file does not exist." >&2 ;;
      esac
      return 2
    fi

    printf '%s\n' "${full_path}"
    return 0
  fi

  # --------------------------------------------------------------------------
  # 2 ir 3 VARIANTAS: Nuorodų išrišimo ciklas ('readlink' arba 'ls -ld')
  # VARIANTS 2 & 3: Symlink resolution loop ('readlink' or 'ls -ld')
  # --------------------------------------------------------------------------
  full_path="${target}"
  broken_link=0

  # Patikriname 'readlink' prieinamumą, jei globalus kintamasis nenustatytas
  # Check 'readlink' availability if the global variable is not set
  if [ -z "${REAL_PATH_HAS_READLINK}" ]; then
    command -v readlink >/dev/null 2>&1
    has_readlink=$?
  else
    has_readlink="${REAL_PATH_HAS_READLINK}"
  fi

  # Sekame simbolines nuorodas, kol pasiekiame tikrąjį failą
  # Follow symbolic links iteratively until reaching the target file
  while [ -L "${full_path}" ]; do
    if [ "${has_readlink}" -eq 0 ]; then
      # 2. VARIANTAS: Išgauname nuorodos tikslą per 'readlink'
      # VARIANT 2: Retrieve link target via 'readlink'
      link_target="$(readlink -- "${full_path}")"
    else
      # 3. VARIANTAS: Išgauname nuorodos tikslą per 'ls -ld' tekstinį karpymą
      # VARIANT 3: Retrieve link target via 'ls -ld' parameter expansion
      ls_out=$(ls -ld -- "${full_path}")
      link_target="${ls_out##* -> }"
    fi

    dir_name="${full_path%/*}"
    : "${dir_name:=/}"

    # Pereiname į nuorodos katalogą, kad teisingai išrištume santykinius kelius
    # Change to the link's directory to properly resolve relative targets
    if ! cd -- "${dir_name}" 2>/dev/null; then
      broken_link=1
      break
    fi

    case "${link_target}" in
      ( /* ) full_path="${link_target}" ;;
      ( * )  full_path="$(pwd)/${link_target}" ;;
    esac
  done

  # Tikriname, ar nuoroda nenutrūkusi ir galutinis failas tikrai egzistuoja
  # Verify the symlink is not broken and the final target file exists
  if [ "${broken_link}" -eq 1 ] || [ ! -e "${full_path}" ]; then
    case "${LANG%".UTF-8"}" in
      ( lt_LT ) printf '%s\n' "Klaida: Nuoroda '${file_name}' yra sugadinta." >&2 ;;
      ( * )     printf '%s\n' "Error: Symlink '${file_name}' is broken." >&2 ;;
    esac
    return 2
  fi

  # Išvalome galutinį fizinį katalogo kelią naudojant POSIX 'cd -P'
  # Resolve the final physical directory path using POSIX 'cd -P'
  dir_name="${full_path%/*}"
  : "${dir_name:=/}"
  final_dir="$(cd -P -- "${dir_name}" && pwd -P)"
  final_base="${full_path##*/}"

  # Apsauga nuo šakninio katalogo trigubo brūkšnio
  # Safeguard against root directory triple slash
  if [ "${final_dir}" = "/" ] && [ -z "${final_base}" ]; then
    printf '%s\n' "/"
  elif [ "${final_dir}" = "/" ]; then
    printf '%s\n' "/${final_base}"
  else
    printf '%s\n' "${final_dir}/${final_base}"
  fi

  return 0
)

# ==============================================================================
# Funkcija: get_real_dir
# Aprašymas: Suranda ir išveda tikrąjį fizinį kelią iki vieno nurodyto failo katalogo.
#            Naudoja 'get_real_path' ir nukerpa failo pavadinimą atmintyje.
#            Trūkstant argumentų grąžina kodą 1, neradus failo – kodą 2.
#
# Function: get_real_dir
# Description: Resolves and outputs the real physical directory path for a single file.
#              Calls 'get_real_path' and strips the filename in memory.
#              Returns exit code 1 if arguments are missing, and code 2 on error.
# ==============================================================================
get_real_dir() (
  # Tikrinama, ar pateiktas argumentas (savo pagalbos pranešimui išvesti)
  # Check if the file argument is provided (to output its own usage message)
  if [ $# -eq 0 ]; then
    case "${LANG%".UTF-8"}" in
      ( lt_LT ) printf '%s\n' 'Klaida: Trūksta argumento! Naudojimas: get_real_dir <failas>' >&2 ;;
      ( * )     printf '%s\n' 'Error: Missing argument! Usage: get_real_dir <file>' >&2 ;;
    esac
    return 1
  fi

  # Iškviečiame get_real_path ir išsaugome jos išeities kodą
  # Call get_real_path and capture its exit status
  resolved_path="$(get_real_path "$1")"
  exit_status=$?

  # Jei get_real_path nepavyko, ji jau išvedė klaidą į stderr; tiesiog grąžiname jos kodą
  # If get_real_path failed, it already printed the error to stderr; simply return its code
  if [ "${exit_status}" -ne 0 ]; then
    return "${exit_status}"
  fi

  # Greitas katalogo kelio išgavimas integruotu parametrų karpymu (be 'dirname')
  # Fast directory path extraction via built-in parameter expansion (without 'dirname')
  dir_path="${resolved_path%/*}"
  : "${dir_path:=/}"

  printf '%s\n' "${dir_path}"
  return 0
)

#get_real_dir () {
#  if [ $# -eq 0 ]; then
#    echo "Error: Missing arguments. Usage: get_real_path_hybrid <file1> *<fileN>" >&2
#    return 1
#  fi
#  target="$1"
#
#  if command -v realpath >/dev/null 2>&1; then
#    full_path="$(realpath -- "${target}" 2>/dev/null)"
#  else
#
#    # Kol target yra simbolinė nuoroda
#    while [ -L "${target}" ]; do
#      # Gauname nuorodos rodomą kelią
#      link="$(readlink -- "${target}")"
#      case "${link}" in
#        (/*)
#          # Jei nuoroda rodo į pilną kelią
#          target="${link}"
#          ;;
#        (*)
#          # Jei nuoroda rodo į santykinį kelią
#          #target_dir="$(dirname -- "${target}")"
#          target="$(dirname -- "${target}")/${link}"
#          ;;
#      esac
#    done
#    full_path="${target}"
#  fi
#
#  # Išsprendžiame galutinio failo katalogą ir pavadinimą
#  dir_name="$(cd -P -- "$(dirname -- "${full_path}")" && pwd -P)"
#
#  printf "%s\n" "${dir_name}"
#}

# Surandame tikrąjį fizinį šio bibliotekos failo katalogą
# Resolve the true physical directory of this library file
REAL_PATH_LIB_DIR="$(get_real_dir "${APPS_LIB}/real-path.sh")"

# Tikriname įkėlimo režimą per aplinkos kintamąjį
# Check the loading mode via environment variable
case "${REAL_PATH_MODE}" in
  ( "full" )
    if [ -n "${REAL_PATH_LIB_DIR}" ]; then
      # shellcheck source=real-path-list.sh
      . "${REAL_PATH_LIB_DIR}/real-path-list.sh"
    fi
    ;;
  ( * )
    # Numatytasis režimas: paliekame tik bazines vieno failo funkcijas
    # Default mode: keep only base single-file functions
    ;;
esac

# Būtinai išvalome kintamąjį, kad jis neliktų pagrindinio skripto aplinkoje
# Always unset the variable so it does not persist in the main script's environment
# unset REAL_PATH_MODE
