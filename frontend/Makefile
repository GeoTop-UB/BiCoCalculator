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

deploy:
	./deploy.sh
.PHONY: deploy

# uv run --with python-minifier==3.0.0 pyminify ../../BiCo/bigraded_complexes.py.sage --in-place --no-remove-pass --no-combine-imports --no-constant-folding --no-convert-posargs-to-args --no-remove-object-base --no-rename-locals --no-hoist-literals --remove-literal-statements