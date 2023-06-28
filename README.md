# freebsd_test_example
Record how to write a test for FreeBSD. This example write a test for `pwd` command. The main reference of the step to write the test is from FreeBSD wiki [DeveloperHowTo](https://wiki.freebsd.org/TestSuite/DeveloperHowTo), [Structure](https://wiki.freebsd.org/TestSuite/Structure) and [TestingFreeBSDExamples](https://wiki.freebsd.org/TestingFreeBSDExamples).

The test use ATF and shell to write whcih ATF is FreeBSD recommend.

I also write a blog to introduct FreeBSD Test Suit with chinese. Here is the link - [FreeBSD Test Suit 介紹](https://cozy-kola.medium.com/freebsd-kernel-unit-test-e21be1ab2b3a).

# Folder introduction
The layout follows the FreeBSD layout. The usr/src/ put our `pwd` test case. The example put some existing code to give reference. For example, we can learn what to do if we want to use the C function in our test case. We need to write another C file to use, just like what `cp` test does in the example folder ...

In the example, I add my_summuary.md which does not exist in src code. This is what I summary about the tool.

# Main step to prepare environment
In the moment I write this test the `pwd` has no any test case (/usr/src/bin/pwd/tests folder is not exist). So we are adding a new test program.

1. Create an empty tests subdirecotyr (/usr/src/bin/pwd/tests).
2. Create the test program source file (/usr/src/bin/pwd/tests/pwd_test.sh)
3. Add the new test program to the existing Makefile (/usr/src/bin/pwd/Makefile). We add this code.
    ```
    HAS_TESTS=
    SUBDIR.${MK_TESTS}+= tests # `${MK_TESTS}` requires src.opts.mk or bsd.own.mk
    ```
    This code target is for build and install tests folder via MK_TESTS knob.
4. Create the Makefile for the directory (/usr/src/bin/pwd/tests/Makefile). Refer to share/examples/tests/ for Makefile sample code. This Makefile is for create the test program /usr/tests/bin/pwd/pwd_test.
5. Edit the parent Makefile to recurse into the new subdirectory. Because our tests case is just one layer under /usr/src/bin/pwd/, so we don't need to recurse into to new subdirectory. If you need to do this pls refer [root/share/examples/tests/Makefile](https://cgit.freebsd.org/src/tree/share/examples/tests/Makefile).
6. Edit etc/mtree/BSD.tests.dist to register the new subdirectory. Note that if you are adding tests to, say, usr.bin/du/tests/, the directory you register in the mtree file should be /usr/tests/usr.bin/du/; i.e. the layout under /usr/tests/ must match the layout of /usr/src. We add pwd directory under bin directory.

# Test the test program
After we finish the step in 'Main step to prepare environment' Chapter. We can start the test program itself (pwd_test.sh). Once we finish it, we need use kyua to run it to assure everything is good. So this chapter tell how to run the test with kyua.

This test example is much special, we don't have any tmp test case exist. So the /usr/tests/bin/pwd folder is not exist. We need create the folder first (The folder generate by etc/mtree/BST.tests.dist in actually system, this is just for test our test program). Then go to the /usr/src/bin/pwd/ to type below command
```
$ make obj
$ make depend
$ make all install 
```
The the test program will be generated on /usr/tests/bin/pwd/. We can see there is our test program, pwd_test (pwd_test: a /usr/libexec/atf-sh script, ASCII text executable) and Kyuafile. We cay type `kyua test` to run the test know and see the test result matrix generate by kyua.

# Testing case of pwd_test.sh
* Positive test
    * pwd, pwd -L, pwd -P in a simple directory. -> testcase name - basic.
    * pwd, pwd -L, pwd -P in a directory with a soft link in tha path. -> testcase name - soft_link
* Negative test
  * pwd, pwd -L, pwd -P in a directory with broken soft link in tha path. -> testcase name - broken_soft_link

We do the top test and check the ouput of the commadn is correct or not.