#
# Install stuff on Linux
# 
# TODO: move ALL of this to Ansible!!

# util functions

function startsudo() {
    sudo -v
    ( while true; do sudo -v; sleep 50; done; ) &
    SUDO_PID="$!"
    trap stopsudo SIGINT SIGTERM
}
function stopsudo() {
    kill "$SUDO_PID"
    trap - SIGINT SIGTERM
    sudo -k
}

function get_download_url {
    wget -q -nv -O- https://api.github.com/repos/$1/$2/releases/latest 2>/dev/null |  jq -r '.assets[] | select(.browser_download_url | contains("linux64")) | .browser_download_url'
}

startsudo

# Versions (where needed)
GO_VERSION=1.16.4

# Add necessary repositories

## vscode
if [[ ! -f /etc/apt/sources.list.d/vscode.list ]]; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    rm packages.microsoft.gpg
fi

## emacs PPA
sudo add-apt-repository -y ppa:kelleyk/emacs

# 1password
 curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
 echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 beta main' | sudo tee /etc/apt/sources.list.d/1password.list
 sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
 curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
 sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
 curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

 # Dropbox
 sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E
 echo 'deb [arch=i386,amd64] http://linux.dropbox.com/ubuntu disco main' | sudo tee /etc/apt/sources.list.d/dropbox.list

# Update repos
sudo apt update

# Upgrade anything that's ready to be upgraded
sudo apt full-upgrade -y

# Install essential development packages
sudo apt install \
    build-essential \
    python3-dev \
    python3-setuptools \
    python3-pip \
    python3-smbus \
    libncursesw5-dev \
    libgdbm-dev \
    libc6-dev \
    zlib1g-dev \
    libsqlite3-dev \
    tk-dev \
    libssl-dev \
    openssl \
    libffi-dev \
    libreadline-gplv2-dev \
    libbz2-dev

# Install essential packages
sudo apt install -y \
    software-properties-common \
    apt-transport-https \
    ssh \
    curl \
    mosh \
    tmux \
    zsh \
    openjdk-11-jdk \
    htop \
    tree \
    jq \
    libgranite5 \
    1password

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

# Install Signal
if [[ ! -f /etc/apt/sources.list.d/signal-xenial.list ]]; then
    wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
    cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
    sudo tee -a /etc/apt/sources.list.d/signal-xenial.list

    sudo apt update && sudo apt install signal-desktop
fi

# Install Slack
SLACK_PACKAGE=slack-desktop-4.15.0-amd64.deb
wget -O $SLACK_PACKAGE https://downloads.slack-edge.com/linux_releases/$SLACK_PACKAGE
sudo dpkg -i $SLACK_PACKAGE
rm $SLACK_PACKAGE

# Install Dropbox
DROPBOX_PACKAGE=dropbox_2020.03.04_amd64.deb
wget -O $DROPBOX_PACKAGE https://www.dropbox.com/download\?dl=packages/ubuntu/$DROPBOX_PACKAGE
sudo dpkg -i $DROPBOX_PACKAGE
rm $DROPBOX_PACKAGE

# Install Cascadia Code font
CASCADIA_CODE_PACKAGE=CascadiaCode-2102.25.zip
wget -O $CASCADIA_CODE_PACKAGE https://github.com/microsoft/cascadia-code/releases/download/v2102.25/$CASCADIA_CODE_PACKAGE
mkdir fonts; pushd fonts
unzip ../$CASCADIA_CODE_PACKAGE
sudo mkdir -p /usr/share/fonts/truetype/cascadia
sudo cp ttf/*.ttf /usr/share/fonts/truetype/cascadia
popd
rm -rf fonts
rm -rf $CASCADIA_CODE_PACKAGE

# Install Tailscale
if [[ ! -f /etc/apt/sources.list.d/tailscale.list ]]; then
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/bionic.gpg | sudo apt-key add -
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/bionic.list | sudo tee /etc/apt/sources.list.d/tailscale.list
    sudo apt-get update
    sudo apt-get install tailscale
    sudo tailscale up
fi

# Remove some unnecessary packages
sudo apt remove -y chromium-browser
sudo apt autoremove

stopsudo