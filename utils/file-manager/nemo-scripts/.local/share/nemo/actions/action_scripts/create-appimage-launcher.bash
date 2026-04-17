#!/usr/bin/env -S bash

base_name="$(basename "$1")"

declare -A messages=(
  [en.UTF-8.not-an-appimage]="The selected file <b><i>$base_name</i></b> is not an AppImage!"
  [lt_LT.UTF-8.not-an-appimage]="Pasirinktas failas $base_name</i></b> nėra AppImage tipo!"
)

if [[ ! "$1" =~ \.AppImage$ ]]; then
  zenity --error --text="${messages[${LANG}.not-an-appimage]}"
  exit 1
fi

file_name="${1%\.AppImage}.sh"
printf '%s\n\n%s\n' "#!/usr/bin/env -S bash" "$1 --disable-setuid-sandbox" > "$file_name"

chmod +x "$1"
chmod +x "$file_name"

exit 0
