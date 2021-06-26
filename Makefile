.PHONY: lint test-local test-github-dev test-github-master

lint:
	vint ftdetect/yadm.vim

test-local: lint
	bin/test local

test-github-dev:
	bin/test github:dev

test-github-master:
	bin/test github:master
