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
    peril_threshold = {
        en = "Peril Threshold",
    },
    peril_threshold_description = {
        en = "Maximum allowable peril before peril-generating attacks are disabled.",
    },
    -- Warp Unbound Bug Fix
    warp_unbound_bug_fix = {
        en = "Warp Unbound Bug Fix",
    },
    warp_unbound_bug_fix_enable = {
        en = "Enable Warp Unbound Bug Fix",
    },
    warp_unbound_bug_fix_enable_description = {
        en = "There is a probability to explode with Smite, Surge & Trauma staffs despite activating Warp Unbound. Bugfix disables attacks that generate peril when entering and exiting the infinite-casting state.",
    },
    debounce_enter_percentage = {
        en = "Debounce Enter Percentage",
    },
    debounce_enter_percentage_description = {
        en = "At what peril percentage are perilous inputs disabled until warp unbound buff becomes activated.",
    },
    debounce_exit_time = {
        en = "Debounce Exit Time",
    },
    debounce_exit_time_description = {
        en = "At how many seconds left of the Warp Unbound buff timer are perilous inputs disabled until buff becomes disabled.",
    },
}

return loc
