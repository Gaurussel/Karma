util.AddNetworkString("karma.notification")

timer.Simple(0, function()
    MySQLite.query([[
        CREATE TABLE IF NOT EXISTS karma(
            player TEXT NOT NULL PRIMARY KEY,
            karma INTEGER NOT NULL
        );
    ]], function() end, function(error) ErrorNoHalt(error) end)
end)

hook.Add("DoPlayerDeath", "karma.PlayerDeath", function(victim, ent, dmg)
    victim.danger = nil
    victim.robbery = nil

    if !KARMA.config.Degreese.mDeath then
        return
    end

    local attacker = dmg:GetAttacker()
    if !IsValid(attacker) or !attacker:IsPlayer() then
        return
    end

    local activeWeapon = victim:GetActiveWeapon():GetClass()

    if attacker == victim then
        return
    end


    if string.StartsWith(activeWeapon, "cw_") then
        return
    end

    attacker:AddKarma(KARMA.config.Degreese.mDeathAmount, 1)
end)

hook.Add("PlayerTick", "karma.PlayerTick", function(ply)
    if !KARMA.config.Degreese.mWepGuid then
        return
    end

    if ply:isCP() then
        return
    end

    if !ply:Alive() then
        return
    end

    local activeWeapon = IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() or ""

    if !string.StartWith(activeWeapon, "cw_") then
        return
    end

    local viewEntity = ply:GetEyeTrace().Entity

    if ply:GetPos():Distance(viewEntity:GetPos()) < 256 then
        return
    end

    if !IsValid(viewEntity) then
        return
    end

    if !viewEntity:IsPlayer() then
        return
    end

    if !ply.danger then
        ply.danger = {}
    end

    if ply.danger[viewEntity] then
        return
    end

    if timer.Exists("karma.ugroza." .. viewEntity:SteamID()) then
        return
    end

    timer.Create("karma.ugroza." .. viewEntity:SteamID(), 5, 1, function()
        if !IsValid(ply) then
            return
        end

        secViewEntity = ply:GetEyeTrace().Entity

        if !IsValid(secViewEntity) or !IsValid(viewEntity) then
            return
        end

        if !secViewEntity:IsPlayer() or !viewEntity:IsPlayer() then
            return
        end

        if secViewEntity != viewEntity then
            return
        end

        if ply:GetPos():Distance(secViewEntity:GetPos()) < 256 then
            return
        end

        ply.danger[secViewEntity] = true
        ply:AddKarma(KARMA.config.Degreese.mWepGuidAmount, 5)
    end)
end)

hook.Add("PlayerDisconnected", "karma.PlayerDisconnected", function(ply)
    KARMA.Update(ply, ply:GetKarma())
    timer.Remove("karma." .. ply:SteamID())
end)

hook.Add("PlayerInitialSpawn", "karma.PlayerInitialSpawn", function(ply)
    ply:SetKarma(KARMA.Get(ply))

    timer.Create("karma." .. ply:SteamID(), 300, 0, function()
        if !IsValid(ply) then
            return
        end

        if !KARMA.config.PeacefulJobs[ply:Team()] then
            return
        end

        if !KARMA.config.Increase.iPeaceful then
            return
        end

        ply:AddKarma(KARMA.config.Increase.iPeacefulAmount, 8)
    end)
end)

hook.Add("onLockpickCompleted", "karma.onLockpickCompleted", function(ply, success)
    if !success then
        return
    end

    if !KARMA.config.Degreese.mRobbery then
        return
    end

    ply:AddKarma(KARMA.config.Degreese.mRobberyAmount, 3)
end)

hook.Add("moneyChecked", "karma.moneyChecked", function(ply, target)
    if !KARMA.config.Degreese.mLockpeek then
        return
    end

    if !ply.robbery then
        ply.robbery = {}
    end

    if ply.robbery[target] then
        return
    end

    ply.robbery[target] = true
    ply:AddKarma(KARMA.config.Degreese.mLockpeekAmount, 4)
end)

hook.Add("ShutDown", "karma.ShutDown", function()
    for _, ply in ipairs(player.GetAll()) do
        KARMA.Update(ply, ply:GetKarma())
    end
end)

hook.Add("PostEntityTakeDamage", "karma.PostEntityTakeDamage", function(ent, dmg)
    if !KARMA.config.Degreese.mDamage then
        return
    end

    if !ent:IsPlayer() then
        return
    end

    local attacker = dmg:GetAttacker()

    if !IsValid(attacker) or !attacker:IsPlayer() then
        return
    end

    if !attacker.damage then
        attacker.damage = {}
    end

    if attacker.damage[ent] then
        return
    end

    local timerName = "karma.damage." .. ent:SteamID()

    if timer.Exists(timerName) then
        return
    end

    timer.Create(timerName, 10, 1, function()
        if !IsValid(ent) then
            return
        end

        if !ent:Alive() then
            return
        end

        attacker.damage[ent] = true
        attacker:AddKarma(KARMA.config.Degreese.mDamageAmount, 2)
    end)
end)

hook.Add("playerArrested", "karma.playerArrested", function(criminal, _, officer)
    if !KARMA.config.Increase.iArrest then
        return
    end

    if IsValid(officer) and officer:IsPlayer() and !criminal:isArrested() then
        officer:AddKarma(KARMA.config.Increase.iArrestAmount, 7)
    end
end)

hook.Add("playerGetSalary", "karma.playerGetSalary", function(ply, amount)
    local karma = ply:GetKarma()

    if karma < 10 then
        return
    end

    local pMoney = math.Round(amount + karma * 2)

    ply:addMoney(pMoney)
    DarkRP.notify(ply, 0, 5, "Надбавка к зарплате $" .. pMoney .. " за хорошее поведение!")
end)

if ConfigurationMedicMod then
    hook.Add("onPlayerStabilized", "karma.onPlayerStabilized", function(ply, medic)
        if !KARMA.config.Increase.iFA then
            return
        end

        medic:AddKarma(KARMA.config.Increase.iFAAmount, 6)
    end)
end

if HITMAN then
    hook.Add("AddHitmanOrder", "karma.AddHitmanOrder", function(_, ply)
        if !KARMA.config.Degreese.mHitman then
            return
        end

        ply:AddKarma(KARMA.config.Degreese.mHitmanAmount, 1)
    end)
end

timer.Simple(0.1, function()
    if DarkRP.disabledDefaults.modules.hitmenu then
        hook.Add("onHitAccepted", "karma.onHitAccepted", function(_, _, ply)
            if !KARMA.config.Degreese.mHitman then
                return
            end

            ply:AddKarma(KARMA.config.Degreese.mHitmanAmount, 1)
        end)
    end
end)