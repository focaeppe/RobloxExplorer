-- Define properties for editing
TextProperties = {"ClassName", "Name", "Value", "Text", "Reflectance", "Transparency", "Heat", "TeamName", "WalkSpeed", "Health", "MaxHealth", "Size", "Position", "AccountAge", "RobloxLocked", "TeamColor", "userId", "Brightness", "Ambient", "TimeOfDay", "FieldOfView", "CameraType", "LinkedSource"}
BoolProperties = {"Anchored", "CanCollide", "Disabled", "Jump", "Sit", "Visible", "Enabled", "Locked", "FilteringEnabled", "StreamingEnabled", "GlobalShadows"}
BrickColorProperties = {"BrickColor", "Color", "TeamColor", "Texture", "Value"}

-- Create the main GUI button
if game.CoreGui:FindFirstChild("Explorer") then 
    game.CoreGui:FindFirstChild("Explorer"):Destroy() 
end

local s = Instance.new("ScreenGui", game.CoreGui)
s.Name = "Explorer"

local pgr = Instance.new("TextButton")
pgr.Parent = s
pgr.Size = UDim2.new(0, 100, 0, 40)
pgr.Position = UDim2.new(0, 30, 0, 440)
pgr.Text = "Explorer"
pgr.BackgroundTransparency = 0.3
pgr.TextColor3 = Color3.new(1, 1, 1)
pgr.BackgroundColor3 = Color3.new(0, 0, 0)
pgr.BorderSizePixel = 1
pgr.Font = Enum.Font.SourceSansBold
pgr.TextSize = 14

-- Variables for managing the GUI
local Cloned, Deleted, DeleteParent
local Gui
local Current = 0
local CurrentOption = 0

-- Helper function to clear the GUI
local function Clear()
    if Gui then 
        Gui:Destroy() 
    end
    Current = 0
    CurrentOption = 0
end

-- Function to add a button to the GUI
local function AddButton(N, Function, Color, Copy)
    local P = Instance.new("TextButton")
    P.Size = UDim2.new(0, 110, 0, 20)
    P.Text = N.Name
    P.Name = N.Name
    P.Parent = Gui
    P.BackgroundColor3 = Color
    P.TextColor3 = Color3.new(0, 0, 0)
    P.BackgroundTransparency = 0.5
    P.Position = UDim2.new(0, ((math.floor(Current / 30)) * 150) + 300, 0, 50 + (20 * ((Current % 30) - 1)))
    P.TouchTap:Connect(function() 
        Function(P) 
    end)

    if Copy then
        local C = Instance.new("TextButton")
        C.Size = UDim2.new(0, 20, 0, 20)
        C.Text = "C"
        C.Name = N.Name
        C.Parent = Gui
        C.BackgroundColor3 = Color3.new(0, 1, 0.5)
        C.TextColor3 = Color3.new(0, 0, 0)
        C.BackgroundTransparency = 0.5
        C.Position = UDim2.new(0, ((math.floor(Current / 30)) * 150) + 300 + 110, 0, 50 + (20 * ((Current % 30) - 1)))
        C.TouchTap:Connect(function()
            Cloned = N
            Clear()
            Search(N.Parent)
        end)
    end

    Current = Current + 1
    return P
end

-- Function to load object properties into the GUI
local function LoadOptions(Object)
    for _, Prop in pairs(TextProperties) do
        if pcall(function() return Object[Prop] end) then
            local T = Instance.new("TextBox")
            T.Size = UDim2.new(0, 150, 0, 20)
            T.Text = tostring(Object[Prop])
            T.Name = Prop
            T.Parent = Gui
            T.BackgroundColor3 = Color3.new(0.1, 0.4, 0.1)
            T.TextColor3 = Color3.new(0, 0, 0)
            T.BackgroundTransparency = 0.5
            T.Position = UDim2.new(0, ((math.floor(CurrentOption / 30)) * 150) + 150, 0, 50 + (20 * ((CurrentOption % 30) - 1)))
            T.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    Object[Prop] = tonumber(T.Text) or T.Text
                end
            end)
            CurrentOption = CurrentOption + 1
        end
    end
end

-- Function to search and display children of an object
local function Search(Object)
    Gui = Instance.new("ScreenGui")
    Gui.Parent = game.CoreGui
    Gui.Name = "Explorer"

    if Object ~= game then
        AddButton({ Name = "Back" }, function() 
            Clear()
            Search(Object.Parent) 
        end, Color3.new(0.5, 1, 1), false)
    end

    AddButton({ Name = "Reload" }, function() 
        Clear()
        Search(Object) 
    end, Color3.new(0.2, 1, 0.2), false)

    if Cloned then
        AddButton({ Name = "Paste" }, function() 
            Cloned:Clone().Parent = Object 
            Clear()
            Search(Object)
        end, Color3.new(0.5, 1, 1), false)
    end

    if Deleted then
        AddButton({ Name = "Undo" }, function() 
            Deleted.Parent = DeleteParent 
            Deleted = nil
            DeleteParent = nil
            Clear()
            Search(Object)
        end, Color3.new(1, 0.6, 0.1), false)
    end

    LoadOptions(Object)

    for _, Obj in pairs(Object:GetChildren()) do
        AddButton(Obj, function() 
            Clear()
            Search(Obj) 
        end, Color3.new(1, 1, 1), true)
    end

    AddButton({ Name = "Close" }, Clear, Color3.new(1, 0.2, 0), false)
end

-- Connect the Explorer button
pgr.TouchTap:Connect(function()
    Clear()
    Search(game)
end)
