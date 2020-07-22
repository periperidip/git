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
