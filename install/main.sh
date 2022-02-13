#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

"./$(get_os)/main.sh"

./oh-my-zsh.sh
./npm.sh
./pip.sh
./vim.sh

cd ..
exec zsh -l