-- Client_PresentSettingsUI.lua

function Client_PresentSettingsUI(rootParent)
    local vert = UI.CreateVerticalLayoutGroup(rootParent)

    UI.CreateLabel(vert)
        .SetText('Robin Hood Mode')
        .SetColor('#FFD700')

    local transfer  = tonumber(Mod.Settings.TransferPercent)  or 10
    local threshold = tonumber(Mod.Settings.ThresholdPercent) or 10
    local roundUp   = Mod.Settings.RoundUp ~= false

    UI.CreateLabel(vert)
        .SetText('At the start of each turn, a percentage of the richest player\'s income is given to the poorest player.\n\n'
                 .. '• Transfer: ' .. transfer .. '% of richest income\n'
                 .. '• Threshold: triggers when richest earns ' .. threshold .. '% more than poorest\n'
                 .. '• Rounding: ' .. (roundUp and 'round up' or 'round down') .. '\n'
                 .. '• Ties: all players tied for richest contribute, all tied for poorest receive')
end
