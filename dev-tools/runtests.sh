#!/bin/bash
#
# Test wrapper for Octave tests.
#
# BROKEN: As of Octave 8.x (and maybe earlier), it looks like runtests() no longer
# exists, and this script will error out with a "'runtests' undefined..." error.
#
# This exists because Octave's runtests() does not return an error status, so
# you can't detect within octave whether your tests have failed.
#
# Prerequisite: "make local" must have been run on this packaage

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi

# Utility functions

THIS_PROGRAM=$(basename $0)

function info() {
  echo "$*"
}

function error() {
  echo >&2 "${THIS_PROGRAM}: ERROR: $*"
}

# Main script code

pkg_dir=$(dirname $(realpath $(dirname "$0")))
inst_dir="${pkg_dir}/inst"
test_dir="$inst_dir"
package='tablicious'
OCTAVE="octave --norc --no-gui"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')

outfile="octave-${package}-tests-${TIMESTAMP}.log"
oct_test_code="addpath('$test_dir'); runtests('$test_dir')"

# Main test run

info "Running tests for package ${package}"

${OCTAVE} --path="$inst_dir" --eval="${oct_test_code}" 2>&1 | tee "$outfile"

if grep FAIL "$outfile" &>/dev/null; then
  status=1
  info "Some tests FAILED!"
else
  status=0
  info "All tests passed."
fi
echo ''

info "Running additional tests so we can get output"
things_to_test=( datetime duration string table )
for thing in "${things_to_test[@]}"; do
  info "Testing ${thing}"
  ${OCTAVE} --path="$PWD/inst" --eval="addpath('$test_dir'); test ${thing}" 2>&1 | tee -a "$outfile"
done

if [[ $status = 0 ]]; then
  extra_fail=''
else
  extra_fail='SOME TESTS FAILED!'
fi

echo ''
info "Done running tests. Exiting with status ${status}. ${extra_fail}"
info "Test output is in file: ${outfile}"
echo ''

exit "$status"
