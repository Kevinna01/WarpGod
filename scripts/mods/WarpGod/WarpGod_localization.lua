local mod = get_mod("WarpGod")

local loc = {
    mod_name = {
        en = "Warp God",
    },
    mod_description = {
        en = "Prevent Peril of the Warp Explosion & Warp Unbound talent bug hotfix",
    },
    -- Prevent Psyker Explosion
    prevent_psyker_explosion = {
        en = "Prevent Psyker Explosion",
    },
    prevent_psyker_explosion_enable = {
        en = "Enable Prevent Psyker Explosion",
    },
    prevent_psyker_explosion_enable_description = {
        en = "Prevents peril-generating attacks when peril exceeds the threshold whilst Warp Unbound ability is not active.",
    },
    macro_anti_detection_enable = {
        en = "Enable Macro Anti-Detection",
    },
    macro_anti_detection_enable_description = {
        en = "Prevents quelling when exceeding threshold, used to hide usage of quell-cancel macro. Default is Off.",
    },
    peril_threshold = {
        en = "Peril Threshold",
    },
    peril_threshold_description = {
        en = "Maximum allowable peril before peril-generating attacks are disabled. Default is 1.0.",
    },
    -- Warp Unbound Bug Fix
    warp_unbound_bug_fix = {
        en = "Warp Unbound Bug Fix",
    },
    warp_unbound_bug_fix_enable = {
        en = "Enable Warp Unbound Bug Fix",
    },
    warp_unbound_bug_fix_enable_description = {
        en = "Warp Unbound last 11.5s, sometime around 10.5s there is a probability to explode with Smite, Surge & Trauma staffs. Bugfix disables attacks that generate peril during a interval.",
    },
    interval1_duration = {
        en = "Interval-duration",
    },
    interval1_duration_description = {
        en = "For the bugfix interval. Default is 0.7",
    },
    interval1_start_delay = {
        en = "Interval start-delay",
    },
    interval1_start_delay_description = {
        en = "For the Bugfix interval. Default is 0.9",
    },
}

return loc
