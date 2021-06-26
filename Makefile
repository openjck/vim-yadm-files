.PHONY: test-local test-github-dev test-github-master

test-local:
	bin/test local

test-github-dev:
	bin/test github:dev

test-github-master:
	bin/test github:master
