#!/bin/bash

echo "Continue? (y/n)"
read -n 1 answer
echo ""

if [[ "$answer" =~ ^[Yy]$ ]]; then
    clear
    echo "Nvidia Fedora Install - choose stage of install:"
    echo "1) Stage 1"
    echo "2) Stage 2"

    read -n 1 -p "Enter 1 or 2: " choice
    echo ""

    if [[ "$choice" != "1" && "$choice" != "2" ]]; then
        echo "Invalid choice. Please enter 1 or 2."
        sleep 1
        exec ./nvidia.sh
    fi

    clear
    echo "Installing"

    if [[ "$choice" == "1" ]]; then
        sudo dnf update -y

        sudo dnf install -y \
        https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

        sudo dnf install -y \
        akmod-nvidia \
        xorg-x11-drv-nvidia-cuda \
        mokutil \
        kmodtool \
        openssl

        sudo kmodgenca -a
        sudo mokutil --import /etc/pki/akmods/certs/public_key.der
        sudo grubby --update-kernel=ALL --args="nvidia-drm.modeset=1"
    fi

    if [[ "$choice" == "2" ]]; then
        sudo akmods --force
        sudo dracut --force
        sudo reboot
    fi
fi
