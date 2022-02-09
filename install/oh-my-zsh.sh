#/!bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

main() {

    print_in_purple "\n • Oh-My-Zsh\n\n"

    execute \
        "sudo chsh -s $(which zsh)" \
        "Set zsh as default"

    if [ ! -d $HOME/.oh-my-zsh ]; then

        execute \
            "sh -c \"$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\"" \
            "Install oh-my-zsh"
      
    fi
}


main
