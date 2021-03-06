GO ?= go
GOLANGCI_LINT ?= golangci-lint

LDFLAGS ?= -s -w
ifdef COMMIT
LDFLAGS += -X github.com/ethersphere/beekeeper.commit="$(COMMIT)"
endif

.PHONY: all
all: build lint vet test binary

.PHONY: binary
binary: export CGO_ENABLED=0
binary: dist FORCE
	$(GO) version
	$(GO) build -trimpath -ldflags "$(LDFLAGS)" -o dist/beekeeper ./cmd/beekeeper

dist:
	mkdir $@

.PHONY: lint
lint:
	$(GOLANGCI_LINT) run

.PHONY: vet
vet:
	$(GO) vet ./...

.PHONY: test
test:
	$(GO) test -v ./...

.PHONY: build
build: export CGO_ENABLED=0
build:
	$(GO) build -trimpath -ldflags "$(LDFLAGS)" ./...

.PHONY: clean
clean:
	$(GO) clean
	rm -rf dist/

FORCE: