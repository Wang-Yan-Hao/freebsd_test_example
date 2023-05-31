get_output() {
	# PWD environment variable which is logical path 
	pwd_environment="$PWD"
    # Compile the C program with the getcwd function
    gcc -o getcwd_prog -xc - <<EOF
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <limits.h>

int main() {
    char current_path[PATH_MAX];
    if (getcwd(current_path, sizeof(current_path)) == NULL) {
        perror("getcwd error");
        return 1;
    }
    char* resolved_path = realpath(current_path, NULL);
    if (resolved_path == NULL) {
        perror("realpath error");
        return 1;
    }
    printf("%s %s", current_path, resolved_path);
    return 0;
}
EOF
    # Execute the compiled C program and capture the output into two variables
    # getcwd is pyhsical path
	# realpath is pyhsica path
	read -r getcwd realpath < <(./getcwd_prog)
    # https://stackoverflow.com/questions/2443085/what-does-command-args-mean-in-the-shell
    
    # Remove the compiled C program
    rm getcwd_prog

    # Return the three variables as an array
    local result=("$pwd_environment" "$getcwd" "$realpath")
    echo "${result[@]}"
}


# Call the get_output function and capture the three variables
output=($(get_output))

# Access the individual variables
pwd_environment="${output[0]}"
getcwd="${output[1]}"
realpath="${output[2]}"

echo "$pwd_environment"
echo "$getcwd"
echo "$realpath"