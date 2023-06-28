#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <limits.h>

int
main(void)
{   
    char current_path[PATH_MAX];
    char resolved_path[PATH_MAX];

    if (getcwd(current_path, sizeof(current_path)) == NULL)
        err(1, "%s", "getcwd error"); 
    else if (realpath(current_path, resolved_path) == NULL)
        err(1, "%s", "realpath error"); 

    printf("%s %s", current_path, resolved_path);
    return EXIT_SUCCESS;
}
