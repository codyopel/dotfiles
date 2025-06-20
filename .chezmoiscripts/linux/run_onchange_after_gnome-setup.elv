#!/usr/bin/env elvish

# Disable auto hide overlay-scrollbar behavior
e:gsettings set org.gnome.desktop.interface overlay-scrolling 'false'

# Nautilus
try {
    e:gsettings set org.gnome.file-roller.general compression-level 'maximum'
} catch _ { }
e:gsettings set org.gnome.desktop.peripherals.mouse natural-scroll 'false'
e:gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll 'false'
e:gsettings set org.gnome.nautilus.preferences open-folder-on-dnd-hover 'false'
