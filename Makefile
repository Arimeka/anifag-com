.PHONY: check-go
check-go:
	@scripts/check-go-version.sh

.PHONY: lint
lint:
	@scripts/linter.sh

.PHONY: build-go
build-go: check-go
	@scripts/build-go.sh

.PHONY: build-assets
build-assets:
	@scripts/build-assets.sh

.PHONY: build
build: build-assets
	@scripts/build-go-production.sh
