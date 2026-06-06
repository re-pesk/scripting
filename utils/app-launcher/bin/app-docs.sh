#!/usr/bin/env -S bash

HELP_MESSAGE="$(
    cat <<EOF
Usage:
  app-docs -h|-help|--help,
  app-man  -h|-help|--help,
  app-md   -h|-help|--help  - show this message and exit

  app-docs --man <name>,
  app-man <name>            - open man page

  app-docs --md <name>,
  app-md <name>             - open Markdown file

  app-docs <name>           - show found documentation
EOF
)"

CONFIG_FILE="${HOME}/.app_paths.conf"
CALLED_AS=$(basename "$0")
MODE=""
TARGET=""

# Check all parameters to catch a help argument anywhere in the line
if [[ "$#" -lt 1 ]] || [[ " $1 " =~ [[:space:]]-(-?help|h)[[:space:]] ]]; then
  echo "${HELP_MESSAGE}"
  exit 1
fi

# Režimo ir TARGET nustatymas naudojant case
case "${CALLED_AS}" in
  (app-man)
    MODE="man"
    TARGET="$1"
    ;;
  (app-md)
    MODE="md"
    TARGET="$1"
    ;;
  (app-docs)
    case "$1" in
      (--man)
        MODE="man"
        TARGET="$2"
        shift
        ;;
      (--md)
        MODE="md"
        TARGET="$2"
        shift
        ;;
      (*)
        TARGET="$1"
        ;;
    esac
    ;;
esac

# Pagalba, jei nėra nurodyto pavadinimo
if [ -z "$TARGET" ]; then
  echo "$HELP_MESSAGE"
  exit 1
fi

# Konfigūracinio failo patikra (.app_paths)
TARGET_DIRS=()
if [ -f "$CONFIG_FILE" ]; then
  APP_DIR=$(grep "^${TARGET}=" "${HOME}/.app_paths.conf" | cut -d'=' -f2 | cut -d':' -f1)
  if [ -n "${APP_DIR}" ]; then
    TARGET_DIRS=("${APP_DIR}")
    [[ "${APP_DIR}" == *"/bin" ]] && TARGET_DIRS+=("$(dirname "${APP_DIR}")")
  fi
fi

# Man failų paieška
MAN_FILE=""
MAN_DIR="share/man"
for TARGET_DIR in "${TARGET_DIRS[@]}"; do
  if [ -d "${TARGET_DIR}/${MAN_DIR}" ]; then
    MAN_FILE="$(find "${TARGET_DIR}/${MAN_DIR}" -type f -name "*.[1-8]*" 2>/dev/null | head -n 1)"
    [ -n "$MAN_FILE" ] && break
  fi
done

# Makrkdown failų paieška
MD_FILE=""
DOC_DIRS=("share/doc/$TARGET" "share/doc")
for TARGET_DIR in "${TARGET_DIRS[@]}"; do
  for DOC_DIR in "${DOC_DIRS[@]}"; do
    if [ -d "${TARGET_DIR}/${DOC_DIR}" ]; then
      MD_FILE=$(find "${TARGET_DIR}/${DOC_DIR}" -maxdepth 2 -iname "README.md" -o -iname "*.md" 2>/dev/null | head -n 1)
      [ -n "$MD_FILE" ] && break
    fi
  done
done

# VYKDYMO LOGIKA
case "$MODE" in
  (man)
    # Man režimas
    if [ -f "${MAN_FILE}" ]; then
      exec /usr/bin/man "${MAN_FILE}"
    elif [ -n "$(/usr/bin/man -w "$TARGET")" ]; then
      exec /usr/bin/man "$TARGET"
    else
      echo "Klaida: 'man' dokumentacija paketui '$TARGET' nerasta." >&2
      exit 1
    fi
    ;;
  (md)
    # Markdown režimas
    if [ -n "$MD_FILE" ]; then
      command -v glow >/dev/null 2>&1 && exec glow -p "$MD_FILE" || exec less "$MD_FILE"
    else
      echo "Klaida: 'md' dokumentacija paketui '$TARGET' nerasta." >&2
      exit 1
    fi
    ;;
  (*)
    # Informacinis režimas (kai MODE tuščias)
    echo -e "\nDokumentacija paketui \e[1m$TARGET\e[39m:\n"
    if [ -n "$MAN_FILE" ]; then
      echo -e "  \e[32m[man]\e[39m - rasta ($MAN_FILE)"
    else
      echo -e "  \e[31m[man]\e[39m - nėra"
    fi
    if [ -n "$MD_FILE" ]; then
      echo -e "  \e[32m[md]\e[39m  - rasta ($MD_FILE)"
    else
      echo -e "  \e[31m[md]\e[39m  - nėra"
    fi
    echo ""
    ;;
esac
