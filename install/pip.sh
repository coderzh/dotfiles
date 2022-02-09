#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh" \
    && . "../setup.conf"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n • Pip\n\n"

    for i in "${PIP_PACKAGES[@]}"; do
        execute \
            "python3 -m pip install $i" \
            "install $i"
    done

}

main


