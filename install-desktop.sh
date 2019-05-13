# --- Desktop only section ---

## Clean and simplify (desktop only, optionnal) 
sudo apt purge apparmor ufw
sudo apt purge cups-daemon whoopsie pulseaudio-utils
sudo apt purge ubuntu-release-upgrader-gtk update-manager update-notifier synaptic leafpad pavucontrol
sudo apt purge fonts-noto-cjk abiword abiword-common gnumeric audacious bluez
sudo apt purge xfburn guvcview sylpheed pidgin simple-scan xpad gnome mpv
sudo apt purge hunspell* pidgin-data humanity-icon-theme gnumeric-common qttranslations5-l10n  libsane1 hplib-data
sudo apt purge audacious-plugins audacious-plugins-data ffmpegthumbnailer galculator gnome-icon-theme gstreamer1.0-nice gstreamer1.0-plugins-bad gstreamer1.0-plugins-good libabiword-3.0 libmplex2-2.1-0 libfarstream-0.2-5 fcitx-data fcitx-modules
sudo apt purge adwaita-icon-theme cups cups-bsd cups-client cups-common cups-ppdc fonts-noto-color-emoji fonts-tibetan-machine gconf2-common geoclue-2.0 geoip-database gsfonts gucharmap iio-sensor-proxy libgoffice-0.10-10 libgoffice-0.10-10-common libpresage-data libpresage1v5 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 lubuntu-gtk-core lxlauncher printer-driver-gutenprint printer-driver-hpcups printer-driver-splix  xfce4-power-manager xfce4-power-manager-data xfce4-power-manager-plugins pulseaudio
sudo apt purge samba-libs

## Visual code (desktop only) 
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install -y apt-transport-https
sudo apt-get update
sudo apt-get install -y code

## Install Brave (desktop only)
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
sudo sh -c 'echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com `lsb_release -sc` main" >> /etc/apt/sources.list.d/brave.list'
sudo apt update
sudo apt install -y brave-browser brave-keyring 

## Development tools
sudo apt install -y emacs
sudo apt install -y bitcoin-qt