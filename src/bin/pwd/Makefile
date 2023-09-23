#	@(#)Makefile	8.1 (Berkeley) 5/31/93
# $FreeBSD$
.include <src.opts.mk>

HAS_TESTS= # Add this, mean pwd has test
SUBDIR.${MK_TESTS}+= tests # Add this, for build tests folder.

PACKAGE=runtime
PROG=	pwd

# Add this, src.opts.mk is a makefile that allows users to customize the build options for the FreeBSD kernel and world.
# .include will insert the src.opts.mk content
# http://web.mit.edu/freebsd/head/share/mk/src.opts.mk
.include <bsd.prog.mk>
