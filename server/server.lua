AddEventHandler('chatMessage', function(source, name, message)
    if not message:match("^/") then
        CancelEvent()
    else
        -- Check if the command exists
        local command = message:match("^/([^%s]+)") -- Extract command name
        if not GetRegisteredCommands()[command] then
            CancelEvent() -- Block invalid commands
        end
    end
end)