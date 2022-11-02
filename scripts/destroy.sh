#!/bin/sh

echo "##################################################################"
echo " terraform destroy"
echo "##################################################################"

[ -n "$1" ] || {
  echo "No base directory specified. Usage: $(basename "${0}") <base_directory>"
  exit 1
}

ORIGIN_DIR=${pwd}
BASE_DIR=$(realpath $1)

cd "${BASE_DIR}" || {
  echo "Failed to exec change directory command. ${BASE_DIR}"
  exit 1
}

realpath() {
  case "$1" in /*) ;; *) printf '%s/' "$PWD";; esac; echo "$1"
}

terraform init -input=false -no-color || exit 1
terraform destroy -no-color || exit 1

cd "${ORIGIN_DIR}"