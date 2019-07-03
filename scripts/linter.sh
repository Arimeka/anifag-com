#!/usr/bin/env bash

echo
echo "==> Running go vet <=="
go vet ./... || exit_code=1
echo
echo "==> Running golint <=="
golint -set_exit_status ./... || exit_code=1
echo
echo "==> Running gocritic <=="
gocritic check -enable='#diagnostic,#style,#performance' ./... || exit_code=1
echo
echo "==> Running gocyclo <=="
gocyclo -over 15 . || exit_code=1

exit $exit_code
