#!/bin/bash -x

echo -e '\033[1m ## INSTALL DESKTOP SCRIPT ## \033[0m'
sudo apt-get update
# Install xserver, lxde desktop, and minimal 
sudo apt-get install -y --no-install-recommends \
    xserver-xorg virtualbox-guest-x11 \
    lxde lightdm lightdm-gtk-greeter\
    gtk2-engines gnome-themes-extra dmz-cursor-theme

## Clean and simplify (desktop only, optionnal)

# sudo apt-get -y purge ufw byobu geoip-database ## ! Don't do that on a production machine

# > The following is useful when starting from a lubuntu-desktop install
# sudo apt-get purge apparmor cups-daemon whoopsie pulseaudio-utils
# sudo apt-get purge ubuntu-release-upgrader-gtk update-manager update-notifier synaptic leafpad pavucontrol
# sudo apt-get purge fonts-noto-cjk abiword abiword-common gnumeric audacious bluez
# sudo apt-get purge xfburn guvcview sylpheed pidgin simple-scan xpad gnome mpv
# sudo apt-get purge hunspell* pidgin-data humanity-icon-theme gnumeric-common qttranslations5-l10n  libsane1 hplib-data
# sudo apt-get purge audacious-plugins audacious-plugins-data ffmpegthumbnailer galculator gnome-icon-theme gstreamer1.0-nice gstreamer1.0-plugins-bad gstreamer1.0-plugins-good libabiword-3.0 libmplex2-2.1-0 libfarstream-0.2-5 fcitx-data fcitx-modules
# sudo apt-get purge cups cups-bsd cups-client cups-common cups-ppdc fonts-noto-color-emoji fonts-tibetan-machine gconf2-common geoclue-2.0 geoip-database gsfonts gucharmap iio-sensor-proxy libgoffice-0.10-10 libgoffice-0.10-10-common libpresage-data libpresage1v5 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 lubuntu-gtk-core lxlauncher printer-driver-gutenprint printer-driver-hpcups printer-driver-splix xfce4-power-manager xfce4-power-manager-data xfce4-power-manager-plugins pulseaudio
# sudo apt-get purge samba-libs

## Visual code & Sublime (desktop only) 
cd
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get install -y apt-transport-https
sudo apt-get update
sudo apt-get install -y code
sudo apt-get install -y sublime-text
rm packages.microsoft.gpg

## Install Brave (desktop only)
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt-get update
sudo apt-get install -y brave-browser 

## Java environment 
sudo apt-get install -y default-jdk maven 

## Development tools
sudo apt-get install -y emacs unzip libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev

## Wallpaper
sudo cp /home/bobby/.cryptotux/images/wallpaper.jpg /etc/alternatives/desktop-background

## Log in directly to bobby's desktop
sudo echo '[SeatDefaults]
autologin-user=bobby
autologin-user-timeout=0
user-session=LXDE
greeter-session=ligthtdm-gtk-greeter'| sudo tee /etc/lightdm/lightdm.conf


## Boot Cosmetics (optionnal)
echo 'GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_RECORDFAIL_TIMEOUT=0
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=0 splash "
GRUB_CMDLINE_LINUX=""' |sudo tee /etc/default/grub.d/10-local-settings.cfg
sudo rm /etc/default/grub.d/50-cloudimg-settings.cfg
sudo update-grub

sudo apt-get install -y plymouth-label
sudo mkdir  /usr/share/plymouth/themes/cryptotux-text/
echo '[Plymouth Theme]
Name=Cryptotux Text
Description=Text mode theme 
ModuleName=ubuntu-text

[ubuntu-text]
title=Cryptotux       
black=0x0078C2
white=0xffffff
brown=0x009DFD
blue=0x00182C' | sudo tee /usr/share/plymouth/themes/cryptotux-text/cryptotux-text.plymouth

sudo ln -sf /usr/share/plymouth/themes/cryptotux-text/cryptotux-text.plymouth /etc/alternatives/text.plymouth
sudo ln -sf /usr/share/plymouth/themes/cryptotux-text/cryptotux-text.plymouth /etc/alternatives/default.plymouth

sudo update-initramfs -u


# Fix for some console apps launch xterm
sudo ln -s /usr/bin/lxterminal /usr/bin/xterm

sudo apt-get autoremove -y

## Reboot
echo -e '\033[1m ## END OF INSTALL DESKTOP SCRIPT - REBOOTING  ## \033[0m'
sudo reboot

#lxsession-logout --banner "/usr/share/lxde/images/logout-banner.png" --side=top