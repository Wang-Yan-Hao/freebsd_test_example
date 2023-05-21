/*-
 * SPDX-License-Identifier: BSD-3-Clause
 *
 * Copyright (c) 1991, 1993, 1994
 *	The Regents of the University of California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

/* 
 * https://blog.csdn.net/freeWayWalker/article/details/50035923 
 * https://forums.freebsd.org/threads/ifndef-lint-in-src-code.32483/ 
 * 條件編譯，由編譯器先預處理
 * It's to compile the copyright string into the binary, #ifndef lint is there to avoid lint() warnings about the constant not being used.
 */

#if 0
#ifndef lint
static char const copyright[] =
"@(#) Copyright (c) 1991, 1993, 1994\n\
	The Regents of the University of California.  All rights reserved.\n";
#endif /* not lint */

#ifndef lint
static char sccsid[] = "@(#)pwd.c	8.3 (Berkeley) 4/1/94";
#endif /* not lint */
#endif
#include <sys/cdefs.h>
__FBSDID("$FreeBSD$");
// __FBSDID("$FreeBSD$"); is a special macro used in FreeBSD operating system source code to indicate the revision number and copyright information of a file.
// https://man.freebsd.org/cgi/man.cgi?query=style&sektion=9

#include <sys/param.h>
#include <sys/stat.h>
#include <sys/types.h>

#include <err.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

static char *getcwd_logical(void);
void usage(void);

/* 
 * pwd 有兩個 option
 * -L	Display the logical current working directory.
 * -P	Display the physical current working directory (all symbolic links resolved).
 */
int
main(int argc, char *argv[])
{
	int physical;
	int ch;
	char *p;

	physical = 1; // flag, 預設為 1 代表使用 physical 位置 (-P)
	while ((ch = getopt(argc, argv, "LP")) != -1) // unistd.h, getopt()，用法參考 https://blog.csdn.net/Mculover666/article/details/106646339
		switch (ch) {
		case 'L':
			physical = 0;
			break;
		case 'P':
			physical = 1;
			break;
		case '?':
		default: // default 回傳錯誤訊息
			usage();
		}

	// extern int optind 紀錄下一個檢索位置
	argc -= optind;
	argv += optind;

	if (argc != 0) // 如果 argc 數量不等於 0，代表還有參數，回傳錯誤訊息
		usage();

	/*
	 * If we're trying to find the logical current directory and that
	 * fails, behave as if -P was specified.
	 */
	if ((!physical && (p = getcwd_logical()) != NULL) || // 如果 !physical, 那就獲得 logical 位置
	    (p = getcwd(NULL, 0)) != NULL) // 如果 pyhsical, 那就使用 getcwd 函數 https://blog.csdn.net/nyist_yangguang/article/details/106311489
		printf("%s\n", p);
	else
		err(1, "."); // https://linux.die.net/man/3/err

	exit(0);
}

void __dead2 // no return, https://ithelp.ithome.com.tw/articles/10273976
usage(void)
{
	(void)fprintf(stderr, "usage: pwd [-L | -P]\n");
  	exit(1);
}

static char *
getcwd_logical(void) // 檢查 $PWD 環境變數，獲得 logical 位置。
{
	struct stat lg, phy; // struct stat: file attribute, https://man7.org/linux/man-pages/man2/stat.2.html
	char *pwd;

	/*
	 * Check that $PWD is an absolute logical pathname referring to
	 * the current working directory.
	 */
	if ((pwd = getenv("PWD")) != NULL && *pwd == '/') { // 檢查是否為 NULL，並且 pwd 要從 / 開始
		if (stat(pwd, &lg) == -1 || stat(".", &phy) == -1) // get file attribute by logical path and physical path
			return (NULL);
		if (lg.st_dev == phy.st_dev && lg.st_ino == phy.st_ino) // check device number and inode number, https://stackoverflow.com/questions/47078477/what-is-the-device-of-inode
			return (pwd);
	}
	// 常 errno 數是針對各種錯誤狀況指派給 errno 的值。https://learn.microsoft.com/zh-tw/cpp/c-runtime-library/errno-constants?view=msvc-170
	errno = ENOENT; // Error NO ENTity, https://stackoverflow.com/questions/19902828/why-does-enoent-mean-no-such-file-or-directory
	return (NULL);
}
