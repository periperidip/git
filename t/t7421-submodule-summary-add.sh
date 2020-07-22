#!/bin/sh
#
# Copyright (C) 2020  Shourya Shukla
#

test_description='Summary support for submodules, adding them using git submodule add

This test script tries to verify the sanity of summary subcommand of git submodule
while making sure to add submodules using `git submodule add` instead of
`git add` as done in t7401.
'

. ./test-lib.sh

test_expect_success 'summary test environment setup' '
	git init sm &&
	test_commit -C sm "add file" file file file &&

	git init &&
	git submodule add ./sm submodule &&
	test_tick &&
	git commit -m "add submodule"
'

test_done
