-- Client_SaveConfigureUI.lua

function Client_SaveConfigureUI(alert, addCard)
    local transfer = math.floor(_RHMod_transferInput.GetValue())
    if transfer < 1 or transfer > 100 then
        alert('Transfer percentage must be between 1 and 100.')
        return
    end

    local threshold = math.floor(_RHMod_thresholdInput.GetValue())
    if threshold < 1 then
        alert('Threshold percentage must be at least 1.')
        return
    end

    Mod.Settings.TransferPercent  = transfer
    Mod.Settings.ThresholdPercent = threshold
    Mod.Settings.RoundUp          = not _RHMod_rbDown.GetIsChecked()
end
