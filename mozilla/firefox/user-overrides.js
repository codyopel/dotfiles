//
//// Personal overrides
//

user_pref("gfx.webrender.all", true);
// Multi-process
user_pref("fission.autostart", true);
user_pref("fission.autostart.session", true);

// VA-API
user_pref("media.ffmpeg.vaapi.enabled", true);
user_pref("media.rdd-ffmpeg.enabled", true);
// WebRTC VA-API
user_pref("media.navigator.mediadatadecoder_vpx_enabled", true);

// JPEG-XL
user_pref("image.jxl.enabled", true);

// Don't thrash SSDs, cache in memory instead.
user_pref("browser.cache.disk.enable", false);
user_pref("browser.cache.disk_cache_ssl", false);

// Find bar
user_pref("findbar.highlightAll", true);
// Smoother scroll animations
user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 400);
user_pref("general.smoothScroll.mouseWheel.durationMinMS", 125);
// Disable GTK overlay-scrollbars
user_pref("widget.gtk.overlay-scrollbars.enabled", false);

// FIXME: document
// Disable "Upload" feature on screenshots
user_pref("extensions.screenshots.upload-disabled", true);

//
//// Arkenfox overrides
//

// 0000: Preserve about:config warning.
user_pref("browser.aboutConfig.showWarning", true);
// 0102: Resume previous session
user_pref("browser.startup.page", 3);
// FIXME: 0360: Captive Portal Detection, is this useful?
// user_pref("network.captive-portal-service.enabled", false);
// 0701: Enable IPv6
user_pref("network.dns.disableIPv6", false);
// FIXME: 0703: Uniform Naming Convention, maybe enable?
// user_pref("network.file.disable_unc_paths", true);
// 0801: Location bar search
user_pref("keyword.enabled", true);
// FIXME: 0905: does this break anything, or does this only apply to iframes?
// FIXME: 1003: Store extra session data
// user_pref("browser.sessionstore.privacy_level", 2);
// 1004: Use default session save interval
user_pref("browser.sessionstore.interval", 15000);
// Allow mixed content (HTTP/HTTPS)
user_pref("security.mixed_content.block_display_content", false);
// 1246: HTTPS quick timeout
user_pref("dom.security.https_only_mode_send_http_background_request", true);
// FIXME: 1401: are SVG fonts useful?
// FIXME: 1402: consider limiting exposed fonts
// 1601/1602: Send cross-origin referer, use open-referer-control ext
user_pref("network.http.referer.XOriginPolicy", 0);
user_pref("network.http.referer.XOriginTrimmingPolicy", 0);
// FIXME: 2022: DRM for Netflix/Hulu etc., maybe just keep google-chrome for
// these
// user_pref("media.eme.enabled", true);
// FIXME: 2403: Allow popups (might be needed for paypal)
// user_pref("dom.disable_open_during_load", false);
// 2607: Enable devtools
user_pref("devtools.chrome.enabled", true);
// 2620: Enable PDF support
user_pref("pdfjs.disabled", true);
// FIXME: 2651/2652/2654: download handling
// 2801: Keep cookies until they expire
user_pref("network.cookie.lifetimePolicy", 0);
// FIXME: 2803: Persist third-party cookies
// user_pref("network.cookie.thirdparty.sessionOnly", true);
// user_pref("network.cookie.thirdparty.nonsecureSessionOnly", true);
// 2810: Keep history across sessions
user_pref("privacy.clearOnShutdown.history", false);
// 4504: Disable letterboxing
user_pref("privacy.resistFingerprinting.letterboxing", false);
// FIXME: 4520: WebGL
user_pref("webgl.disabled", true);
// 5003: Disable password manager
user_pref("signon.rememberSignons", false);
// FIXME: 5004: Disable permissions manager
// user_pref("permissions.memory_only", true);
// 5009: Disable open with dialog
user_pref("browser.download.forbid_open_with", true);
// 5014: Disable Windows jump lists
user_pref("browser.taskbar.lists.enabled", false);
user_pref("browser.taskbar.lists.frequent.enabled", false);
user_pref("browser.taskbar.lists.recent.enabled", false);
user_pref("browser.taskbar.lists.tasks.enabled", false);
// 7013: Don't allow sites to disable copy/paste.
user_pref("dom.event.clipboardevents.enabled", false);
// 9000: Welcome/Whats New
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("browser.messaging-system.whatsNewPanel.enabled", false);
// 9000: Typeahead find
user_pref("accessibility.typeaheadfind", true);
// 9000: Open bookmarks in new tab
user_pref("browser.tabs.loadBookmarksInTabs", true);
// 9000: Disable ALT-key toggling the menu bar
user_pref("ui.key.menuAccessKey", 0);
user_pref("ui.key.menuAccessKeyFocuses", false);
// 9000: Disable pocket
user_pref("extensions.pocket.enabled", false);
// 9000: Disable reader view
user_pref("reader.parse-on-load.enabled", false);