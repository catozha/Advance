-- fully open source.
-- bypasses are very simple, but it bypasses anticheat in games like YBA, Jujtusu Shenanigans and Blox Fruits (buggy) and maybe other, only tested this trio
-- right shift to hide

local tws = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local plr = game:GetService("Players")
local lp = plr.LocalPlayer
local cam = workspace.CurrentCamera

local cfg = {
	name = "Ctz Utility",
	key = Enum.KeyCode.RightShift,
	size = UDim2.fromOffset(450, 240),
	aspeed = 0.4
}

local thm = {
	bg = Color3.fromRGB(20, 20, 24),
	sec = Color3.fromRGB(30, 30, 35),
	acc = Color3.fromRGB(0, 69, 104),
	txt = Color3.fromRGB(255, 255, 255),
	dim = Color3.fromRGB(130, 130, 140),
}

local isopen = true
local vflyspeed = 1 -- default fly speed
local qefly = false -- set to true if you want to move higher pressing E and lower pressing Q like in Infinite Yield
local wsval = 35 -- default speedhack speed
local spdenabled = false


-- gui protection, but i don't think someone need this in 2025
local function getpar()
	if (not rs:IsStudio()) and (gethui) then
		return gethui()
	end
	return lp:WaitForChild("PlayerGui")
end

local function corn(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = p
	return c
end

local function pad(p, h, v)
	local pd = Instance.new("UIPadding")
	pd.PaddingTop = UDim.new(0, v)
	pd.PaddingBottom = UDim.new(0, v)
	pd.PaddingLeft = UDim.new(0, h)
	pd.PaddingRight = UDim.new(0, h)
	pd.Parent = p
	return pd
end

local function drag(f)
	local dragging, draginp, dragstart, startpos
	f.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragstart = inp.Position
			startpos = f.Position
			inp.Changed:Connect(function()
				if inp.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	f.InputChanged:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseMovement then
			draginp = inp
		end
	end)
	uis.InputChanged:Connect(function(inp)
		if inp == draginp and dragging then
			local delta = inp.Position - dragstart
			tws:Create(f, TweenInfo.new(0.05), {
				Position = UDim2.new(startpos.X.Scale, startpos.X.Offset + delta.X, startpos.Y.Scale, startpos.Y.Offset + delta.Y)
			}):Play()
		end
	end)
end

local sg = Instance.new("ScreenGui")
sg.ResetOnSpawn = false
sg.Parent = getpar()

local mf = Instance.new("Frame")
mf.AnchorPoint = Vector2.new(0.5, 0.5)
mf.Position = UDim2.fromScale(0.5, 0.5)
mf.Size = cfg.size
mf.BackgroundColor3 = thm.bg
mf.BorderSizePixel = 0
mf.Parent = sg
corn(mf, 12)
drag(mf)

local ms = Instance.new("UIScale")
ms.Scale = 1
ms.Parent = mf

local str = Instance.new("UIStroke")
str.Color = thm.sec
str.Thickness = 1.5
str.Parent = mf

local tb = Instance.new("Frame")
tb.Size = UDim2.new(1, 0, 0, 45)
tb.BackgroundTransparency = 1
tb.Parent = mf

local ttl = Instance.new("TextLabel")
ttl.Text = "Ctz<b> Utility</b>"
ttl.RichText = true
ttl.Font = Enum.Font.GothamBold
ttl.TextSize = 18
ttl.TextColor3 = thm.txt
ttl.Size = UDim2.new(1, -50, 1, 0)
ttl.Position = UDim2.new(0, 20, 0, 0)
ttl.BackgroundTransparency = 1
ttl.TextXAlignment = Enum.TextXAlignment.Left
ttl.Parent = tb

local cls = Instance.new("TextButton")
cls.Text = "—"
cls.Font = Enum.Font.GothamBlack
cls.TextSize = 18
cls.TextColor3 = thm.dim
cls.BackgroundTransparency = 1
cls.Size = UDim2.new(0, 30, 0, 30)
cls.Position = UDim2.new(1, -35, 0.5, 0)
cls.AnchorPoint = Vector2.new(0, 0.5)
cls.Parent = tb
corn(cls, 6)

local cnt = Instance.new("ScrollingFrame")
cnt.Size = UDim2.new(1, 0, 1, -50)
cnt.Position = UDim2.new(0, 0, 0, 50)
cnt.BackgroundTransparency = 1
cnt.BorderSizePixel = 0
cnt.ScrollBarThickness = 2
cnt.ScrollBarImageColor3 = thm.acc
cnt.AutomaticCanvasSize = Enum.AutomaticSize.Y 
cnt.CanvasSize = UDim2.new(0, 0, 0, 0) 
cnt.Parent = mf
pad(cnt, 15, 5)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = cnt

local function tog(txt, cb)
	local btn = Instance.new("TextButton")
	btn.Text = ""
	btn.Size = UDim2.new(1, 0, 0, 42)
	btn.BackgroundColor3 = thm.sec
	btn.AutoButtonColor = false
	btn.Parent = cnt
	corn(btn, 8)

	local lbl = Instance.new("TextLabel")
	lbl.Text = txt
	lbl.Font = Enum.Font.GothamMedium
	lbl.TextSize = 14
	lbl.TextColor3 = thm.txt
	lbl.BackgroundTransparency = 1
	lbl.Size = UDim2.new(1, -20, 1, 0)
	lbl.Position = UDim2.new(0, 12, 0, 0)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = btn

	local ind = Instance.new("Frame")
	ind.Size = UDim2.new(0, 12, 0, 12)
	ind.Position = UDim2.new(1, -25, 0.5, 0)
	ind.AnchorPoint = Vector2.new(0, 0.5)
	ind.BackgroundColor3 = thm.dim
	ind.Parent = btn
	corn(ind, 3)

	local en = false
	btn.MouseEnter:Connect(function() tws:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play() end)
	btn.MouseLeave:Connect(function() tws:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = thm.sec}):Play() end)
	btn.MouseButton1Click:Connect(function()
		en = not en
		if en then
			tws:Create(ind, TweenInfo.new(0.2), {BackgroundColor3 = thm.acc}):Play()
			lbl.TextColor3 = thm.txt
		else
			tws:Create(ind, TweenInfo.new(0.2), {BackgroundColor3 = thm.dim}):Play()
			lbl.TextColor3 = thm.txt
		end
		if cb then cb(en) end
	end)
end

local function sli(txt, min, max, def, cb)
	local ctn = Instance.new("Frame")
	ctn.Size = UDim2.new(1, 0, 0, 50)
	ctn.BackgroundColor3 = thm.sec
	ctn.Parent = cnt
	corn(ctn, 8)

	local lbl = Instance.new("TextLabel")
	lbl.Text = txt
	lbl.Font = Enum.Font.GothamMedium
	lbl.TextSize = 14
	lbl.TextColor3 = thm.txt
	lbl.BackgroundTransparency = 1
	lbl.Size = UDim2.new(1, -20, 0, 25)
	lbl.Position = UDim2.new(0, 12, 0, 0)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = ctn

	local vlbl = Instance.new("TextLabel")
	vlbl.Text = tostring(def)
	vlbl.Font = Enum.Font.GothamBold
	vlbl.TextSize = 14
	vlbl.TextColor3 = thm.dim
	vlbl.BackgroundTransparency = 1
	vlbl.Size = UDim2.new(0, 50, 0, 25)
	vlbl.Position = UDim2.new(1, -12, 0, 0)
	vlbl.AnchorPoint = Vector2.new(1, 0)
	vlbl.TextXAlignment = Enum.TextXAlignment.Right
	vlbl.Parent = ctn

	local sbg = Instance.new("TextButton")
	sbg.Text = ""
	sbg.AutoButtonColor = false
	sbg.Size = UDim2.new(1, -24, 0, 6)
	sbg.Position = UDim2.new(0, 12, 0, 32)
	sbg.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
	sbg.Parent = ctn
	corn(sbg, 3)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
	fill.BackgroundColor3 = thm.acc
	fill.BorderSizePixel = 0
	fill.Parent = sbg
	corn(fill, 3)

	local drag = false
	local function up(inp)
		local pos = math.clamp((inp.Position.X - sbg.AbsolutePosition.X) / sbg.AbsoluteSize.X, 0, 1)
		local val = math.floor(min + ((max - min) * pos))
		tws:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
		vlbl.Text = tostring(val)
		if cb then cb(val) end
	end
	sbg.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; up(inp) end
	end)
	uis.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
	end)
	uis.InputChanged:Connect(function(inp)
		if drag and inp.UserInputType == Enum.UserInputType.MouseMovement then up(inp) end
	end)
end

local flying = false
local fdown, fup

function getroot(c)
	local r = c:FindFirstChild('HumanoidRootPart') or c:FindFirstChild('Torso') or c:FindFirstChild('UpperTorso')
	return r
end

function sfly(vfly)
	local p = plr.LocalPlayer
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

	fdown = uis.InputBegan:Connect(function(i, p)
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

	fup = uis.InputEnded:Connect(function(i, p)
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
	if lp.Character and lp.Character:FindFirstChildOfClass('Humanoid') then
		lp.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
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
	
	rs.RenderStepped:Connect(function()
		if spdenabled then
			local c = lp.Character
			local h = c and c:FindFirstChild("Humanoid")
			if h then
				h.WalkSpeed = wsval
			end
		end
	end)
end

-- uncomment if you want to auto-enable
-- task.spawn(sfly) 
task.spawn(initspeed) -- do not touch this or speedhack will break

tog("Enable Fly", function(s)
	if s then
		sfly(true) 
	else
		nofly()
	end
end)

sli("Fly Speed", 1, 10, 1, function(v)
	vflyspeed = v
end)

local sep = Instance.new("Frame")
sep.Size = UDim2.new(1, 0, 0, 2)
sep.BackgroundColor3 = thm.bg
sep.BorderSizePixel = 0
sep.Parent = cnt

tog("Enable Speedboost", function(s)
	spdenabled = s
	if not s and lp.Character then
		local h = lp.Character:FindFirstChild("Humanoid")
		if h then h.WalkSpeed = 16 end
	end
end)

sli("Walk Speed", 10, 500, 35, function(v)
	wsval = v
end)

local function togg()
	if isopen then
		isopen = false
		local tw = tws:Create(ms, TweenInfo.new(cfg.aspeed, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0})
		tw:Play()
		tw.Completed:Connect(function()
			if not isopen then mf.Visible = false end
		end)
	else
		isopen = true
		mf.Visible = true
		tws:Create(ms, TweenInfo.new(cfg.aspeed, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
	end
end

cls.MouseButton1Click:Connect(togg)
uis.InputBegan:Connect(function(i, gp)
	if not gp and i.KeyCode == cfg.key then
		togg()
	end
end)

mf.Visible = true
ms.Scale = 1