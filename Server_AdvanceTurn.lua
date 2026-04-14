-- Server_AdvanceTurn.lua
-- "Robin Hood Mode"
--
-- At the start of each turn, takes a percentage of the richest player(s)'
-- income and adds it to the poorest player(s)' income for that turn.
--
-- Settings:
--   TransferPercent  : percentage of richest income to transfer (default 10)
--   ThresholdPercent : richest must earn at least this % more than poorest (default 10)
--   RoundUp          : whether to round the transfer up or down (default true)

function Server_AdvanceTurn_Start(game, addNewOrder)
    local players  = game.Game.Players
    local standing = game.ServerGame.LatestTurnStanding

    local transferPct  = tonumber(Mod.Settings.TransferPercent)  or 10
    local thresholdPct = tonumber(Mod.Settings.ThresholdPercent) or 10
    local roundUp      = Mod.Settings.RoundUp ~= false  -- default true

    -- Compute each playing player's income
    local incomes = {}  -- { playerID, income }
    for _, player in pairs(players) do
        if player.State == WL.GamePlayerState.Playing then
            local income = player.Income(0, standing, false, false).Total
            incomes[#incomes + 1] = { id = player.ID, income = income }
        end
    end

    if #incomes < 2 then return end  -- need at least 2 players

    -- Find max and min incomes
    local maxIncome = -math.huge
    local minIncome = math.huge
    for _, entry in ipairs(incomes) do
        if entry.income > maxIncome then maxIncome = entry.income end
        if entry.income < minIncome then minIncome = entry.income end
    end

    -- Check threshold: richest must earn at least thresholdPct% more than poorest
    -- e.g. threshold=10 means richest must be at least 110% of poorest
    if minIncome <= 0 then return end  -- avoid division by zero
    local ratio = ((maxIncome - minIncome) / minIncome) * 100
    if ratio < thresholdPct then return end

    -- Compute transfer amount from richest player's income
    local rawTransfer = maxIncome * (transferPct / 100)
    local transferAmount
    if roundUp then
        transferAmount = math.ceil(rawTransfer)
    else
        transferAmount = math.floor(rawTransfer)
    end

    if transferAmount <= 0 then return end

    -- Collect richest and poorest players
    local richest = {}
    local poorest = {}
    for _, entry in ipairs(incomes) do
        if entry.income == maxIncome then richest[#richest + 1] = entry.id end
        if entry.income == minIncome then poorest[#poorest + 1] = entry.id end
    end

    -- Build income mods:
    -- Each richest player loses transferAmount, each poorest player gains transferAmount
    local incomeMods = {}
    for _, pid in ipairs(richest) do
        incomeMods[#incomeMods + 1] = WL.IncomeMod.Create(
            pid,
            -transferAmount,
            'Robin Hood: -' .. transferAmount .. ' (taxed)'
        )
    end
    for _, pid in ipairs(poorest) do
        incomeMods[#incomeMods + 1] = WL.IncomeMod.Create(
            pid,
            transferAmount,
            'Robin Hood: +' .. transferAmount .. ' (redistributed)'
        )
    end

    -- Emit a visible event with the income mods
    local msg = 'Robin Hood: ' .. transferAmount .. ' armies redistributed from richest to poorest.'
    local event = WL.GameOrderEvent.Create(
        WL.PlayerID.Neutral,
        msg,
        nil,   -- visible to everyone
        nil,
        nil,
        incomeMods
    )
    addNewOrder(event)
end

function Server_AdvanceTurn_Order(game, order, orderResult, skipThisOrder, addNewOrder)
end

function Server_AdvanceTurn_End(game, addNewOrder)
end
