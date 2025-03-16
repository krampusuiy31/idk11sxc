-- Оптимизированная красивая UI библиотека для Roblox
local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Конфигурация
local Config = {
    MainColor = Color3.fromRGB(40, 40, 40),
    AccentColor = Color3.fromRGB(70, 130, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    TweenSpeed = 0.2,
    EasingStyle = Enum.EasingStyle.Quart,
    CornerRadius = UDim.new(0, 5)
}

-- Утилиты
local function Create(instanceType, properties)
    local instance = Instance.new(instanceType)
    for property, value in pairs(properties or {}) do
        instance[property] = value
    end
    return instance
end

local function Tween(instance, properties, duration)
    local tween = TweenService:Create(instance, TweenInfo.new(duration or Config.TweenSpeed, Config.EasingStyle), properties)
    tween:Play()
    return tween
end

local function ApplyCorner(instance, radius)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = radius or Config.CornerRadius
    UICorner.Parent = instance
    return UICorner
end

local function Dragify(frame)
    local startPos, dragStart, dragging
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Создание основного окна
function Library:CreateWindow(title)
    local ScreenGui = Create("ScreenGui", {
        Name = "BeautifulUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = game.CoreGui
    })
    
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = Config.MainColor,
        Size = UDim2.new(0, 500, 0, 350),
        Position = UDim2.new(0.5, -250, 0.5, -175),
        Parent = ScreenGui
    })
    
    ApplyCorner(MainFrame)
    Dragify(MainFrame)
    
    local TopBar = Create("Frame", {
        Name = "TopBar",
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Size = UDim2.new(1, 0, 0, 30),
        Parent = MainFrame
    })
    
    ApplyCorner(TopBar)
    
    local TitleLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Font = Config.Font,
        TextColor3 = Config.TextColor,
        TextSize = 16,
        Text = title or "UI Library",
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })
    
    local CloseButton = Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -30, 0, 0),
        Font = Config.Font,
        TextColor3 = Config.TextColor,
        TextSize = 16,
        Text = "×",
        Parent = TopBar
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
    
    local ContentFrame = Create("ScrollingFrame", {
        Name = "ContentFrame",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -40),
        Position = UDim2.new(0, 10, 0, 35),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Config.AccentColor,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = MainFrame
    })
    
    local UIListLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = ContentFrame
    })
    
    local UILibrary = {}
    
    -- Создание Toggle
    function UILibrary:CreateToggle(text, defaultState, callback)
        local toggleState = defaultState or false
        
        local ToggleFrame = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(45, 45, 45),
            Size = UDim2.new(1, 0, 0, 35),
            Parent = ContentFrame
        })
        
        ApplyCorner(ToggleFrame)
        
        local ToggleLabel = Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            Font = Config.Font,
            TextColor3 = Config.TextColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = text or "Toggle",
            Parent = ToggleFrame
        })
        
        local ToggleButton = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(60, 60, 60),
            Size = UDim2.new(0, 40, 0, 20),
            Position = UDim2.new(1, -50, 0.5, -10),
            Parent = ToggleFrame
        })
        
        ApplyCorner(ToggleButton, UDim.new(0, 10))
        
        local ToggleCircle = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, 2, 0.5, -8),
            Parent = ToggleButton
        })
        
        ApplyCorner(ToggleCircle, UDim.new(1, 0))
        
        local function UpdateToggle()
            if toggleState then
                Tween(ToggleButton, {BackgroundColor3 = Config.AccentColor})
                Tween(ToggleCircle, {Position = UDim2.new(0, 22, 0.5, -8)})
            else
                Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
                Tween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, -8)})
            end
            
            if callback then callback(toggleState) end
        end
        
        ToggleFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                toggleState = not toggleState
                UpdateToggle()
            end
        end)
        
        if defaultState then UpdateToggle() end
        
        return {
            Set = function(self, state)
                toggleState = state
                UpdateToggle()
            end,
            Get = function() return toggleState end
        }
    end
    
    -- Создание Slider
    function UILibrary:CreateSlider(text, min, max, defaultValue, callback)
        local sliderValue = defaultValue or min
        
        local SliderFrame = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(45, 45, 45),
            Size = UDim2.new(1, 0, 0, 50),
            Parent = ContentFrame
        })
        
        ApplyCorner(SliderFrame)
        
        local SliderLabel = Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -50, 0, 20),
            Position = UDim2.new(0, 10, 0, 5),
            Font = Config.Font,
            TextColor3 = Config.TextColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = text or "Slider",
            Parent = SliderFrame
        })
        
        local ValueLabel = Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 40, 0, 20),
            Position = UDim2.new(1, -50, 0, 5),
            Font = Config.Font,
            TextColor3 = Config.TextColor,
            TextSize = 14,
            Text = tostring(sliderValue),
            Parent = SliderFrame
        })
        
        local SliderBG = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Size = UDim2.new(1, -20, 0, 8),
            Position = UDim2.new(0, 10, 0, 30),
            Parent = SliderFrame
        })
        
        ApplyCorner(SliderBG, UDim.new(0, 4))
        
        local SliderFill = Create("Frame", {
            BackgroundColor3 = Config.AccentColor,
            Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0),
            Parent = SliderBG
        })
        
        ApplyCorner(SliderFill, UDim.new(0, 4))
        
        local function UpdateSlider(posX)
            local percent = math.clamp((posX - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * percent
            value = math.round(value * 10) / 10 -- Округляем до 1 десятичного знака
            
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            ValueLabel.Text = tostring(value)
            sliderValue = value
            
            if callback then callback(value) end
        end
        
        SliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local connection
                connection = RunService.RenderStepped:Connect(function()
                    UpdateSlider(Mouse.X)
                end)
                
                UserInputService.InputEnded:Connect(function(endInput)
                    if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                        if connection then connection:Disconnect() end
                    end
                end)
            end
        end)
        
        return {
            Set = function(self, value)
                local newValue = math.clamp(value, min, max)
                local percent = (newValue - min) / (max - min)
                SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                ValueLabel.Text = tostring(newValue)
                sliderValue = newValue
                if callback then callback(newValue) end
            end,
            Get = function() return sliderValue end
        }
    end
    
    -- Создание кнопки
    function UILibrary:CreateButton(text, callback)
        local ButtonFrame = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(45, 45, 45),
            Size = UDim2.new(1, 0, 0, 35),
            Parent = ContentFrame
        })
        
        ApplyCorner(ButtonFrame)
        
        local Button = Create("TextButton", {
            BackgroundColor3 = Config.AccentColor,
            Size = UDim2.new(1, -20, 1, -10),
            Position = UDim2.new(0, 10, 0, 5),
            Font = Config.Font,
            TextColor3 = Config.TextColor,
            TextSize = 14,
            Text = text or "Button",
            Parent = ButtonFrame
        })
        
        ApplyCorner(Button)
        
        Button.MouseButton1Down:Connect(function()
            Tween(Button, {Size = UDim2.new(1, -24, 1, -14), Position = UDim2.new(0, 12, 0, 7)}, 0.1)
        end)
        
        Button.MouseButton1Up:Connect(function()
            Tween(Button, {Size = UDim2.new(1, -20, 1, -10), Position = UDim2.new(0, 10, 0, 5)}, 0.1)
            if callback then callback() end
        end)
    end
    
    -- Создание TextBox
    function UILibrary:CreateTextBox(text, placeholder, callback)
        local TextBoxFrame = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(45, 45, 45),
            Size = UDim2.new(1, 0, 0, 35),
            Parent = ContentFrame
        })
        
        ApplyCorner(TextBoxFrame)
        
        local TextBoxLabel = Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0.4, 0, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            Font = Config.Font,
            TextColor3 = Config.TextColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = text or "Input",
            Parent = TextBoxFrame
        })
        
        local TextBox = Create("TextBox", {
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            Size = UDim2.new(0.55, 0, 0, 25),
            Position = UDim2.new(0.4, 5, 0.5, -12.5),
            Font = Config.Font,
            TextColor3 = Config.TextColor,
            TextSize = 14,
            PlaceholderText = placeholder or "Enter text...",
            Text = "",
            ClearTextOnFocus = false,
            Parent = TextBoxFrame
        })
        
        ApplyCorner(TextBox)
        
        TextBox.FocusLost:Connect(function(enterPressed)
            if callback then callback(TextBox.Text, enterPressed) end
        end)
        
        return {
            SetText = function(self, text) TextBox.Text = text end,
            GetText = function() return TextBox.Text end
        }
    end
    
    -- Создание Color Picker
    function UILibrary:CreateColorPicker(text, defaultColor, callback)
        local color = defaultColor or Color3.fromRGB(255, 255, 255)
        local hue, sat, val = Color3.toHSV(color)
        local expanded = false
        
        local PickerFrame = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(45, 45, 45),
            Size = UDim2.new(1, 0, 0, 35),
            ClipsDescendants = false,
            Parent = ContentFrame
        })
        
        ApplyCorner(PickerFrame)
        
        local Label = Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0.7, 0, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            Font = Config.Font,
            TextColor3 = Config.TextColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = text or "Color",
            Parent = PickerFrame
        })
        
        local ColorPreview = Create("Frame", {
            BackgroundColor3 = color,
            Size = UDim2.new(0, 25, 0, 25),
            Position = UDim2.new(1, -35, 0.5, -12.5),
            Parent = PickerFrame
        })
        
        ApplyCorner(ColorPreview)
        
        local ExpandArea = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            Size = UDim2.new(1, 0, 0, 150),
            Position = UDim2.new(0, 0, 1, 5),
            Visible = false,
            Parent = PickerFrame
        })
        
        ApplyCorner(ExpandArea)
        
        -- Цветовая область
        local ColorArea = Create("ImageLabel", {
            BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
            Size = UDim2.new(1, -30, 0, 100),
            Position = UDim2.new(0, 15, 0, 10),
            Image = "rbxassetid://4155801252",
            Parent = ExpandArea
        })
        
        ApplyCorner(ColorArea)
        
        -- Ползунок оттенка
        local HueSlider = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(1, -30, 0, 15),
            Position = UDim2.new(0, 15, 0, 120),
            Parent = ExpandArea
        })
        
        ApplyCorner(HueSlider)
        
        -- Градиент цветов
        local HueGradient = Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            }),
            Parent = HueSlider
        })
        
        local ColorDot = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(0, 8, 0, 8),
            Position = UDim2.new(sat, -4, 1 - val, -4),
            Parent = ColorArea
        })
        
        ApplyCorner(ColorDot, UDim.new(1, 0))
        
        local HueDot = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(0, 8, 1, 0),
            Position = UDim2.new(hue, -4, 0, 0),
            Parent = HueSlider
        })
        
        ApplyCorner(HueDot, UDim.new(1, 0))
        
        local function UpdateColor()
            local newColor = Color3.fromHSV(hue, sat, val)
            ColorPreview.BackgroundColor3 = newColor
            ColorArea.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            if callback then callback(newColor) end
            return newColor
        end
        
        local picking = false
        local pickType = nil
        
        ColorArea.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                picking = true
                pickType = "color"
            end
        end)
        
        HueSlider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                picking = true
                pickType = "hue"
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                picking = false
            end
        end)
        
        RunService.RenderStepped:Connect(function()
            if picking and pickType == "color" then
                local mousePos = UserInputService:GetMouseLocation() - Vector2.new(0, 36)
                local framePos = ColorArea.AbsolutePosition
                local frameSize = ColorArea.AbsoluteSize
                
                sat = math.clamp((mousePos.X - framePos.X) / frameSize.X, 0, 1)
                val = math.clamp(1 - ((mousePos.Y - framePos.Y) / frameSize.Y), 0, 1)
                
                ColorDot.Position = UDim2.new(sat, -4, 1 - val, -4)
                UpdateColor()
            elseif picking and pickType == "hue" then
                local mousePos = UserInputService:GetMouseLocation() - Vector2.new(0, 36)
                local framePos = HueSlider.AbsolutePosition
                local frameSize = HueSlider.AbsoluteSize
                
                hue = math.clamp((mousePos.X - framePos.X) / frameSize.X, 0, 1)
                HueDot.Position = UDim2.new(hue, -4, 0, 0)
                UpdateColor()
            end
        end)
        
        PickerFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                expanded = not expanded
                ExpandArea.Visible = expanded
            end
        end)
        
        UpdateColor()
        
        return {
            SetColor = function(self, newColor)
                hue, sat, val = Color3.toHSV(newColor)
                ColorDot.Position = UDim2.new(sat, -4, 1 - val, -4)
                HueDot.Position = UDim2.new(hue, -4, 0, 0)
                return UpdateColor()
            end,
            GetColor = function() return ColorPreview.BackgroundColor3 end
        }
    end
    
    -- Добавление разделителя
    function UILibrary:AddDivider()
        local DividerFrame = Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 10),
            Parent = ContentFrame
        })
        
        local Line = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(60, 60, 60),
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, 0.5, 0),
            Parent = DividerFrame
        })
    end
    
    -- Добавление заголовка
    function UILibrary:AddSection(text)
        local SectionLabel = Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 25),
            Font = Config.Font,
            TextColor3 = Config.AccentColor,
            TextSize = 16,
            Text = text or "Section",
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = ContentFrame
        })
    end
    
    return UILibrary
end

return Library
