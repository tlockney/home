BASE_PACKAGES=$(cat <<EOF
    ansible
    awscli
    bash
    cmake
    coreutils
    curl
    emacs
    gcc
    gh
    git
    gnupg
    gzip
    htop
    hugo
    jq
    mosh
    nvm
    pandoc
    pipenv
    pipx
    pyenv
    tmux
    tree
    unzip
    wget
    zsh
    zsh-completions
EOF
)

CASK_PACKAGES=$(cat <<EOF
    1password 
    1password-cli
    alfred
    docker
    emacs
    font-fira-code
    google-chrome
    hazel
    istat-menus
    iterm2
    moom
EOF
)


# Check whether Homebrew is installed and install it if it's missing
which brew 2>&1 > /dev/null
if [ $? -eq 1 ]; then 
    echo "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew tap homebrew/core
brew tap homebrew/cask-fonts
brew tap homebrew/services
brew tap homebrew/cask
brew tap homebrew/cask-versions

brew install $BASE_PACKAGES || true
brew install --cask $CASK_PACKAGES || true
