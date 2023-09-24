atf_test_case basic
basic_head()
{
	atf_set "descr" "Test on common directory"
}
basic_body()
{
	mkdir directory
	cd directory || exit
	atf_check -o match:"^.*\/directory$" pwd
	atf_check -o match:"^.*\/directory$" pwd -L
	atf_check -o match:"^.*\/directory$" pwd -P
}

atf_test_case soft_link
soft_link_head()
{
	atf_set "descr" "Test on the softlink directory"
}
soft_link_body()
{
	mkdir soft_link_src
	ln -s soft_link_src soft_link_dst
	cd soft_link_dst || exit
	atf_check -o match:"^.*\/soft_link_src$" pwd
	atf_check -o match:"^.*\/soft_link_dst$" pwd -L
	atf_check -o match:"^.*\/soft_link_src$" pwd -P
}

atf_test_case broken_soft_link
broken_soft_link_head()
{
	atf_set "descr" "Test on the broken softlink directory"
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