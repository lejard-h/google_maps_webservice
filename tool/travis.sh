#!/bin/bash

# Fast fail the script on failures.
set -e

# Verify that the libraries are error and warning-free.
echo "Running dartanalyzer..."
dartanalyzer $DARTANALYZER_FLAGS \
  lib/**/*.dart \
  test/*.dart

# Verify that dartfmt has been run
echo "Checking dartfmt..."
if [[ $(dartfmt -n --set-exit-if-changed lib/ test/) ]]; then
	echo "Failed dartfmt check: run dartfmt -w lib/ test/"
	exit 1
fi

# Run vm tests
pub run test -p vm test/all_test.dart
pub run test -p "chrome" test/all_browser_test.dart

# Install dart_coveralls; gather and send coverage data.
if [ "$COVERALLS_TOKEN" ] && [ "$TRAVIS_DART_VERSION" = "stable" ]; then
  echo "Running coverage..."
  pub global activate dart_coveralls
  pub global run dart_coveralls report \
    --retry 2 \
    --exclude-test-files \
    --debug \
    test/all_test.dart
fi