#!/usr/bin/env bash

# run
# curl "https://raw.githubusercontent.com/ptdewey/dotfiles/main/scripts/install.sh" >> install.sh
# chmod +x install.sh && ./install.sh

# install git
if ! command -v git &> /dev/null; then
    echo "git not found, installing..."
    sudo apt update
    sudo apt install git -y
    echo "Installed git."
else
    echo "git is already installed."
fi
git --version

# fetch dotfiles
# TODO: ssh clone would be preferable but that requires additional prior setup
echo "Fetching dotfiles..."
git clone "https://github.com/ptdewey/dotfiles" "$HOME/"

# run dotfiles setup
echo "Running setup script..."
pushd "$HOME/dotfiles"
chmod +x scripts/setup.sh
./scripts/setup.sh n
popd
echo "Dotfiles setup complete."

# install nix
# TODO: this part doesnt work correctly, cant be run as script
sudo sh <(curl -L https://nixos.org/nix/install) --daemon
if ! command -v nix &> /dev/null; then
    echo "Installing Nix..."
    sh <(curl -L https://nixos.org/nix/install) --daemon --yes
    echo "Nix installation complete. You may need to restart your shell or system."
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
else
    echo "Nix is already installed."
fi

# install home manager
if ! command -v home-manager &> /dev/null; then
    echo "Installing Home Manager..."
    nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
    echo "Home Manager installation complete."
else
    echo "Home Manager is already installed."
fi

# install packages with nix home manager
echo "Installing home-manager nix packages..."
. "$HOME/dotfiles/scripts/hm-switch.sh"
echo "Done installing home manager packages."


# install zsh extensions
pushd "$HOME/.local/share"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/zsh-users/zsh-autosuggestions.git
popd

# create desktop entry for bspwm (important if installing from nix)
sudo bash -c 'cat > /usr/share/xsessions/bspwm.desktop <<EOF
[Desktop Entry]
Name=bspwm
Comment=Binary space partitioning window manager
Exec=bspwm
Type=Application
EOF'

# install terminal and any other graphical packages nix can't handle
sudo apt install kitty

# TODO: any other installation/setup tasks (other packages)
