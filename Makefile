.PHONY: test-dev test-staging test-master

test-dev:
	bin/test dev

test-staging:
	bin/test staging

test-master:
	bin/test master
