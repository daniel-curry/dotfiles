#!/bin/bash

echo "WARNING: this script will permanently erase the current config directories for the following programs:"

directories=()
for dir in "$HOME/dotfiles"/*/; do 
    name=$(basename "$dir")
    [ "$name" = "Wallpapers" ] && continue
    directories+=("$name")
done

printf "%s\n" "${directories[@]}"

read -p "Are you sure you want to proceed? (y/n)? " user_confirmation
sudo -v

if [[ "$user_confirmation" == "n" || "$user_confirmation" == "N" ]]; then
    exit 1
elif [[ "$user_confirmation" == "y" || "$user_confirmation" == "Y" ]]; then
    for value in "${directories[@]}"; do
        rm -rf "$HOME/.config/$value"
        ln -s "$HOME/dotfiles/$value" "$HOME/.config/$value"
        if [ "$value" = "zsh" ]; then
            rm "$HOME/.zshrc"
            ln -s "$HOME/dotfiles/zsh/.zshrc" "$HOME/.zshrc"
        fi

        if [ "$value" = "keyd" ]; then
            sudo rm -rf "/etc/keyd"
            sudo mkdir -p "/etc/keyd/"
            sudo ln -s "$HOME/dotfiles/keyd/default.conf" "/etc/keyd/default.conf"
        fi
    done
else
    echo "Invalid input. Please try again."
    exit 1
fi

