#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../setup.conf" \
    && . "../../utils.sh" \

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n • Setup MacOS\n\n"
./osx.sh

print_in_purple "\n • Copy MacOS fils\n\n"
copy_files_to_home "${MACOS_FILES_COPY_TO_HOME[@]}"

print_in_purple "\n • Brew\n\n"
./brew.sh

# print_in_purple "\n • Atom\n\n"
# ./apm.sh

