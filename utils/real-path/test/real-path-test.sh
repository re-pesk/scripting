#!/usr/bin/env -S sh

# ==============================================================================
# Failas: real-path-test.sh
# Aprašymas: Automatizuotas bibliotekos 'real-path.sh' testų rinkinys.
#            Tikrina vieno failo ir masinio apdorojimo funkcijas, klaidų kodus (1, 2)
#            bei RS (\036) skyriklių formatą.
#
# File: real-path-test.sh
# Description: Automated test suite for the 'real-path.sh' library.
#              Tests single-file and batch functions, exit codes (1, 2),
#              and RS (\036) delimiter formatting.
# ==============================================================================

# 0. Apsauginė APPS_LIB kintamojo ir bibliotekos egzistavimo patikra
# Safeguard check for the APPS_LIB variable and library file existence
if [ -z "${APPS_LIB}" ]; then
  case "${LANG%".UTF-8"}" in
    ( lt_LT ) printf '%s\n' 'Klaida: Aplinkos kintamasis APPS_LIB nėra nustatytas!' >&2 ;;
    ( * )     printf '%s\n' 'Error: Environment variable APPS_LIB is not set!' >&2 ;;
  esac
  exit 1
fi

if [ ! -r "${APPS_LIB}/real-path.sh" ]; then
  case "${LANG%".UTF-8"}" in
    ( lt_LT ) printf '%s\n' "Klaida: Biblioteka '${APPS_LIB}/real-path.sh' nerasta arba neperskaitoma!" >&2 ;;
    ( * )     printf '%s\n' "Error: Library '${APPS_LIB}/real-path.sh' not found or not readable!" >&2 ;;
  esac
  exit 1
fi

# 1. Įkeliame biblioteką pilnu režimu per APPS_LIB ir nustatome testų katalogą
# Load the library in full mode via APPS_LIB and determine the test directory
REAL_PATH_MODE="full" . "${APPS_LIB}/real-path.sh"
unset REAL_PATH_MODE

REAL_PATH_TEST_DIR="$(cd -P -- "${REAL_PATH_LIB_DIR}/../test" && pwd -P)"
export APPS_LIB="${REAL_PATH_LIB_DIR}"

# 2. Sukuriame laikiną testavimo aplinką su failais ir simbolinėmis nuorodomis
# Set up a temporary test environment with files and symbolic links
setup_test_env() {
  TEST_TEMP_DIR="${REAL_PATH_TEST_DIR}/laikinas_test_dir"
  mkdir -p "${TEST_TEMP_DIR}/katalogas"
  cd "${TEST_TEMP_DIR}" || exit 1

  printf '%s\n' "Turinys" > "tikras_failas.txt"
  printf '%s\n' "Programa" > "katalogas/programa.sh"
  chmod +x "katalogas/programa.sh"

  ln -s "tikras_failas.txt" "nuoroda_1.txt"
  ln -s "nuoroda_1.txt" "nuoroda_grandine.txt"
  ln -s "tikras_failas.txt" "bjaurus_ -> _pavadinimas.txt"
  ln -s "neegzistuojantis_tikslas.txt" "sugadinta_nuoroda.txt"
}

# 3. Išvalome laikiną testavimo aplinką
# Clean up the temporary test environment
cleanup_test_env() {
  cd "${REAL_PATH_TEST_DIR}" || exit 1
  rm -rf "${TEST_TEMP_DIR}"
}

# ==============================================================================
# Patikros variklis (Assertion engine)
# ==============================================================================
TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0

# Funkcija: assert_test
# Aprašymas: Palygina gautą reikšmę bei išeities kodą su tikėtinais.
# Argumentai: $1 - Testo pavadinimas
#             $2 - Gauta reikšmė (actual_out)
#             $3 - Tikėtina reikšmė (expected_out)
#             $4 - Gautas kodas (actual_code)
#             $5 - Tikėtinas kodas (expected_code)
assert_test() {
  test_name="$1"
  actual_out="$2"
  expected_out="$3"
  actual_code="$4"
  expected_code="$5"

  TESTS_TOTAL=$((TESTS_TOTAL + 1))

  if [ "${actual_out}" = "${expected_out}" ] && [ "${actual_code}" -eq "${expected_code}" ]; then
    TESTS_PASSED=$((TESTS_PASSED + 1))
    printf '[PASS] %s\n' "${test_name}"
  else
    TESTS_FAILED=$((TESTS_FAILED + 1))
    # Pakeičiame RS (\036) į '|' kad klaidos pranešimas būtų įskaitomas
    vis_actual="$(printf '%s' "${actual_out}" | tr '\036' '|')"
    vis_expected="$(printf '%s' "${expected_out}" | tr '\036' '|')"
    printf '[FAIL] %s\n' "${test_name}" >&2
    printf '       Tikėtasi / Expected: out="%s", code=%s\n' "${vis_expected}" "${expected_code}" >&2
    printf '       Gauta    / Actual:   out="%s", code=%s\n' "${vis_actual}" "${actual_code}" >&2
  fi
}

# Funkcija: print_summary
# Aprašymas: Išveda bendrą testų suvestinę ir grąžina kodą 0 (jei visi praėjo) arba 1.
print_summary() {
  printf -- '\n--------------------------------------------------------\n\n'
  printf 'Iš viso / Total: %s | Sėkmingų / Passed: %s | Nesėkmingų / Failed: %s\n\n' \
    "${TESTS_TOTAL}" "${TESTS_PASSED}" "${TESTS_FAILED}"

  if [ "${TESTS_FAILED}" -eq 0 ]; then
    printf "REZULTATAS / RESULT: PASS\n\n" >&2
    return 0
  else
    printf "REZULTATAS / RESULT: FAIL\n\n" >&2
    return 1
  fi
}

test_safeguards() {
  # 1. Tiesioginio paleidimo blokavimas (tikimasi kodo 1)
  sh "${APPS_LIB}/real-path.sh" >/dev/null 2>&1
  code=$?
  assert_test "Saugiklis: tiesioginis paleidimas" "" "" "${code}" 1

  # 2. Pakartotinio įkėlimo sustabdymas su DEBUG=1 (tikimasi kodo 0 ir pranešimo į stderr)
  err_out="$(DEBUG=1 . "${APPS_LIB}/real-path.sh" 2>&1)"
  code=$?
  # Tikriname tik ar pranešimas nėra tuščias (pritaikyta lt_LT ir en_US)
  [ -n "${err_out}" ] && has_msg="yes" || has_msg="no"
  assert_test "Saugiklis: pakartotinis įkėlimas (DEBUG=1)" "${has_msg}" "yes" "${code}" 0
}

test_get_real_path() {
  expected_file="${TEST_TEMP_DIR}/tikras_failas.txt"

  # 1. Sėkmingas nuorodos išrišimas su specialiais simboliais
  out="$(get_real_path "bjaurus_ -> _pavadinimas.txt")"
  code=$?
  assert_test "get_real_path: nuoroda su specialiais simboliais" "${out}" "${expected_file}" "${code}" 0

  # 2. Sugadinta nuoroda (tikimasi tuščios išvesties ir kodo 2)
  out="$(get_real_path "sugadinta_nuoroda.txt" 2>/dev/null)"
  code=$?
  assert_test "get_real_path: sugadinta nuoroda" "${out}" "" "${code}" 2

  # 3. Trūkstamas argumentas (tikimasi kodo 1)
  out="$(get_real_path 2>/dev/null)"
  code=$?
  assert_test "get_real_path: be argumentų" "${out}" "" "${code}" 1
}

test_get_real_dir() {
  # 1. Sėkmingas katalogo kelio išgavimas
  out="$(get_real_dir "nuoroda_grandine.txt")"
  code=$?
  assert_test "get_real_dir: nuorodų grandinė" "${out}" "${TEST_TEMP_DIR}" "${code}" 0

  # 2. Nerastas failas (tikimasi kodo 2)
  out="$(get_real_dir "nerastas.txt" 2>/dev/null)"
  code=$?
  assert_test "get_real_dir: nerastas failas" "${out}" "" "${code}" 2
}

test_batch_functions() {
  expected_file="${TEST_TEMP_DIR}/tikras_failas.txt"

  # 1. get_real_path_map: pirmas nerastas, antras rastas, trečias sugadintas
  out="$(get_real_path_map "nerastas1.txt" "tikras_failas.txt" "sugadinta_nuoroda.txt" 2>/dev/null)"
  code=$?
  expected="nerastas1.txt:${RS}tikras_failas.txt:${expected_file}${RS}sugadinta_nuoroda.txt:"
  assert_test "get_real_path_map: dalinė sėkmė ir RS skyrikliai" "${out}" "${expected}" "${code}" 2

  # 2. get_real_path_list_by_key: esamas raktas + nerastas raktas pabaigoje
  map_data="$(get_real_path_map "tikras_failas.txt" "nuoroda_1.txt")"
  out="$(get_real_path_list_by_key "${map_data}" "tikras_failas.txt" "neegzistuojantis.txt" 2>/dev/null)"
  code=$?
  expected="${expected_file}${RS}"
  assert_test "get_real_path_list_by_key: tuščia reikšmė pabaigoje" "${out}" "${expected}" "${code}" 2

  # 3. get_real_path_list: nerasti failai pradžioje ir pabaigoje
  out="$(get_real_path_list "nerastas_pradzioje.txt" "tikras_failas.txt" "nerastas_gale.txt" 2>/dev/null)"
  code=$?
  expected="${RS}${expected_file}${RS}"
  assert_test "get_real_path_list: tušti įrašai kraštuose" "${out}" "${expected}" "${code}" 2

  # 4. get_real_dir_list: keli failai su tuščiu įrašu viduryje
  out="$(get_real_dir_list "tikras_failas.txt" "nerastas.txt" "bjaurus_ -> _pavadinimas.txt" 2>/dev/null)"
  code=$?
  expected="${TEST_TEMP_DIR}${RS}${RS}${TEST_TEMP_DIR}"
  assert_test "get_real_dir_list: katalogų sąrašas su klaida viduryje" "${out}" "${expected}" "${code}" 2
}

# ==============================================================================
# Testų vykdymas / Execution of tests
# ==============================================================================
run_all_tests() {
  printf "\n=== PRADEDAMI TESTAI / STARTING TESTS ===\n\n"
  setup_test_env

  test_safeguards
  test_get_real_path
  test_get_real_dir
  test_batch_functions

  cleanup_test_env
  print_summary
}

run_all_tests

