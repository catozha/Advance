-- fully open source.
-- bypasses are very simple, but it works in games like YBA, Jujtusu Shenanigans and Blox Fruits (or more that i haven't tested yet)
-- right shift to hide/show ui

-- transferred from raw ui creation to uilib
local Lib = loadstring(game:HttpGet("https://pastebin.com/raw/cqURBATw"))()

-- code
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local workspace = game:GetService("Workspace")

local vflyspeed = 1
local qefly = false 
local wsval = 35
local spdenabled = false
local flying = false
local fdown, fup

function getroot(c)
	local r = c:FindFirstChild('HumanoidRootPart') or c:FindFirstChild('Torso') or c:FindFirstChild('UpperTorso')
	return r
end

function sfly(vfly)
	local p = Players.LocalPlayer
	local c = p.Character or p.CharacterAdded:Wait()
	local h = c:FindFirstChildOfClass("Humanoid")
	if not h then
		repeat task.wait() until c:FindFirstChildOfClass("Humanoid")
		h = c:FindFirstChildOfClass("Humanoid")
	end

	if fdown or fup then
		fdown:Disconnect()
		fup:Disconnect()
	end

	local t = getroot(c)
	local ctrl = {f = 0, b = 0, l = 0, r = 0, q = 0, e = 0}
	local lctrl = {f = 0, b = 0, l = 0, r = 0, q = 0, e = 0}
	local speed = 0

	local function fly()
		flying = true
		local bg = Instance.new('BodyGyro')
		local bv = Instance.new('BodyVelocity')
		bg.P = 9e4
		bg.Parent = t
		bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.CFrame = t.CFrame
		bv.Velocity = Vector3.new(0, 0, 0)
		bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		bv.Parent = t
		task.spawn(function()
			repeat task.wait()
				local cm = workspace.CurrentCamera
				if not vfly and h then
					h.PlatformStand = true
				end

				if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 or ctrl.q + ctrl.e ~= 0 then
					speed = 50
				elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 or ctrl.q + ctrl.e ~= 0) and speed ~= 0 then
					speed = 0
				end
				if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 or (ctrl.q + ctrl.e) ~= 0 then
					bv.Velocity = ((cm.CFrame.LookVector * (ctrl.f + ctrl.b)) + ((cm.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b + ctrl.q + ctrl.e) * 0.2, 0).p) - cm.CFrame.p)) * speed
					lctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
				elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and (ctrl.q + ctrl.e) == 0 and speed ~= 0 then
					bv.Velocity = ((cm.CFrame.LookVector * (lctrl.f + lctrl.b)) + ((cm.CFrame * CFrame.new(lctrl.l + lctrl.r, (lctrl.f + lctrl.b + ctrl.q + ctrl.e) * 0.2, 0).p) - cm.CFrame.p)) * speed
				else
					bv.Velocity = Vector3.new(0, 0, 0)
				end
				bg.CFrame = cm.CFrame
			until not flying
			ctrl = {f = 0, b = 0, l = 0, r = 0, q = 0, e = 0}
			lctrl = {f = 0, b = 0, l = 0, r = 0, q = 0, e = 0}
			speed = 0
			bg:Destroy()
			bv:Destroy()

			if h then h.PlatformStand = false end
		end)
	end

	fdown = UIS.InputBegan:Connect(function(i, p)
		if p then return end
		if i.KeyCode == Enum.KeyCode.W then
			ctrl.f = vflyspeed
		elseif i.KeyCode == Enum.KeyCode.S then
			ctrl.b = -vflyspeed
		elseif i.KeyCode == Enum.KeyCode.A then
			ctrl.l = -vflyspeed
		elseif i.KeyCode == Enum.KeyCode.D then
			ctrl.r = vflyspeed
		elseif i.KeyCode == Enum.KeyCode.E and qefly then
			ctrl.q = vflyspeed * 2
		elseif i.KeyCode == Enum.KeyCode.Q and qefly then
			ctrl.e = -vflyspeed * 2
		end
	end)

	fup = UIS.InputEnded:Connect(function(i, p)
		if p then return end
		if i.KeyCode == Enum.KeyCode.W then
			ctrl.f = 0
		elseif i.KeyCode == Enum.KeyCode.S then
			ctrl.b = 0
		elseif i.KeyCode == Enum.KeyCode.A then
			ctrl.l = 0
		elseif i.KeyCode == Enum.KeyCode.D then
			ctrl.r = 0
		elseif i.KeyCode == Enum.KeyCode.E then
			ctrl.q = 0
		elseif i.KeyCode == Enum.KeyCode.Q then
			ctrl.e = 0
		end
	end)
	fly()
end

function nofly()
	flying = false
	if fdown or fup then fdown:Disconnect() fup:Disconnect() end
	if LP.Character and LP.Character:FindFirstChildOfClass('Humanoid') then
		LP.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
	end
end

local function initspeed()
	local s, e = pcall(function()
		local p = game.Players.LocalPlayer
		local c = p.Character or p.CharacterAdded:Wait()
		local h = c:WaitForChild("Humanoid")

		local oi
		oi = hookmetamethod(game, "__index", function(s, k)
			if not checkcaller() and s == h and k == "WalkSpeed" then
				return 16
			end
			return oi(s, k)
		end)

		local oni
		oni = hookmetamethod(game, "__newindex", function(s, k, v)
			if spdenabled and not checkcaller() and s == h and k == "WalkSpeed" and v < wsval then
				return
			end
			return oni(s, k, v)
		end)
	end)
	
	RS.RenderStepped:Connect(function()
		if spdenabled then
			local c = LP.Character
			local h = c and c:FindFirstChild("Humanoid")
			if h then
				h.WalkSpeed = wsval
			end
		end
	end)
end

task.spawn(initspeed)

local Win = Lib.new({
	name = "Ctz <b>Utility</b>",
	key = Enum.KeyCode.RightShift,
	size = UDim2.fromOffset(450, 240),
	aspeed = 0.4,
    mode = "tabs"
})

Win:Tab("Flight")

Win:Toggle("Enable Fly", function(LibState)
	if LibState then
		sfly(true) 
	else
		nofly()
	end
end)

Win:Slider("Fly Speed", 1, 10, 1, function(LibVal)
	vflyspeed = LibVal
end)

Win:Tab("Movement")

Win:Toggle("Enable Speedboost", function(LibState)
	spdenabled = LibState
	if not LibState and LP.Character then
		local h = LP.Character:FindFirstChild("Humanoid")
		if h then h.WalkSpeed = 16 end
	end
end)

Win:Slider("Walk Speed", 10, 500, 35, function(LibVal)
	wsval = LibVal
end)

Win:Tab("Binds")

Win:Keybind("Toggle Fly", Enum.KeyCode.F, function()
    local currentState = not flying
    if currentState then
        sfly(true)
    else
        nofly()
    end
end)

Win:Keybind("Toggle Speedhack", Enum.KeyCode.V, function()
    spdenabled = not spdenabled
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = spdenabled and wsval or 16
    end
end)
