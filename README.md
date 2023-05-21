# freebsd_test_example
Record how to write a test for FreeBSD. This example write a test for `pwd` command. The main reference of the step to write the test is from FreeBSD wiki [DeveloperHowTo](https://wiki.freebsd.org/TestSuite/DeveloperHowTo), [Structure](https://wiki.freebsd.org/TestSuite/Structure) and [TestingFreeBSDExamples](https://wiki.freebsd.org/TestingFreeBSDExamples).

The test use ATF and shell to write whcih ATF is FreeBSD recommend.

I also write a blog to introduct FreeBSD Test Suit with chinese. Here is the link - [FreeBSD Test Suit 介紹](https://cozy-kola.medium.com/freebsd-kernel-unit-test-e21be1ab2b3a).

# Folder introduction
usr/src/bin and /usr/src/etc is related to this pwd example. usr/src/usr.bin is just a referenct, it is related for `wc` test.

# Main step
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

# Testing case of pwd_test.sh
* Positive test
    * wd, pwd -L, pwd -P in a simple directory. -> testcase name, base
    * pwd, pwd -L, pwd -P in a directory with a soft link in tha path. -> testcase name, soft_link
* Negative test
  * pwd, pwd -L, pwd -P in a directory with broken soft link in tha path. -> testcase name, broken_soft_link