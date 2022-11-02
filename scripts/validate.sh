#!/bin/sh

echo "##################################################################"
echo " terraform validate"
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
SCRIPT_DIR=$(
  cd "$(dirname $0)" || {
    echo "Failed to exec change directory command"
    exit 1
  }
  pwd
)

cd "${SCRIPT_DIR}"

validate() {
  target_dirs="$(find ${BASE_DIR} -type f -name "*.tf" -exec dirname {} \; | sort -u)"
  for target in ${target_dirs}; do
    echo "##################################################################"
    echo " processing validate : ${target}"
    echo "##################################################################"

    cd "${target}"
    if [ ! -d ".terraform" ]; then
      terraform init -input=false -backend=false -no-color || exit 1
    fi
    terraform validate -no-color || exit 1
    cd "${SCRIPT_DIR}"
  done
}

validate

cd "${ORIGIN_DIR}"