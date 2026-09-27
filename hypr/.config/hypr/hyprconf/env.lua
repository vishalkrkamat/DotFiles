-- Environment variables formerly set in env.conf.
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("EGL_PLATFORM", "wayland")
hl.env("MOZ_DISABLE_RDD_SANDBOX", "1")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- NVIDIA and other optional variables from the old config remain commented
-- there; enable them here with hl.env(KEY, VALUE) if needed.
hl.config({
    cursor = {
        no_hardware_cursors = true,
    },
    xwayland = {
        force_zero_scaling = true,
    },
})
