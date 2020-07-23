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

test_expect_success 'verify summary output for initialised submodule' '
	test_commit -C sm "add file2" file2 file2 file2 &&
	git submodule update --remote &&
	test_tick &&
	git commit -m "update submodule" submodule &&
	git submodule summary HEAD^ >actual &&
	rev1=$(git -C sm rev-parse --short HEAD^) &&
	rev2=$(git -C sm rev-parse --short HEAD) &&
	cat >expect <<-EOF &&
	* submodule ${rev1}...${rev2} (1):
	  > add file2

	EOF
	test_cmp expect actual
'

test_done
