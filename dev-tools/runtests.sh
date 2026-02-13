#!/bin/bash
#
# Test wrapper for Octave tests.
#
# This exists because Octave's (o)runtests() does not return an error status, so
# you can't detect within octave whether your tests have failed. This wrapper
# script captures and parses the textual output of running the tests to detect
# failures.
#
# Prerequisite: "make local" must have been run on this package.

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi

# Utility functions

THIS_PROGRAM=$(basename $0)

function info()  { emit "$*"; }
function error() { emit "ERROR: $*"; }
function emit()  { echo >&2 "${THIS_PROGRAM}: $*"; }

# Main script code

pkg_dir=$(dirname $(realpath $(dirname "$0")))
inst_dir="${pkg_dir}/inst"
test_dir="$inst_dir"
package='tablicious'
#TODO: Should this pull in a defined $OCTAVE? Or will that cause problems with redundant
# --norc --silent --no-gui from the Makefile?
OCTAVE=(octave --norc --no-gui --path="$inst_dir")
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')

outfile="octave-${package}-tests-${TIMESTAMP}.log"
info "pkg_dir = ${pkg_dir}"
info "inst_dir = ${inst_dir}"
info "test_dir = ${test_dir}"

# Main test run

function run_main_tests() {
  local oct_test_code

  info "Running tests for package ${package}"

  # Run the tests
  oct_test_code="addpath('$test_dir'); tblish.internal.runtests;"
  "${OCTAVE[@]}" --eval="${oct_test_code}" 2>&1 | tee "$outfile"

  # Evaluate test output
  # The '! test failed' case is for BISTs run as individual files bc oruntests
  # doesn't discover them.
  if grep '[^X]FAIL\|! test failed' "$outfile" &>/dev/null; then
    STATUS=1
    info "Some tests FAILED!"
  else
    STATUS=0
    info "All tests passed."
  fi
  echo ''
}

run_main_tests

if [[ $STATUS = 0 ]]; then
  extra_fail=''
else
  extra_fail='SOME TESTS FAILED!'
fi

info "Done running tests. Exiting with status ${STATUS}. ${extra_fail}"
info "Test output is in file: ${outfile}"
echo ''

exit "$STATUS"
