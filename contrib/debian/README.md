
Debian
====================
This directory contains files used to package goldyd/goldy-qt
for Debian-based Linux systems. If you compile goldyd/goldy-qt yourself, there are some useful files here.

## goldy: URI support ##


goldy-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install goldy-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your goldyqt binary to `/usr/bin`
and the `../../share/pixmaps/goldy128.png` to `/usr/share/pixmaps`

goldy-qt.protocol (KDE)

