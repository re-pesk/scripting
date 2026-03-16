#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="yt-dlp"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../utils/install_helpers/_set_helpers.sh ../
. ../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl jq; then
  exit 1
fi

# Gauti programos paskutinės versijos numerį
# Gauti įdiegtos programos versijos numerį
LATEST="$(
  curl -sLo /dev/null -w "%{url_effective}" "https://github.com/yt-dlp/yt-dlp/releases/latest" | \
  xargs basename
)"
CURRENT="$(yt-dlp --version | awk '{print $NF}')"

# Atnaujinti pranešimų masyvą
. ../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "yt-dlp" "${HOME}/.opt/yt-dlp"; then
  exit 1
fi

# Išsaugoti esamą aplanką
# Sukurti laikiną aplanką.
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t yt-dlp_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Pereiti į laikiną aplanką
# Atsisiųsti į laikiną aplanką programos failą ir išskleisti jį į laikiną aplanką.
cd "${TMP_DIR}" || exit 1
curl -sSLO "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux"
curl -sSLO "https://github.com/yt-dlp/yt-dlp/releases/latest/download/SHA2-256SUMS"

# Jeigu patikros sumos nesutampa, nutraukti diegimą
if ! compare_checksums_str sha256sum \
  "yt-dlp_linux" \
  "$(cat SHA2-256SUMS | grep 'yt-dlp_linux$')"; then
  errorMessage "${LANG_MESSAGES[not_downloaded]}"
  exit 1
fi

# Sukurti diegimo katalogą.
# Perkelti iš repozitorijos atsisiųstą failą į diegimo katalogą.
# Sutekti vykdymo leidimus.
mkdir -p "${HOME}/.opt/yt-dlp"
mv -fT "yt-dlp_linux" "${HOME}/.opt/yt-dlp/yt-dlp"
chmod a+rx "${HOME}/.opt/yt-dlp/yt-dlp"

# Sukurti aplinkos kintamųjų įkėlimo skriptą,
# įkeliantį programos aplinkos kintamuosius
# ir papildantį PATH kintamąjį
printf '%s\n' $'[[ -d "${HOME}/.opt/yt-dlp" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/yt-dlp:"* ]] && \
    export PATH="${HOME}/.opt/yt-dlp${PATH:+:${PATH}}"' > "${HOME}/.opt/yt-dlp/env.sh"

# Įvykdyti sukurtą skriptą, kad programą būtų galima kviesti,
# neprisijungus prie vartotojo paskyros iš naujo.
PATH_COMMAND=$'[[ -s "${HOME}/.opt/yt-dlp/env.sh" ]] && . "${HOME}/.opt/yt-dlp/env.sh"'
eval "${PATH_COMMAND}"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! yt-dlp --version &> /dev/null; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(yt-dlp --version | awk '{print $NF}')"
[[ "${CURRENT}" < "${LATEST}" ]] && {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"

# Išvesti į terminalą komandą, kurią reikia įvykdyti,
# kad galima būtų kviesti programą, neprisijungus prie vartotojo paskyros iš naujo.
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Įrašyti skripto įkėlimo komandą į konfigūracinį failą
insert_path "${HOME}/.pathrc" "${PATH_COMMAND}"
