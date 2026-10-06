#!/usr/bin/env elvish

var settings = [
    &/org/gnome/desktop/interface=[
        &color-scheme="'prefer-dark'"
        &font-name="'Noto Sans, 10'"
        # Disable auto hide overlay-scrollbar behavior
        &overlay-scrolling="false"
    ]
    &/org/gnome/desktop/peripherals/mouse=[
        &natural-scroll="false"
    ]
    &/org/gnome/desktop/peripherals/touchpad=[
        &natural-scroll="false"
    ]
    &/org/gnome/desktop/wm/keybindings=[
        &switch-windows="['<Alt>Tab']"
    ]
    &/org/gnome/desktop/notifications/application/org-gnome-nautilus=[
        &enable='false'
    ]
    &/org/gnome/file-roller/general=[
        &compression-level="'maximum'"
    ]
    &/org/gnome/nautilus/preferences=[
        &default-folder-viewer="'icon-view'"
        &open-folder-on-dnd-hover="false"
        &show-directory-item-counts="'always'"
        &show-image-thumbnails="'always'"
    ]
    &/org/gnome/settings-daemon/plugins/power=[
        &power-button-action="'nothing'"
    ]
    &/org/gnome/shell=[
        &enabled-extensions="[
            'CoverflowAltTab@palatis.blogspot.com',
            'clipboard-indicator@tudmotu.com',
            'dash-to-panel@jderose9.github.com',
            'trayIconsReloaded@selfmade.pl'
        ]"
        &favorite-apps="[
            'org.gnome.Nautilus.desktop',
            'foot.desktop', 'firefox.desktop',
            'com.google.Chrome.desktop',
            'tv.plex.PlexDesktop.desktop',
            'org.telegram.desktop.desktop',
            'com.discordapp.Discord.desktop',
            'io.element.Element.desktop',
            'com.edde746.plezy.desktop'
        ]"
    ]
    &/org/gnome/shell/extensions/coverflowalttab=[
        &start-with-next="true"
    ]
    &/org/gnome/shell/extensions/dash-to-panel=[
        &dot-postion="'BOTTOM'"
        &dot-style-focused="'METRO'"
        &dot-style-unfocused="'SEGMENTED'"
        &hide-overview-on-startup="true"
        &highlight-appicon-hover="false"
        &animate-appicon-hover-animation-extent="{
            'PLANK': 4,
            'RIPPLE': 4,
            'SIMPLE': 1
        }"
        &animate-appicon-hover-animation-level="{
            'PLANK': 0.0,
            'RIPPLE': 0.40000000000000002,
            'SIMPLE': 0.20999999999999999
        }"
    ]
    &/org/gnome/TextEditor=[
        &restore-sesson='false'
        &show-line-numbers='true'
    ]
]

if (not (has-external 'dconf')) {
    echo 'gnome-setup.elv: Nothing to do' >&2
    exit
}

for schema [ (keys $settings) ] {
    for key [ (keys $settings[$schema]) ] {
        var value = $settings[$schema][$key]
        try {
            e:dconf 'write' $schema'/'$key $value
        } catch e {
            echo 'dconf' 'write' $schema'/'$key $value >&2
            echo $e['reason'] >&2
        }
    }
}

