copy_fixture "first_file.txt"
copy_fixture "level1/level2/second_file.txt"
copy_fixture "replaced_file.txt"

run "echo 'third' > third_file.txt"