local playerMeta = FindMetaTable("Player")

function playerMeta:SetKarma(new)
    self:SetNWInt("karma", new)
end

function playerMeta:AddKarma(val, reason)
    local newKarma = math.Clamp(self:GetKarma() + val, KARMA.config.min, KARMA.config.max)
    self:SetKarma(newKarma)

    if KARMA.config.mNotification then
        KARMA.notification(self, reason)
    end
end

function KARMA.notification(ply, nID)
    if !KARMA.lang[nID] then
        return
    end

    net.Start("karma.notification")
        net.WriteUInt(nID, 4)
    net.Send(ply)
end

function KARMA.Update(ply, val)
    MySQLite.query(string.format([[REPLACE INTO karma (player, karma) VALUES ('%s', %s)]], ply:SteamID(), val ), function() end, function(error)
        if KARMA.config.bDebug then
            ErrorNoHalt("KARMA.Update:Mysql.Query:\n" .. error)
        end
    end)
end

function KARMA.Get(ply)
    local karma = KARMA.config.default

    MySQLite.query(string.format([[SELECT karma FROM karma WHERE player = '%s']], ply:SteamID()), function(tbl)
        if tbl then
            karma = tbl[1].karma
        end
    end, function(error)
        if KARMA.config.bDebug then
            ErrorNoHalt("KARMA.Get:Mysql.Query:\n" .. error)
        end
    end)

    return tonumber(karma)
end