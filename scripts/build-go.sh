#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${DIR}/build-env.sh

echo
echo "==> Build binary <=="
go build -ldflags "${BUILD_FLAGS}" -o server ./cmd/server
