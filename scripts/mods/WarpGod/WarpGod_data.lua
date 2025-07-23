local mod = get_mod("WarpGod")

return {
    name        = mod:localize("mod_name"),
    description = mod:localize("mod_description"),
    is_togglable = true,

    options = {
        widgets = {
            -- Prevent Psyker Explosion Group
            {
                setting_id = "prevent_psyker_explosion",
                type       = "group",

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
                        range           = { 0.5, 1.0 },
                        default_value   = 0.95,
                        decimals_number = 2,
                        step_size_value = 0.01,
                        text            = mod:localize("peril_threshold"),
                        description     = mod:localize("peril_threshold_description"),
                    },
                },
            },
        },
    },
}
