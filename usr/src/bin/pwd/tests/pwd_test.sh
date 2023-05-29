#
# Copyright (c) 2023 Klara, Inc.
#
# SPDX-License-Identifier: BSD-2-Clause
#

get_output() {
	# PWD environment variable which is logical path 
	pwd_environment="$PWD"
    # Compile the C program with the getcwd function
    gcc -o getcwd_prog -xc - <<EOF
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <limits.h>

int main() {
    char current_path[PATH_MAX];
    if (getcwd(current_path, sizeof(current_path)) == NULL) {
        perror("getcwd error");
        return 1;
    }
    char* resolved_path = realpath(current_path, NULL);
    if (resolved_path == NULL) {
        perror("realpath error");
        return 1;
    }
    printf("%s\n%s\n", current_path, resolved_path);
    free(current_path);
    free(resolved_path);
    return 0;
}
EOF
    # Execute the compiled C program and capture the output into two variables
    # getcwd is pyhsical path
	# realpath is pyhsica path
	read -r getcwd realpath < <(./getcwd_prog)

    # Remove the compiled C program
    rm getcwd_prog

    # Return the three variables as an array
    local result=("$pwd_environment" "$getcwd" "$realpath")
    echo "${result[@]}"
}

atf_check_pwd() {
	local pwd_environment="$1" # logical
	local getcwd="$2" # pyhsical
	local realpath="$2" # pyhsical

	pwd="$(pwd)" # pyhsical
	pwd_L="$(pwd -L)" # logical
	pwd_P="$(pwd -P)" # pyhsical

    atf_check_equal pwd getcwd
	atf_check_equal pwd realpath

    atf_check_equal pwd_L pwd_environment

	atf_check_equal pwd_P getcwd
	atf_check_equal pwd_P realpath
}

atf_test_case basic
basic_head()
{
	atf_set "descr" "Basic test case"
}
basic_body()
{
	# Call the get_output function and capture the three variables
	output=($(get_output))

	# Access the individual variables
	pwd_environment="${output[0]}"
	getcwd="${output[1]}"
	realpath="${output[2]}"

	atf_check_pwd pwd_environment getcwd realpath
}

atf_test_case soft_link
soft_link_head()
{
	# Create a soft_link

	# Call the get_output function and capture the three variables
	output=($(get_output))

	# Access the individual variables
	pwd_environment="${output[0]}"
	getcwd="${output[1]}"
	realpath="${output[2]}"

	atf_check_pwd pwd_environment getcwd realpath
}
soft_link_body()
{
	atf_check_pwd
}

atf_test_case broken_soft_link
broken_soft_link_head()
{
	atf_set "descr" "Test on the path which has broken softlink"
}
broken_soft_link_body()
{
	# Create a broken_soft_link

	# Call the get_output function and capture the three variables
	output=($(get_output))

	# Access the individual variables
	pwd_environment="${output[0]}"
	getcwd="${output[1]}"
	realpath="${output[2]}"

	atf_check_pwd pwd_environment getcwd realpath
}


atf_init_test_cases()
{
	atf_add_test_case basic
	atf_add_test_case soft_link
	atf_add_test_case broken_soft_link
}
