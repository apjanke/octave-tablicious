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
# Prerequisite: "make local" must have been run on this package.
#
# TODO: Factor most of this out to M-code like tblish.internal.runtests, now that
# we need to do runtests vs. oruntests detection. And the "more_tests" stuff should
# be centralized so you can run it inside Octave instead of requiring this wrapper
# script.

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
OCTAVE=(octave --norc --no-gui --path="$inst_dir")
# Extra tests that are not detected by oruntests
more_things_to_test=( @datetime/datetime.m @duration/duration.m @string/string.m @table/table.m )
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')

outfile="octave-${package}-tests-${TIMESTAMP}.log"
info "pkg_dir = ${pkg_dir}"
info "inst_dir = ${inst_dir}"
info "test_dir = ${test_dir}"

# Main test run

function run_main_tests() {
  local oct_test_code

  info "Running tests for package ${package}"

  oct_test_code="addpath('$test_dir'); oruntests('$test_dir')"
  "${OCTAVE[@]}" --eval="${oct_test_code}" 2>&1 | tee "$outfile"

  if grep FAIL "$outfile" &>/dev/null; then
    STATUS=1
    info "Some tests FAILED!"
  else
    STATUS=0
    info "All tests passed."
  fi
  echo ''
}

function run_more_tests() {
  local thing

  info "Running additional tests so we can get output"
  for thing in "${more_things_to_test[@]}"; do
    info "Testing ${thing}"
    "${OCTAVE[@]}" --eval="addpath('$test_dir'); test('${thing}')" 2>&1 | tee -a "$outfile"
  done
}

function run_tests_using_mcode() {
  info "Running tests using ${package}'s M-code test script"
  "${OCTAVE[@]}" --eval="tblish.internal.runtests" 2>&1 | tee "$outfile"
}

run_main_tests
run_more_tests

if [[ $STATUS = 0 ]]; then
  extra_fail=''
else
  extra_fail='SOME TESTS FAILED!'
fi

echo ''
info "Done running tests. Exiting with status ${STATUS}. ${extra_fail}"
info "Test output is in file: ${outfile}"
echo ''

exit "$STATUS"
