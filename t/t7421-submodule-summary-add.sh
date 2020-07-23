#!/bin/sh
#
# Copyright (C) 2020  Shourya Shukla
#

test_description='Summary support for submodules, adding them using git submodule add

This test tries to verify the sanity of summary subcommand of git submodule
while making sure to add them using `git submodule add` instead of the way it
is done using `git add` in t7401.
'

TEST_NO_CREATE_REPO=1
. ./test-lib.sh

test_expect_success 'summary test environment setup' '
	git init super &&
	git init sm &&
	test_commit -C sm "add file" file file file &&

	git -C super submodule add ../sm &&
	test_tick -C super &&
	git -C super commit -m "add submodule"
'

test_expect_success 'verify summary output for initialised submodule' '
	test_commit -C sm "add file2" file2 file2 file2 &&
	git -C super submodule update --remote &&
	git -C super add sm &&
	test_tick -C super &&
	git -C super commit -m "update submodule" &&
	git -C super submodule summary HEAD^ >actual &&
	rev1=$(git -C sm rev-parse --short HEAD^) &&
	rev2=$(git -C sm rev-parse --short HEAD) &&
	cat >expect <<-EOF &&
	* sm ${rev1}...${rev2} (1):
	  > add file2

	EOF
	test_cmp expect actual
'

test_done
