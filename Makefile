all: run

preview-server-nc: build-server-nc
	yarn preview-server-nc --open
.PHONY: preview-server-nc

preview-server: build-server
	yarn preview-server --open
.PHONY: preview-server

preview-static: build-static
	yarn preview-static --open
.PHONY: preview-static

run-server-nc: prepare
	yarn run dev-server-nc --open
.PHONY: run-server-nc

run-server: prepare
	yarn run dev-server --open
.PHONY: run-server

run-static: prepare
	yarn run dev-static --open
.PHONY: run-static

build-server-nc: prepare
	yarn build-server-nc
.PHONY: build-server-nc

build-server: prepare
	yarn build-server
.PHONY: build-server

build-static: prepare
	yarn build-static
.PHONY: build-static

prepare: package.json
	yarn
.PHONY: prepare

deploy:
	./deploy.sh
.PHONY: deploy

format:
	yarn run format
.PHONY: format

# uv run --with python-minifier==3.0.0 pyminify ../../BiCo/bigraded_complexes.py.sage --in-place --no-remove-pass --no-combine-imports --no-constant-folding --no-convert-posargs-to-args --no-remove-object-base --no-rename-locals --no-hoist-literals --remove-literal-statements