--[[
	DanceAnimation (LocalScript)

	Procedural full-body 3D dance for R15 characters. It moves every joint from
	code, so there is no animation to upload. Works in Studio and published games.

	Setup:
	  1. In Roblox Studio, open StarterPlayer > StarterCharacterScripts.
	  2. Insert a LocalScript, name it "DanceAnimation", paste this code in.
	  3. Press Play, then press G to start/stop dancing.

	The dance bounces to the beat and switches between two moves every 8 beats:
	  - "Pump": arms punch up overhead, alternating left and right
	  - "Groove": arms out to the sides, rolling up and down like a wave
]]

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local TOGGLE_KEY = Enum.KeyCode.G
local BPM = 120             -- dance tempo (beats per minute)
local BEATS_PER_MOVE = 8    -- how many beats before switching moves
local BOUNCE_HEIGHT = 0.25  -- how far the body dips on each beat (studs)
local BLEND_SPEED = 5       -- how quickly the dance fades in/out

local rad, sin, cos, max = math.rad, math.sin, math.cos, math.max

local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")

if humanoid.RigType ~= Enum.HumanoidRigType.R15 then
	warn("DanceAnimation: this script needs an R15 character.")
	return
end

local function joint(partName, jointName)
	return character:WaitForChild(partName):WaitForChild(jointName)
end

local joints = {
	Root          = joint("LowerTorso", "Root"),
	Waist         = joint("UpperTorso", "Waist"),
	Neck          = joint("Head", "Neck"),
	RightShoulder = joint("RightUpperArm", "RightShoulder"),
	LeftShoulder  = joint("LeftUpperArm", "LeftShoulder"),
	RightElbow    = joint("RightLowerArm", "RightElbow"),
	LeftElbow     = joint("LeftLowerArm", "LeftElbow"),
	RightHip      = joint("RightUpperLeg", "RightHip"),
	LeftHip       = joint("LeftUpperLeg", "LeftHip"),
	RightKnee     = joint("RightLowerLeg", "RightKnee"),
	LeftKnee      = joint("LeftLowerLeg", "LeftKnee"),
}

-- Lower body + head: the same for every move. Bounce, hip sway, head nod.
local function basePose(phase)
	local dip = (1 - cos(phase)) * 0.5   -- 0..1, bottoms out once per beat
	local sway = sin(phase / 2)          -- -1..1, side to side every 2 beats

	return {
		Root      = CFrame.new(0, -dip * BOUNCE_HEIGHT, 0)
		            * CFrame.Angles(0, sway * rad(15), sway * rad(6)),
		Waist     = CFrame.Angles(0, -sway * rad(20), 0), -- counter-twist chest
		Neck      = CFrame.Angles(-dip * rad(12), sway * rad(10), 0), -- head bob
		RightHip  = CFrame.Angles(dip * rad(20), 0, 0),
		LeftHip   = CFrame.Angles(dip * rad(20), 0, 0),
		RightKnee = CFrame.Angles(-dip * rad(30), 0, 0),
		LeftKnee  = CFrame.Angles(-dip * rad(30), 0, 0),
	}
end

-- Move 1: alternating overhead arm pumps.
local function pumpArms(phase)
	local side = sin(phase / 2)
	local right = max(0, side)
	local left = max(0, -side)
	return {
		RightShoulder = CFrame.Angles(rad(60) + right * rad(110), 0, 0),
		LeftShoulder  = CFrame.Angles(rad(60) + left * rad(110), 0, 0),
		RightElbow    = CFrame.Angles(rad(90) * (1 - right), 0, 0),
		LeftElbow     = CFrame.Angles(rad(90) * (1 - left), 0, 0),
	}
end

-- Move 2: arms out to the sides, rolling like a wave.
local function grooveArms(phase)
	local roll = sin(phase)
	return {
		RightShoulder = CFrame.Angles(0, 0, rad(85) + roll * rad(25)),
		LeftShoulder  = CFrame.Angles(0, 0, -(rad(85) - roll * rad(25))),
		RightElbow    = CFrame.Angles(0, 0, -roll * rad(35)),
		LeftElbow     = CFrame.Angles(0, 0, -roll * rad(35)),
	}
end

local dancing = false
local blend = 0     -- 0 = normal pose, 1 = fully dancing
local moveMix = 0   -- 0 = pump, 1 = groove (smoothly crossfades)
local t = 0

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end -- ignore keys typed into chat, etc.
	if input.KeyCode == TOGGLE_KEY then
		dancing = not dancing
		if dancing then t = 0 end -- start each dance on the beat
	end
end)

-- Stepped runs after the default animations each frame, so these
-- Transforms layer on top of (and blend with) idle/walk animations.
local connection
connection = RunService.Stepped:Connect(function(_, dt)
	if humanoid.Health <= 0 then
		connection:Disconnect()
		return
	end

	blend += ((dancing and 1 or 0) - blend) * math.min(1, dt * BLEND_SPEED)
	if blend < 0.001 then return end

	t += dt
	local beat = t * BPM / 60
	local phase = beat * 2 * math.pi

	local moveTarget = math.floor(beat / BEATS_PER_MOVE) % 2
	moveMix += (moveTarget - moveMix) * math.min(1, dt * 4)

	local pose = basePose(phase)
	local pump, groove = pumpArms(phase), grooveArms(phase)
	for name, cf in pump do
		pose[name] = cf:Lerp(groove[name], moveMix)
	end

	for name, motor in joints do
		motor.Transform = motor.Transform:Lerp(pose[name], blend)
	end
end)
