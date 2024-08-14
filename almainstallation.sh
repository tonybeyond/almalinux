#!/bin/bash

# AlmaLinux System Setup and Optimization Script
# Author: AI Assistant (modified)
# Date: August 14, 2024

set -e

# Function to check for sudo privileges
check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run this script with sudo"
        exit 1
    fi
}

# Function to get the actual user
get_actual_user() {
    ACTUAL_USER=$(logname)
    USER_HOME=$(eval echo ~$ACTUAL_USER)
}

# Function to enable necessary repositories
enable_repos() {
    echo "Enabling CRB and PLUS repositories..."
    dnf config-manager --set-enabled crb
    dnf config-manager --set-enabled plus
}

# Function to update the system
update_system() {
    echo "Updating system..."
    dnf update -y
    dnf upgrade -y
}

# Function to install EPEL repository
install_epel() {
    echo "Installing EPEL repository..."
    dnf install -y epel-release
}

# Function to install common tools and utilities
install_common_tools() {
    echo "Installing common tools and utilities..."
    dnf install -y vim nano wget curl git htop tmux zsh neofetch
}

# Function to install and configure Flatpak
setup_flatpak() {
    echo "Setting up Flatpak..."
    dnf install -y flatpak
    
    # Add Flathub repository for the actual user
    su - $ACTUAL_USER -c 'flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo'
}

# Function to install Flatpak applications
install_flatpak_apps() {
    echo "Installing Flatpak applications..."
    
    # Install Flatpak applications for the actual user
    su - $ACTUAL_USER -c 'flatpak install -y flathub com.visualstudio.code'
    su - $ACTUAL_USER -c 'flatpak install -y flathub md.obsidian.Obsidian'
    su - $ACTUAL_USER -c 'flatpak install -y flathub org.standardnotes.standardnotes'
    su - $ACTUAL_USER -c 'flatpak install -y flathub com.github.flxzt.rnote'
    su - $ACTUAL_USER -c 'flatpak install -y flathub com.github.tchx84.Flatseal'
    su - $ACTUAL_USER -c 'flatpak install -y flathub org.videolan.VLC'
    su - $ACTUAL_USER -c 'flatpak install -y flathub com.mattjakeman.ExtensionManager'
    
    echo "Flatpak applications installed for user $ACTUAL_USER"
}

# Function to install development tools
install_dev_tools() {
    echo "Installing development tools..."
    dnf groupinstall -y "Development Tools"
    dnf install -y python3 python3-pip nodejs npm
}

install_brave_browser () {
    echo "Installing Brave browser..."
    dnf install dnf-plugins-core
    dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    dnf install brave-browser -y
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
    chsh -s $(which zsh) $ACTUAL_USER

    # Install Oh My Zsh for the actual user
    su - $ACTUAL_USER -c 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'

    # Install additional ZSH plugins
    su - $ACTUAL_USER -c 'git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting'
    su - $ACTUAL_USER -c 'git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete'

    # Download and replace .zshrc file for the actual user
    echo "Downloading and replacing .zshrc file for user $ACTUAL_USER..."
    su - $ACTUAL_USER -c 'curl -o ~/.zshrc https://raw.githubusercontent.com/tonybeyond/almalinux/main/.zshrc'

    echo "ZSH setup complete with custom .zshrc file for user $ACTUAL_USER"
}

# Function to install Blur My Shell extension
install_blur_my_shell() {
    echo "Installing Blur My Shell extension..."
    git clone https://github.com/aunetx/blur-my-shell.git /tmp/blur-my-shell
    cd /tmp/blur-my-shell
    sudo -u $ACTUAL_USER make install
    # Clean up
    cd -
    rm -rf /tmp/blur-my-shell
    echo "Blur My Shell extension installed for user $ACTUAL_USER"
}

# Function to clean up
cleanup() {
    echo "Cleaning up..."
    dnf clean all
    journalctl --vacuum-time=7d
}

# Main function
main() {
    check_sudo
    get_actual_user

    enable_repos
    update_system
    install_epel
    install_common_tools
    setup_flatpak
    install_flatpak_apps
    install_brave_browser
    install_dev_tools
    setup_firewall
    optimize_system
    setup_zsh
    install_blur_my_shell
    cleanup

    echo "AlmaLinux setup and optimization complete!"
    echo "Flatpak applications and Blur My Shell extension installed."
    echo "You may need to log out and log back in for changes to take effect."
    echo "Please reboot your system to apply all changes."
}

# Run the main function
main
