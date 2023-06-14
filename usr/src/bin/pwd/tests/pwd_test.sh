#! /usr/libexec/atf-sh
#
# Copyright (c) 2023 Klara, Inc.
#
# SPDX-License-Identifier: BSD-2-Clause
#

get_output() {
	# PWD environment variable which is logical path 
	pwd_environment="$PWD"
	read -r getcwd realpath < <(./get_path)
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
