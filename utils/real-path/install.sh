#!/usr/bin/env -S sh

# ==============================================================================
# Failas: install.sh
# Aprašymas: Automatinio diegimo ir šalinimo skriptas, sukuriantis arba ištrinantis
#            simbolinę nuorodą į 'lib/real-path.sh' vartotojo $APPS_LIB kataloge.
#            Naudojimas: ./install.sh [ --install   | -i[nstall]   ]
#                        ./install.sh ( --help      | -h[elp]      )
#                        ./install.sh ( --uninstall | -u[ninstall] )
#
# File: install.sh
# Description: Automated installation and uninstallation script that creates or
#              removes a symbolic link to 'lib/real-path.sh' in $APPS_LIB.
#              Usage:    ./install.sh [ --install   | -i[nstall]   ]
#                        ./install.sh ( --help      | -h[elp]      )
#                        ./install.sh ( --uninstall | -u[ninstall] )
# ==============================================================================

# ==============================================================================
# Funkcija: install_lib
# Aprašymas: Nustato projekto šaknį, patikrina šaltinio failą ir sukuria arba
#            atnaujina simbolinę nuorodą $APPS_LIB kataloge.
#
# Function: install_lib
# Description: Resolves the project root, verifies the source file, and creates
#              or updates the symbolic link in the $APPS_LIB directory.
# ==============================================================================
install_lib() (
  # Nustatome tikrąjį fizinį šio diegimo skripto katalogą (projekto šaknį)
  # Resolve the true physical directory of this installation script (project root)
  _script_dir="${0%/*}"
  [ "${_script_dir}" = "$0" ] && _script_dir="."
  real_path_root="$(cd -P -- "${_script_dir}" && pwd -P)"

  source_file="${real_path_root}/lib/real-path.sh"
  target_link="${APPS_LIB}/real-path.sh"

  # Tikriname, ar šaltinio failas egzistuoja projekte
  # Check if the source library file exists in the project
  if [ ! -f "${source_file}" ]; then
    case "${LANG%".UTF-8"}" in
      ( lt_LT ) printf '%s\n' "Klaida: Šaltinio failas '${source_file}' nerastas!" >&2 ;;
      ( * )     printf '%s\n' "Error: Source file '${source_file}' not found!" >&2 ;;
    esac
    return 2
  fi

  # Apsauga: jei target_link jau egzistuoja ir tai tikras failas (ne nuoroda), neperrašome jo
  # Safeguard: if target_link exists and is a regular file (not a symlink), do not overwrite it
  if [ -e "${target_link}" ] && [ ! -L "${target_link}" ]; then
    case "${LANG%".UTF-8"}" in
      ( lt_LT ) printf '%s\n' "Klaida: '${target_link}' jau egzistuoja ir tai nėra simbolinė nuoroda. Diegimas nutrauktas." >&2 ;;
      ( * )     printf '%s\n' "Error: '${target_link}' already exists and is not a symbolic link. Installation aborted." >&2 ;;
    esac
    return 2
  fi

  # Sukuriame arba atnaujiname simbolinę nuorodą (su išankstiniu išėjimu įvykus klaidai)
  # Create or update the symbolic link (with early exit on failure)
  if ! ln -sf -- "${source_file}" "${target_link}"; then
    case "${LANG%".UTF-8"}" in
      ( lt_LT ) printf '%s\n' "Klaida: Nepavyko sukurti simbolinės nuorodos '${target_link}'." >&2 ;;
      ( * )     printf '%s\n' "Error: Failed to create symbolic link '${target_link}'." >&2 ;;
    esac
    return 2
  fi

  case "${LANG%".UTF-8"}" in
    ( lt_LT ) printf 'Sėkmė: Simbolinė nuoroda sukurta:\n  %s -> %s\n' "${target_link}" "${source_file}" ;;
    ( * )     printf 'Success: Symbolic link created:\n  %s -> %s\n' "${target_link}" "${source_file}" ;;
  esac
  return 0
)

# ==============================================================================
# Funkcija: uninstall_lib
# Aprašymas: Patikrina, ar nuoroda egzistuoja $APPS_LIB kataloge, ir ją pašalina.
#
# Function: uninstall_lib
# Description: Verifies that the symlink exists in $APPS_LIB and removes it.
# ==============================================================================
uninstall_lib() (
  target_link="${APPS_LIB}/real-path.sh"

  # Tikriname, ar nuoroda egzistuoja (taip pat pagauna ir sugadintas nuorodas per -L)
  # Check if the symlink exists (also catches broken symlinks via -L)
  if [ ! -L "${target_link}" ]; then
    if [ -e "${target_link}" ]; then
      case "${LANG%".UTF-8"}" in
        ( lt_LT ) printf '%s\n' "Klaida: '${target_link}' yra tikras failas, o ne simbolinė nuoroda. Šalinimas nutrauktas." >&2 ;;
        ( * )     printf '%s\n' "Error: '${target_link}' is a regular file, not a symbolic link. Uninstallation aborted." >&2 ;;
      esac
    else
      case "${LANG%".UTF-8"}" in
        ( lt_LT ) printf '%s\n' "Klaida: Simbolinė nuoroda '${target_link}' nerasta." >&2 ;;
        ( * )     printf '%s\n' "Error: Symbolic link '${target_link}' not found." >&2 ;;
      esac
    fi
    return 2
  fi

  # Išankstinis išėjimas, jei nepavyksta pašalinti nuorodos
  # Early exit if removing the symbolic link fails
  if ! rm -f -- "${target_link}"; then
    case "${LANG%".UTF-8"}" in
      ( lt_LT ) printf '%s\n' "Klaida: Nepavyko pašalinti simbolinės nuorodos '${target_link}'." >&2 ;;
      ( * )     printf '%s\n' "Error: Failed to remove symbolic link '${target_link}'." >&2 ;;
    esac
    return 2
  fi

  case "${LANG%".UTF-8"}" in
    ( lt_LT ) printf 'Sėkmė: Simbolinė nuoroda pašalinta:\n  %s\n' "${target_link}" ;;
    ( * )     printf 'Success: Symbolic link removed:\n  %s\n' "${target_link}" ;;
  esac
  return 0
)

# ==============================================================================
# Funkcija: usage
# Aprašymas: Išveda scenarijaus naudojimo instrukciją į standartinį srautą.
#
# Function: usage
# Description: Prints the script usage instructions to standard output.
# ==============================================================================
usage() (
  case "${LANG%".UTF-8"}" in
    ( lt_LT ) printf '\n%s\n\n' 'Naudojimas:   install.sh [ --install   | -i[nstall]   ]
              install.sh ( --help      | -h[elp]      )
              install.sh ( --uninstall | -u[ninstall] )' ;;
    ( * )     printf '\n%s\n\n' 'Usage:        install.sh [ --install   | -i[nstall]   ]
              install.sh ( --help      | -h[elp]      )
              install.sh ( --uninstall | -u[ninstall] )' ;;
  esac
)

# ==============================================================================
# Funkcija: check_env
# Aprašymas: Patikrina, ar nustatytas APPS_LIB ir ar egzistuoja toks katalogas.
#
# Function: check_env
# Description: Verifies that APPS_LIB is set and the target directory exists.
# ==============================================================================
check_env() {
  if [ -z "${APPS_LIB}" ]; then
    case "${LANG%".UTF-8"}" in
      ( lt_LT ) printf '\n%s\n\n' 'Klaida: Aplinkos kintamasis APPS_LIB nėra nustatytas!' >&2 ;;
      ( * )     printf '\n%s\n\n' 'Error: Environment variable APPS_LIB is not set!' >&2 ;;
    esac
    exit 1
  fi

  if [ ! -d "${APPS_LIB}" ]; then
    case "${LANG%".UTF-8"}" in
      ( lt_LT ) printf '\n%s\n\n' "Klaida: Katalogas '${APPS_LIB}' neegzistuoja!" >&2 ;;
      ( * )     printf '\n%s\n\n' "Error: Directory '${APPS_LIB}' does not exist!" >&2 ;;
    esac
    exit 2
  fi
}

# ==============================================================================
# Pagrindinis vykdymas / Main execution
# ==============================================================================

# 1. Tikriname argumentų kiekį
# Check the number of provided arguments
if [ $# -gt 1 ]; then
  case "${LANG%".UTF-8"}" in
    ( lt_LT ) printf '\n%s\n' 'Klaida: Per daug argumentų!' >&2 ;;
    ( * )     printf '\n%s\n' 'Error: Too many arguments!' >&2 ;;
  esac
  usage >&2
  exit 1
fi

# 2. Apdorojame veiksmą pagal argumentą (pagal nutylėjimą: --install)
# Process the requested action based on the argument (default: --install)
case "${1:-"--install"}" in
  ( --help | -help | -h )
    usage
    exit 0
    ;;
  ( --install | -install | -i )
    check_env
    install_lib
    exit $?
    ;;
  ( --uninstall | -uninstall | -u )
    check_env
    uninstall_lib
    exit $?
    ;;
  ( * )
    case "${LANG%".UTF-8"}" in
      ( lt_LT ) printf '\n%s\n' 'Klaida: Neteisingas argumentas!' >&2 ;;
      ( * )     printf '\n%s\n' 'Error: Invalid argument!' >&2 ;;
    esac
    usage >&2
    exit 1
    ;;
esac
