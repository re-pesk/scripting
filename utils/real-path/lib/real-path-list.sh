# shellcheck shell=sh
# shellcheck disable=2030,2031

# Apibrėžiame RS (Record Separator - ASCII 30 / aštuntainis 036) įrašų skyriklį
# Define RS (Record Separator - ASCII 30 / octal 036) record delimiter
RS="$(printf '\036')"

# ==============================================================================
# Funkcija: get_real_path_map
# Aprašymas: Suranda pilną tikrąjį failų kelią ir grąžina raktų-reikšmių žemėlapį (map).
#            Jei failas tiesiogiai nerandamas, ieškoma per $PATH ir $APPS_LIB.
#            Rezultatus kaupia atskirtus RS (\036) skyrikliu be skyriklio pabaigoje.
#            Trūkstant argumentų grąžina kodą 1. Neradus failo – išveda 'raktas:' ir kodą 2.
#
# Function: get_real_path_map
# Description: Resolves the full real path of files and returns a key-value map.
#              If a file is not directly found, searches through $PATH and $APPS_LIB.
#              Accumulates results separated by RS (\036) with no trailing delimiter.
#              Returns exit code 1 if arguments are missing, and code 2 on missing files.
# ==============================================================================
get_real_path_map() (
  # Tikrinama, ar pateiktas bent vienas argumentas
  # Check if at least one argument is provided
  if [ $# -eq 0 ]; then
    case "${LANG%".UTF-8"}" in
      ( lt_LT ) printf '%s\n' 'Klaida: Trūksta argumentų! Naudojimas: get_real_path_map <failas1> *(<failasN>)' >&2 ;;
      ( * )     printf '%s\n' 'Error: Missing arguments! Usage: get_real_path_map <file1> *(<fileN>)' >&2 ;;
    esac
    return 1
  fi

  exit_status=0
  # Išsaugome pradinį katalogą, kad galėtume jį atstatyti po kiekvienos iteracijos
  # Save the initial working directory to restore it after each iteration
  orig_pwd="$(pwd)"
  
  # Išvalome kintamąjį, kad jis būtų neapibrėžtas prieš pirmąją iteraciją
  # Unset the variable so it remains undefined before the first iteration
  unset result

  # Apdorojamas kiekvienas funkcijai perduotas argumentas
  # Process each argument provided to the function
  for file_name in "$@"; do
    target="${file_name}"

    # Paverčiame kelią į absoliutų, jei įvestas santykinis
    # Convert input path to absolute if it is relative
    case "${target}" in
      ( /* ) ;;
      ( * )  target="${orig_pwd}/${target}" ;;
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
            result="${result}${result+${RS}}${file_name}:"
            exit_status=2
            continue
          fi
          target="${APPS_LIB}/${file_name}"
          ;;
      esac
    fi

    # --------------------------------------------------------------------------
    # 1. VARIANTAS: Tiesioginis kelio išrišimas naudojant 'realpath'
    # VARIANT 1: Direct path resolution using 'realpath'
    # --------------------------------------------------------------------------
    if [ "${REAL_PATH_HAS_REALPATH}" -eq 0 ]; then
      full_path="$(realpath -- "${target}" 2>/dev/null)"
      if [ -z "${full_path}" ] || [ ! -e "${full_path}" ]; then
        case "${LANG%".UTF-8"}" in
          ( lt_LT ) printf '%s\n' "Klaida: Nepavyko išrišti kelio failui '${file_name}'." >&2 ;;
          ( * )     printf '%s\n' "Error: Failed to resolve path for file '${file_name}'." >&2 ;;
        esac
        result="${result}${result+${RS}}${file_name}:"
        exit_status=2
        continue
      fi
      result="${result}${result+${RS}}${file_name}:${full_path}"
      continue
    fi

    # --------------------------------------------------------------------------
    # 2 ir 3 VARIANTAS: Nuorodų išrišimo ciklas be papildomo sub-shell
    # VARIANTS 2 & 3: Symlink resolution loop without an extra sub-shell
    # --------------------------------------------------------------------------
    full_path="${target}"
    broken_link=0

    # Sekame simbolines nuorodas, kol pasiekiame tikrąjį failą
    # Follow symbolic links iteratively until reaching the target file
    while [ -L "${full_path}" ]; do
      if [ "${REAL_PATH_HAS_READLINK}" -eq 0 ]; then
        # 2. VARIANTAS: Išgauname nuorodos tikslą per 'readlink'
        # VARIANT 2: Retrieve link target via 'readlink'
        link_target="$(readlink -- "${full_path}")"
      else
        # 3. VARIANTAS: Išgauname nuorodos tikslą per 'ls -ld' tekstinį karpymą
        # VARIANT 3: Retrieve link target via 'ls -ld' parameter expansion
        ls_out=$(ls -ld -- "${full_path}")
        link_target="${ls_out##* -> }"
      fi
      
      # Greitas katalogo kelio išgavimas integruotu parametrų karpymu
      # Fast directory path extraction via built-in parameter expansion
      dir_name="${full_path%/*}"
      [ -z "${dir_name}" ] && dir_name="/"

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
      result="${result}${result+${RS}}${file_name}:"
      exit_status=2
      cd -- "${orig_pwd}" 2>/dev/null ||exit 1
      continue
    fi

    # Išvalome galutinį fizinį katalogo kelią naudojant POSIX 'cd -P'
    # Resolve the final physical directory path using POSIX 'cd -P'
    final_dir="$(cd -P -- "$(dirname -- "${full_path}")" && pwd -P)"
    final_base="$(basename -- "${full_path}")"
    
    # Apsauga nuo šakninio katalogo trigubo brūkšnio
    # Safeguard against root directory triple slash
    if [ "${final_dir}" = "/" ] && [ "${final_base}" = "/" ]; then
      resolved_item="/"
    else
      resolved_item="${final_dir}/${final_base}"
    fi

    # Atstatome pradinį katalogą kitai ciklo iteracijai
    # Restore the initial working directory for the next loop iteration
    cd -- "${orig_pwd}" 2>/dev/null ||exit 1

    result="${result}${result+${RS}}${file_name}:${resolved_item}"
  done

  # Išvedame sukauptą rezultatų žemėlapį į stdout
  # Output the accumulated result map to stdout
  printf '%s' "${result}"
  return "${exit_status}"
)

# ==============================================================================
# Funkcija: get_real_path_list_by_key
# Aprašymas: Suranda reikšmes RS (\036) atskirtame duomenų žemėlapyje pagal raktus.
#            Rezultatus kaupia atskirtus RS (\036) skyrikliu be skyriklio pabaigoje.
#            Trūkstant argumentų grąžina kodą 1 ir išeina. Neradus rakto – išveda
#            tuščią reikšmę, tęsia darbą ir pabaigoje grąžina kodą 2.
#
# Function: get_real_path_list_by_key
# Description: Finds values in an RS (\036) separated data map by keys.
#              Accumulates results separated by RS (\036) with no trailing delimiter.
#              Returns exit code 1 and exits if arguments are missing. On missing keys,
#              outputs an empty value, continues processing, and returns code 2.
# ==============================================================================
get_real_path_list_by_key() (
  real_path_map="$1"
  shift

  # Tikriname, ar pateiktas duomenų žemėlapis ir bent vienas ieškomas raktas
  # Check if the data map and at least one target key are provided
  if [ -z "${real_path_map}" ] || [ $# -eq 0 ]; then
    case "${LANG%".UTF-8"}" in
      ( lt_LT ) printf '%s\n' 'Klaida: Trūksta argumentų! Naudojimas: get_real_path_list_by_key <duomenu_zemelapis> <raktas1> *(<raktasN>)' >&2 ;;
      ( * )     printf '%s\n' 'Error: Missing arguments! Usage: get_real_path_list_by_key <data_map> <key1> *(<keyN>)' >&2 ;;
    esac
    return 1
  fi

  exit_status=0
  unset result

  # Ieškome kiekvieno perduoto rakto duomenų žemėlapyje iki pat pabaigos
  # Search for each provided key in the data map until the end
  for target_key in "$@"; do
    key_found=0
    remaining_map="${real_path_map}"
    has_more=1

    # Skaidome duomenų žemėlapį pagal RS skyriklį
    # Split the data map using the RS delimiter
    while [ "${has_more}" -eq 1 ]; do
      case "${remaining_map}" in
        ( *"${RS}"* )
          record="${remaining_map%%"${RS}"*}"
          remaining_map="${remaining_map#*"${RS}"}"
          ;;
        ( * )
          record="${remaining_map}"
          has_more=0
          ;;
      esac

      [ -z "${record}" ] && continue

      current_key="${record%%:*}"
      if [ "${current_key}" = "${target_key}" ]; then
        current_value="${record#*:}"
        result="${result}${result+${RS}}${current_value}"
        key_found=1
        break
      fi
    done

    # Jei raktas nerastas, prijungiame tuščią reikšmę, fiksuojame kodą 2 ir tęsiame
    # If the key is not found, append an empty value, set code 2, and continue
    if [ "${key_found}" -eq 0 ]; then
      case "${LANG%".UTF-8"}" in
        ( lt_LT ) printf '%s\n' "Klaida: Raktas '${target_key}' duomenų žemėlapyje nerastas." >&2 ;;
        ( * )     printf '%s\n' "Error: Key '${target_key}' not found in the data map." >&2 ;;
      esac
      result="${result}${result+${RS}}"
      exit_status=2
    fi
  done

  # Išvedame visus sukauptus rezultatus ir grąžiname galutinį kodą (0 arba 2)
  # Output all accumulated results and return the final code (0 or 2)
  printf '%s' "${result}"
  return "${exit_status}"
)

# ==============================================================================
# Funkcija: get_real_path_list
# Aprašymas: Suranda ir išveda tikruosius failų kelius, atskirtus RS (\036).
#            Trūkstant argumentų grąžina kodą 1. Neradus bent vieno failo – kodą 2.
#
# Function: get_real_path_list
# Description: Resolves and outputs the real file paths separated by RS (\036).
#              Returns exit code 1 if arguments are missing, and code 2 on missing files.
# ==============================================================================
get_real_path_list() (
  # Tikriname, ar pateiktas bent vienas argumentas
  # Check if at least one argument is provided
  if [ $# -lt 1 ]; then
    case "${LANG%".UTF-8"}" in
      ( lt_LT ) printf '%s\n' 'Klaida: Trūksta argumentų! Naudojimas: get_real_path_list <raktas1> *(<raktasN>)' >&2 ;;
      ( * )     printf '%s\n' 'Error: Missing arguments! Usage: get_real_path_list <key1> *(<keyN>)' >&2 ;;
    esac
    return 1
  fi

  # Sugeneruojame visų failų kelių žemėlapį ir išgauname galutines reikšmes
  # Generate the path map for all files and extract the final values
  real_path_map="$(get_real_path_map "$@")"
  exit_status=$?

  get_real_path_list_by_key "${real_path_map}" "$@"
  by_key_status=$?

  if [ "${by_key_status}" -eq 2 ]; then
    exit_status=2
  fi

  return "${exit_status}"
)

# ==============================================================================
# Funkcija: get_real_dir_list
# Aprašymas: Suranda ir išveda tikruosius katalogų kelius, atskirtus RS (\036).
#            Naudoja 'get_real_path_list' ir nukerpa failų pavadinimus atmintyje.
#            Neradus failo, išveda tuščią reikšmę tarp skyriklių ir grąžina kodą 2.
#            Trūkstant argumentų grąžina kodą 1.
#
# Function: get_real_dir_list
# Description: Finds and outputs the real directory paths separated by RS (\036).
#              Calls 'get_real_path_list' and strips filenames in memory.
#              If a file is missing, outputs an empty value between delimiters
#              and returns code 2. Returns code 1 if arguments are missing.
# ==============================================================================
get_real_dir_list() (
  # Tikriname, ar pateiktas bent vienas argumentas
  # Check if at least one argument is provided
  if [ $# -eq 0 ]; then
    case "${LANG%".UTF-8"}" in
      ( lt_LT ) printf '%s\n' 'Klaida: Trūksta argumentų! Naudojimas: get_real_dir_list <failas1> *(<failasN>)' >&2 ;;
      ( * )     printf '%s\n' 'Error: Missing arguments! Usage: get_real_dir_list <file1> *(<fileN>)' >&2 ;;
    esac
    return 1
  fi

  # Iškviečiame get_real_path_list ir perimame jos sugeneruotą sąrašą bei išeities kodą
  # Call get_real_path_list and capture its generated list and exit status
  remaining_paths="$(get_real_path_list "$@")"
  exit_status=$?

  unset result
  has_more=1

  # Skaidome RS atskirtus kelius ir nukerpame failų pavadinimus
  # Parse RS-separated paths and strip the filenames
  while [ "${has_more}" -eq 1 ]; do
    case "${remaining_paths}" in
      ( *"${RS}"* )
        resolved_path="${remaining_paths%%"${RS}"*}"
        remaining_paths="${remaining_paths#*"${RS}"}"
        ;;
      ( * )
        resolved_path="${remaining_paths}"
        has_more=0
        ;;
    esac

    # Jei kelias tuščias (failas nebuvo rastas), išlaikome tuščią įrašą tarp RS skyriklių
    # If the path is empty (file was not found), preserve the empty record between RS delimiters
    if [ -z "${resolved_path}" ]; then
      result="${result}${result+${RS}}"
      continue
    fi

    # Greitas katalogo kelio išgavimas integruotu parametrų karpymu (be 'dirname')
    # Fast directory path extraction via built-in parameter expansion (without 'dirname')
    dir_path="${resolved_path%/*}"
    : "${dir_path:=/}"

    result="${result}${result+${RS}}${dir_path}"
  done

  # Išvedame sukauptus katalogų kelius į stdout
  # Output the accumulated directory paths to stdout
  printf '%s' "${result}"
  return "${exit_status}"
)