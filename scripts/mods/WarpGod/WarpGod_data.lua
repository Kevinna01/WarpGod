local mod = get_mod("WarpGod")

return {
    name = mod:localize("mod_name"),
    description = mod:localize("mod_description"),
    is_togglable = true,
    options = {
        widgets = {
            -- Prevent Psyker Explosion Group
            {
                setting_id = "prevent_psyker_explosion",
                type = "group",
                sub_widgets = {
                    {
                        setting_id    = "prevent_psyker_explosion_enable",
                        type          = "checkbox",
                        default_value = true,
                        text          = mod:localize("prevent_psyker_explosion_enable"),
                        description   = mod:localize("prevent_psyker_explosion_enable_description"),
                    },
                    {
                        setting_id      = "peril_threshold",
                        type            = "numeric",
                        range           = { 0.5, 1.0 }, -- Allowing thresholds between 50% and 100%
                        default_value   = 0.95,          -- Default to 100%
                        decimals_number = 2,
                        step_size_value = 0.01,
                        text            = mod:localize("peril_threshold"),
                        description     = mod:localize("peril_threshold_description"),
                    },
                },
            },
            -- Warp Unbound Bug Fix Group
            {
                setting_id = "warp_unbound_bug_fix",
                type = "group",
                sub_widgets = {
                    {
                        setting_id    = "warp_unbound_bug_fix_enable",
                        type          = "checkbox",
                        default_value = true,
                        text          = mod:localize("warp_unbound_bug_fix_enable"),
                        description   = mod:localize("warp_unbound_bug_fix_enable_description"),
                    },
                    {
                        setting_id      = "debounce_enter_percentage",
                        type            = "numeric",
                        range           = { 0.9, 1.0 },
                        default_value   = 0.96,
                        decimals_number = 2,
                        step_size_value = 0.01,
                        text            = mod:localize("debounce_enter_percentage"),
                        description     = mod:localize("debounce_enter_percentage_description"),
                    },
                    {
                        setting_id      = "debounce_exit_time",
                        type            = "numeric",
                        range           = { 0, 1.0 },
                        default_value   = 0.5,
                        decimals_number = 1,
                        step_size_value = 0.1,
                        text            = mod:localize("debounce_exit_time"),
                        description     = mod:localize("debounce_exit_time_description"),
                    },
                },
            },
            -- Auto Quell Group
            {
                setting_id = "auto_quell",
                type = "group",
                sub_widgets = {
                    {
                        setting_id    = "auto_quell_enable",
                        type          = "checkbox",
                        default_value = false,
                        text          = mod:localize("auto_quell_enable"),
                        description   = mod:localize("auto_quell_enable_description"),
                    },
                    {
                        setting_id      = "auto_quell_threshold",
                        type            = "numeric",
                        range           = { 0.0, 1.0 },
                        default_value   = 0.95,
                        decimals_number = 2,
                        step_size_value = 0.01,
                        text            = mod:localize("auto_quell_threshold"),
                        description   = mod:localize("auto_quell_threshold_description"),
                    },
                    {
                        setting_id      = "auto_quell_duration",
                        type            = "numeric",
                        range           = { 0.0, 2.5 },
                        default_value   = 1.0,
                        decimals_number = 2,
                        step_size_value = 0.1,
                        text            = mod:localize("auto_quell_duration"),
                        description   = mod:localize("auto_quell_duration_description"),
                    },
                },
            },
            -- Auto Ability Activation
            {
                setting_id = "auto_ability",
                type = "group",
                sub_widgets = {
                    {
                        setting_id    = "auto_gaze_enable",
                        type          = "checkbox",
                        default_value = false,
                        text          = mod:localize("auto_gaze_enable"),
                    },
                    {
                        setting_id    = "auto_vent_enable",
                        type          = "checkbox",
                        default_value = false,
                        text          = mod:localize("auto_vent_enable"),
                    },
                },
            },
        },
    },
}
