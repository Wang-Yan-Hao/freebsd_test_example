
# A variable that represents the list of directories that make will search	for files.  The	search list should  be updated	using the target `.PATH' rather	than the variable.
.PATH: ${SRCTOP}/sys/geom/eli ${SRCTOP}/sys/crypto/sha2

PACKAGE=	tests

# This line sets the warning level for the C compiler to 3, which indicates a relatively high level of warnings?
WARNS?=		3

# ${.CURDIR:T} to extract the last component of the current directory, which in this case is the name of the current directory (eli).
TESTSDIR=	${TESTSBASE}/sys/geom/class/${.CURDIR:T}

ATF_TESTS_C=	pbkdf2_test
ATF_TESTS_SH+=	attach_test
ATF_TESTS_SH+=	configure_test
ATF_TESTS_SH+=	delkey_test
ATF_TESTS_SH+=	detach_test
ATF_TESTS_SH+=	init_test
ATF_TESTS_SH+=	integrity_test
ATF_TESTS_SH+=	kill_test
ATF_TESTS_SH+=	misc_test
ATF_TESTS_SH+=	onetime_test
ATF_TESTS_SH+=	online_resize_test
ATF_TESTS_SH+=	reentrancy_test
ATF_TESTS_SH+=	resize_test
ATF_TESTS_SH+=	setkey_test

# This line adds the conf.sh file to the list of files associated with this test package.
${PACKAGE}FILES+=		conf.sh

# These lines specify build-related information for the pbkdf2_test program, including compiler flags, source files, and library dependencies.
# -I flag is used to specify an additional directory where the compiler should look for header files.
CFLAGS.pbkdf2_test=	-I${SRCTOP}/sys

# This line specifies the source code files (C source files) that should be compiled to create the pbkdf2_test program.
SRCS.pbkdf2_test=	\
		hmac_test.c \
		g_eli_crypto.c \
		g_eli_hmac.c \
		pkcs5v2.c \
		sha512c.c \
		sha256c.c

# This line specifies the libraries that should be linked with the pbkdf2_test program.
LIBADD.pbkdf2_test= crypto

# These lines indicate that an additional program called unaligned_io should be built,
# and it should be placed in the same directory where the tests are located 
PROGS+= unaligned_io
BINDIR?= ${TESTSDIR}

# This appears to be a target for generating a test vector header file using a Python script (gentestvect.py).
# The header file is generated when the testvect.h target is invoked.
testvect.h:
	python gentestvect.py > ${.TARGET}

.include <bsd.test.mk>