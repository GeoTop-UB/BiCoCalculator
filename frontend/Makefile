all: run

run: prepare
	yarn run dev --open
.PHONY: run

prepare: package.json
	yarn
.PHONY: prepare

build:
	yarn build
.PHONY: build

preview: build
	yarn preview --open
.PHONY: preview
