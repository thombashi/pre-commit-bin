PRE_COMMIT_SRC_DIR := src


.PHONY: build-latest
build-latest: clean
	@git clone --depth 1 https://github.com/pre-commit/pre-commit.git "$(PRE_COMMIT_SRC_DIR)"
	@./scripts/build_linux_package.sh "$(shell cat tag_name)" "$(PRE_COMMIT_SRC_DIR)"
	ls dist

.PHONY: clean
clean:
	@rm -rf "$(PRE_COMMIT_SRC_DIR)" build dist dpkg_build

.PHONY: release
release:
	git tag v$(shell cat tag_name)
	git push --tags

.PHONY: setup
setup:
	@sudo apt-get -qq update
	@sudo apt-get install -qq -y --no-install-recommends curl coreutils fakeroot git rename tar
