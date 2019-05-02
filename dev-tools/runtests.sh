#!/bin/bash
#
# Test wrapper for Octave tests.
#
# This exists because Octave's runtests() does not return an error status, so
# you can't detect within octave whether your tests have failed.
#
# This must be run from the root of the repo.
#
# Prerequisite: "make local"

set -e

package=$(grep "^Name: " DESCRIPTION | cut -f2 -d' ')

#OCTAVE="octave --no-gui --norc"
# --no-gui might be causing build failures on Linux???
OCTAVE="octave --norc --no-gui"

test_dir="$1"

tempfile=$(mktemp /tmp/octave-${package}-tests-XXXXXXXX)
if [[ "$test_dir" == "" ]]; then
  ${OCTAVE} --path="$PWD/inst" --eval="runtests" 2>&1 | tee "$tempfile"
else
  ${OCTAVE} --path="$PWD/inst" --eval="addpath('$test_dir'); runtests('$test_dir')" 2>&1 | tee "$tempfile"
fi

if grep FAIL "$tempfile" &>/dev/null; then
  echo runtests.sh: Some tests FAILED!
  status=1
else
  echo runtests.sh: All tests passed.
  status=0
fi

echo "runtests.sh: running additional tests so we can get output"
echo "runtests.sh: testing datetime"
${OCTAVE} --path="$PWD/inst" --eval="addpath('$test_dir'); test datetime" 2>&1 | tee "$tempfile"
echo "runtests.sh: testing duration"
${OCTAVE} --path="$PWD/inst" --eval="addpath('$test_dir'); test duration" 2>&1 | tee "$tempfile"

rm "$tempfile"
exit $status
