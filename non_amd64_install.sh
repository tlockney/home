sudo apt update
sudo apt install -y build-essential curl emacs mosh tmux zsh

# Install pipx
python3 -m pip install --user pipx
python3 -m pipx ensurepath

# Install pyenv
if [ ! -d $HOME/.pyenv ]; then
    curl https://pyenv.run | bash
fi
