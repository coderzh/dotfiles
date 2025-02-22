#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh" \
    && . "../setup.conf"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n • Pip\n\n"

    if [ ! -f $HOME/.venv/bin/activate ]; then
        echo "install venv..."
        mkdir ~/.venv
        python3 -m venv ~/.venv
    fi
    source ~/.venv/bin/activate

    for i in "${PIP_PACKAGES[@]}"; do
        execute \
            "python3 -m pip install $i" \
            "install $i"
    done

    deactivate

}

main


