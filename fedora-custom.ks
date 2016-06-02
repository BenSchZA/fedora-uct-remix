#sudo livecd-creator --config=/home/bscholtz/workspace/workspace-contingency/fedora-custom.ks --fslabel=FedoraUltimate --cache=/var/cache/live --verbose
#livecd-iso-to-disk

#Base Installation
%include spin-kickstarts/fedora-live-workstation.ks

#$LIVE_ROOT
#$INSTALL_ROOT/etc/skel
#/home/bscholtz

#RPMFusion
repo --name=rpmfusionfree --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-23&arch=$basearch
repo --name=rpmfusionfreeupdates --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-23&arch=$basearch
repo --name=rpmfusionnonfree --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-23&arch=$basearch
repo --name=rpmfusionnonfreeupdate --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-23&arch=$basearch

%packages --ignoremissing
#Unbrand release
#-fedora-release
#-fedora-logos
#-fedora-release-notes
#generic-release
#generic-logos
#generic-release-notes

#Remove
#-libreoffice*

#Software 
meld 
texlive-arara 
texmaker  
nano 
anki
transmission
terminator
hedgewars

#Engineering
openscad
kicad
eclipse
octave
inkscape

#Utility
keepassx
deja-dup
youtube-dl
dconf
liveusb-creator
git
gparted
wget
shutter
tlp
powertop
gnome-shell-extension-pomodoro
spin-kickstarts

#GUI
gnome-tweak-tool
plank
redshift-gtk

#Website
python-pelican

#WhiteHat
testdisk
aircrack-ng
driftnet
nmap
wireshark-gnome

#Dependant on RPMFusion
moc
ffmpeg

%end

#Run before package installation
%pre

%end

#On local machine
%post --nochroot
mkdir -p $INSTALL_ROOT/etc/skel
mkdir -p $INSTALL_ROOT/etc/skel/.config
cp -p -r /home/bscholtz/.themes $INSTALL_ROOT/etc/skel
cp -p -r /home/bscholtz/.icons $INSTALL_ROOT/etc/skel
cp -p -r /home/bscholtz/bin $INSTALL_ROOT/etc/skel
cp -p -r /home/bscholtz/.config/plank $INSTALL_ROOT/etc/skel/.config
cp -p -r /home/bscholtz/workspace/workspace-contingency/assorted/wallpaper.png $INSTALL_ROOT/etc/skel
cp -p -r /home/bscholtz/workspace/workspace-contingency/fedora-custom.ks $INSTALL_ROOT/etc/skel

#Load Default LaTeX Templates
git clone https://github.com/BenSchZA/latex-template-uct.git $INSTALL_ROOT/etc/skel/workspace/workspace-latex/latex-template-uct
git clone https://github.com/BenSchZA/koma-latex-template-thesis.git $INSTALL_ROOT/etc/skel/workspace/workspace-latex/koma-latex-template-thesis

#External Packages
#Nylas N1, GitKraken, Foxit Reader, WPS Office, Zotero, Dropbox, Atom, Anki

#wget -P ~/workspace/workspace-contingency/software https://atom.io/download/rpm
#wget -P ~/workspace/workspace-contingency/software https://www.dropbox.com/download?dl=packages/fedora/nautilus-dropbox-2015.10.28-1.fedora.x86_64.rpm
#wget -P ~/workspace/workspace-contingency/software https://release.gitkraken.com/linux/gitkraken-amd64.tar.gz
#wget -P ~/workspace/workspace-contingency/software http://kdl.cc.ksosoft.com/wps-community/download/a20/wps-office-10.1.0.5503-1.a20p2.x86_64.rpm

mkdir -p $INSTALL_ROOT/etc/skel/Install
cp -p -r /home/bscholtz/workspace/workspace-contingency/software/. $INSTALL_ROOT/etc/skel/Install

%end

#Run after package installation
%post
#Copy from /etc/skel to LIVE_ROOT home
cp -r /etc/skel/. /home/liveuser/

#Install external packages
#dnf install /home/liveuser/Install/wps-*


#Enable RPMFusion Repos
#dnf install -y http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

#dnf copr enable numix/numix
#dnf install numix-icon-theme-circle

#Set [shell, GTK] theme and icons

cat >> /usr/share/glib-2.0/schemas/org.gnome.shell.gschema.override << FOE
[org.gnome.shell]
enabled-extensions=['apps-menu@gnome-shell-extensions.gcampax.github.com', 'user-theme@gnome-shell-extensions.gcampax.github.com', 'places-menu@gnome-shell-extensions.gcampax.github.com', 'System_Monitor@bghome.gmail.com', 'TopIcons@phocean.net']
FOE

glib-compile-schemas /usr/share/glib-2.0/schemas/

cat >> /usr/share/glib-2.0/schemas/org.gnome.shell.gschema.override << FOE
[org.gnome.shell.extensions.user-theme]
name="Flat-Remix-OS"
[org.gnome.desktop.interface]
gtk-theme="Flat-Remix-OS"
icon-theme="Numix-Circle-Light"
[org.gnome.desktop.background]
color-shading-type='solid'
picture-opacity='100' 
picture-uri='file:///home/liveuser/wallpaper.png'
FOE

glib-compile-schemas /usr/share/glib-2.0/schemas/

#gsettings set org.gnome.desktop.interface gtk-theme "Flat-Remix-OS"
#gsettings set org.gnome.desktop.interface icon-theme "Numix-Circle-Light"
#gsettings set org.gnome.desktop.wm.preferences theme "Flat-Remix-OS"

#Autostart Applications
mkdir -p /home/liveuser/.config/autostart
cp /usr/share/applications/plank.desktop /home/liveuser/.config/autostart/
cp /usr/share/applications/redshift-gtk.desktop /home/liveuser/.config/autostart/

mkdir -p /etc/skel/.config/autostart
cp /usr/share/applications/plank.desktop /etc/skel/.config/autostart/
cp /usr/share/applications/redshift-gtk.desktop /etc/skel/.config/autostart/

#Global Dark Theme
mkdir -p /home/liveuser/.config/gtk-3.0/
touch /home/liveuser/.config/gtk-3.0/settings.ini
echo "[Settings]" >> /home/liveuser/.config/gtk-3.0/settings.ini
echo "gtk-application-prefer-dark-theme=1" >> /home/liveuser/.config/gtk-3.0/settings.ini

mkdir -p /etc/skel/.config/gtk-3.0/
touch /etc/skel/.config/gtk-3.0/settings.ini
echo "[Settings]" >> /etc/skel/.config/gtk-3.0/settings.ini
echo "gtk-application-prefer-dark-theme=1" >> /etc/skel/.config/gtk-3.0/settings.ini

#Start on live-desktop
if [ -f /usr/share/applications/liveinst.desktop ]; then
	firefox -new-tab https://www.foxitsoftware.com/ https://www.zotero.org/download/ https://www.google.com/chrome/browser/desktop/
fi

#Welcome message
echo "https://www.foxitsoftware.com/ https://www.zotero.org/download/ https://www.google.com/chrome/browser/desktop/" >> /home/liveuser/Welcome.txt

echo "https://www.foxitsoftware.com/ https://www.zotero.org/download/ https://www.google.com/chrome/browser/desktop/" >> /etc/skel/Welcome.txt

%end
