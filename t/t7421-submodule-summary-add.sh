#!/bin/sh
#
# Copyright (C) 2020  Shourya Shukla
#

test_description='Summary support for submodules, adding them using git submodule add

This test tries to verify the sanity of summary subcommand of git submodule
while making sure to add them using git submodule add instead of the way it
is done using git add in t7401 by Ping Yin.
'

TEST_NO_CREATE_REPO=1
. ./test-lib.sh

test_expect_success 'summary test environment setup' '
	git init super &&
	git init sm &&
	(cd sm &&
		echo file >file &&
		git add file &&
		test_tick &&
		git commit -m "add file"
	) &&
	(cd super &&
		git submodule add ../sm &&
		test_tick &&
		git commit -m "add submodule"
	)
'

test_expect_success 'ensure .gitmodules is present' '
	(cd super &&
		test_path_is_file .gitmodules
	)
'

test_expect_success 'verify summary output for initialised submodule' '
	(cd sm &&
		echo file2 >file2 &&
		git add file2 &&
		test_tick &&
		git commit -m "add file2"
	) &&
	(cd super &&
		git submodule update --remote &&
		git add sm &&
		test_tick &&
		git commit -m "update submodule" &&
		git submodule summary HEAD^ >../actual
	) &&
	rev1=$(git -C sm rev-parse --short HEAD^) &&
	rev2=$(git -C sm rev-parse --short HEAD) &&
	cat >expect <<-EOF &&
	* sm ${rev1}...${rev2} (1):
	  > add file2

	EOF
	test_cmp expect actual
'

test_done
