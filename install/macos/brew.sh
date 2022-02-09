# Install Homebrew

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew tap homebrew/versions
brew update
brew upgrade

# Install packages
apps=(
    cmake
    coreutils
    findutils
    git
    gnu-sed --with-default-names
    go
    hugo
    python
    ruby
    svn
    vim
    wget
    zsh
    htop
    ack
    tree
)

brew install "${apps[@]}"
brew cleanup

caskapps=(
    android-studio
    alfred
    atom
    cheatsheet
    dash
    genymotion
    google-chrome
    intellij-idea-ce
    iterm2
    java
    karabiner
    keepassx
    kindle
    pomotodo
    pycharm-ce
    qq
    qqmusic
    qqmacmgr
    sogouinput
    thunder
    vagrant
    virtualbox
    vlc
    youdao
)

# brew tap caskroom/versions
# brew cask update
# brew cask install --appdir="/Applications" "${caskapps[@]}"
# brew cask cleanup

