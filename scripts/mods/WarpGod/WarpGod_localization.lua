local mod = get_mod("WarpGod")

local loc = {
    mod_name = {
        en = "Warp God",
    },
    mod_description = {
        en = "Prevent Peril of the Warp Explosion & Warp Unbound talent bug hotfix & Auto Quelling & Auto Ability Activation",
    },

    -- Prevent Psyker Explosion
    prevent_psyker_explosion = {
        en = "Prevent Psyker Explosion",
    },
    prevent_psyker_explosion_enable = {
        en = "Enable Prevent Psyker Explosion",
    },
    prevent_psyker_explosion_enable_description = {
        en = "Prevents peril‑generating attacks when peril exceeds the threshold whilst Warp Unbound ability is not active.",
    },
    peril_threshold = {
        en = "Peril Threshold Percentage",
    },
    peril_threshold_description = {
        en = "Maximum allowable peril before peril‑generating attacks are disabled. [Default 0.95]",
    },
}

return loc
