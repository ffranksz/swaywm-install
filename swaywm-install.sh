#!/usr/bin/env bash

# |---------------------------------------------------------------------
# Franklin Souza (@ffranksz)
# swaywm-install.sh v1.0
# Revised with security, POSIX compatibility and clean code style.
# |---------------------------------------------------------------------

set -euo pipefail

msg() {
    printf "\033[1;32m[OK]\033[0m %s\n" "$1"
}

err() {
    printf "\033[1;31m[ERROR]\033[0m %s\n" "$1" >&2
}

# -------------| Folder Create
folders() {

    mkdir -p "$HOME"/{Franks,Scripts,.dotfiles,.projects,.local/bin}
    mkdir -p "$HOME/.config"/{sway,nvim,wofi,waybar,kitty,dunst}

    mkdir -p "$HOME/.config/nvim"/{lua,core,plugins,utils}
    mkdir -p "$HOME/.config/wofi/scripts"
    mkdir -p "$HOME/.config/waybar/scripts"

    msg "Folders created."
}

# -------------| Package Install
packageInstall() {

    sudo pacman -Syu

    sudo pacman -S \
      archlinux-keyring rustup git wget fzf firefox-i18n-pt-br \
      bitwarden gucharmap mpv wofi waybar sway wayland xorg-xwayland \
      pipewire pipewire-alsa pipewire-pulse \
      ttf-fira-code ttf-jetbrains-mono-nerd ttf-dejavu \
      zsh zsh-autosuggestions zsh-syntax-highlighting \
      grim slurp wine-staging lib32-mangohud mangohud \
      xf86-video-amdgpu kitty xdg-user-dirs python-pywal jq npm yarn \
      neovim dunst libnotify fuse pacman-contrib reflector \

    rustup default stable
    xdg-user-dirs-update

    msg "Packages installed."
}

# -------------| Git Clone
gitclone() {

    cd "$HOME/.dotfiles" || exit

    if [ ! -d "dotfiles" ]; then
        git clone https://github.com/ffranksz/dotfiles.git
    else
        msg "Dotfiles already cloned, skipping."
    fi

    msg "Git clone completed."
}

# -------------| Copy Files
copyfiles() {

    cp "$HOME/.dotfiles/dotfiles/.config/dunst/dunstrc"              "$HOME/.config/dunst"
    cp "$HOME/.dotfiles/dotfiles/.config/dunst/launchdunst.sh"       "$HOME/.config/dunst"

    cp "$HOME/.dotfiles/dotfiles/.config/kitty/"*.conf               "$HOME/.config/kitty"

    cp "$HOME/.dotfiles/dotfiles/.config/nvim/coc-settings.json"     "$HOME/.config/nvim"
    cp "$HOME/.dotfiles/dotfiles/.config/nvim/init.lua"              "$HOME/.config/nvim"

    cp "$HOME/.dotfiles/dotfiles/.config/sway/config"                "$HOME/.config/sway"
    cp "$HOME/.dotfiles/dotfiles/.config/waybar/"{config.jsonc,style.css} "$HOME/.config/waybar"

    cp "$HOME/.dotfiles/dotfiles/.config/wofi/"{config,config.drun,style.css} "$HOME/.config/wofi"

    cp -r "$HOME/.dotfiles/dotfiles/scripts"                         "$HOME/Scripts"
    cp -r "$HOME/.dotfiles/dotfiles/.config/nvim/lua"                "$HOME/.config/nvim"
    cp -r "$HOME/.dotfiles/dotfiles/.config/sway/config.d"           "$HOME/.config/sway"
    cp -r "$HOME/.dotfiles/dotfiles/.config/waybar/scripts"          "$HOME/.config/waybar"

    cp -r "$HOME/.dotfiles/dotfiles/bin/."                           "$HOME/.local/bin"

    msg "Files copied."
}

# -------------| Set Permissions
permissions() {

    chmod +x "$HOME"/.local/bin/*
    chmod +x "$HOME"/Scripts/*
    chmod +x "$HOME/.config/dunst/launchdunst.sh"
    chmod +x "$HOME/.config/waybar/scripts"/*

    msg "Permissions updated."
}

# -------------| Vim-Plug Install
vimpluginstall() {

    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim \
        --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    msg "Vim-Plug installed."
}

# -------------| Run Script
folders
packageInstall
gitclone
copyfiles
permissions
vimpluginstall

msg "Installation completed successfully!"
