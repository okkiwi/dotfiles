#!/usr/bin/env bash

# packages
apps="git tmux podman keepassxc"
utils="ripgrep fd-find curl wget jq build-essential"
sudo apt-get install -y $apps $utils

# dotfiles
mkdir -p ~/.config/nvim && cp init.lua ~/.config/nvim
mkdir -p ~/.config/tmux && cp tmux.conf ~/.config/tmux

# config
echo 'export EDITOR=nvim VISUAL=nvim' >> ~/.bashrc
sudo ln -s $(which fdfind) /usr/local/bin/fd

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# nodejs & npm packages
nvm install v22.11.0
npm i -g npm@latest
npm i -g typescript typescript-language-server vscode-langservers-extracted
npm i -g http-server prettier @johnnymorganz/stylua-bin

# nvim
wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
tar xzf nvim-linux64.tar.gz
rm nvim-linux64.tar.gz
sudo mv nvim-linux64 /var/opt/nvim
sudo ln -s /var/opt/nvim/bin/nvim /usr/local/bin/nvim
nvim +qall

# git
git config --global user.name "okkiwi"
git config --global user.email "okkiwi@tuta.io"
ssh-keygen -t ed25519 -C "okkiwi@tuta.io" -f ~/.ssh/id_ed25519
