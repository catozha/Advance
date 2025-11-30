local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local core = game:GetService("CoreGui")

local lp = plrs.LocalPlayer
local cam = workspace.CurrentCamera

local bind = Enum.KeyCode.RightAlt
local all = true
local good = false
local mid = false
local low = false
local vlow = false

local bg = Color3.fromRGB(25, 25, 25)
local top = Color3.fromRGB(35, 35, 35)
local item = Color3.fromRGB(40, 40, 40)
local txt = Color3.fromRGB(240, 240, 240)
local dim = Color3.fromRGB(150, 150, 150)

local off = Color3.fromRGB(60, 60, 60)
local on = Color3.fromRGB(0, 200, 100)

local cgood = Color3.fromRGB(50, 255, 100)
local cmid = Color3.fromRGB(255, 170, 0)
local clow = Color3.fromRGB(255, 50, 50)
local cbad = Color3.fromRGB(200, 0, 0)

local sg = Instance.new("ScreenGui")
sg.Name = "UI"
sg.ResetOnSpawn = false

pcall(function()
	sg.Parent = core
end)
if not sg.Parent then
	sg.Parent = lp:WaitForChild("PlayerGui")
end

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 260, 0, 385)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = bg
main.BorderSizePixel = 0
main.Parent = sg

local scale = Instance.new("UIScale")
scale.Scale = 1
scale.Parent = main

local mcorn = Instance.new("UICorner")
mcorn.CornerRadius = UDim.new(0, 12)
mcorn.Parent = main

local strk = Instance.new("UIStroke")
strk.Thickness = 2
strk.Color = Color3.fromRGB(50, 50, 50)
strk.Parent = main

local hdr = Instance.new("Frame")
hdr.Size = UDim2.new(1, 0, 0, 50)
hdr.BackgroundColor3 = top
hdr.BackgroundTransparency = 1
hdr.Parent = main

local ttl = Instance.new("TextLabel")
ttl.Text = "ESP Manager"
ttl.Font = Enum.Font.GothamBold
ttl.TextSize = 22
ttl.TextColor3 = txt
ttl.Size = UDim2.new(1, 0, 1, 0)
ttl.BackgroundTransparency = 1
ttl.Parent = hdr

local sub = Instance.new("TextLabel")
sub.Text = "[Right Alt] to Hide"
sub.Font = Enum.Font.Gotham
sub.TextSize = 11
sub.TextColor3 = dim
sub.Size = UDim2.new(1, 0, 0, 20)
sub.Position = UDim2.new(0, 0, 0, 38)
sub.BackgroundTransparency = 1
sub.Parent = hdr

local box = Instance.new("ScrollingFrame")
box.Size = UDim2.new(1, -20, 1, -70)
box.Position = UDim2.new(0, 10, 0, 70)
box.BackgroundTransparency = 1
box.ScrollBarThickness = 2
box.BorderSizePixel = 0
box.AutomaticCanvasSize = Enum.AutomaticSize.Y
box.CanvasSize = UDim2.new(0,0,0,0)
box.Parent = main

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 10)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = box

local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0, 5)
pad.PaddingBottom = UDim.new(0, 5)
pad.Parent = box

local drag = false
local dinp
local dstart
local spos

local function udrag(input)
	local delta = input.Position - dstart
	main.Position = UDim2.new(spos.X.Scale, spos.X.Offset + delta.X, spos.Y.Scale, spos.Y.Offset + delta.Y)
end

main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		drag = true
		dstart = input.Position
		spos = main.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				drag = false
			end
		end)
	end
end)

main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dinp = input
	end
end)

uis.InputChanged:Connect(function(input)
	if input == dinp and drag then
		udrag(input)
	end
end)

local function mktog(t, vname)
	local frm = Instance.new("Frame")
	frm.Size = UDim2.new(1, 0, 0, 45)
	frm.BackgroundColor3 = item
	frm.BorderSizePixel = 0
	
	local crn = Instance.new("UICorner")
	crn.CornerRadius = UDim.new(0, 8)
	crn.Parent = frm
	
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.6, 0, 1, 0)
	lbl.Position = UDim2.new(0, 15, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = t
	lbl.Font = Enum.Font.GothamSemibold
	lbl.TextSize = 14
	lbl.TextColor3 = txt
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = frm
	
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 50, 0, 26)
	btn.Position = UDim2.new(1, -60, 0.5, -13)
	
	local en = false
	if vname == "all" then en = all end
	if vname == "good" then en = good end
	if vname == "mid" then en = mid end
	if vname == "low" then en = low end
	if vname == "vlow" then en = vlow end
	
	if en then
		btn.BackgroundColor3 = on
	else
		btn.BackgroundColor3 = off
	end
	
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.Parent = frm
	
	local bcrn = Instance.new("UICorner")
	bcrn.CornerRadius = UDim.new(1, 0)
	bcrn.Parent = btn
	
	local circ = Instance.new("Frame")
	circ.Size = UDim2.new(0, 20, 0, 20)
	
	if en then
		circ.Position = UDim2.new(1, -23, 0.5, -10)
	else
		circ.Position = UDim2.new(0, 3, 0.5, -10)
	end
	
	circ.BackgroundColor3 = Color3.new(1,1,1)
	circ.Parent = btn
	
	local ccrn = Instance.new("UICorner")
	ccrn.CornerRadius = UDim.new(1, 0)
	ccrn.Parent = circ
	
	btn.MouseButton1Click:Connect(function()
		if vname == "all" then all = not all en = all end
		if vname == "good" then good = not good en = good end
		if vname == "mid" then mid = not mid en = mid end
		if vname == "low" then low = not low en = low end
		if vname == "vlow" then vlow = not vlow en = vlow end
		
		local tpos
		local tcol
		
		if en then
			tpos = UDim2.new(1, -23, 0.5, -10)
			tcol = on
		else
			tpos = UDim2.new(0, 3, 0.5, -10)
			tcol = off
		end
		
		ts:Create(circ, TweenInfo.new(0.2), {Position = tpos}):Play()
		ts:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = tcol}):Play()
	end)
	
	frm.Parent = box
end

mktog("Show All", "all")
mktog("Good HP (>70)", "good")
mktog("Mid HP (45-70)", "mid")
mktog("Low HP (25-45)", "low")
mktog("Very Low HP (<25)", "vlow")

local fld = Instance.new("Folder")
fld.Name = "Anticheat"
fld.Parent = sg

local function mkbb(p)
	if fld:FindFirstChild(p.Name) then return fld[p.Name] end

	local bb = Instance.new("BillboardGui")
	bb.Name = p.Name
	bb.AlwaysOnTop = true
	bb.Size = UDim2.new(0, 200, 0, 50)
	bb.StudsOffset = Vector3.new(0, 3.5, 0)
	
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, 0, 1, 0)
	t.BackgroundTransparency = 1
	t.TextStrokeTransparency = 0.5
	t.TextStrokeColor3 = Color3.new(0,0,0)
	t.Font = Enum.Font.GothamBold
	t.TextSize = 14
	t.Parent = bb
	
	bb.Parent = fld
	return bb
end

local function upd()
	for i, p in pairs(plrs:GetPlayers()) do
		if p ~= lp and p.Character then
			local c = p.Character
			local h = c:FindFirstChild("Head")
			local r = c:FindFirstChild("HumanoidRootPart")
			local hum = c:FindFirstChild("Humanoid")
			
			if h and r and hum and hum.Health > 0 then
				local hp = hum.Health
				local mag = (r.Position - cam.CFrame.Position).Magnitude
				local dist = math.floor(mag)
				
				local vis = false
				
				if all then
					vis = true
				else
					if good and hp >= 70 then vis = true end
					if mid and hp >= 45 and hp < 70 then vis = true end
					if low and hp >= 25 and hp < 45 then vis = true end
					if vlow and hp < 25 then vis = true end
				end
				
				local bb = fld:FindFirstChild(p.Name)
				if not bb then bb = mkbb(p) end
				
				if vis then
					bb.Enabled = true
					bb.Adornee = h
					
					local col = txt
					if hp >= 70 then col = cgood
					elseif hp >= 45 then col = cmid
					elseif hp >= 25 then col = clow
					else col = cbad
					end
					
					local l = bb:FindFirstChild("TextLabel")
					l.TextColor3 = col
					l.Text = p.Name .. "\n[" .. dist .. " m] [" .. math.floor(hp) .. " HP]"
				else
					bb.Enabled = false
				end
			else
				if fld:FindFirstChild(p.Name) then
					fld[p.Name].Enabled = false
				end
			end
		else
			if fld:FindFirstChild(p.Name) then
				fld[p.Name].Enabled = false
			end
		end
	end
end

rs.RenderStepped:Connect(upd)

plrs.PlayerRemoving:Connect(function(p)
	if fld:FindFirstChild(p.Name) then
		fld[p.Name]:Destroy()
	end
end)

local open = true

uis.InputBegan:Connect(function(inp, gpe)
	if inp.KeyCode == bind then
		open = not open
		
		if open then
			main.Visible = true
			ts:Create(scale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
		else
			local tw = ts:Create(scale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0})
			tw:Play()
			tw.Completed:Connect(function()
				if not open then main.Visible = false end
			end)
		end
	end
end)