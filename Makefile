.PHONY: check-go
check-go:
	@scripts/check-go-version.sh

.PHONY: lint
lint:
	@scripts/linter.sh

.PHONY: build-go
build-go: check-go
	@scripts/build-go.sh
