net.Receive("karma.notification", function()
    local langID = net.ReadUInt(4)
    local lang = istable(KARMA.lang[langID]) and table.Random(KARMA.lang[langID]) or KARMA.lang[langID]

    timer.Simple(0.1, function()
        chat.AddText(KARMA.config.Colors.gray, "[", KARMA.config.Colors.red, "#", KARMA.config.Colors.gray, "] ", KARMA.config.Colors.text, string.format(lang, LocalPlayer():GetKarma()))
    end)
end)