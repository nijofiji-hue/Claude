--[[
	WaveAnimation (LocalScript)

	Procedural wave animation for R15 characters. No animation upload needed,
	so it works in Studio and in published games.

	Setup:
	  1. In Roblox Studio, open StarterPlayer > StarterCharacterScripts.
	  2. Insert a LocalScript, name it "WaveAnimation", paste this code in.
	  3. Press Play, then press E to start/stop waving.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local TOGGLE_KEY = Enum.KeyCode.E
local WAVE_SPEED = 8          -- how fast the hand waves back and forth
local WAVE_AMOUNT = math.rad(30) -- how far the forearm swings
local ARM_RAISE = math.rad(150)  -- how high the arm is lifted
local BLEND_SPEED = 6         -- how quickly the wave fades in/out

local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")

if humanoid.RigType ~= Enum.HumanoidRigType.R15 then
	warn("WaveAnimation: this script needs an R15 character.")
	return
end

local shoulder = character:WaitForChild("RightUpperArm"):WaitForChild("RightShoulder")
local elbow = character:WaitForChild("RightLowerArm"):WaitForChild("RightElbow")

local waving = false
local blend = 0 -- 0 = normal pose, 1 = fully waving
local t = 0

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end -- ignore keys typed into chat, etc.
	if input.KeyCode == TOGGLE_KEY then
		waving = not waving
	end
end)

-- Stepped runs after the default animations are applied each frame,
-- so setting Transform here layers the wave on top of walking/idle.
local connection
connection = RunService.Stepped:Connect(function(_, dt)
	if humanoid.Health <= 0 then
		connection:Disconnect()
		return
	end

	local target = waving and 1 or 0
	blend += (target - blend) * math.min(1, dt * BLEND_SPEED)
	if blend < 0.001 then return end

	t += dt

	-- Lift the arm out to the side and up over the head.
	local shoulderWave = CFrame.Angles(0, 0, ARM_RAISE)
	-- Swing the forearm side to side.
	local elbowWave = CFrame.Angles(0, 0, math.sin(t * WAVE_SPEED) * WAVE_AMOUNT)

	shoulder.Transform = shoulder.Transform:Lerp(shoulderWave, blend)
	elbow.Transform = elbow.Transform:Lerp(elbowWave, blend)
end)
