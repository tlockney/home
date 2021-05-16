# util functions

function get_download_url {
    wget -q -nv -O- https://api.github.com/repos/$1/$2/releases/latest 2>/dev/null |  jq -r '.assets[] | select(.browser_download_url | contains("linux64")) | .browser_download_url'
}

# Versions (where needed)
GO_VERSION=1.16.4

# Add necessary repositories

## vscode
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
rm packages.microsoft.gpg

## emacs PPA
sudo add-apt-repository -y ppa:kelleyk/emacs

# Update repos
sudo apt update
sudo apt full-upgrade -y

# Install essential packages
sudo apt install -y \
    software-properties-common \
    apt-transport-https \
    python3-pip \
    ssh \
    build-essential \
    curl \
    mosh \
    tmux \
    zsh \
    openjdk-11-jdk \
    htop \
    tree \
    libreadline-gplv2-dev \
    libncursesw5-dev \
    libssl-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev \
    jq

# Install Visual Studio Code
sudo apt install -y code

# Install Emacs 27  
sudo apt install -y emacs27

# Install latest Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb 
rm google-chrome-stable_current_amd64.deb

# Install pipx
python3 -m pip install --user pipx
python3 -m pipx ensurepath

# Install pyenv
if [ ! -d $HOME/.pyenv ]; then
    curl https://pyenv.run | bash
fi 

# Install Go
GO_PLATFORM=linux-amd64
GO_FILE=go$GO_VERSION.$GO_PLATFORM.tar.gz
wget https://storage.googleapis.com/golang/$GO_FILE
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.16.4.linux-amd64.tar.gz
rm $GO_FILE

# Install Processing
sudo mkdir -p /opt/Processing
pushd /opt/Processing
PROCESSING_DL=$(get_download_url processing processing)
PROCESSING_FILE=$(echo $PROCESSING_DL | cut -d'/' -f9)
sudo wget $PROCESSING_DL
PROCESSING_DIR=$(tar tzf processing-3.5.4-linux64.tgz | head -1 | sed -e 's@/.*@@')
sudo tar xzvf $PROCESSING_FILE
sudo rm $PROCESSING_FILE
sudo ln -sf $PROCESSING_DIR processing
popd
/opt/Processing/processing/install.sh 

# Remove some unnecessary packages
sudo apt remove -y chromium-browser
sudo apt autoremove