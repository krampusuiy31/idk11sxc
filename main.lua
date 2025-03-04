--// discord invite
local HttpService = game:GetService("HttpService")

local function openDiscordInvite()
    local requestFunc = syn and syn.request or request
    
    if not requestFunc then return end
    
    requestFunc({
        Url = "http://127.0.0.1:6463/rpc?v=1",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["Origin"] = "https://discord.com"
        },
        Body = HttpService:JSONEncode({
            cmd = "INVITE_BROWSER",
            args = {
                code = "wdQeeb9Eej"
            },
            nonce = HttpService:GenerateGUID(false)
        })
    })
end

openDiscordInvite()

--// games
if game.PlaceId == 2788229376 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/krampusuiy31/idk11sxc/refs/heads/main/bs.lua",true))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/krampusuiy31/idk11sxc/refs/heads/main/r.lua",true))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/krampusuiy31/idk11sxc/refs/heads/main/p.lua",true))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/krampusuiy31/idk11sxc/refs/heads/main/chat.lua",true))()
elseif game.PlaceId == 301549746 then
    print("Idk")
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/krampusuiy31/idk11sxc/refs/heads/main/r.lua",true))()
end
