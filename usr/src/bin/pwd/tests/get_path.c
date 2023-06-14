#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <limits.h>

int main(int argc, char *argv[]) {
    char current_path[PATH_MAX];

    if (getcwd(current_path, sizeof(current_path)) == NULL) {
        perror("getcwd error");
        return 1;
    }
    char resolved_path[PATH_MAX];
    if (realpath(current_path, resolved_path) == NULL) {
        perror("realpath error");
        return 1;
    }
    printf("%s\n%s\n", current_path, resolved_path);
    return 0;
}
