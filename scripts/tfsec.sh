#!/bin/sh

echo "##################################################################"
echo " tfsec"
echo "##################################################################"

[ -n "$1" ] || {
  echo "No base directory specified. Usage: $(basename "${0}") <base_directory>"
  exit 1
}

abspath() {
  case "$1" in /*) ;; *) printf '%s/' "$PWD";; esac; echo "$1"
}

ORIGIN_DIR=${pwd}
BASE_DIR=$(abspath $1)

cd "${BASE_DIR}" || {
  echo "Failed to exec change directory command. ${BASE_DIR}"
  exit 1
}

if [ ! -d ".terraform" ]; then
  terraform init -input=false -backend=false -no-color || exit 1
fi
tfsec --no-color 

cd "${ORIGIN_DIR}"