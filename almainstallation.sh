#!/bin/bash

# AlmaLinux System Setup and Optimization Script
# Author: Me with AI Assistant
# Date: August 13, 2024

set -e

# Function to check if script is run as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" 
        exit 1
    fi
}

# Function to enable necessary repositories
enable_repos() {
    echo "Enabling CRB and PLUS repositories..."
    dnf config-manager --set-enabled crb
    dnf config-manager --set-enabled plus
    echo "Installing EPEL repository..."
    dnf install -y epel-release
}

# Function to update the system
update_system() {
    echo "Updating system..."
    dnf update -y
    dnf upgrade -y
}

# Function to install common tools and utilities
install_common_tools() {
    echo "Installing common tools and utilities..."
    dnf install -y neovim wget curl git btop tmux zsh neofetch gnome-shell-extension-pop-shell gnome-shell-extension-user-theme gnome-shell-extension-workspace-indicator gnome-shell-extension-dash-to-panel 
}

# Function to install and configure Flatpak
setup_flatpak() {
    echo "Setting up Flatpak..."
    dnf install -y flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

# Function to install Flatpak applications
install_flatpak_apps() {
    echo "Installing Flatpak applications..."
    flatpak install -y flathub com.visualstudio.code
    flatpak install -y flathub md.obsidian.Obsidian
    flatpak install -y flathub org.standardnotes.standardnotes
    flatpak install -y flathub com.github.flxzt.rnote
    flatpak install -y flathub com.github.tchx84.Flatseal
    flatpak install -y flathub org.videolan.VLC
}

install_brave_browser () {
    echo "Installing Brave browser..."
    dnf install dnf-plugins-core
    dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    dnf install brave-browser -y
}


# Function to install development tools
install_dev_tools() {
    echo "Installing development tools..."
    dnf groupinstall -y "Development Tools"
    dnf install -y python3 python3-pip nodejs npm
}

# Function to install and configure firewall
setup_firewall() {
    echo "Setting up firewall..."
    dnf install -y firewalld
    systemctl enable firewalld
    systemctl start firewalld
    firewall-cmd --set-default-zone=public
    firewall-cmd --add-service=ssh --permanent
    firewall-cmd --reload
}

# Function to optimize system performance
optimize_system() {
    echo "Optimizing system performance..."
    systemctl disable bluetooth.service
    systemctl disable cups.service
    echo "vm.swappiness=10" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_fastopen = 3" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_slow_start_after_idle = 0" >> /etc/sysctl.conf
    sysctl -p
}

# Function to install and configure ZSH
setup_zsh() {
    echo "Setting up ZSH..."
    dnf install -y zsh
    chsh -s $(which zsh)
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    cat << EOF > ~/.zshrc
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git docker python npm)
source $ZSH/oh-my-zsh.sh
alias update='sudo dnf update -y'
alias install='sudo dnf install -y'
alias search='dnf search'
alias remove='sudo dnf remove -y'
export PATH=$HOME/bin:/usr/local/bin:$PATH
function mkcd() {
    mkdir -p "$1" && cd "$1"
}
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
EOF
}

# Function to clean up
cleanup() {
    echo "Cleaning up..."
    dnf clean all
    journalctl --vacuum-time=7d
}

# Main function
main() {
    check_root
    enable_repos
    update_system
    install_common_tools
    setup_flatpak
    install_flatpak_apps
    install_brave_browser
    install_dev_tools
    setup_firewall
    optimize_system
    setup_zsh
    cleanup

    echo "AlmaLinux setup and optimization complete!"
    echo "Flatpak applications installed. You may need to log out and log back in for them to appear in your application menu."
    echo "Please reboot your system to apply all changes."
}

# Run the main function
main
