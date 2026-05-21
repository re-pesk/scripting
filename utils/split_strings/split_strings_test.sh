#!/bin/sh

# Import the core functions from split_strings.sh
# Using POSIX dot command for sourcing
. ./split_strings.sh

# ==============================================================================
# AUTOMATED TESTING ENGINE (POSIX COMPLIANT)
# ==============================================================================

# Global test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Helper function to evaluate test results programmatically
# Arguments: $1 = Got, $2 = Expected
assert_equals() {
  TOTAL_TESTS=$((TOTAL_TESTS + 1))
  got="$1"
  expected="$2"

  if [ "$got" = "$expected" ]; then
    printf '%s\n' 'Test result: [ OK ]'
    PASSED_TESTS=$((PASSED_TESTS + 1))
  else
    printf '%s\n' 'Test result: [ FAILED ]'
    printf '%s\n' '  Expected (od -c):'
    printf '%s' "$expected" | od -c | sed 's/^/    /'
    FAILED_TESTS=$((FAILED_TESTS + 1))
  fi
}

# --- TEST SUITES ---

test_split_string_1() {
  printf '\nTest: test_split_string_1\n'
  # shellcheck disable=SC2016
  printf '%s\n' 'Call: split_string -j="$RS" "POSIX"'
  actual=$(split_string -j="$RS" "POSIX")
  printf 'Result:\n'; printf '%s' "$actual" | od -c
  expected="P${RS}O${RS}S${RS}I${RS}X"
  assert_equals "$actual" "$expected"
}

test_split_string_2() {
  printf '\nTest: test_split_string_2\n'
  printf '%s\n' 'Call: split_string -delim="[IR]" -j="$RS" "Vienas[IR]Du[IR]Trys"'
  actual=$(split_string -delim="[IR]" -j="$RS" "Vienas[IR]Du[IR]Trys")
  printf 'Result:\n'; printf '%s' "$actual" | od -c
  expected="Vienas${RS}Du${RS}Trys"
  assert_equals "$actual" "$expected"
}

test_split_string_3() {
  printf '\nTest: test_split_string_3\n'
  printf '%s\n' 'Call: split_string --delim="," -j="$RS" "A,B,C"'
  actual=$(split_string --delim="," -j="$RS" "A,B,C")
  printf 'Result:\n'; printf '%s' "$actual" | od -c
  expected="A${RS}B${RS}C"
  assert_equals "$actual" "$expected"
}

test_split_string_4() {
  printf '\nTest: test_split_string_4 (Edge Case: Empty input string)\n'
  printf '%s\n' 'Call: split_string -j="$RS" ""'
  actual=$(split_string -j="$RS" "")
  printf 'Result:\n'; printf '%s' "$actual" | od -c
  expected=""
  assert_equals "$actual" "$expected"
}

test_split_string_5() {
  printf '\nTest: test_split_string_5 (Edge Case: Character split with custom text join)\n'
  printf '%s\n' 'Call: split_string -j="-" "SH"'
  actual=$(split_string -j="-" "SH")
  printf 'Result:\n'; printf '%s' "$actual" | od -c
  expected="S-H"
  assert_equals "$actual" "$expected"
}

test_normalize_indexes_1() {
  printf '\nTest: test_normalize_indexes_1\n'
  printf '%s\n' 'Call: normalize_indexes -max=3 -j="$RS" "1,-2,3"\n'
  actual=$(normalize_indexes -max=3 -j="$RS" "1,-2,3")
  printf 'Result:\n'; printf '%s' "$actual" | od -c
  expected="1${RS}2${RS}3"
  assert_equals "$actual" "$expected"
}

test_normalize_indexes_2() {
  printf '\nTest: test_normalize_indexes_2\n'
  printf '%s\n' 'Call: normalize_indexes --max=5 -j="$RS" "1,-1"\n'
  actual=$(normalize_indexes --max=5 -j="$RS" "1,-1")
  printf 'Result:\n'; printf '%s' "$actual" | od -c
  expected="1${RS}5"
  assert_equals "$actual" "$expected"
}

test_normalize_indexes_3() {
  printf '\nTest: test_normalize_indexes_3\n'
  printf '%s\n' 'Call: normalize_indexes -m=4 -j="$RS" "2,9,3"\n'
  actual=$(normalize_indexes -m=4 -j="$RS" "2,9,3")
  printf 'Result:\n'; printf '%s' "$actual" | od -c
  expected="2${RS}3"
  assert_equals "$actual" "$expected"
}

test_normalize_indexes_4() {
  printf '\nTest: test_normalize_indexes_4 (Edge Case: Index out of bounds - too negative)\n'
  printf '%s\n' 'Call: normalize_indexes -max=3 -j="$RS" "1,-5,3"\n'
  actual=$(normalize_indexes -max=3 -j="$RS" "1,-5,3")
  printf 'Result:\n'; printf '%s' "$actual" | od -c
  expected="1${RS}3"
  assert_equals "$actual" "$expected"
}

test_normalize_indexes_5() {
  printf '\nTest: test_normalize_indexes_5 (Edge Case: Empty index input string)\n'
  printf '%s\n' 'Call: normalize_indexes -max=3 -j="$RS" ""\n'
  actual=$(normalize_indexes -max=3 -j="$RS" "")
  printf 'Result:\n'; printf '%s' "$actual" | od -c
  expected=""
  assert_equals "$actual" "$expected"
}

test_filter_text_1() {
  printf '\nTest: test_filter_text_1\n'
  printf '%s\n' 'Call: filter_text -delim="[IR]" -incl="1,3" -j="$RS" "Vienas[IR]Du[IR]Trys[IR]Keturi"\n'
  actual=$(filter_text -delim="[IR]" -incl="1,3" -j="$RS" "Vienas[IR]Du[IR]Trys[IR]Keturi")
  printf 'Result:\n'; printf '%s' "$actual" | od -c
  expected="Vienas${RS}Trys"
  assert_equals "$actual" "$expected"
}

test_filter_text_2() {
  printf '\nTest: test_filter_text_2\n'
  printf '%s\n' 'Call: filter_text -delim="," -excl="-1" -j="$RS" "A,B,C,D"\n'
  actual=$(filter_text -delim="," -excl="-1" -j="$RS" "A,B,C,D")
  printf 'Result:\n'; printf '%s' "$actual" | od -c
  expected="A${RS}B${RS}C"
  assert_equals "$actual" "$expected"
}

test_filter_text_3() {
  printf '\nTest: test_filter_text_3\n'
  printf '%s\n' 'Call: filter_text --incl="1,-1" -j="$RS" "POSIX"\n'
  actual=$(filter_text --incl="1,-1" -j="$RS" "POSIX")
  printf 'Result:\n'; printf '%s' "$actual" | od -c
  expected="P${RS}X"
  assert_equals "$actual" "$expected"
}

test_filter_text_4() {
  printf '\nTest: test_filter_text_4\n'
  printf '%s\n' 'Call: filter_text -d="," -incl="1,2,3" -excl="2" -j="$RS" "Jonas,Petras,Antanas,Linas"\n'
  actual=$(filter_text -d="," -incl="1,2,3" -excl="2" -j="$RS" "Jonas,Petras,Antanas,Linas")
  printf 'Result:\n'; printf '%s' "$actual" | od -c
  expected="Jonas${RS}Antanas"
  assert_equals "$actual" "$expected"
}

test_filter_text_5() {
  printf '\nTest: test_filter_text_5 (Edge Case: All elements are excluded)\n'
  printf '%s\n' 'Call: filter_text -d="," -excl="1,2,3" -j="$RS" "A,B,C"\n'
  actual=$(filter_text -d="," -excl="1,2,3" -j="$RS" "A,B,C")
  printf 'Result:\n'; printf '%s' "$actual" | od -c
  expected=""
  assert_equals "$actual" "$expected"
}

test_filter_text_6() {
  printf '\nTest: test_filter_text_6 (Edge Case: Input text contains only the delimiter)\n'
  printf '%s\n' 'Call: filter_text -d="[IR]" -incl="1,2" -j="$RS" "[IR]"\n'
  actual=$(filter_text -d="[IR]" -incl="1,2" -j="$RS" "[IR]")
  printf 'Result:\n'; printf '%s' "$actual" | od -c
  expected=""
  assert_equals "$actual" "$expected"
}


# ==============================================================================
# EXECUTE ALL TESTS
# ==============================================================================

printf '\n======================================================================\n'
printf '1. TESTS FOR FUNCTION "split_string"'
printf '\n======================================================================\n'
test_split_string_1
test_split_string_2
test_split_string_3
test_split_string_4
test_split_string_5

printf '\n======================================================================\n'
printf '2. TESTS FOR FUNCTION "normalize_indexes"'
printf '\n======================================================================\n'
test_normalize_indexes_1
test_normalize_indexes_2
test_normalize_indexes_3
test_normalize_indexes_4
test_normalize_indexes_5

printf '\n======================================================================\n'
printf '3. TESTS FOR FUNCTION "filter_text"'
printf '\n======================================================================\n'
test_filter_text_1
test_filter_text_2
test_filter_text_3
test_filter_text_4
test_filter_text_5
test_filter_text_6

# --- FINAL SUMMARY REPORT ---
printf '\n======================================================================\n'
printf 'FINAL TEST SUMMARY'
printf '\n======================================================================\n'
printf 'Total Executed : %d\n' "$TOTAL_TESTS"
printf 'Passed         : %d\n' "$PASSED_TESTS"
printf 'Failed         : %d' "$FAILED_TESTS"
printf '\n======================================================================\n'

# Return standard POSIX exit status to the environment (CI/CD pipelines friendly)
if [ "$FAILED_TESTS" -gt 0 ]; then
  printf '\nSome tests failed. Check the log above. Exit status: 1\n\n'
  exit 1
fi

printf '\nAll tests completed successfully. Exit status: 0\n\n'
exit 0
