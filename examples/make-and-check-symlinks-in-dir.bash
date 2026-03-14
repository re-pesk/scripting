#!/usr/bin/env bash

# readarray -td '
# ' configArray <<< "$configstrings"

# Make symbolic links
function make_symbolic_links() {
  destination_dir="$1"
  [ ! -d "$destination_dir" ] && echo "The destination directory ${destination_dir} does not exists!" && exit -1

  source_dir="$2"
  [ ! -d "$source_dir" ] && echo "The source directory ${source_dir} does not exists!" && exit -1
  
  prefix="$3"
  files=( $source_dir/$prefix* )
  for filename in "${files[@]}" ; do
    # -s - make symbolic links
    # -f - force to remove existing files
    ln -fs "${filename}" "${filename}" "${destination_dir}"
    exit_code="$?"
    [[ $exit_code > 0 ]] && echo "Error! Link is not created!" && return $exit_code 
  done
}

function check_symbolic_links() {
  destination_dir="$1"
  [ ! -d "$destination_dir" ] && echo "The destination directory ${destination_dir} does not exists!" && exit -1

  prefix="$2"
  files=( ${destination_dir}/${prefix}* )
  for filename in "${files[@]}" ; do
    # -e check if file exists or is valid.
    if [[ -L "$filename" ]];then
      echo "${filename} -> $(readlink $filename)"
      [[ ! -e "$filename" ]] && echo "The symlink is broken!"
      echo ""
    fi
  done
}

mkdir /tmp/linktest
make_symbolic_links /tmp/linktest ${HOME}/.local/nu nu
check_symbolic_links "/tmp/linktest" "nu"
rm -r /tmp/linktest
