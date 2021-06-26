.PHONY: lint test-local test-github-dev test-github-master

lint:
	vint ftdetect/yadm.vim

test-local: lint
	bin/test local

test-github-dev: lint
	bin/test github:dev

test-github-master: lint
	bin/test github:master
