get_output() {
	# PWD environment variable which is logical path 
	pwd_environment="$PWD"
	get_path_output="$("${0%/*}"/get_path)"
	echo "$pwd_environment $get_path_output"
}

atf_test_case basic
basic_head()
{
	atf_set "descr" "Basic test case"
}
basic_body()
{
	output="$(get_output)"
	echo "$output" | while IFS=" " read pwd_environment getcwd realpath; do
		atf_check -o inline:"${getcwd}\n" pwd
		atf_check -o inline:"${realpath}\n" pwd
		atf_check -o inline:"${pwd_environment}\n" pwd -L
		atf_check -o inline:"${getcwd}\n" pwd -P
		atf_check -o inline:"${realpath}\n" pwd -P
	done
}

atf_test_case soft_link
soft_link_head()
{
	atf_set "descr" "Test on the path which has softlink"
}
soft_link_body()
{
	# Create a soft_link and enter it
	mkdir soft_link_src
	ln -s soft_link_src soft_link_dst
	cd soft_link_dst || exit

	output="$(get_output)"
	echo "$output" | while IFS=" " read pwd_environment getcwd realpath; do
		atf_check -o inline:"${getcwd}\n" pwd
		atf_check -o inline:"${realpath}\n" pwd
		atf_check -o inline:"${pwd_environment}\n" pwd -L
		atf_check -o inline:"${getcwd}\n" pwd -P
		atf_check -o inline:"${realpath}\n" pwd -P
	done
}

atf_test_case broken_soft_link
broken_soft_link_head()
{
	atf_set "descr" "Test on the path which has broken softlink"
}
broken_soft_link_body()
{
	mkdir broken_soft_link_src
	ln -s broken_soft_link_src broken_soft_link_dst
    cd broken_soft_link_dst || exit
	rm -r ../broken_soft_link_src

	atf_check -s exit:1 -e inline:"pwd: .: No such file or directory\n" pwd
	atf_check -s exit:1 -e inline:"pwd: .: No such file or directory\n" pwd -L
	atf_check -s exit:1 -e inline:"pwd: .: No such file or directory\n" pwd -P
}

atf_init_test_cases()
{
	atf_add_test_case basic
	atf_add_test_case soft_link
	atf_add_test_case broken_soft_link
}
