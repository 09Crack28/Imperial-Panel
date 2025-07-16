local Library = {}
Library.__index = Library

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local function animate(instance, goal, time, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(time, easingStyle, easingDirection)
    local tween = TweenService:Create(instance, tweenInfo, goal)
    tween:Play()
end

function Library.new()
    local self = setmetatable({}, Library)
  
    self.gui = Instance.new("ScreenGui", CoreGui)
    self.gui.Name = "AdvancedExecutorPanel"
  
    self.frame = Instance.new("Frame", self.gui)
    self.frame.Size = UDim2.new(0, 320, 0, 360)
    self.frame.Position = UDim2.new(0.5, -160, 0.5, -180)
    self.frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.frame.BorderSizePixel = 0
    self.frame.BackgroundTransparency = 0.1
    self.frame.Active = true
    self.frame.Draggable = true
    Instance.new("UICorner", self.frame).CornerRadius = UDim.new(0, 12)
  
    local shadow = Instance.new("ImageLabel", self.frame)
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://2071824617"
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
  
    self.title = Instance.new("TextLabel", self.frame)
    self.title.Size = UDim2.new(1, 0, 0, 50)
    self.title.Position = UDim2.new(0, 0, 0, 10)
    self.title.BackgroundTransparency = 1
    self.title.Text = "Advanced Executor"
    self.title.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.title.Font = Enum.Font.GothamBold
    self.title.TextSize = 24
    self.title.TextStrokeTransparency = 0.8
    self.title.TextYAlignment = Enum.TextYAlignment.Center
  
    animate(self.title, {TextTransparency = 0}, 0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
  
    self.pages = {}
    self.currentPage = 1

    return self
end

function Library:createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 280, 0, 40)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.AutoButtonColor = true
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
  
    button.BackgroundTransparency = 1
    animate(button, {BackgroundTransparency = 0.05}, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
  
    button.MouseButton1Click:Connect(function()
        callback()
        animate(button, {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}, 0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        wait(0.2)
        animate(button, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    end)

    return button
end

function Library:createTextBox(placeholderText)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 280, 0, 40)
    textBox.PlaceholderText = placeholderText or "Entrez votre texte ici"
    textBox.Text = ""
    textBox.TextColor3 = Color3.new(1, 1, 1)
    textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    textBox.ClearTextOnFocus = false
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 16
    Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 8)
  
    textBox.BackgroundTransparency = 1
    animate(textBox, {BackgroundTransparency = 0.1}, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

    return textBox
end

function Library:createToggle(text, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 280, 0, 40)
    toggle.Text = text
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggle.AutoButtonColor = true
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 16
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)
  
    toggle.BackgroundTransparency = 1
    animate(toggle, {BackgroundTransparency = 0.05}, 0.3, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
  
    toggle.MouseButton1Click:Connect(function()
        local state = not toggle.Text:find("ON")
        callback(state)
        toggle.Text = state and text .. " ON" or text .. " OFF"
        animate(toggle, {BackgroundColor3 = state and Color3.fromRGB(70, 180, 70) or Color3.fromRGB(180, 70, 70)}, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    end)

    return toggle
end


function Library:switchPage(to)
    if to < 1 or to > #self.pages then return end
    self.pages[self.currentPage].Visible = false
    self.currentPage = to
    self.pages[self.currentPage].Visible = true
end

return Library
