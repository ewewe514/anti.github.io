local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

local RuntimeItems = Workspace:WaitForChild("RuntimeItems")

function UpdateCamera()
    if Camera.CameraType == Enum.CameraType.Track then
        Camera.CameraType = Enum.CameraType.Custom
    end
end

function HandleSit(seat)
    if seat and Humanoid then
        Character:PivotTo(seat.CFrame)
        seat:Sit(Humanoid)
    end
    RunService.Heartbeat:Wait()
    if seat.Parent and seat.Parent.Name == "MaximGun" then
        Debris:AddItem(seat.Parent, 0)
    end
end

local function enableNoclip()
    RunService.Stepped:Connect(function()
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function teleportToPosition()
    local teleportPosition = Vector3.new(57, 3, -9000)
    local teleportCount = 10
    local delayTime = 0.1

    for i = 1, teleportCount do
        HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(delayTime)
    end
end

local function tryMaximGunNearCastle()
    local vampireCastle = Workspace:FindFirstChild("VampireCastle")
    if vampireCastle and vampireCastle.PrimaryPart then
        local closestGun
        for _, item in pairs(RuntimeItems:GetDescendants()) do
            if item:IsA("Model") and item.Name == "MaximGun" and item.PrimaryPart then
                local dist = (item.PrimaryPart.Position - vampireCastle.PrimaryPart.Position).Magnitude
                if dist <= 500 then
                    closestGun = item
                    break
                end
            end
        end

        if closestGun then
            local seat = closestGun:FindFirstChildWhichIsA("VehicleSeat", true)
            if seat then
                HandleSit(seat)
                enableNoclip()
            end
        end
    end
end

function BypassAC()
    local MaximGun = RuntimeItems:FindFirstChild("MaximGun")
    if MaximGun then
        local seat = MaximGun:FindFirstChildWhichIsA("VehicleSeat", true)
        if seat then HandleSit(seat) end
    else
        for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name == "MaximGun" then
                local seat = v:FindFirstChildWhichIsA("VehicleSeat", true)
                if seat then HandleSit(seat) end
            end
        end
    end
end

task.wait(2)
teleportToPosition()
tryMaximGunNearCastle()

RunService.Heartbeat:Connect(BypassAC)
Camera:GetPropertyChangedSignal("CameraType"):Connect(UpdateCamera)
UpdateCamera()
