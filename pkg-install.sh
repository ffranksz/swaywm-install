#!/usr/bin/env bash

# Franklin Souza
# @ffranksz

# ---------------| Package Install
pkgInstall(){

  sudo pacman -S wayland \
    xorg-xwayland \
    pipewire \
    pipewire-pulse \
    pipewire-alsa \
    kitty \
    git \
    sway \
    --noconfirm
}

pkgInstall
