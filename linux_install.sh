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
    tree

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

# Remove some unnecessary packages
sudo apt remove -y chromium-browser
sudo apt autoremove