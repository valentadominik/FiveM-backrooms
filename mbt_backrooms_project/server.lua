RegisterCommand('tpBackrooms', function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    
    if not targetId and source > 0 then
        targetId = source
    end

    if targetId then
        TriggerClientEvent('mbt:sendToBackrooms', targetId)
        
        if source > 0 then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Backrooms',
                description = 'Hráč ' .. targetId .. ' byl odeslán do prázdnoty!',
                type = 'success'
            })
        end
    else
        if source > 0 then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Systém',
                description = 'Musíš zadat ID hráče! (např. /tpBackrooms 5)',
                type = 'error'
            })
        end
    end
end, true)
