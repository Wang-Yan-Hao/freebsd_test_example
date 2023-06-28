/*-
 * Copyright (c) 2023 Klara, Inc.
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include <err.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <sysexits.h>
#include <unistd.h>

static bool verbose;

/*
 * Returns true if the file named by its argument is sparse, i.e. if
 * seeking to SEEK_HOLE returns a different value than seeking to
 * SEEK_END.
 */
static bool
sparse(const char *filename)
{
	off_t hole, end; // off_t represent file offset
	int fd; // file descriptor

	if ((fd = open(filename, O_RDONLY)) < 0 ||
	    (hole = lseek(fd, 0, SEEK_HOLE)) < 0 || // Seek to the next hole in the file
	    (end = lseek(fd, 0, SEEK_END)) < 0) // Seek to the end of the file
		err(1, "%s", filename); // Print error message (filename) and return 1 
	close(fd);
	if (end > hole) { // If the end position is greater than the hole position, the file is sparse
		if (verbose)
			// convert off_t to size_t and use %zn to print size_t
			printf("%s: hole at %zu\n", filename, (size_t)hole); // Print the filename and the position of the hole
		return (true);
	}
	return (false);
}

// static func cannot be used in other source file. static functions are normally used to avoid name conflicts in bigger project
// https://stackoverflow.com/questions/41196027/what-is-the-difference-between-void-and-static-void-function-in-c
static void
usage(void)
{
	fprintf(stderr, "usage: sparse [-v] file [...]\n"); // Print the usage information to the standard error stream
	exit(EX_USAGE); // Exit with a usage error code, EX_USAGE (64)
}

int
main(int argc, char *argv[])
{
	int opt, rv;

	while ((opt = getopt(argc, argv, "v")) != -1) {
		switch (opt) {
		case 'v':
			verbose = true; // Set the verbose flag if the '-v' option is provided
			break;
		default:
			usage();
			break;
		}
	}
	argc -= optind; // Adjust the argument count and pointer to exclude processed options
	argv += optind;
	if (argc == 0)
		usage(); // If no files are provided, print usage information and exit
	rv = EXIT_SUCCESS; // Initialize the return value to success
	while (argc-- > 0)
		if (!sparse(*argv++))
			rv = EXIT_FAILURE; // If any file is not sparse, set the return value to failure
	exit(rv); // Exit with the appropriate return value
}
