--[[
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ Mod Name: Warp God                                                                                                               │
│ Mod Description: Warp Unbound bug hotfix, Peril of the Warp Explosion Prevention                                                 │
│ Mod Author: Kevinna (collaboration with CrazyMonkey, author of PsykerAutoQuell)                                                  │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
--]]

local mod = get_mod("WarpGod")

local attempted_ability_usage = false -- Tracks if the player has attempted to use the ability
local ability_triggered = false -- Tracks if the ability was actually triggered
local waiting_on_buff = false -- Tracks if we have triggered ability but warp unbound is not yet active
local is_perilous_weapon = false
local is_forcesword = false
local perilous_attacks_disabled = false
local warp_unbound_buff_active = false
local current_peril = 0
local warp_unbound_equipped = false
local venting_shriek_equipped = false
local timer = 0

local perilous_action_sent = false
local quell_time_remaining = 0
local quell_active = false

local auto_ability_activation = true
local auto_unbound_time = 0.4

local perilous_weapons = {
    "forcestaff_p4_m1",
    "forcestaff_p3_m1",
    "forcestaff_p2_m1",
    "forcestaff_p1_m1",
    "psyker_throwing_knives",
    "psyker_smite",
    --"psyker_chain_lightning",
    "forcesword_p1_m3",
    "forcesword_p1_m2",
    "forcesword_p1_m1",
    "forcesword_2h_p1_m1",
    "forcesword_2h_p1_m2",
}

local forceswords = {
    "forcesword_p1_m1",
    "forcesword_p1_m2",
    "forcesword_p1_m3",
    "forcesword_2h_p1_m1",
    "forcesword_2h_p1_m2",
}

-- Settings with default values
local peril_threshold = mod:get("peril_threshold")
local debounce_enter_percentage = mod:get("debounce_enter_percentage")
local debounce_exit_time = mod:get("debounce_exit_time")
local auto_quell_threshold = mod:get("auto_quell_threshold")
local auto_quell_duration = mod:get("auto_quell_duration")

-- Update settings when they change
mod.on_setting_changed = function(setting_id)
    peril_threshold = mod:get("peril_threshold")
    debounce_enter_percentage = mod:get("debounce_enter_percentage")
    debounce_exit_time = mod:get("debounce_exit_time")
    auto_quell_threshold = mod:get("auto_quell_threshold")
    auto_quell_duration = mod:get("auto_quell_duration")
end

-- Function to get the local player
local function get_player()
    if Managers and Managers.state and Managers.state.game_mode then
        local player_manager = Managers.player
        local player = player_manager and player_manager:local_player(1)
        return player
    else return false end
end

-- Function to update weapon status
local function update_weapon_status()
    is_perilous_weapon = false
    is_forcesword = false

    local player = get_player()
    if not player then return end
    local player_unit = player.player_unit
    if not player_unit or not Unit.alive(player_unit) then return end

    local weapon_extension = ScriptUnit.has_extension(player_unit, "weapon_system")
    if weapon_extension then
        local weapon_template = weapon_extension:weapon_template()
        if weapon_template and weapon_template.name then
            local weapon_name = weapon_template.name

            for _, name in ipairs(perilous_weapons) do
                if string.find(weapon_name, name) then
                    is_perilous_weapon = true
                end
            end
            
            for _, name in ipairs(forceswords) do
                if string.find(weapon_name, name) then
                    is_forcesword = true
                end
            end
        end
    end
end

-- Function to get the current peril level
local function get_peril_level()
    local player = get_player()
    if not player then return 0 end
    local player_unit = player.player_unit
    if not player_unit or not Unit.alive(player_unit) then return 0 end

    local success, unit_data_extension = pcall(ScriptUnit.extension, player_unit, "unit_data_system")
    if not success or not unit_data_extension then return 0 end
    local warp_charge_component = unit_data_extension:read_component("warp_charge")
    if not warp_charge_component then return 0 end
    return warp_charge_component.current_percentage or 0
end

-- function to debounce inputs when entering and exiting infinite-casting state
local function state_debounce()
    -- Debounce before entering Warp Unbound infinite casting state
    if current_peril > debounce_enter_percentage and waiting_on_buff then
        perilous_attacks_disabled = true
    end

    -- Debounce before exiting Warp Unbound infinite casting state
    local player = get_player()
    if not player then return end
    local player_unit = player.player_unit
    if not player_unit or not Unit.alive(player_unit) then return end
    
    local buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")
    local remaining_time = 0
    if buff_extension then
        timer = 0
        for _, buff in pairs(buff_extension:buffs()) do
            local template = buff:template()
            if template.name == "psyker_overcharge_stance_infinite_casting" then
                remaining_time = buff:duration() * (buff:duration_progress() or 1)
                timer = math.max(timer, remaining_time)
                if (timer < debounce_exit_time) and not waiting_on_buff then
                    perilous_attacks_disabled = true
                end
            end
        end
    end
end

local function get_warp_unbound_buff_status()
    local player = get_player()
    if not player then return false end
    local player_unit = player.player_unit
    if not player_unit or not Unit.alive(player_unit) then return false end
    
    local success, buff_extension = pcall(ScriptUnit.extension, player_unit, "buff_system")
    if not success or not buff_extension then return false end

    for _, buff in pairs(buff_extension._buffs_by_index) do
        local template = buff:template()
        if template and template.name == "psyker_overcharge_stance_infinite_casting" then
            return true
        end
    end

    return false
end

local function update_equipped_ability_status()
    local player = Managers.player:local_player(1)
    local profile = player:profile()
    local has_warp_unbound_talent = profile.talents['psyker_overcharge_stance_infinite_casting'] or 0
    if has_warp_unbound_talent == 1 then
        warp_unbound_equipped = true
    else
        warp_unbound_equipped = false
    end

    local has_venting_shriek_talent = profile.talents['psyker_shout_vent_warp_charge'] or 0
    if has_venting_shriek_talent == 1 then
        venting_shriek_equipped = true
    else
        venting_shriek_equipped = false
    end
end

local function attack_to_quell(dt)
    if perilous_action_sent then
        perilous_action_sent = false
        quell_time_remaining = auto_quell_duration
    end
    if quell_time_remaining > 0 then
        quell_time_remaining = quell_time_remaining - dt
        quell_active = true
    else
        quell_active = false
    end
end

-- Hook into PlayerUnitAbilityExtension to confirm ability is actually used
mod:hook_safe("PlayerUnitAbilityExtension", "use_ability_charge", function(self, ability_type, optional_num_charges)
    if ability_type == "combat_ability" and attempted_ability_usage and warp_unbound_equipped then
        ability_triggered = true
        attempted_ability_usage = false
        waiting_on_buff = true
    end
end)

-- Hook into InputService to disable certain actions when necessary
mod:hook("InputService", "_get", function(func, self, action_name)
    if action_name ~= "action_one_pressed" and
        action_name ~= "action_one_hold" and
        action_name ~= "action_one_release" and
        action_name ~= "action_two_pressed" and
        action_name ~= "action_two_hold" and
        action_name ~= "action_two_release" and
        action_name ~= "weapon_extra_pressed" and
        action_name ~= "weapon_extra_hold" and
        action_name ~= "weapon_extra_release" and
        action_name ~= "weapon_reload" and
        action_name ~= "weapon_reload_hold" and
        action_name ~= "pressed" and
        action_name ~= "combat_ability_pressed" and
        action_name ~= "combat_ability_hold" and
        action_name ~= "combat_ability_release"
    then
        return func(self, action_name)
    end

    update_equipped_ability_status()
    update_weapon_status()
    current_peril = get_peril_level()
    warp_unbound_buff_active = get_warp_unbound_buff_status()
    perilous_attacks_disabled = false

    if waiting_on_buff and warp_unbound_buff_active and warp_unbound_equipped then
        waiting_on_buff = false
    end

    if mod:get("auto_quell_enable") and (current_peril > auto_quell_threshold) and perilous_action_sent == false and is_perilous_weapon and (not waiting_on_buff) and (not warp_unbound_buff_active) then
        perilous_action_sent = true
    end

    -- Auto Ability Activation
    if action_name == "combat_ability_pressed" and auto_ability_activation then
        if mod:get("auto_gaze_enable") and warp_unbound_equipped and warp_unbound_buff_active and (timer < auto_unbound_time) then
            attempted_ability_usage = true
            return true
        end
        --This implementation might not work if using bubble
        if mod:get("auto_vent_enable") and venting_shriek_equipped and current_peril > peril_threshold then
            attempted_ability_usage = true
            return true
        end
    end

    -- Auto Quell Functionality
    if action_name == "weapon_reload_hold" and quell_active == true then
        return true
    end


    -- Prevent Psyker Explosion functionality
    if mod:get("prevent_psyker_explosion_enable") and (current_peril >= peril_threshold) and not waiting_on_buff and not warp_unbound_buff_active then
        perilous_attacks_disabled = true
    end

    -- Warp Unbound LMB disabling functionality
    if mod:get("warp_unbound_bug_fix_enable") then
        state_debounce()

        if action_name == "combat_ability_hold" and warp_unbound_equipped then
            -- Player attempts to use the ability. Mark the attempt but do not set ability_triggered yet.
            if func(self, action_name) then
                attempted_ability_usage = true
            end
        end
        -- Only reset intervals if the ability was actually triggered
        if action_name == "combat_ability_release" and func(self, action_name) and ability_triggered and warp_unbound_equipped then
            ability_triggered = false
            attempted_ability_usage = false
        end
    end
    
    if perilous_attacks_disabled and is_perilous_weapon then
        -- Disable primary attack (LMB) for perilous weapons
        if (not is_forcesword) and (action_name == "action_one_pressed" or action_name == "action_one_hold" or action_name == "action_one_release" or action_name == "action_two_pressed" or action_name == "action_two_hold" or action_name == "action_two_release") then
            return false
        end
        -- Disable special attack keys for force swords
        if is_forcesword and (action_name == "weapon_extra_pressed" or action_name == "weapon_extra_hold" or action_name == "weapon_extra_release") then
            return false
        end
        
        
        -- Disable Reload/Quell when Warp Unbound is active
        if (current_peril > 0.99) and waiting_on_buff and (action_name == "weapon_reload" or action_name == "weapon_reload_hold") then
            return false
        end
    end

    return func(self, action_name)
end)

function mod.update(dt)
    attack_to_quell(dt)
end

return mod
