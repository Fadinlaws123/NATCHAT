local resourceName = GetCurrentResourceName()
local currentVersion = GetResourceMetadata(resourceName, "version", 0) or "unknown"
local versionCheckURL = "https://raw.githubusercontent.com/Fadinlaws123/ScriptVersionChecker/refs/heads/main/NATCHAT.json" -- Default URL if not set
local webhookURL = Config.VersionLogs
local branding = {
        name = "NAT2K15 Chat Version Checker",
        version = "1.0.0",
        author = "NAT2K15",
        color = "^2",  -- Color for the console messages
}

-- Function to send update notification to Discord
local function sendToDiscord(title, message)
    local embed = {
        {
            ["color"] = 15258703,  -- Color for the embed (green)
            ["title"] = title,
            ["description"] = message,
            ["footer"] = {
                ["text"] = "Powered by " .. branding.name
            },
            ["fields"] = {
                {
                    ["name"] = "Current Version",
                    ["value"] = currentVersion,
                    ["inline"] = true
                },
                {
                    ["name"] = "Latest Version",
                    ["value"] = message,
                    ["inline"] = true
                }
            }
        }
    }
    
    local data = {
        username = branding.name,
        avatar_url = "https://cdn.discordapp.com/icons/778812156925181966/a_ccd0ddc4a3bdec90c0ec79b67af802a2.gif?size=1024&width=640&height=640", -- Optional, set your avatar URL
        embeds = embed
    }
    
    PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end

-- Function to fetch version information
local function fetchVersionInfo()
    PerformHttpRequest(versionCheckURL, function(statusCode, response, headers)
        if statusCode == 200 then
            local versionData = json.decode(response)
            if versionData and versionData.version then
                local latestVersion = versionData.version

                -- Log the branding message to the console
                if latestVersion ~= currentVersion then
                    print(branding.color .. "NAT2K15 Chat Version Checker")
                    print(branding.color .. "[" .. branding.name .. "] ^1Update Available!^0")
                    print(branding.color .. "[" .. branding.name .. "] ^2Current Version: ^0" .. currentVersion)
                    print(branding.color .. "[" .. branding.name .. "] ^2Latest Version: ^0" .. latestVersion)
                    print(branding.color .. "[" .. branding.name .. "] ^3Download the latest update: ^0" .. (versionData.downloadURL or "No URL provided"))
                    print('^1MADE BY NAT2K15 DEVELOPMENT - SUPPORT: https://discord.gg/n3NdrKDxSb')
                    -- Send Discord notification
                    sendToDiscord("Update Available for " .. branding.name, "Current Version: " .. currentVersion .. "\nLatest Version: " .. latestVersion .. "\nDownload URL: " .. (versionData.downloadURL or "Not Provided"))
                else
                    print(branding.color .. "NAT2K15 Chat Version Checker")
                    print(branding.color .. "[" .. branding.name .. "] ^2You are running the latest version!^0")
                    print('^1MADE BY NAT2K15 DEVELOPMENT - SUPPORT: https://discord.gg/n3NdrKDxSb')
                end
            else
                print(branding.color .. "[" .. branding.name .. "] ^1Failed to parse version information.^0")
                print('^1MADE BY NAT2K15 DEVELOPMENT - SUPPORT: https://discord.gg/n3NdrKDxSb')
            end
        else
            print(branding.color .. "[" .. branding.name .. "] ^1Version check failed. HTTP Status Code: " .. statusCode .. "^0")
            print('^1MADE BY NAT2K15 DEVELOPMENT - SUPPORT: https://discord.gg/n3NdrKDxSb')
        end
    end, "GET", "", {})
end

-- Run version check on resource start
Citizen.CreateThread(function()
    print(branding.color .. "^3[NAT2K15 Chat] ^0Checking for updates...")
    fetchVersionInfo()
end)