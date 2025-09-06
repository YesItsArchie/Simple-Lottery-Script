-- CONFIG
local ticketPrice = 1000          -- Price per lottery ticket
local drawInterval = 60 * 60      -- Seconds between draws (1 hour here)
local jackpot = 5000              -- Starting jackpot amount

-- STATE
local tickets = {}                -- Table of {playerId, playerName}
local currentJackpot = jackpot

-- BUY TICKET COMMAND
RegisterCommand("buyticket", function(source, args, raw)
    local playerId = source
    local playerName = GetPlayerName(playerId)

    -- (Replace with your framework’s money check, ESX/QBCore)
    local hasMoney = true -- stub
    if hasMoney then
        -- (Remove money from player here)
        table.insert(tickets, {id = playerId, name = playerName})
        currentJackpot = currentJackpot + ticketPrice
        TriggerClientEvent("chat:addMessage", playerId, {
            args = {"Lottery", "You bought a ticket! Jackpot is now $" .. currentJackpot}
        })
    else
        TriggerClientEvent("chat:addMessage", playerId, {
            args = {"Lottery", "You don’t have enough money for a ticket!"}
        })
    end
end)

-- LOTTERY DRAW FUNCTION
function drawLottery()
    if #tickets == 0 then
        TriggerClientEvent("chat:addMessage", -1, {
            args = {"Lottery", "No tickets were sold this round. Jackpot rolls over to $" .. currentJackpot}
        })
        return
    end

    local winnerIndex = math.random(1, #tickets)
    local winner = tickets[winnerIndex]

    -- (Add money to winner here)

    TriggerClientEvent("chat:addMessage", -1, {
        args = {"Lottery", winner.name .. " has won the jackpot of $" .. currentJackpot .. "!"}
    })

    -- Reset lottery
    tickets = {}
    currentJackpot = jackpot
end

-- RECURRING DRAW TIMER
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(drawInterval * 1000)
        drawLottery()
    end
end)
