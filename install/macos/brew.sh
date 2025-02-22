# Install Homebrew

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update
brew upgrade

# Install packages
apps=(
    cmake
    coreutils
    findutils
    git
    go
    node
    python
    ruby
    svn
    wget
    zsh
    htop
    ack
    tree
)

brew install "${apps[@]}"

caskapps=(
    alfred
    iterm2
    sogouinput
    google-chrome
    macvim
    visual-studio-code
    tencent-lemon
    keepassx
    shadowsocksx-ng
    kindle
    pomotodo
    wechat
    qq
    qqmusic
    jietu
    thunder
    iina

    # dropbox

    ### for android develop
    # android-studio
    # pycharm-ce
)

# brew install --cask "${caskapps[@]}"

brew cleanup

# open /Applications/Alfred*.app