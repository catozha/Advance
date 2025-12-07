-- ui lib
local Lib = loadstring(game:HttpGet("https://pastebin.com/raw/cqURBATw"))()

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local Player = Players.LocalPlayer

local enb = false
local trg = nil
local spd = 1
local rad = 5
local hgt = 0
local ang = 0

-- functions
local function getplr(str)
    if not str or str == "" then return nil end
    local fnd = nil
    for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= Player then
        if string.find(plr.Name:lower(), str:lower()) or string.find(plr.DisplayName:lower(), str:lower()) then
            fnd = plr
            break
        end
    end
end
    return fnd
end

local function start()

    pcall(function() RS:UnbindFromRenderStep("looped") end)

    RS:BindToRenderStep("looped", Enum.RenderPriority.Camera.Value + 1, function()
        if not enb then 
            RS:UnbindFromRenderStep("looped")
            return 
        end

        if not trg or not trg.Character or not trg.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        local Char = Player.Character
        if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end

        local MHRP = Char.HumanoidRootPart
        local THRP = trg.Character.HumanoidRootPart

        ang = ang + (spd * 0.05)
        
        local RotRn = CFrame.Angles(0, ang, 0)
        local offset = Vector3.new(0, hgt, rad)

        local newpos = THRP.Position + (RotRn * offset)
        
        MHRP.CFrame = CFrame.new(newpos, THRP.Position)
        
        MHRP.Velocity = Vector3.new(0, 0, 0)
        MHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end)
end

-- UI
local Win = Lib.new({
    name = "Orbit"
})

Win:Label("Selector")

Win:Input("Nickname...", function(txt)
    local found = getplr(txt)
    if found then
        trg = found
    end
end)

Win:Label("Controls")

Win:Toggle("Enable Orbit", function(stt)
    enb = stt
    if stt then
        if trg then
            start()
        else
            enb = false
        end
    else
        pcall(function() RS:UnbindFromRenderStep("looped") end)
    end
end)

Win:Slider("Distance", 2, 20, 5, function(val)
    rad = val
end)

Win:Slider("Speed", 1, 50, 2, function(val)
    spd = val
end)

Win:Slider("Height", -10, 10, 0, function(val)
    hgt = val
end)