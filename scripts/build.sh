#!/bin/bash

dart pub get
dart run build_runner build --delete-conflicting-outputs