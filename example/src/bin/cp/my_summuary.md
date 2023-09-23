# CP

## src code


## test
1. basic: cp a file and check it's size (use `stat`).
2. basic_symlink: create a softlink, use cp to copy softlink, but the genebasic_symlinkrated file should not a softlink. Also attemp to copy same file to check the error message.
3. chrdev: cp null device and check it's size is 0.
4. matching_srctgt:  test cp -R
5. matching_srctgt_contained: test cp -R + recursively
6. matching_srctgt_link: test cp -RH
7. matching_srctgt_nonexistent: copyto a nonexistent subdirectory
8. ...