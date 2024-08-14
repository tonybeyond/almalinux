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
    dnf install -y neovim wget curl git btop tmux zsh neofetch gnome-shell-extension-pop-shell gnome-shell-extension-user-theme gnome-shell-extension-workspace-indicator gnome-shell-extension-dash-to-panel kitty kitty-doc kitty-terminfo eza
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
    flatpak install -y flathub com.mattjakeman.ExtensionManager
    
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
    chsh -s $(which zsh)
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    cat << EOF > ~/.zshrc
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="bira"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
	fzf
	vscode
	z
	zsh-autocomplete
	zsh-syntax-highlighting
)

# Autocompletion settings
#zstyle ':completion:*' menu select
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zle -N insert-unambiguous-or-complete
zle -N menu-search
zle -N recent-paths

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
#
# User configuration

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes.
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# vim and emacs
alias vim='nvim'

# Changing "ls" to "exa"
alias ls='exa -al --color=always --group-directories-first'
alias la='exa -a --color=always --group-directories-first'
alias ll='exa -l --color=always --group-directories-first'
alias lt='exa -aT --color=always --group-directories-first'
alias l.='exa -a | egrep "^\."'

# rpm-ostree
alias upall='sudo dnf update && sudo dnf upgrade -y'
alias upcheck='sudo dnf check-update'

# Colorize grep output
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# adding flags
alias df='df -h'
alias free='free -m'

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# Merge Xresources
alias merge='xrdb -merge ~/.Xresources'

# git
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias tag='git tag'
alias newtag='git tag -a'

# system reporting
neofetch
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
