// Respect system scroll wheel behavior (otherwise, Firefox tends to scroll
// much faster than other applications).
user_pref("mousewheel.system_scroll_override.enabled", false);
// Disable microphone/webcam indicator overlay.
user_pref("privacy.webrtc.legacyGlobalIndicator", false);
// Disable F11 full screen animation (and others).
user_pref("ui.prefersReducedMotion", 1);
