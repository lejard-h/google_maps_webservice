#!/bin/bash

# Fast fail the script on failures.
set -e

if [ "$#" == "0" ]; then
  echo -e '\033[31mAt least one task argument must be provided!\033[0m'
  exit 1
fi

pub upgrade || exit $?

EXIT_CODE=0

function pkg_coverage {
  if [ "$CODECOV_TOKEN"] ; then
    pub run test_coverage
    bash <(curl -s https://codecov.io/bash)
  fi
}

while (( "$#" )); do
  TASK=$1
  case $TASK in
  test) echo
    echo -e '\033[1mTASK: command\033[22m'
    echo -e 'pub run test -- -p chrome -p vm'
    pub run test -p chrome -p vm --reporter expanded || EXIT_CODE=$?
    pkg_coverage
    ;;
  analyzer) echo
    echo -e '\033[1mTASK: dartanalyzer\033[22m'
    echo -e 'dartanalyzer --fatal-infos --fatal-warnings .'
    dartanalyzer --fatal-infos --fatal-warnings . || EXIT_CODE=$?
    ;;
  dartfmt) echo
    echo -e '\033[1mTASK: dartfmt\033[22m'
    echo -e 'dartfmt -n --set-exit-if-changed .'
    dartfmt -n --set-exit-if-changed . || EXIT_CODE=$?
    ;;
  *) echo -e "\033[31mNot expecting TASK '${TASK}'. Error!\033[0m"
    EXIT_CODE=1
    ;;
  esac

  shift
done

exit $EXIT_CODE