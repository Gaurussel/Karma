local playerMeta = FindMetaTable("Player")

function playerMeta:GetKarma()
    return self:GetNWInt("karma", KARMA.config.default)
end