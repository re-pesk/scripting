# shellcheck shell=bash

unset MESSAGES LANG_MESSAGES

# shellcheck disable=SC2034,SC2190
declare -A MESSAGES=(
  # Messages for _messages.sh
  'en.UTF-8.empty_app_name' 'Error! Variable APP_NAME is empty!'
  'en.UTF-8.empty_current' 'Warning! Variable CURRENT is empty!'
  'en.UTF-8.empty_lang_messages' 'Error! Variable LANG_MESSAGES is empty!'
  'en.UTF-8.empty_latest' 'Error! Variable LATEST is empty!'
  'lt_LT.UTF-8.empty_app_name' 'Klaida! Kintamasis APP_NAME tuščias!'
  'lt_LT.UTF-8.empty_current' 'Svarbu! Kintamasis CURRENT tuščias!'
  'lt_LT.UTF-8.empty_lang_messages' 'Klaida! Kintamasis LANG_MESSAGES tuščias!'
  'lt_LT.UTF-8.empty_latest' 'Klaida! Kintamasis LATEST tuščias!'

  # Messages for _helpers.sh
  'en.UTF-8.checking_commands' 'Checking required commands'
  'en.UTF-8.checking_packages' 'Checking required packages'
  'en.UTF-8.empty_parameter' 'Error! Parameter {i} is empty!'
  'en.UTF-8.enter' '<Enter>'
  'en.UTF-8.erroneous_names' $'Error! Some name are not packages! Please check your script!\n\nErroneous names:'
  'en.UTF-8.file_exists' '{FILE_NAME} already exists!'
  'en.UTF-8.install_new' 'Application {APP_NAME} is not installed. Do you want to install version {LATEST}?'
  'en.UTF-8.installed_not_in_dir' 'Application {APP_NAME}{CURRENT} is installed, but not in {INSTALL_DIR}. Uninstall it first and then run this script again.'
  'en.UTF-8.installing' 'Installing {APP_NAME} version {LATEST}'
  'en.UTF-8.match' 'Checksum match!'
  'en.UTF-8.missing_arguments' 'Error! Arguments are not provided!'
  'en.UTF-8.missing_chksum_fname' 'Error! Checksum file name is not provided!'
  'en.UTF-8.missing_checksum_type' 'Error! Checksum type is not provided!'
  'en.UTF-8.missing_commands' $'Error! Some commands are not available! Please install to continue!\n\nMissing commands:'
  'en.UTF-8.missing_filename' 'Error! File name is not provided!'
  'en.UTF-8.missing_packages' $'Error! Some packages are not installed! Please install to continue!\n\nMissing packages:'
  'en.UTF-8.missing_packages_are_not_installed' $'Error! Some missing packages are not installed! Execution terminated!\n\nMissing packages:'
  'en.UTF-8.mismatch' 'Error! Checksum mismatch!'
  'en.UTF-8.no_app' 'Application {APP_NAME} is not found, but current version is{CURRENT}! Check app code!'
  'en.UTF-8.no_app_name' 'Application name is not provided! Check app code!'
  'en.UTF-8.no_changes' 'No changes were made.'
  'en.UTF-8.no_command_name' 'Command name is not provided! Check app code!'
  'en.UTF-8.no_current' 'Application {APP_NAME} is not found, but current version is empty! Check app code!'
  'en.UTF-8.no_install_dir' 'Installation directory is not provided! Check app code!'
  'en.UTF-8.no_latest' 'Latest version is not provided! Check app code!'
  'en.UTF-8.overwrite' 'Application {APP_NAME}{CURRENT} is installed. Do you want overwrite it with version {LATEST}?'
  'en.UTF-8.prompt' $'Print \'y\' to continue, \'n\' or <Enter> to exit'
  'en.UTF-8.record_exists' 'Record for {APP_NAME} already exists in {FILE_NAME}!'
  'lt_LT.UTF-8.checking_commands' 'Tikrinamos reikalingos komandos'
  'lt_LT.UTF-8.checking_packages' 'Tikrinami reikalingi paketai'
  'lt_LT.UTF-8.empty_parameter' 'Klaida! Parametras {i} tuščias!'
  'lt_LT.UTF-8.enter' '<Įvesti>'
  'lt_LT.UTF-8.erroneous_names' $'Klaida! Klaidingi paketų pavadinimai! Patikrinkite savo skriptą!\n\nKlaidingi pavadinimai:'
  'lt_LT.UTF-8.file_exists' 'Failas {FILE_NAME} sistemoje jau yra!'
  'lt_LT.UTF-8.install_new' 'Programa {APP_NAME} neįdiegta. Ar įdiegti versiją {LATEST}?'
  'lt_LT.UTF-8.installed_not_in_dir' 'Programa {APP_NAME}{CURRENT} yra įdiegta, bet ne į {INSTALL_DIR} aplanką. Išdiekite programą ir dar kartą paleiskite šį skriptą.'
  'lt_LT.UTF-8.installing' 'Diegiama {APP_NAME} programos versija {LATEST}'
  'lt_LT.UTF-8.match' 'Kontrolinės sumos sutampa!'
  'lt_LT.UTF-8.missing_arguments' 'Klaida! Nepateikti argumentai!'
  'lt_LT.UTF-8.missing_chksum_fname' 'Klaida! Nepateiktas kontrolinės sumos failo pavadinimas!'
  'lt_LT.UTF-8.missing_checksum_type' 'Klaida! Nepateiktas kontrolinės sumos tipas!'
  'lt_LT.UTF-8.missing_commands' $'Klaida! Nėra reikalingų komandų! Įdiekite, kad galėtute tęsti!\n\nTrūkstamos komandos:'
  'lt_LT.UTF-8.missing_filename' 'Klaida! Nepateiktas failo pavadinimas!'
  'lt_LT.UTF-8.missing_packages' $'Klaida! Neįdiegti reikalingi paketai! Įdiekite, kad galėtute tęsti!\n\nTrūkstami paketai:'
  'lt_LT.UTF-8.missing_packages_are_not_installed' $'Klaida! Trūkstami paketai nebuvo įdiegti! Vykdymas nutraukiamas!\n\nTrūkstami paketai:'
  'lt_LT.UTF-8.mismatch' 'Klaida! Kontrolinės sumos nesutampa!'
  'lt_LT.UTF-8.no_app' 'Programa {APP_NAME} nerasta, bet esama versija yra{CURRENT}! Patikrinkite programos kodą!'
  'lt_LT.UTF-8.no_app_name' 'Nepateiktas programos pavadinimas! Patikrinkite programos kodą!'
  'lt_LT.UTF-8.no_changes' 'Jokių pakeitimų neatlikta.'
  'lt_LT.UTF-8.no_command_name' 'Nepateiktas komandos pavadinimas! Check app code!'
  'lt_LT.UTF-8.no_current' 'Programa {APP_NAME} įdiegta, bet esama versija nepateikta! Patikrinkite programos kodą!'
  'lt_LT.UTF-8.no_install_dir' 'Nepateiktas diegimo katalogas! Patikrinkite programos kodą!'
  'lt_LT.UTF-8.no_latest' 'Nepateikta vėliausia versija! Patikrinkite programos kodą!'
  'lt_LT.UTF-8.overwrite' 'Programa {APP_NAME}{CURRENT} yra įdiegta. Ar diegti versiją {LATEST}?'
  'lt_LT.UTF-8.prompt' $'Norėdami tęsti, spauskite \'y\', norėdami išeiti, spauskite \'n\' arba <Įvesti>'
  'lt_LT.UTF-8.record_exists' '{APP_NAME} įrašas faile {FILE_NAME} jau yra!'

  # Messages for *_install.sh
  'en.UTF-8.already' 'Application {APP_NAME} already installed!'
  'en.UTF-8.failed' 'Installation of {APP_NAME} failed!'
  'en.UTF-8.failed_latest' 'Installation of {APP_NAME} {LATEST} failed!'
  'en.UTF-8.installed' 'Application {APP_NAME} is successfully installed!'
  'en.UTF-8.installed_latest' 'Application {APP_NAME} {LATEST} is successfully installed!'
  'en.UTF-8.not_extracted' 'Error! Extraction of the file failed!'
  'en.UTF-8.not_installed' 'Error! Application {APP_NAME} is not installed!'
  'en.UTF-8.not_latest' 'Error! Application {APP_NAME}{CURRENT} is not {LATEST}!'
  'en.UTF-8.not_updated' 'Error! Application {APP_NAME}{CURRENT} is not up to date!'
  'en.UTF-8.not_working' 'Error! {APP_NAME} is not working as expected!'
  'en.UTF-8.wo_relogin' $'To use without relogin, execute the following command in the terminal:\n\n{PATH_COMMAND}'
  'lt_LT.UTF-8.already' 'Programa {APP_NAME} jau įdiegta!'
  'lt_LT.UTF-8.failed' 'Programos {APP_NAME} įdiegti nepavyko!'
  'lt_LT.UTF-8.failed_latest' 'Programos {APP_NAME} {LATEST} įdiegti nepavyko!'
  'lt_LT.UTF-8.installed' 'Programa {APP_NAME} sėkmingai įdiegta!'
  'lt_LT.UTF-8.installed_latest' 'Programa {APP_NAME} {LATEST} sėkmingai įdiegta!'
  'lt_LT.UTF-8.not_extracted' 'Klaida! Failo išskleisti nepavyko!'
  'lt_LT.UTF-8.not_installed' 'Klaida! Programa {APP_NAME} {LATEST} neįdiegta!'
  'lt_LT.UTF-8.not_latest' 'Error! Programa {APP_NAME}{CURRENT} nėra {LATEST}!'
  'lt_LT.UTF-8.not_updated' 'Error! Programa {APP_NAME}{CURRENT} neatnaujinta!'
  'lt_LT.UTF-8.not_working' 'Klaida! {APP_NAME} neveikia, kaip turėtų!'
  'lt_LT.UTF-8.wo_relogin' $'Norėdami naudoti programą šioje sesijoje, paleiskite terminale komandą:\n\n{PATH_COMMAND}'
)

# shellcheck disable=SC1094
UTILS_DIR="$(cd -- "$(realpath "${BASH_SOURCE[0]}" | xargs dirname)" &> /dev/null && pwd )"
. "${UTILS_DIR}/_logging.sh"

declare -gA LANG_MESSAGES

APP_NAME="${APP_NAME:-}"

if [ -z "${APP_NAME}" ]; then
  # shellcheck disable=SC1094
  errorMessage "${MESSAGES[${LANG}.empty_app_name]}"
  exit 1
fi

while IFS= read -rd '' key && IFS= read -rd '' value; do
  [[ "$key" != "${LANG}"* ]] && continue
  # shellcheck disable=SC2034
  LANG_MESSAGES["${key#"${LANG}."}"]="${value//'{APP_NAME}'/"${APP_NAME}"}"
done < <(printf '%s\0%s\0' "${MESSAGES[@]@k}")

if [[ -n "${LATEST}" ]]; then
  while IFS= read -rd '' key && IFS= read -rd '' value; do
    # shellcheck disable=SC2034
    LANG_MESSAGES["${key}"]="$(sed -e "s|{LATEST}|${LATEST}|g;s|{CURRENT}|${CURRENT:+ ${CURRENT}}|g" <<<"${value}")"
  done < <(printf '%s\0%s\0' "${LANG_MESSAGES[@]@k}")
fi
