-- Client_PresentConfigureUI.lua

function Client_PresentConfigureUI(rootParent)
    local vert = UI.CreateVerticalLayoutGroup(rootParent)

    UI.CreateLabel(vert)
        .SetText('Robin Hood Mode')
        .SetColor('#FFD700')

    UI.CreateLabel(vert)
        .SetText('At the start of each turn, a percentage of the richest player\'s income is given to the poorest player.')

    -- Transfer percentage
    UI.CreateLabel(vert)
        .SetText('Transfer percentage (% of richest income to give away, default 10):')

    local transferInput = UI.CreateNumberInputField(vert)
        .SetValue(tonumber(Mod.Settings.TransferPercent) or 10)
        .SetWholeNumbers(true)
        .SetSliderMinValue(1)
        .SetSliderMaxValue(100)

    -- Threshold percentage
    UI.CreateLabel(vert)
        .SetText('Threshold percentage (richest must earn at least this % more than poorest to trigger, default 10):')

    local thresholdInput = UI.CreateNumberInputField(vert)
        .SetValue(tonumber(Mod.Settings.ThresholdPercent) or 10)
        .SetWholeNumbers(true)
        .SetSliderMinValue(1)
        .SetSliderMaxValue(1000)

    -- Rounding
    UI.CreateLabel(vert)
        .SetText('Rounding:')

    local group = UI.CreateRadioButtonGroup(vert)

    local rbUp = UI.CreateRadioButton(vert)
        .SetGroup(group)
        .SetText('Round up (default)')

    local rbDown = UI.CreateRadioButton(vert)
        .SetGroup(group)
        .SetText('Round down')

    if Mod.Settings.RoundUp == false then
        rbDown.SetIsChecked(true)
    else
        rbUp.SetIsChecked(true)
    end

    _RHMod_transferInput  = transferInput
    _RHMod_thresholdInput = thresholdInput
    _RHMod_rbUp           = rbUp
    _RHMod_rbDown         = rbDown
end
