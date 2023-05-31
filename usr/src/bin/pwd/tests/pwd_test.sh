#! /usr/libexec/atf-sh
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
    printf("%s %s", current_path, resolved_path);
    return 0;
}
EOF
    # Execute the compiled C program and capture the output into two variables
    # getcwd is pyhsical path
	# realpath is pyhsica path
	read -r getcwd realpath < <(./getcwd_prog)
    # https://stackoverflow.com/questions/2443085/what-does-command-args-mean-in-the-shell

    # Remove the compiled C program
    rm getcwd_prog

    # Return the three variables as an array
    local result=("$pwd_environment" "$getcwd" "$realpath")
    echo "${result[@]}"
}

atf_check_pwd() {
	local pwd_environment="$1" # logical
	local getcwd="$2" # pyhsical
	local realpath="$3" # pyhsical

	# pwd_="$(pwd)" # pyhsical
	# pwd_L="$(pwd -L)" # logical
	# pwd_P="$(pwd -P)" # pyhsical

	atf_check -o match:"${getcwd}" pwd
	# atf_check -o match:"$realpath" pwd

	# atf_check -o match:"$pwd_environment" pwd -L

	# atf_check -o match:"$getcwd" pwd -P
	# atf_check -o match:"$realpath" pwd -P
}

atf_test_case soft_link
soft_link_head()
{
	# Create a soft_link and enter it
	mkdir soft_link_src
	ln -s ./soft_link_src ./soft_link_dst
	cd ./soft_link_dst

	# Call the get_output function and capture the three variables
	output=($(get_output))

	# Access the individual variables
	pwd_environment="${output[0]}"
	getcwd="${output[1]}"
	realpath="${output[2]}"

	atf_check_pwd "$pwd_environment" "$getcwd" "$realpath"
}
soft_link_body()
{
	atf_check_pwd
}

atf_init_test_cases()
{
	atf_add_test_case soft_link
}
