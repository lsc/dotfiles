emacs ?= emacs
CASK ?= cask
BEMACS = $(CASK) exec $(emacs) --batch -Q

cask:
	$(CASK) --verbose --debug

build:
	$(CASK) build

test:
	$(CASK) exec buttercup -L .

checkdoc:
	$(BEMACS) -l test/test-checkdoc.el

clean:
	$(CASK) clean-elc

.PHONY: cask test checkdoc clean
