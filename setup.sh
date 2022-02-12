#!/bin/bash

# Get current dir (so run this script from anywhere)
# export DOTFILES_DIR
# DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# # Update dotfiles itself first
# [ -d "$DOTFILES_DIR/.git" ] && git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master

# # Package managers & packages
# . "$DOTFILES_DIR/install/brew.sh"
# . "$DOTFILES_DIR/install/pip.sh"
# . "$DOTFILES_DIR/install/vundle.sh"

# # Install fonts
# cp -r $DOTFILES_DIR/fonts/* ~/Library/Fonts/

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "./utils.sh"

declare -r GITHUB_REPOSITORY="coderzh/dotfiles"

declare -r DOTFILES_ORIGIN="git@github.com:$GITHUB_REPOSITORY.git"
declare -r DOTFILES_TARBALL_URL="https://github.com/$GITHUB_REPOSITORY/tarball/master"
declare -r DOTFILES_UTILS_URL="https://raw.githubusercontent.com/$GITHUB_REPOSITORY/master/utils.sh"
declare -r DOTFILES_CONFIG_URL="https://raw.githubusercontent.com/$GITHUB_REPOSITORY/master/setup.conf"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare skipQuestions=false

download_dotfiles() {

    local tmpFile=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_in_purple "\n • Download and extract archive\n\n"

    tmpFile="$(mktemp /tmp/XXXXX)"

    download "$DOTFILES_TARBALL_URL" "$tmpFile"
    print_result $? "Download archive" "true"
    printf "\n"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if ! $skipQuestions; then

        ask_for_confirmation "Do you want to store the dotfiles in '$dotfilesDirectory'?"

        if ! answer_is_yes; then
            dotfilesDirectory=""
            while [ -z "$dotfilesDirectory" ]; do
                ask "Please specify another location for the dotfiles (path): "
                dotfilesDirectory="$(get_answer)"
            done
        fi

        # Ensure the `dotfiles` directory is available

        while [ -e "$dotfilesDirectory" ]; do
            ask_for_confirmation "'$dotfilesDirectory' already exists, do you want to overwrite it?"
            if answer_is_yes; then
                rm -rf "$dotfilesDirectory"
                break
            else
                dotfilesDirectory=""
                while [ -z "$dotfilesDirectory" ]; do
                    ask "Please specify another location for the dotfiles (path): "
                    dotfilesDirectory="$(get_answer)"
                done
            fi
        done

        printf "\n"

    else

        rm -rf "$dotfilesDirectory" &> /dev/null

    fi

    mkdir -p "$dotfilesDirectory"
    print_result $? "Create '$dotfilesDirectory'" "true"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Extract archive in the `dotfiles` directory.

    extract "$tmpFile" "$dotfilesDirectory"
    print_result $? "Extract archive" "true"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    rm -rf "$tmpFile"
    print_result $? "Remove archive"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    cd "$dotfilesDirectory/src/os" \
        || return 1

}

extract() {

    local archive="$1"
    local outputDir="$2"

    if command -v "tar" &> /dev/null; then
        tar -zxf "$archive" --strip-components 1 -C "$outputDir"
        return $?
    fi

    return 1

}

verify_os() {

    declare -r MINIMUM_MACOS_VERSION="10.10"
    declare -r MINIMUM_UBUNTU_VERSION="14.04"

    local os_name=""
    local os_version=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if the OS is `macOS` and
    # it's above the required version.

    os_name="$(uname -s)"

    if [ "$os_name" == "Darwin" ]; then

        os_version="$(sw_vers -productVersion)"

        if is_supported_version "$os_version" "$MINIMUM_MACOS_VERSION"; then
            return 0
        else
            printf "Sorry, this script is intended only for macOS %s+" "$MINIMUM_MACOS_VERSION"
        fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if the OS is `Ubuntu` and
    # it's above the required version.

    elif [ "$os_name" == "Linux" ] && [ -e "/etc/lsb-release" ]; then

        os_version="$(lsb_release -d | cut -f2 | cut -d' ' -f2)"

        if is_supported_version "$os_version" "$MINIMUM_UBUNTU_VERSION"; then
            return 0
        else
            printf "Sorry, this script is intended only for Ubuntu %s+" "$MINIMUM_UBUNTU_VERSION"
        fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    else
        printf "Sorry, this script is intended only for macOS and Ubuntu!"
    fi

    return 1

}


main() {
    # 进入该脚本目录
    cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

    # 如果 utils.sh 存在且可执行
    if [ -x "utils.sh" ]; then
        . "utils.sh" || exit 1
    else
        download_and_execute_file ${DOTFILES_UTILS_URL} || exit 1
    fi

    if [ -x "setup.conf" ]; then
        . "setup.conf" || exit 1
    else
        download_and_execute_file ${DOTFILES_CONFIG_URL} || exit 1
    fi

    verify_os || exit 1

    skip_questions "$@" && skipQuestions=true

    ask_for_sudo

    # 如果不是执行本地的setup.sh脚本，则下载dotfiles。
    printf "%s" "${BASH_SOURCE[0]}" | grep "setup.sh" &> /dev/null \
        || download_dotfiles

    print_in_purple "\n • Create directories\n\n"
    create_directories ${DIRECTORIES[@]}

    print_in_purple "\n • Create symbolic links\n\n"
    create_symlinks $skipQuestions ${FILES_TO_SYMLINK[@]} 

    print_in_purple "\n • Copy files\n\n"
    copy_os_files

    print_in_purple "\n • Execute commands\n\n"
    execute_commands "${COMMANDS[@]}"

    ./install/main.sh
}

# $@ 为 shell 脚本参数
main "$@"
