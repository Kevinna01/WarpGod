local mod = get_mod("WarpGod")

---------------------------------------------------------------------
--  User settings ----------------------------------------------------------
---------------------------------------------------------------------
local function feature_enabled()
    -- Checkbox defaults to true, so nil counts as enabled
    return mod:get("prevent_psyker_explosion_enable") ~= false
end

local function peril_threshold()
    -- Numeric widget returns a value in [0.5, 1.0]; default 0.95
    local t = mod:get("peril_threshold") or 0.95
    -- Hard‑clamp in case the user hand‑edits settings
    if t < 0.0 then t = 0.0 elseif t > 1.0 then t = 1.0 end
    return t
end

---------------------------------------------------------------------
--  Weapons that generate warp‑charge when used -----------------------------
---------------------------------------------------------------------
local perilous_weapons = {
    "forcestaff_p4_m1", "forcestaff_p3_m1", "forcestaff_p2_m1", "forcestaff_p1_m1",
    "psyker_throwing_knives", "psyker_smite",
    "forcesword_p1_m3", "forcesword_p1_m2", "forcesword_p1_m1",
    "forcesword_2h_p1_m1", "forcesword_2h_p1_m2",
}

local forceswords = {
    "forcesword_p1_m1", "forcesword_p1_m2", "forcesword_p1_m3",
    "forcesword_2h_p1_m1", "forcesword_2h_p1_m2",
}

---------------------------------------------------------------------
--  Helpers ----------------------------------------------------------------
---------------------------------------------------------------------
local function player()
    return (Managers.player and Managers.player:local_player(1)) or nil
end

local function peril_percentage(unit)
    if not unit or not Unit.alive(unit) then return 0 end
    local ok, ud = pcall(ScriptUnit.extension, unit, "unit_data_system")
    if not ok or not ud then return 0 end
    local wc = ud:read_component("warp_charge")
    return (wc and wc.current_percentage) or 0
end

local function current_weapon(unit)
    local w_ext = ScriptUnit.has_extension(unit, "weapon_system")
    if not w_ext then return nil end
    local t = w_ext:weapon_template()
    return (t and t.name) or nil
end

local function weapon_is_perilous(name)
    if not name then return false, false end
    for _, w in ipairs(perilous_weapons) do
        if string.find(name, w) then
            local fs = false
            for _, f in ipairs(forceswords) do
                if string.find(name, f) then fs = true break end
            end
            return true, fs
        end
    end
    return false, false
end

local function warp_unbound_active(unit)
    local buff_ext = ScriptUnit.has_extension(unit, "buff_system")
    if not buff_ext then return false end
    for _, buff in pairs(buff_ext:buffs()) do
        local tpl = buff:template()
        if tpl and tpl.name == "psyker_overcharge_stance_infinite_casting" then
            return true
        end
    end
    return false
end

---------------------------------------------------------------------
--  Actions we block -------------------------------------------------------
---------------------------------------------------------------------
local normal_block = {
    action_one_pressed  = true, action_one_hold  = true, action_one_release  = true,
    action_two_pressed  = true, action_two_hold  = true, action_two_release  = true,
}
local forcesword_block = {
    weapon_extra_pressed = true, weapon_extra_hold = true, weapon_extra_release = true,
}

---------------------------------------------------------------------
--  Input hook -------------------------------------------------------------
---------------------------------------------------------------------
mod:hook("InputService", "_get", function(func, self, action_name)
    -- If feature disabled or action irrelevant, pass straight through
    if not feature_enabled() then
        return func(self, action_name)
    end
    if not normal_block[action_name] and not forcesword_block[action_name] then
        return func(self, action_name)
    end

    local p = player()
    if not p then return func(self, action_name) end

    local unit   = p.player_unit
    local peril  = peril_percentage(unit)

    -- Only intervene at/above threshold and if Warp Unbound isn’t saving us
    if peril < peril_threshold() or warp_unbound_active(unit) then
        return func(self, action_name)
    end

    local weapon_name           = current_weapon(unit)
    local is_perilous, is_fs    = weapon_is_perilous(weapon_name)
    if not is_perilous then
        return func(self, action_name)
    end

    -- Hard‑block the input that would push peril higher (and explode!)
    if (is_fs and forcesword_block[action_name]) or (not is_fs and normal_block[action_name]) then
        return false  -- swallow the input
    end

    return func(self, action_name)
end)

return mod
