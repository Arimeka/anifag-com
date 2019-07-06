#!/usr/bin/env bash

CURRENT_GO_VERSION=$(go version | grep -Eo 'go([0-9\.]+)')
BUILD_GO_VERSION=`cat GO_VERSION`

echo
echo "==> Check go version <=="
if [[ ${CURRENT_GO_VERSION} != ${BUILD_GO_VERSION} ]]; then
  echo "Current go version ${CURRENT_GO_VERSION} is not equal to expected ${BUILD_GO_VERSION}";
  exit 1
fi
