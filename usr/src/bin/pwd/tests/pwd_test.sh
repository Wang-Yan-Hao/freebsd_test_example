#
# Copyright (c) 2023 Klara, Inc.
#
# SPDX-License-Identifier: BSD-2-Clause
#


#
# Run a series of tests using the same input file.  The first argument
# is the name of the file.  The next three are the expected line,
# word, and byte counts.  The optional fifth is the expected character
# count; if not provided, it is expected to be identical to the byte
# count.
#
atf_check_pwd() {
	atf_check -o match:"^\/[a-zA-Z0-9_\-\/\.]+\n?$" pwd # pwd
}
atf_test_case basic
basic_head()
{
	atf_set "Basic test case"
}
basic_body()
{
	atf_check_pwd
}


atf_init_test_cases()
{
	atf_add_test_case basic
}
