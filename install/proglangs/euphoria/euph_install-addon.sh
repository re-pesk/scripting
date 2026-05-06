#!/usr/bin/env -S bash

install_euphoria_addon() {

  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"
  printf '%s' "${FUNC_NAME:+"${FUNC_NAME}"$'\n\n'}"

  ADDONS=("$@")

  cd "${TMP_DIR}" || return 1

  # shellcheck disable=SC2068
  for addon in ${ADDONS[@]} ; do
    printf '%s\n\n' "Compiling ${addon^}"
    git clone "https://github.com/OpenEuphoria/${addon}"

    cd "${addon}" || exit 1
    ./configure --prefix "${HOME}/.opt/euphoria"
    make
    make install
    cd "${TMP_DIR}" || exit 1
    printf '%s\n\n' "${addon^} is installed!"
  done
}
