
.include <src.opts.mk>

PACKAGE=	tests

TESTSDIR=	${TESTSBASE}/sys/geom/class

TESTS_SUBDIRS+=	concat
.if ${MK_OPENSSL} != "no"  # If OpenSSL library be included and linked in the build process
TESTS_SUBDIRS+=	eli
.endif
TESTS_SUBDIRS+=	gate
TESTS_SUBDIRS+=	mirror
TESTS_SUBDIRS+=	multipath
TESTS_SUBDIRS+=	nop
TESTS_SUBDIRS+=	part
TESTS_SUBDIRS+=	raid3
TESTS_SUBDIRS+=	shsec
TESTS_SUBDIRS+=	stripe
TESTS_SUBDIRS+=	uzip

${PACKAGE}FILES+=	geom_subr.sh  # Shared functions in all geom class

.include <bsd.test.mk>