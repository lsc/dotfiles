# SPDX-License-Identifier: GPL-3.0-or-later
# This Makefile is for convenience only; it is not needed for building the package.

EMACS ?= emacs

.PHONY: all test clean

all: test

test:
	./tests/shift-number-tests.sh

clean:
	rm -f *.elc
