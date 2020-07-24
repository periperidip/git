#!/bin/sh
#
# Copyright (C) 2020 Shourya Shukla
#

test_description='Summary support for submodules, adding them using git submodule add

This test script tries to verify the sanity of summary subcommand of git submodule
while making sure to add submodules using `git submodule add` instead of
`git add` as done in t7401.
'

. ./test-lib.sh

test_expect_success 'summary test environment setup' '
	git init sm &&
	test_commit -C sm "add file" file file-content file-tag &&

	git submodule add ./sm submodule &&
	test_tick &&
	git commit -m "add submodule"
'

test_expect_success 'submodule summary output for initialized submodule' '
	test_commit -C sm "add file2" file2 file2-content file2-tag &&
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

test_expect_success 'submodule summary output for deinitialized submodule' '
	git submodule deinit submodule &&
	git submodule summary HEAD^ >actual &&
	test_must_be_empty actual &&
	git submodule update --init submodule &&
	git submodule summary HEAD^ >actual &&
	rev1=$(git -C sm rev-parse --short HEAD^) &&
	rev2=$(git -C sm rev-parse --short HEAD) &&
	cat >expect <<-EOF &&
	* submodule ${rev1}...${rev2} (1):
	  > add file2

	EOF
	test_cmp expect actual
'

test_expect_success 'submodule summary output for submodules with changed paths' '
	git mv submodule subm &&
	git commit -m "change submodule path" &&
	rev=$(git -C sm rev-parse --short HEAD^) &&
	git submodule summary HEAD^^ -- submodule >actual 2>&1 &&
	cat >expect <<-EOF &&
	fatal: exec '\''rev-parse'\'': cd to '\''submodule'\'' failed: No such file or directory
	* submodule ${rev}...0000000:

	EOF
	test_cmp expect actual
'

test_done
