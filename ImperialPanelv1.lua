local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local Humanoid = Char:WaitForChild("Humanoid")
local HRP = Char:WaitForChild("HumanoidRootPart")

local targetSpeed = 16
local noclipOn = false
local guiVisible = true
local spawnPart = nil
local infiniteJump = false

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "ImperialPanel"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 430)
frame.Position = UDim2.new(0.5, -160, 0.5, -230)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.05
frame.Active = true
frame.Draggable = true

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Imperial Panel v1"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.LayoutOrder = 0

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 10)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.SortOrder = Enum.SortOrder.LayoutOrder

local padding = Instance.new("UIPadding", frame)
padding.PaddingTop = UDim.new(0, 10)

function createBtn(text, callback)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 280, 0, 32)
	b.Text = text
	b.TextColor3 = Color3.new(1, 1, 1)
	b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	b.AutoButtonColor = true
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.MouseButton1Click:Connect(callback)
	local corner = Instance.new("UICorner", b)
	corner.CornerRadius = UDim.new(0, 6)
	return b
end

function createBox()
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0, 280, 0, 32)
	box.PlaceholderText = "WalkSpeed (default = 16)"
	box.Text = ""
	box.TextColor3 = Color3.new(1, 1, 1)
	box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	box.ClearTextOnFocus = false
	box.Font = Enum.Font.Gotham
	box.TextSize = 14
	local corner = Instance.new("UICorner", box)
	corner.CornerRadius = UDim.new(0, 6)
	return box
end

LP.CharacterAdded:Connect(function(char)
	Char = char
	Humanoid = char:WaitForChild("Humanoid")
	HRP = char:WaitForChild("HumanoidRootPart")
end)

UIS.InputBegan:Connect(function(i, g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.Insert or i.KeyCode == Enum.KeyCode.K then
		guiVisible = not guiVisible
		frame.Visible = guiVisible
	end
end)

local wsBox = createBox()
wsBox.Parent = frame
wsBox.FocusLost:Connect(function()
	local val = tonumber(wsBox.Text)
	if val then
		targetSpeed = val
	end
end)

RunService.RenderStepped:Connect(function()
	if Humanoid and Humanoid.WalkSpeed ~= targetSpeed then
		Humanoid.WalkSpeed = targetSpeed
	end
end)

local noclipBtn = createBtn("Toggle Noclip", function()
	noclipOn = not noclipOn
end)
noclipBtn.Parent = frame

RunService.Stepped:Connect(function()
	if Char then
		for _, p in ipairs(Char:GetDescendants()) do
			if p:IsA("BasePart") then
				p.CanCollide = not noclipOn
			end
		end
	end
end)

local stealBtn = createBtn("Instant Steal", function()
	for _, p in ipairs(Workspace:GetDescendants()) do
		if p:IsA("ProximityPrompt") and string.lower(p.ActionText):find("steal") then
			pcall(function()
				p.HoldDuration = 0.05
				p.RequiresLineOfSight = false
				p.MaxActivationDistance = math.huge
				p.Enabled = true
				fireproximityprompt(p)
			end)
		end
	end
end)
stealBtn.Parent = frame

local placeBtn = createBtn("Place Spawn Point", function()
	if spawnPart then spawnPart:Destroy() end
	spawnPart = Instance.new("Part", Workspace)
	spawnPart.Name = "TP_SpawnPoint"
	spawnPart.Anchored = true
	spawnPart.CanCollide = false
	spawnPart.Transparency = 0.2
	spawnPart.Size = Vector3.new(4, 1, 4)
	spawnPart.Position = HRP.Position - Vector3.new(0, 3, 0)
	spawnPart.BrickColor = BrickColor.new("Bright blue")
end)
placeBtn.Parent = frame

local tpBtn = createBtn("Teleport to Spawn", function()
	if spawnPart then
		noclipOn = true
		Char:PivotTo(spawnPart.CFrame + Vector3.new(0, 3, 0))
		task.delay(0.5, function()
			noclipOn = false
		end)
	end
end)
tpBtn.Parent = frame

local infJumpBtn = createBtn("Toggle Infinite Jump", function()
	infiniteJump = not infiniteJump
end)
infJumpBtn.Parent = frame

UIS.JumpRequest:Connect(function()
	if infiniteJump and Humanoid then
		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

Humanoid.StateChanged:Connect(function(_, new)
	if new == Enum.HumanoidStateType.FallingDown or new == Enum.HumanoidStateType.Ragdoll then
		Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end)

local credits = Instance.new("TextLabel", frame)
credits.Size = UDim2.new(1, 0, 0, 25)
credits.BackgroundTransparency = 1
credits.Text = "Made by Crack.xyz - Press Insert or K"
credits.TextColor3 = Color3.fromRGB(180, 180, 180)
credits.Font = Enum.Font.Gotham
credits.TextSize = 12
credits.TextTransparency = 0.1
credits.LayoutOrder = 999

local warning = Instance.new("TextLabel", frame)
warning.Size = UDim2.new(1, 0, 0, 20)
warning.BackgroundTransparency = 1
warning.Text = "Some mods can cause freezes"
warning.TextColor3 = Color3.fromRGB(200, 100, 100)
warning.Font = Enum.Font.Gotham
warning.TextSize = 11
warning.LayoutOrder = 1000