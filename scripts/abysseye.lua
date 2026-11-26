local fortnite = (getgenv and getgenv()) or shared
local bytexfesettings = fortnite.neptunian or {}
if type(bytexfesettings) ~= "table" then bytexfesettings = {} end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local PlayerGui = Player.PlayerGui
local Cam = workspace.CurrentCamera

local Character, Humanoid, RootPart, Torso, Head
local RightArm, LeftArm, RightLeg, LeftLeg
local RootJoint, Neck, RightShoulder, LeftShoulder, RightHip, LeftHip

local IT = Instance.new
local CF = CFrame.new
local VT = Vector3.new
local RAD = math.rad
local C3 = Color3.new
local UD2 = UDim2.new
local BRICKC = BrickColor.new
local ANGLES = CFrame.Angles
local COS = math.cos
local SIN = math.sin
local ABS = math.abs
local MRANDOM = math.random

local Animation_Speed = 3
local Frame_Speed = 1/60
local Speed = 25
local ROOTC0 = CF(0,0,0) * ANGLES(RAD(-90),0,RAD(180))
local NECKC0 = CF(0,1,0) * ANGLES(RAD(-90),0,RAD(180))
local RIGHTSHOULDERC0 = CF(-0.5,0,0) * ANGLES(0,RAD(90),0)
local LEFTSHOULDERC0 = CF(0.5,0,0) * ANGLES(0,RAD(-90),0)
local DAMAGEMULTIPLIER = 1
local ANIM = "Idle"
local ATTACK = false
local EQUIPPED = false
local COMBO = 1
local Rooted = false
local SINE = 0
local CHANGE = 2/Animation_Speed
local FADERS = true
local UNANCHOR = true
local Disable_Jump = false

local ArtificialHB = IT("BindableEvent")
local tf = 0
RunService.Heartbeat:Connect(function(s)
	tf = tf + s
	if tf >= Frame_Speed then
		for _ = 1, math.floor(tf/Frame_Speed) do ArtificialHB:Fire() end
		tf = tf - Frame_Speed*math.floor(tf/Frame_Speed)
	end
end)

local function Swait(n)
	if n == 0 or n == nil then ArtificialHB.Event:Wait() else for _ = 1, n do ArtificialHB.Event:Wait() end end
end

local function bindCharacter(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
	RootPart = char:WaitForChild("HumanoidRootPart")
	Torso = char:WaitForChild("Torso")
	Head = char:WaitForChild("Head")
	RightArm = char:WaitForChild("Right Arm")
	LeftArm = char:WaitForChild("Left Arm")
	RightLeg = char:WaitForChild("Right Leg")
	LeftLeg = char:WaitForChild("Left Leg")
	RootJoint = RootPart:WaitForChild("RootJoint")
	Neck = Torso:WaitForChild("Neck")
	RightShoulder = Torso:WaitForChild("Right Shoulder")
	LeftShoulder = Torso:WaitForChild("Left Shoulder")
	RightHip = Torso:WaitForChild("Right Hip")
	LeftHip = Torso:WaitForChild("Left Hip")
end

local function stripAnims(char)
	for _, v in ipairs(char:GetDescendants()) do
		if v:IsA("Animator") then v:Destroy() end
		if v:IsA("Animation") then v:Destroy() end
	end
	local animate = char:FindFirstChild("Animate")
	if animate then animate:Destroy() end
end

local function bindAndInit(char)
	bindCharacter(char)
	stripAnims(char)
end

bindAndInit(Player.Character or Player.CharacterAdded:Wait())

local rp = RaycastParams.new()
rp.FilterType = Enum.RaycastFilterType.Exclude
local function Raycast(POS, DIR, RANGE, IGNORE)
	rp.FilterDescendantsInstances = IGNORE and {IGNORE} or {}
	return workspace:Raycast(POS, DIR.Unit*RANGE, rp)
end

local function CreateMesh(MESH, PARENT, MESHTYPE, MESHID, TEXTUREID, SCALE, OFFSET)
	local M = IT(MESH)
	if MESH == "SpecialMesh" then
		M.MeshType = MESHTYPE
		if MESHID and MESHID ~= "" then M.MeshId = "rbxassetid://"..MESHID end
		if TEXTUREID and TEXTUREID ~= "" then M.TextureId = "rbxassetid://"..TEXTUREID end
	end
	M.Offset = OFFSET or VT(0,0,0)
	M.Scale = SCALE
	M.Parent = PARENT
	return M
end

local function CreatePart(PARENT, MATERIAL, REFLECTANCE, TRANSPARENCY, BRICKCOLOR, NAME, SIZE, ANCHOR)
	local P = IT("Part")
	P.Reflectance = REFLECTANCE
	P.Transparency = TRANSPARENCY
	P.CanCollide = false
	P.Locked = true
	P.Anchored = (ANCHOR ~= false)
	P.BrickColor = BRICKC(tostring(BRICKCOLOR))
	P.Name = NAME
	P.Size = SIZE
	P.Position = Torso.Position
	P.Material = MATERIAL
	P.Parent = PARENT
	return P
end

local function CreateWeld(PARENT, P0, P1, C0, C1)
	local W = IT("ManualWeld")
	W.Part0 = P0; W.Part1 = P1
	W.C0 = C0 or CF(); W.C1 = C1 or CF()
	W.Parent = PARENT
	return W
end

local function CreateFrame(PARENT, TR, POS, SIZE, COL, NAME)
	local f = IT("Frame")
	f.BackgroundTransparency = TR; f.BorderSizePixel = 2
	f.Position = POS; f.Size = SIZE
	f.BackgroundColor3 = COL; f.BorderColor3 = C3(0,0,0)
	f.Name = NAME; f.Parent = PARENT
	return f
end

local function CreateLabel(PARENT, TEXT, TCOL, TSIZE, TFONT, TR, NAME)
	local l = IT("TextLabel")
	l.BackgroundTransparency = 1; l.Size = UD2(1,0,1,0)
	l.TextColor3 = TCOL; l.TextStrokeTransparency = 1; l.TextTransparency = TR
	l.Font = TFONT; l.BorderSizePixel = 2; l.Text = TEXT; l.Name = NAME
	l.Parent = PARENT
	return l
end

local function CreateSound(ID, PARENT, VOL, PITCH, LOOP)
	local s = IT("Sound")
	s.Parent = PARENT
	s.Volume = VOL or 5; s.Pitch = PITCH or 1
	s.SoundId = "rbxassetid://"..ID
	s.Looped = LOOP == true
	s:Play()
	if not LOOP then Debris:AddItem(s, 10) end
	return s
end

local function QFC(cf)
	local _,_,_,m00,m01,m02,m10,m11,m12,m20,m21,m22 = cf:components()
	local trace = m00+m11+m22
	if trace > 0 then
		local s = math.sqrt(1+trace); local r = 0.5/s
		return (m21-m12)*r,(m02-m20)*r,(m10-m01)*r,s*0.5
	else
		local i = 0
		if m11 > m00 then i = 1 end
		if m22 > (i == 0 and m00 or m11) then i = 2 end
		if i == 0 then
			local s = math.sqrt(m00-m11-m22+1); local r = 0.5/s
			return 0.5*s,(m10+m01)*r,(m20+m02)*r,(m21-m12)*r
		elseif i == 1 then
			local s = math.sqrt(m11-m22-m00+1); local r = 0.5/s
			return (m01+m10)*r,0.5*s,(m21+m12)*r,(m02-m20)*r
		else
			local s = math.sqrt(m22-m00-m11+1); local r = 0.5/s
			return (m02+m20)*r,(m12+m21)*r,0.5*s,(m10-m01)*r
		end
	end
end

local function QTC(px,py,pz,x,y,z,w)
	local xs,ys,zs = x+x,y+y,z+z
	local wx,wy,wz = w*xs,w*ys,w*zs
	local xx,xy,xz = x*xs,x*ys,x*zs
	local yy,yz,zz = y*ys,y*zs,z*zs
	return CFrame.new(px,py,pz,
		1-(yy+zz), xy-wz, xz+wy,
		xy+wz, 1-(xx+zz), yz-wx,
		xz-wy, yz+wx, 1-(xx+yy))
end

local function QSlerp(a,b,t)
	local ct = a[1]*b[1]+a[2]*b[2]+a[3]*b[3]+a[4]*b[4]
	local si,fi
	if ct >= 0.0001 then
		if (1-ct) > 0.0001 then
			local th = math.acos(ct); local inv = 1/math.sin(th)
			si = math.sin((1-t)*th)*inv; fi = math.sin(t*th)*inv
		else si = 1-t; fi = t end
	else
		if (1+ct) > 0.0001 then
			local th = math.acos(-ct); local inv = 1/math.sin(th)
			si = math.sin((t-1)*th)*inv; fi = math.sin(t*th)*inv
		else si = t-1; fi = t end
	end
	return a[1]*si+b[1]*fi,a[2]*si+b[2]*fi,a[3]*si+b[3]*fi,a[4]*si+b[4]*fi
end

local function Clerp(a,b,t)
	local qa = {QFC(a)}; local qb = {QFC(b)}
	local _t = 1-t
	return QTC(_t*a.x+t*b.x,_t*a.y+t*b.y,_t*a.z+t*b.z,QSlerp(qa,qb,t))
end

local function R_RANDOM(cfr, dist)
	return cfr*ANGLES(RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)))*CF(0,0,-dist)
end

local Effects = IT("Folder", Character)
Effects.Name = "Effects"

local function WACKYEFFECT(t)
	local cf = t.CFrame or CF()
	local size = t.Size or VT(1,1,1)
	local size2 = t.Size2 or VT(0.001,0.001,0.001)
	local tr = t.Transparency or 0
	local tr2 = t.Transparency2 or 1
	local col = t.Color or C3(1,1,1)
	local mat = t.Material or "Neon"
	local life = (t.Time or 20)/60
	local part = IT("Part")
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.Material = mat
	part.Color = col
	part.Transparency = tr
	part.Size = size
	part.CFrame = cf
	part.Parent = Effects
	local etype = t.EffectType
	if etype == "Sphere" then
		local m = IT("SpecialMesh", part); m.MeshType = "Sphere"
		TweenService:Create(m, TweenInfo.new(life), {Scale = size2}):Play()
	elseif etype == "Block" then
		local m = IT("BlockMesh", part)
		TweenService:Create(m, TweenInfo.new(life), {Scale = size2}):Play()
	elseif etype == "Wave" then
		local m = IT("SpecialMesh", part); m.MeshType = "Sphere"; m.Scale = VT(0.1,0.01,0.1)
		TweenService:Create(m, TweenInfo.new(life), {Scale = size2}):Play()
	elseif etype == "Round Slash" then
		local m = IT("SpecialMesh", part); m.MeshType = "Sphere"; m.Scale = VT(0.1,0.01,0.1)
		TweenService:Create(m, TweenInfo.new(life), {Scale = size2}):Play()
	end
	TweenService:Create(part, TweenInfo.new(life), {Transparency = tr2}):Play()
	if t.RotationX or t.RotationY or t.RotationZ then
		TweenService:Create(part, TweenInfo.new(life), {
			CFrame = cf * ANGLES(RAD(t.RotationX or 0), RAD(t.RotationY or 0), RAD(t.RotationZ or 0))
		}):Play()
	end
	if t.SoundID then CreateSound(t.SoundID, part, t.SoundVolume or 5, t.SoundPitch or 1, false) end
	Debris:AddItem(part, life + 0.1)
end

local function CharacterFade(col, timer, movedir, parent)
	local part = IT("Part")
	part.Anchored = true; part.CanCollide = false
	part.Material = "Neon"; part.Color = col or C3(0,0,0)
	part.Size = VT(1,1,1); part.Transparency = 0.3
	part.CFrame = CF(movedir or (Torso and Torso.Position) or VT(0,0,0))
	part.Parent = Effects
	TweenService:Create(part, TweenInfo.new((timer or 25)/60), {Size = VT(0.1,0.1,0.1), Transparency = 1}):Play()
	Debris:AddItem(part, (timer or 25)/60 + 0.1)
end

local function ApplyDamage(Hum, Dmg)
	if not Hum or Hum.Health <= 0 then return end
	Hum:TakeDamage(Dmg * DAMAGEMULTIPLIER)
end

local function ApplyAoE(POS, RANGE, MIN, MAX, FLING, INSTAKILL)
	for _, CHILD in ipairs(workspace:GetDescendants()) do
		if CHILD:IsA("Model") and CHILD ~= Character then
			local HUM = CHILD:FindFirstChildOfClass("Humanoid")
			if HUM then
				local TP = CHILD:FindFirstChild("Torso") or CHILD:FindFirstChild("UpperTorso")
				if TP and (TP.Position-POS).Magnitude <= RANGE then
					if INSTAKILL then CHILD:BreakJoints() else ApplyDamage(HUM, MRANDOM(MIN,MAX)) end
					if FLING > 0 then
						for _, c in ipairs(CHILD:GetChildren()) do
							if c:IsA("BasePart") then
								local bv = IT("BodyVelocity")
								bv.MaxForce = VT(1e9,1e9,1e9)
								bv.Velocity = CF(POS,TP.Position).LookVector*FLING
								bv.Parent = c
								Debris:AddItem(bv, 0.05)
							end
						end
					end
				end
			end
		end
	end
end

local BLADE = CreatePart(Effects, "Fabric", 0, 0, "Really black", "Abyssal_Sword", VT(1,7.6,1), true)
CreateMesh("SpecialMesh", BLADE, "FileMesh", "93117521", "1015990846", VT(1,1,1), VT(0,0,0))
BLADE.CFrame = RootPart.CFrame * CF(0.4,1,4) * ANGLES(RAD(195),RAD(15),RAD(15))
BLADE.Transparency = 1

local hatid = bytexfesettings.bhatid
local hatcf = bytexfesettings.bcframele
local hatlimb = bytexfesettings.bhatlimb or "Right Arm"
if bytexfesettings.usinghats and hatid and hatcf then
	local timeout = 0
	while not (Character and Character:FindFirstChild(hatlimb)) and timeout < 5 do
		task.wait(0.1); timeout = timeout + 0.1
	end
	pcall(function()
		local acc
		for _, v in ipairs(Character:GetChildren()) do
			if v:IsA("Accessory") or v:IsA("Hat") then acc = v; break end
		end
		if not acc then return end
		local handle = acc:FindFirstChild("Handle")
		if not handle then return end
		for _, v in ipairs(handle:GetChildren()) do
			if v:IsA("Weld") or v:IsA("Motor6D") or v:IsA("WeldConstraint") then v:Destroy() end
		end
		local grip = IT("Part")
		grip.Name = "AccessoryGrip"; grip.Size = VT(0.2,0.2,0.2)
		grip.Transparency = 1; grip.CanCollide = false; grip.Anchored = false
		grip.Parent = Character
		local gw = IT("Motor6D")
		gw.Name = "GripWeld"; gw.Part0 = Character:FindFirstChild(hatlimb) or RightArm; gw.Part1 = grip
		gw.C0 = hatcf; gw.Parent = grip
		local ap = IT("AlignPosition")
		ap.Attachment0 = IT("Attachment", handle)
		ap.Attachment1 = IT("Attachment", grip)
		ap.RigidityEnabled = false; ap.Responsiveness = 200; ap.MaxForce = 100000
		ap.Parent = handle
		local ao = IT("AlignOrientation")
		ao.Attachment0 = ap.Attachment0; ao.Attachment1 = ap.Attachment1
		ao.MaxTorque = 100000; ao.Responsiveness = 200; ao.Parent = handle
	end)
end

local EYE = IT("Part")
EYE.Name = "EYE"
EYE.Size = VT(1,1,1)
EYE.Transparency = 1
EYE.CanCollide = false
EYE.Anchored = false
EYE.Parent = Character
CreateWeld(EYE, RootPart, EYE, CF(0,3,0), CF())

local WEAPONGUI = IT("ScreenGui", PlayerGui)
WEAPONGUI.Name = "Weapon GUI"
WEAPONGUI.ResetOnSpawn = false

local SKILLTEXTCOLOR = C3(0,0,0)
local SKILLFONT = "Fantasy"
local SKILLTEXTSIZE = 4
local SKILLTEXTSIZE2 = 12
local ATTACKS = {"Abyssal Shriek - Z","Abyssal Dash - X","Shadow Cloak - C","Black Blast - V","Nightmare Fall - Q"}

for i = 1, #ATTACKS do
	local SKILLFRAME = CreateFrame(WEAPONGUI, 1, UD2(0.74,0,0.97-(0.04*i),0), UD2(0.26,0,0.07,0), C3(0,0,0), "Skill Frame")
	local SKILLTEXT = CreateLabel(SKILLFRAME, "["..ATTACKS[i].."]", SKILLTEXTCOLOR, SKILLTEXTSIZE, SKILLFONT, 0, "Skill text")
	SKILLTEXT.TextXAlignment = "Right"
	SKILLTEXT.Rotation = i*3
end

local BMUSIC = IT("Sound", RootPart)
BMUSIC.SoundId = "rbxassetid://1074563286"
BMUSIC.Looped = true
BMUSIC.Volume = 5
BMUSIC.Pitch = 1
BMUSIC:Play()

local A = IT("Attachment", Torso)

coroutine.resume(coroutine.create(function()
	while task.wait(1) do
		if FADERS and EYE and EYE.Parent then
			coroutine.resume(coroutine.create(function()
				local RING = CreatePart(Effects, "Granite", 0, 1, "Maroon", "MagicRing", VT(0.1,0.1,0.1), true)
				RING.Anchored = false
				CreateWeld(RING, EYE, RING, CF(), CF())
				local M = IT("SpecialMesh", RING); M.MeshType = "Sphere"
				local decal = IT("Decal", RING); decal.Face = "Top"
				decal.Texture = "rbxassetid://1208118228"
				for i = 1, 35 do
					Swait()
					M.Scale = M.Scale + VT(1,0,1)*1.2
					decal.Transparency = i/35
				end
				RING:Destroy()
			end))
		end
	end
end))

local function Melee()
	ATTACK = true
	BLADE.CanCollide = true
	Rooted = false
	EQUIPPED = true
	local HITS = {}
	local TOUCH = BLADE.Touched:Connect(function(hit)
		if hit.Parent and hit.Parent ~= Character and hit.Parent:FindFirstChildOfClass("Humanoid") then
			local HUM = hit.Parent:FindFirstChildOfClass("Humanoid")
			local TP = hit.Parent:FindFirstChild("Torso") or hit.Parent:FindFirstChild("UpperTorso")
			if TP and HUM.Health > 0 then
				local PASS = true
				for i = 1, #HITS do if HITS[i] == hit.Parent then PASS = false end end
				table.insert(HITS, hit.Parent)
				if PASS then ApplyDamage(HUM, MRANDOM(15,25)) end
			end
		end
	end)
	if COMBO == 1 then
		for i = 0, 0.35, 0.1/Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0.1*COS(SINE/12)) * ANGLES(0,0,RAD(-15)), 1/Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(0,0,RAD(15)), 1/Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5,0.5,0) * ANGLES(0,0,RAD(90)) * RIGHTSHOULDERC0, 1/Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-0.75,0.35,-0.6) * ANGLES(0,0,RAD(92)) * LEFTSHOULDERC0, 1/Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1,-0.6-0.05*SIN(SINE/12),-0.5) * ANGLES(0,RAD(70),0) * ANGLES(RAD(-1),0,RAD(-25)), 1/Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-1-0.05*SIN(SINE/12),0) * ANGLES(RAD(-5),RAD(-70),0) * ANGLES(RAD(1),0,0), 1/Animation_Speed)
			BLADE.CFrame = Clerp(BLADE.CFrame, RightArm.CFrame*CF(0,-8,0) * ANGLES(RAD(180),RAD(90),0), 0.4)
		end
		CreateSound(1489705211, BLADE, MRANDOM(7,8), MRANDOM(8,13)/12, false)
		for i = 0, 0.5, 0.1/Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0.1*COS(SINE/12)) * ANGLES(0,0,RAD(35)), 1/Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(0,0,RAD(-35)), 0.9/Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(0.8,0.5,-0.7) * ANGLES(0,0,RAD(-90)) * ANGLES(RAD(15),RAD(180),0) * RIGHTSHOULDERC0, 0.6/Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-0.75,0.35,-0.6) * ANGLES(0,0,RAD(92)) * LEFTSHOULDERC0, 1/Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1,-0.6-0.05*SIN(SINE/12),-0.5) * ANGLES(0,RAD(70),0) * ANGLES(RAD(-1),0,RAD(-25)), 1/Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-1-0.05*SIN(SINE/12),0) * ANGLES(RAD(-5),RAD(-70),0) * ANGLES(RAD(1),0,0), 1/Animation_Speed)
			BLADE.CFrame = Clerp(BLADE.CFrame, RightArm.CFrame*CF(0,-8,0) * ANGLES(RAD(180),RAD(90),0), 0.4)
		end
		TOUCH:Disconnect()
		COMBO = 2
	else
		for i = 0, 0.35, 0.1/Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0.1*COS(SINE/12)), 1/Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(RAD(-15),0,0), 1/Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5,0.75,0) * ANGLES(RAD(160),0,RAD(-5)) * RIGHTSHOULDERC0, 1/Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-0.75,0.35,-0.6) * ANGLES(0,0,RAD(92)) * LEFTSHOULDERC0, 1/Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1,-0.6-0.05*SIN(SINE/12),-0.5) * ANGLES(0,RAD(70),0) * ANGLES(RAD(-1),0,RAD(-25)), 1/Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-1-0.05*SIN(SINE/12),0) * ANGLES(RAD(-5),RAD(-70),0) * ANGLES(RAD(1),0,0), 1/Animation_Speed)
			BLADE.CFrame = Clerp(BLADE.CFrame, RightArm.CFrame*CF(0,-8,0) * ANGLES(RAD(180),RAD(90),0), 0.4)
		end
		CreateSound(1489705211, BLADE, MRANDOM(7,8), MRANDOM(8,13)/12, false)
		for i = 0, 0.35, 0.1/Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0.1*COS(SINE/12)) * ANGLES(0,0,RAD(15)), 1/Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(0,0,RAD(-15)), 0.8/Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1,0.25,-0.5) * ANGLES(RAD(85),0,RAD(-5)) * RIGHTSHOULDERC0, 1/Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-0.75,0.35,-0.6) * ANGLES(0,0,RAD(92)) * LEFTSHOULDERC0, 1/Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1,-0.6-0.05*SIN(SINE/12),-0.5) * ANGLES(0,RAD(70),0) * ANGLES(RAD(-1),0,RAD(-25)), 1/Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-1-0.05*SIN(SINE/12),0) * ANGLES(RAD(-5),RAD(-70),0) * ANGLES(RAD(1),0,0), 1/Animation_Speed)
			BLADE.CFrame = Clerp(BLADE.CFrame, RightArm.CFrame*CF(0,-8,0) * ANGLES(RAD(180),RAD(90),0), 0.4)
		end
		TOUCH:Disconnect()
		for i = 0, 0.2, 0.1/Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0.1*COS(SINE/12)) * ANGLES(0,0,RAD(15)), 1/Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(0,0,RAD(-15)), 0.8/Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1,0.25,-0.5) * ANGLES(RAD(85),0,RAD(-5)) * RIGHTSHOULDERC0, 1/Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-0.75,0.35,-0.6) * ANGLES(0,0,RAD(92)) * LEFTSHOULDERC0, 1/Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1,-0.6-0.05*SIN(SINE/12),-0.5) * ANGLES(0,RAD(70),0) * ANGLES(RAD(-1),0,RAD(-25)), 1/Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-1-0.05*SIN(SINE/12),0) * ANGLES(RAD(-5),RAD(-70),0) * ANGLES(RAD(1),0,0), 1/Animation_Speed)
			BLADE.CFrame = Clerp(BLADE.CFrame, RootPart.CFrame*CF(4,0.3,0) * ANGLES(RAD(195),RAD(-25),RAD(15)), 0.4)
		end
		COMBO = 1
	end
	coroutine.resume(coroutine.create(function()
		for i = 1, 50 do
			Swait()
			if ATTACK == true then break end
		end
		if ATTACK == false then COMBO = 1 end
	end))
	BLADE.CanCollide = false
	ATTACK = false
	EQUIPPED = false
end

local function AbyssalShriek()
	if ANIM ~= "Fall" and ANIM ~= "Jump" then
		ATTACK = true
		Rooted = true
		for i = 0, 0.2, 0.1/Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0.1*COS(SINE/12)), 1/Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(RAD(15-2.5*SIN(SINE/12)),0,0), 1/Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(0.75,0.5+0.05*SIN(SINE/12),-0.7) * ANGLES(0,0,RAD(-95)) * ANGLES(RAD(5),0,0) * RIGHTSHOULDERC0, 1/Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-0.75,0.35+0.05*SIN(SINE/12),-0.6) * ANGLES(0,0,RAD(92)) * LEFTSHOULDERC0, 1/Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1,-0.6-0.05*SIN(SINE/12),-0.5) * ANGLES(0,RAD(70),0) * ANGLES(RAD(-1),0,RAD(-15)), 1/Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-0.6-0.05*SIN(SINE/12),-0.5) * ANGLES(0,RAD(-70),0) * ANGLES(RAD(-1),0,RAD(15)), 1/Animation_Speed)
		end
		coroutine.resume(coroutine.create(function()
			repeat
				Swait()
				RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0.1*COS(SINE/12)) * ANGLES(RAD(-5),0,0), 1/Animation_Speed)
				Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(RAD(-35),RAD(MRANDOM(-5,5)),RAD(MRANDOM(-5,5))), 1/Animation_Speed)
				RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5,0.5,0) * ANGLES(RAD(-25+MRANDOM(-5,5)),RAD(-15+MRANDOM(-5,5)),RAD(35)) * RIGHTSHOULDERC0, 1/Animation_Speed)
				LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5,0.5,0) * ANGLES(RAD(-25+MRANDOM(-5,5)),RAD(15+MRANDOM(-5,5)),RAD(-35)) * LEFTSHOULDERC0, 1/Animation_Speed)
				RightHip.C0 = Clerp(RightHip.C0, CF(1,-1,-0.1) * ANGLES(0,RAD(85),RAD(MRANDOM(-5,5))) * ANGLES(RAD(-1),0,RAD(-12)), 1/Animation_Speed)
				LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-1,-0.1) * ANGLES(0,RAD(-85),RAD(MRANDOM(-5,5))) * ANGLES(RAD(-1),0,RAD(12)), 1/Animation_Speed)
			until ATTACK == false
		end))
		WACKYEFFECT({Time = 65, EffectType = "Sphere", Size = VT(0.1,0.1,0.1), Size2 = VT(25,25,25), Transparency = 0, Transparency2 = 1, CFrame = CF(RootPart.Position+VT(0,1.5,0)), Material = "Neon", Color = C3(0,0,0)})
		CreateSound(199978176, Head, 5, 1, false)
		for i = 1, 60 do
			Swait()
			ApplyAoE(RootPart.Position, 17, 1, 1, 0, false)
			local hit = Raycast(RootPart.Position, VT(0,-1,0), 4+Humanoid.HipHeight, Character)
			if hit then
				WACKYEFFECT({Time = 15, EffectType = "Wave", Size = VT(20,1,20), Size2 = VT(25+MRANDOM(0,8),7,25+MRANDOM(0,8)), Transparency = 0.95, Transparency2 = 1, CFrame = CF(hit.Position)*ANGLES(0,RAD(MRANDOM(0,360)),0), Material = "Neon", Color = C3(0,0,0)})
			end
			local SIZE = VT(1,3,1)
			WACKYEFFECT({EffectType = "Sphere", Size = VT(0.1,0.1,0.1), Size2 = SIZE*MRANDOM(10,65)/10, Transparency = 0.5, Transparency2 = 1, CFrame = CF(RootPart.Position) * ANGLES(0,RAD(MRANDOM(0,360)),0)*CF(0,MRANDOM(1,17),MRANDOM(0,12)), Material = "Neon", Color = C3(0,0,0)})
		end
		wait(0.2)
		ATTACK = false
		Rooted = false
	end
end

local function AbyssalDash()
	ATTACK = true
	Rooted = true
	UNANCHOR = false
	for i = 0, 0.4, 0.1/Animation_Speed do
		Swait()
		RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0.1*COS(SINE/12)), 1/Animation_Speed)
		Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(RAD(15-2.5*SIN(SINE/12)),0,0), 1/Animation_Speed)
		RightShoulder.C0 = Clerp(RightShoulder.C0, CF(0.75,0.5+0.05*SIN(SINE/12),-0.7) * ANGLES(0,0,RAD(-95)) * RIGHTSHOULDERC0, 1/Animation_Speed)
		LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-0.75,0.35+0.05*SIN(SINE/12),-0.6) * ANGLES(0,0,RAD(92)) * LEFTSHOULDERC0, 1/Animation_Speed)
		RightHip.C0 = Clerp(RightHip.C0, CF(1,-0.6-0.05*SIN(SINE/12),-0.5) * ANGLES(0,RAD(70),0) * ANGLES(RAD(-1),0,RAD(-15)), 1/Animation_Speed)
		LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-0.6-0.05*SIN(SINE/12),-0.5) * ANGLES(0,RAD(-70),0) * ANGLES(RAD(-1),0,RAD(15)), 1/Animation_Speed)
	end
	CreateSound(1177785010, Torso, 2, 1, false)
	CreateSound(971125740, Torso, 5, 1, false)
	WACKYEFFECT({Time = 65, EffectType = "Sphere", Size = VT(0.1,0.1,0.1), Size2 = VT(25,25,25), Transparency = 0, Transparency2 = 1, CFrame = CF(RootPart.Position), Material = "Neon", Color = C3(0,0,0), SoundID = 331666014, SoundPitch = 1, SoundVolume = 6})
	for _, CHILD in ipairs(Character:GetChildren()) do
		if CHILD:IsA("BasePart") then CHILD.Transparency = CHILD.Transparency + 1
		elseif CHILD:IsA("Accessory") and CHILD:FindFirstChild("Handle") then CHILD.Handle.Transparency = CHILD.Handle.Transparency + 1 end
	end
	local HITS = {}
	for i = 0, 1, 0.1/Animation_Speed do
		Swait()
		for _, CHILD in ipairs(workspace:GetDescendants()) do
			if CHILD:IsA("Model") and CHILD ~= Character then
				local HUM = CHILD:FindFirstChildOfClass("Humanoid")
				if HUM then
					local TP = CHILD:FindFirstChild("Torso") or CHILD:FindFirstChild("UpperTorso")
					if TP and (TP.Position-RootPart.Position).Magnitude <= 25 then
						local PASS = true
						for E = 1, #HITS do if HITS[E] == CHILD then PASS = false end end
						if PASS then
							ApplyDamage(HUM, MRANDOM(25,45))
							table.insert(HITS, CHILD)
						end
					end
				end
			end
		end
		WACKYEFFECT({Time = 25, EffectType = "Wave", Size = VT(0.1,0.1,0.1), Size2 = VT(25,0,25), Transparency = 0.8, Transparency2 = 1, CFrame = RootPart.CFrame*CF(0,0,-6) * ANGLES(RAD(-90),RAD(MRANDOM(0,360)),0), Material = "Neon", Color = C3(0,0,0)})
		for i = 1, 2 do
			RootPart.CFrame = RootPart.CFrame * CF(0,0,-1)
			CharacterFade(C3(0,0,0), 25, R_RANDOM(Torso.CFrame,1.25).Position)
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0.1*COS(SINE/12)) * ANGLES(RAD(65),0,0), 1/Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(RAD(-25-2.5*SIN(SINE/12)),0,0), 1/Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(0.75,0.5+0.05*SIN(SINE/12),-0.7) * ANGLES(RAD(-25),0,RAD(-95)) * RIGHTSHOULDERC0, 1/Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-0.75,0.35+0.05*SIN(SINE/12),-0.6) * ANGLES(RAD(-25),0,RAD(92)) * LEFTSHOULDERC0, 1/Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1,-0.6-0.05*SIN(SINE/12),-0.5) * ANGLES(0,RAD(70),0) * ANGLES(RAD(-1),0,RAD(-25)), 1/Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-1-0.05*SIN(SINE/12),0) * ANGLES(RAD(-5),RAD(-70),0) * ANGLES(RAD(1),0,0), 1/Animation_Speed)
		end
	end
	for _, CHILD in ipairs(Character:GetChildren()) do
		if CHILD:IsA("BasePart") then CHILD.Transparency = CHILD.Transparency - 1
		elseif CHILD:IsA("Accessory") and CHILD:FindFirstChild("Handle") then CHILD.Handle.Transparency = CHILD.Handle.Transparency - 1 end
	end
	for i = 1, 25 do
		Swait()
		RootPart.CFrame = RootPart.CFrame * CF(0,0,-((25-i)/25))
		RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0.1*COS(SINE/12)) * ANGLES(RAD(-15),0,0), 1/Animation_Speed)
		Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(RAD(5-2.5*SIN(SINE/12)),0,0), 1/Animation_Speed)
		RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5,0.5+0.05*SIN(SINE/12),0) * ANGLES(RAD(-35),0,0) * RIGHTSHOULDERC0, 1/Animation_Speed)
		LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5,0.5+0.05*SIN(SINE/12),0) * ANGLES(RAD(-35),0,0) * LEFTSHOULDERC0, 1/Animation_Speed)
		RightHip.C0 = Clerp(RightHip.C0, CF(1,-0.6-0.05*SIN(SINE/12),-0.5) * ANGLES(0,RAD(70),0) * ANGLES(RAD(-1),0,RAD(-45)), 1/Animation_Speed)
		LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-1-0.05*SIN(SINE/12),0) * ANGLES(RAD(-25),RAD(-70),0) * ANGLES(RAD(1),0,0), 1/Animation_Speed)
	end
	UNANCHOR = true
	ATTACK = false
	Rooted = false
end

local function ShadowCloak()
	if ANIM ~= "Fall" and ANIM ~= "Jump" then
		ATTACK = true
		Rooted = false
		UNANCHOR = false
		FADERS = false
		coroutine.resume(coroutine.create(function()
			coroutine.resume(coroutine.create(function()
				for i = 1, 25 do
					Swait()
					RootPart.CFrame = RootPart.CFrame * CF(0,(25-i)/25,0)
				end
			end))
			repeat
				Swait()
				BLADE.Transparency = Torso.Transparency
				RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0.1*COS(SINE/12)) * ANGLES(RAD(-5),0,0), 1/Animation_Speed)
				Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(RAD(-35),RAD(MRANDOM(-5,5)),RAD(MRANDOM(-5,5))), 1/Animation_Speed)
				RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5,0.5,0) * ANGLES(RAD(-25+MRANDOM(-5,5)),RAD(-15+MRANDOM(-5,5)),RAD(35)) * RIGHTSHOULDERC0, 1/Animation_Speed)
				LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5,0.5,0) * ANGLES(RAD(-25+MRANDOM(-5,5)),RAD(15+MRANDOM(-5,5)),RAD(-35)) * LEFTSHOULDERC0, 1/Animation_Speed)
				RightHip.C0 = Clerp(RightHip.C0, CF(1,-1,-0.1) * ANGLES(0,RAD(85),RAD(MRANDOM(-5,5))) * ANGLES(RAD(-1),0,RAD(-12)), 1/Animation_Speed)
				LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-1,-0.1) * ANGLES(0,RAD(-85),RAD(MRANDOM(-5,5))) * ANGLES(RAD(-1),0,RAD(12)), 1/Animation_Speed)
			until ATTACK == false
		end))
		WACKYEFFECT({Time = 65, EffectType = "Sphere", Size = VT(0.1,0.1,0.1), Size2 = VT(25,1,25), Transparency = 0, Transparency2 = 1, CFrame = CF(RootPart.Position-VT(0,3.5,0)), Material = "Neon", Color = C3(0,0,0), SoundID = 814168787, SoundPitch = 0.6, SoundVolume = 6})
		WACKYEFFECT({Time = 65, EffectType = "Sphere", Size = VT(0.1,0.1,0.1), Size2 = VT(25,1,25), Transparency = 0, Transparency2 = 1, CFrame = CF(RootPart.Position-VT(0,3.5,0)), Material = "Neon", Color = C3(0,0,0), SoundID = 814168787, SoundPitch = 1, SoundVolume = 6})
		for i = 1, 50 do
			Swait()
			CharacterFade(C3(0,0,0), 12, R_RANDOM(Torso.CFrame,1.25).Position)
			for _, CHILD in ipairs(Character:GetChildren()) do
				if CHILD:IsA("BasePart") then CHILD.Transparency = CHILD.Transparency + 1/50
				elseif CHILD:IsA("Accessory") and CHILD:FindFirstChild("Handle") then CHILD.Handle.Transparency = CHILD.Handle.Transparency + 1/50 end
			end
		end
		for i = 1, 25 do
			Swait()
			CharacterFade(C3(0,0,0), 12, R_RANDOM(Torso.CFrame,1.25).Position)
		end
		RootPart.CFrame = CF(Mouse.Hit.Position+VT(0,12,0)) * ANGLES(0,RAD(RootPart.Orientation.Y),0)
		for i = 1, 5 do
			WACKYEFFECT({Time = 50, EffectType = "Round Slash", Size = VT(0.1,0.1,0.1), Size2 = VT(0.3,0,0.3), Transparency = 0, Transparency2 = 1, CFrame = CF(RootPart.Position) * ANGLES(RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360))), Material = "Neon", Color = C3(0,0,0)})
		end
		ApplyAoE(Torso.Position, 15, 12, 22, 150, false)
		CreateSound(331666014, Torso, 5, 1, false)
		for i = 1, 12 do
			Swait()
			CharacterFade(C3(0,0,0), 12, R_RANDOM(Torso.CFrame,1.25).Position)
		end
		for i = 1, 50 do
			Swait()
			CharacterFade(C3(0,0,0), 12, R_RANDOM(Torso.CFrame,1.25).Position)
			for _, CHILD in ipairs(Character:GetChildren()) do
				if CHILD:IsA("BasePart") then CHILD.Transparency = CHILD.Transparency - 1/50
				elseif CHILD:IsA("Accessory") and CHILD:FindFirstChild("Handle") then CHILD.Handle.Transparency = CHILD.Handle.Transparency - 1/50 end
			end
		end
		UNANCHOR = true
		ATTACK = false
		Rooted = false
		FADERS = true
	end
end

local function BlackBlast()
	if ANIM ~= "Fall" and ANIM ~= "Jump" then
		ATTACK = true
		Rooted = true
		local GYRO = IT("BodyGyro", RootPart)
		GYRO.D = 25
		GYRO.P = 20000
		GYRO.MaxTorque = VT(0,4000000,0)
		GYRO.CFrame = CF(RootPart.Position, Mouse.Hit.Position)
		CreateSound(429459101, Torso, 5, 1.5, false)
		local GYROING = true
		coroutine.resume(coroutine.create(function()
			repeat
				Swait()
				GYRO.CFrame = CF(RootPart.Position, Mouse.Hit.Position)
			until GYROING == false
			GYRO:Destroy()
		end))
		for i = 0, 1, 0.1/Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0.1*COS(SINE/12)), 1/Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(RAD(15-2.5*SIN(SINE/12)),0,0), 1/Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(0.75,0.5+0.05*SIN(SINE/12),-0.7) * ANGLES(0,0,RAD(-95)) * ANGLES(RAD(5),0,0) * RIGHTSHOULDERC0, 1/Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-0.75,0.35+0.05*SIN(SINE/12),-0.6) * ANGLES(0,0,RAD(92)) * LEFTSHOULDERC0, 1/Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1,-0.6-0.05*SIN(SINE/12),-0.5) * ANGLES(0,RAD(70),0) * ANGLES(RAD(-1),0,RAD(-15)), 1/Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-0.6-0.05*SIN(SINE/12),-0.5) * ANGLES(0,RAD(-70),0) * ANGLES(RAD(-1),0,RAD(15)), 1/Animation_Speed)
		end
		for i = 1, 13 do
			WACKYEFFECT({Time = 55, EffectType = "Wave", Size = VT(0.1,0.1,0.1), Size2 = VT(i,0,i)*2, Transparency = 0.8, Transparency2 = 1, CFrame = RootPart.CFrame*CF(0,0,7.5-i) * ANGLES(RAD(-90),RAD(MRANDOM(0,360)),0), Material = "Neon", Color = C3(0,0,0)})
		end
		CreateSound(1368637781, Torso, 5, 1.5, false)
		WACKYEFFECT({Time = 65, EffectType = "Sphere", Size = VT(0.1,0.1,0.1), Size2 = VT(12,12,12), Transparency = 0, Transparency2 = 1, CFrame = CF(RootPart.Position), Material = "Neon", Color = C3(0,0,0), SoundID = 331666014, SoundPitch = 1, SoundVolume = 6})
		for _, CHILD in ipairs(Character:GetChildren()) do
			if CHILD:IsA("BasePart") then CHILD.Transparency = CHILD.Transparency + 1
			elseif CHILD:IsA("Accessory") and CHILD:FindFirstChild("Handle") then CHILD.Handle.Transparency = CHILD.Handle.Transparency + 1 end
		end
		GYROING = false
		coroutine.resume(coroutine.create(function()
			coroutine.resume(coroutine.create(function()
				for i = 1, 25 do
					Swait()
					RootPart.CFrame = RootPart.CFrame * CF(0,0,(25-i)/25)
				end
			end))
			repeat
				Swait()
				CharacterFade(C3(0,0,0), 12, R_RANDOM(Torso.CFrame,1.25).Position)
				RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0.1*COS(SINE/12)) * ANGLES(RAD(-5),0,0), 1/Animation_Speed)
				Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(RAD(-35),RAD(MRANDOM(-5,5)),RAD(MRANDOM(-5,5))), 1/Animation_Speed)
				RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5,0.5,0) * ANGLES(RAD(-25+MRANDOM(-5,5)),RAD(-15+MRANDOM(-5,5)),RAD(35)) * RIGHTSHOULDERC0, 1/Animation_Speed)
				LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5,0.5,0) * ANGLES(RAD(-25+MRANDOM(-5,5)),RAD(15+MRANDOM(-5,5)),RAD(-35)) * LEFTSHOULDERC0, 1/Animation_Speed)
				RightHip.C0 = Clerp(RightHip.C0, CF(1,-1,-0.1) * ANGLES(0,RAD(85),RAD(MRANDOM(-5,5))) * ANGLES(RAD(-1),0,RAD(-12)), 1/Animation_Speed)
				LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-1,-0.1) * ANGLES(0,RAD(-85),RAD(MRANDOM(-5,5))) * ANGLES(RAD(-1),0,RAD(12)), 1/Animation_Speed)
			until ATTACK == false
		end))
		coroutine.resume(coroutine.create(function()
			local BULLETCFRAME = RootPart.CFrame
			local EXPLODED = false
			coroutine.resume(coroutine.create(function()
				repeat
					Swait()
					WACKYEFFECT({Time = 15, EffectType = "Block", Size = VT(15,15,15), Size2 = VT(10,10,10), Transparency = 0.3, Transparency2 = 1, CFrame = CF(BULLETCFRAME.Position), Material = "Neon", Color = C3(0,0,0)})
					WACKYEFFECT({Time = 15, EffectType = "Block", Size = VT(15,15,15), Size2 = VT(25,25,25), Transparency = 0.8, Transparency2 = 1, CFrame = CF(BULLETCFRAME.Position), Material = "Neon", Color = C3(0,0,0)})
				until EXPLODED == true
			end))
			for i = 1, 50 do
				Swait()
				BULLETCFRAME = BULLETCFRAME * CF(0,0,-((50-i)/15))
				local hit = Raycast(BULLETCFRAME.Position, BULLETCFRAME.LookVector, 7, Character)
				if hit then
					ApplyAoE(BULLETCFRAME.Position, 25, 12, 54, 350, false)
					WACKYEFFECT({Time = 45, EffectType = "Wave", Size = VT(0.1,0.1,0.1), Size2 = VT(160,0,160), Transparency = 0.6, Transparency2 = 1, CFrame = CF(hit.Position, hit.Position+hit.Normal) * ANGLES(RAD(-90),RAD(MRANDOM(0,360)),0), Material = "Neon", Color = C3(0,0,0), SoundID = 765590102, SoundPitch = MRANDOM(9,11)/10, SoundVolume = 10})
					break
				end
			end
			wait(0.5)
			WACKYEFFECT({Time = 85, EffectType = "Sphere", Size = VT(25,25,25), Size2 = VT(75,75,75), Transparency = 0, Transparency2 = 1, CFrame = CF(BULLETCFRAME.Position), Material = "Neon", Color = C3(0,0,0), SoundID = 401056199, SoundPitch = 0.7, SoundVolume = 6})
			WACKYEFFECT({Time = 85, EffectType = "Sphere", Size = VT(25,25,25), Size2 = VT(50,50,50), Transparency = 0, Transparency2 = 1, CFrame = CF(BULLETCFRAME.Position), Material = "Neon", Color = C3(0,0,0), SoundID = 401056199, SoundPitch = 1, SoundVolume = 10})
			for E = 1, 3 do
				for i = 1, 5 do
					WACKYEFFECT({Time = 50, EffectType = "Round Slash", Size = VT(0.1,0.1,0.1), Size2 = VT(E,0,E)/2, Transparency = 0, Transparency2 = 1, CFrame = CF(BULLETCFRAME.Position) * ANGLES(RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360))), Material = "Neon", Color = C3(0,0,0)})
				end
			end
			ApplyAoE(BULLETCFRAME.Position, 125, 25, 75, 250, false)
			EXPLODED = true
			for i = 1, 15 do
				Swait()
				WACKYEFFECT({Time = 25, EffectType = "Wave", Size = VT(0.1,0.1,0.1), Size2 = VT(160,0,160), Transparency = 0.6, Transparency2 = 1, CFrame = BULLETCFRAME * ANGLES(RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360))), Material = "Neon", Color = C3(0,0,0), SoundPitch = MRANDOM(9,11)/10, SoundVolume = MRANDOM(9,11)/2})
			end
		end))
		wait(0.5)
		for _, CHILD in ipairs(Character:GetChildren()) do
			if CHILD:IsA("BasePart") then CHILD.Transparency = CHILD.Transparency - 1
			elseif CHILD:IsA("Accessory") and CHILD:FindFirstChild("Handle") then CHILD.Handle.Transparency = CHILD.Handle.Transparency - 1 end
		end
		ATTACK = false
		Rooted = false
	end
end

local function NightmareFall()
	if ANIM ~= "Fall" and ANIM ~= "Jump" and DAMAGEMULTIPLIER == 1 then
		ATTACK = true
		Rooted = true
		EQUIPPED = true
		CreateSound(160740121, Head, 10, 1, false)
		for i = 0, 2, 0.1/Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0.1*COS(SINE/12)), 1/Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(RAD(15-2.5*SIN(SINE/12)),0,0), 1/Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(0.75,0.4+0.05*SIN(SINE/12),-0.7) * ANGLES(RAD(120),0,0) * RIGHTSHOULDERC0, 0.15/Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-0.75,0.35+0.05*SIN(SINE/12),-0.6) * ANGLES(0,0,RAD(92)) * LEFTSHOULDERC0, 1/Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1,-0.6-0.05*SIN(SINE/12),-0.5) * ANGLES(0,RAD(70),0) * ANGLES(RAD(-1),0,RAD(-25)), 1/Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-1-0.05*SIN(SINE/12),0) * ANGLES(RAD(-5),RAD(-70),0) * ANGLES(RAD(1),0,0), 1/Animation_Speed)
			BLADE.CFrame = Clerp(BLADE.CFrame, RightArm.CFrame*CF(0,-8,0) * ANGLES(RAD(180),RAD(90),0), 0.4)
		end
		for i = 0, 2, 0.1/Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0.1*COS(SINE/12)), 1/Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(RAD(15-2.5*SIN(SINE/12)),0,0), 1/Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(0.75,0.15+0.05*SIN(SINE/12),-0.7) * ANGLES(RAD(140),0,0) * RIGHTSHOULDERC0, 0.15/Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-0.75,0.35+0.05*SIN(SINE/12),-0.6) * ANGLES(0,0,RAD(92)) * LEFTSHOULDERC0, 1/Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1,-0.6-0.05*SIN(SINE/12),-0.5) * ANGLES(0,RAD(70),0) * ANGLES(RAD(-1),0,RAD(-25)), 1/Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-1-0.05*SIN(SINE/12),0) * ANGLES(RAD(-5),RAD(-70),0) * ANGLES(RAD(1),0,0), 1/Animation_Speed)
			BLADE.CFrame = Clerp(BLADE.CFrame, RightArm.CFrame*CF(0,-8,0) * ANGLES(RAD(180),RAD(90),0), 0.4)
		end
		local SIZE = 0
		local POS = RootPart.Position + VT(0,150,0)
		local BLOWN = false
		coroutine.resume(coroutine.create(function()
			coroutine.resume(coroutine.create(function()
				repeat
					Swait()
					if SIZE > 0 then
						WACKYEFFECT({Time = 15, EffectType = "Block", Size = VT(0.1,0.1,0.1), Size2 = VT(SIZE,SIZE,SIZE)*2.5, Transparency = 0.3, Transparency2 = 1, CFrame = CF(POS), Material = "Neon", Color = C3(0,0,0)})
						WACKYEFFECT({Time = 15, EffectType = "Block", Size = VT(0.1,0.1,0.1), Size2 = VT(SIZE,SIZE,SIZE)*3, Transparency = 0.8, Transparency2 = 1, CFrame = CF(POS), Material = "Neon", Color = C3(0,0,0)})
					end
				until BLOWN == true
			end))
			repeat
				Swait()
				RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0.1*COS(SINE/12)) * ANGLES(RAD(-5),RAD(12),RAD(25)), 1/Animation_Speed)
				Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(RAD(-35),0,RAD(-15)), 1/Animation_Speed)
				RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5,0.75,0) * ANGLES(RAD(180),RAD(15),RAD(17)) * RIGHTSHOULDERC0, 1/Animation_Speed)
				LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-0.75,0.35,-0.6) * ANGLES(0,0,RAD(92)) * LEFTSHOULDERC0, 1/Animation_Speed)
				RightHip.C0 = Clerp(RightHip.C0, CF(1,-0.6-0.05*SIN(SINE/12),-0.5) * ANGLES(0,RAD(70),0) * ANGLES(RAD(-1),0,RAD(-25)), 1/Animation_Speed)
				LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-1-0.05*SIN(SINE/12),0) * ANGLES(RAD(-5),RAD(-70),0) * ANGLES(RAD(1),0,0), 1/Animation_Speed)
				BLADE.CFrame = Clerp(BLADE.CFrame, RightArm.CFrame*CF(0,-8,0) * ANGLES(RAD(180),RAD(90),0), 0.4)
			until ATTACK == false
		end))
		wait(0.2)
		for i = 1, 15 do
			wait(MRANDOM(2,6)/45)
			coroutine.resume(coroutine.create(function()
				local CFRAME = CF(BLADE.Position, POS) * ANGLES(0,0,RAD(MRANDOM(-90,90)))
				local HEIGHT = 45/5
				local DISTANCE = (BLADE.Position - POS).Magnitude
				for i = 1, 45 do
					Swait()
					CFRAME = CFRAME * CF(0,(HEIGHT-(i/2.575))/45,-DISTANCE/45)
					WACKYEFFECT({Time = 15, EffectType = "Block", Size = VT(3,3,3), Size2 = VT(0.1,0.1,0.1), Transparency = 0.3, Transparency2 = 1, CFrame = CFRAME, Material = "Neon", Color = C3(0,0,0)})
				end
				SIZE = SIZE + 1
			end))
		end
		wait(2.5)
		BLOWN = true
		WACKYEFFECT({Time = 85, EffectType = "Sphere", Size = VT(25,25,25), Size2 = VT(150,50,150), Transparency = 0, Transparency2 = 1, CFrame = CF(POS), Material = "Neon", Color = C3(0,0,0), SoundID = 401056199, SoundPitch = 0.4, SoundVolume = 10})
		for E = 1, 5 do
			for i = 1, 5 do
				WACKYEFFECT({Time = 50+(E*4), EffectType = "Round Slash", Size = VT(0.1,0.1,0.1), Size2 = VT(E,0,E)/2, Transparency = 0, Transparency2 = 1, CFrame = CF(POS) * ANGLES(RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360))), Material = "Neon", Color = C3(0,0,0)})
			end
		end
		CreateSound(288641686, Effects, 5, 1, false)
		CreateSound(592877506, Effects, 5, 1, false)
		local HITS = {}
		for _, CHILD in ipairs(workspace:GetDescendants()) do
			if CHILD:IsA("Model") and CHILD ~= Character then
				local HUM = CHILD:FindFirstChildOfClass("Humanoid")
				if HUM then
					local TP = CHILD:FindFirstChild("Torso") or CHILD:FindFirstChild("UpperTorso")
					if TP and (TP.Position-RootPart.Position).Magnitude <= 175 then
						local PASS = true
						for E = 1, #HITS do if HITS[E] == CHILD then PASS = false end end
						if PASS then table.insert(HITS, CHILD) end
					end
				end
			end
		end
		if #HITS > 0 then
			local DONE = false
			local HUMS = {}
			coroutine.resume(coroutine.create(function()
				for E = 1, #HITS do
					local HUM = HITS[E]:FindFirstChildOfClass("Humanoid")
					table.insert(HUMS, HUM)
					local TP = HITS[E]:FindFirstChild("Torso") or HITS[E]:FindFirstChild("UpperTorso")
					if TP then
						local grav = IT("BodyPosition", TP)
						grav.D = 850
						grav.P = 4000
						grav.MaxForce = VT(math.huge,math.huge,math.huge)
						grav.Position = TP.Position + VT(0,35,0)
						CreateSound(592877506, TP, 5, 0.5, false)
						coroutine.resume(coroutine.create(function()
							local B = IT("Attachment", TP)
							local ChainLink = IT("Beam", TP)
							ChainLink.Texture = "rbxassetid://73042633"
							ChainLink.Color = ColorSequence.new(C3(0,0,0))
							ChainLink.TextureSpeed = -1
							ChainLink.Width0 = 3
							ChainLink.Width1 = 3
							ChainLink.TextureLength = 3
							ChainLink.Attachment0 = A
							ChainLink.Attachment1 = B
							ChainLink.CurveSize0 = 0
							ChainLink.CurveSize1 = 0
							ChainLink.FaceCamera = true
							ChainLink.TextureMode = "Static"
							ChainLink.Transparency = NumberSequence.new(0)
							repeat
								Swait()
								WACKYEFFECT({Time = 5, EffectType = "Block", Size = VT(2,2,2)*TP.Size.Z, Size2 = VT(0.1,0.1,0.1), Transparency = 0.6, Transparency2 = 1, CFrame = CF(TP.Position), Material = "Neon", Color = C3(0,0,0)})
							until DONE == true or HUM.Health < 1
							B:Destroy()
							ChainLink:Destroy()
							grav:Destroy()
						end))
					end
				end
				wait(1)
				for i = 1, 250 do
					Swait()
					for E = 1, #HUMS do
						if HUMS[E] and HUMS[E].Health > 0 then
							DAMAGEMULTIPLIER = DAMAGEMULTIPLIER + 0.0025
							WACKYEFFECT({Time = 10, EffectType = "Round Slash", Size = VT(0.1,0.1,0.1), Size2 = VT(1.5,0,1.5)/20, Transparency = 0.9, Transparency2 = 1, CFrame = CF(Torso.Position) * ANGLES(RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360))), Material = "Neon", Color = C3(0,0,0)})
						end
					end
				end
				local SKILLFRAME = CreateFrame(WEAPONGUI, 1, UD2(0,0,0,0), UD2(1,0,1,0), C3(0,0,0), "OWEXTRADAMAGE")
				local SKILLTEXT = CreateLabel(SKILLFRAME, "!You have increased damage!", SKILLTEXTCOLOR, SKILLTEXTSIZE2, SKILLFONT, 1, "AAAA")
				coroutine.resume(coroutine.create(function()
					CreateSound(743521450, Cam, 5, 0.6, false)
					for E = 1, 75 do
						Swait()
						SKILLTEXT.TextTransparency = SKILLTEXT.TextTransparency - 1/75
					end
					wait(4)
					for E = 1, 25 do
						Swait()
						SKILLTEXT.TextTransparency = SKILLTEXT.TextTransparency + 1/25
					end
					SKILLFRAME:Destroy()
				end))
				DONE = true
				for i = 1, 50 do
					wait(0.5)
					for i = 1, 3 do
						WACKYEFFECT({Time = 25, EffectType = "Wave", Size = VT(0.1,0.1,0.1), Size2 = VT(DAMAGEMULTIPLIER-1,0.1,DAMAGEMULTIPLIER-1)*1.5, Transparency = 0.6, Transparency2 = 1, CFrame = CF(RootPart.CFrame*CF(0,-3.25,0).Position) * ANGLES(0,RAD(MRANDOM(0,360)),0), Material = "Neon", Color = C3(0,0,0), SoundPitch = MRANDOM(9,11)/10, SoundVolume = MRANDOM(9,11)/2})
					end
				end
				DAMAGEMULTIPLIER = 1
			end))
			wait(0.2)
		end
		wait(0.4)
		EQUIPPED = false
		ATTACK = false
		Rooted = false
	end
end

local function Laugh()
	ATTACK = true
	Rooted = true
	CreateSound(160740121, Head, 10, 1, false)
	for i = 0, 0.5, 0.1/Animation_Speed do
		Swait()
		RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0.1*COS(SINE/12)), 1/Animation_Speed)
		Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(RAD(15-2.5*SIN(SINE/12)),0,0), 0.8/Animation_Speed)
		RightShoulder.C0 = Clerp(RightShoulder.C0, CF(0.75,0.6+0.05*SIN(SINE/12),-0.7) * ANGLES(0,0,RAD(-95)) * RIGHTSHOULDERC0, 1/Animation_Speed)
		LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-0.75,0.45+0.05*SIN(SINE/12),-0.6) * ANGLES(0,0,RAD(92)) * LEFTSHOULDERC0, 1/Animation_Speed)
		RightHip.C0 = Clerp(RightHip.C0, CF(1,-0.6-0.05*SIN(SINE/12),-0.5) * ANGLES(0,RAD(70),0) * ANGLES(RAD(-1),0,RAD(-25)), 1/Animation_Speed)
		LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-1-0.05*SIN(SINE/12),0) * ANGLES(RAD(-5),RAD(-70),0) * ANGLES(RAD(1),0,0), 1/Animation_Speed)
	end
	for i = 1, 185 do
		Swait()
		RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0.1*COS(SINE/12)), 1/Animation_Speed)
		Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(RAD(-15),0,0), 1/Animation_Speed)
		RightShoulder.C0 = Clerp(RightShoulder.C0, CF(0.75,0.55+0.15*SIN(SINE/2),-0.7) * ANGLES(RAD(3+3*SIN(SINE/2)),0,RAD(-95)) * RIGHTSHOULDERC0, 1/Animation_Speed)
		LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-0.75,0.4+0.15*SIN(SINE/2),-0.6) * ANGLES(RAD(3+3*SIN(SINE/2)),0,RAD(92)) * LEFTSHOULDERC0, 1/Animation_Speed)
		RightHip.C0 = Clerp(RightHip.C0, CF(1,-0.6-0.05*SIN(SINE/12),-0.5) * ANGLES(0,RAD(70),0) * ANGLES(RAD(-1),0,RAD(-25)), 1/Animation_Speed)
		LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-1-0.05*SIN(SINE/12),0) * ANGLES(RAD(-5),RAD(-70),0) * ANGLES(RAD(1),0,0), 1/Animation_Speed)
	end
	ATTACK = false
	Rooted = false
end

local function unanchor()
	for _, c in ipairs(Character:GetChildren()) do
		if c:IsA("BasePart") and c ~= RootPart then c.Anchored = false end
	end
	RootPart.Anchored = (UNANCHOR ~= true)
end

Mouse.Button1Down:Connect(function()
	if ATTACK == false then Melee() end
end)

UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if ATTACK then return end
	if input.KeyCode == Enum.KeyCode.Z then AbyssalShriek()
	elseif input.KeyCode == Enum.KeyCode.X then AbyssalDash()
	elseif input.KeyCode == Enum.KeyCode.C then ShadowCloak()
	elseif input.KeyCode == Enum.KeyCode.V then BlackBlast()
	elseif input.KeyCode == Enum.KeyCode.Q then NightmareFall()
	end
end)

Humanoid.Changed:Connect(function(prop)
	if prop == "Jump" and Disable_Jump then Humanoid.Jump = false end
end)

RunService.RenderStepped:Connect(function()
	SINE = SINE + CHANGE
	if not RootPart or not RootPart.Parent then return end
	local TORSOVELOCITY = (RootPart.Velocity * VT(1,0,1)).Magnitude
	local TORSOVERTICALVELOCITY = RootPart.Velocity.Y
	local HITFLOOR = Raycast(RootPart.Position, VT(0,-1,0), 4+Humanoid.HipHeight, Character)
	local WALKSPEEDVALUE = 8 / (Humanoid.WalkSpeed/16)
	Humanoid.HipHeight = 1
	if TORSOVERTICALVELOCITY > 1 and HITFLOOR == nil then
		ANIM = "Jump"
		if ATTACK == false then
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * ANGLES(RAD(-5),0,0), 1/Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(RAD(-25),0,0), 1/Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5,0.5,0) * ANGLES(RAD(-35),0,RAD(25+10*COS(SINE/12))) * RIGHTSHOULDERC0, 1/Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5,0.5,0) * ANGLES(RAD(-35),0,RAD(-25-10*COS(SINE/12))) * LEFTSHOULDERC0, 1/Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1,-0.4,-0.6) * ANGLES(RAD(1),RAD(90),0) * ANGLES(RAD(-1*SIN(SINE/6)),0,0), 1/Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-1,0) * ANGLES(0,RAD(-85),0) * ANGLES(RAD(-1*SIN(SINE/6)),0,0), 1/Animation_Speed)
		end
	elseif TORSOVERTICALVELOCITY < -1 and HITFLOOR == nil then
		ANIM = "Fall"
		if ATTACK == false then
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * ANGLES(RAD(15),0,0), 1/Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(RAD(15),0,0), 1/Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5,0.5,0) * ANGLES(RAD(35-4*COS(SINE/6)),0,RAD(45+10*COS(SINE/12))) * RIGHTSHOULDERC0, 1/Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5,0.5,0) * ANGLES(RAD(35-4*COS(SINE/6)),0,RAD(-45-10*COS(SINE/12))) * LEFTSHOULDERC0, 1/Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1,-0.3,-0.7) * ANGLES(RAD(-25+5*SIN(SINE/12)),RAD(90),0) * ANGLES(RAD(-1*SIN(SINE/6)),0,0), 1/Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-0.8,-0.3) * ANGLES(RAD(-10),RAD(-80),0) * ANGLES(RAD(-1*SIN(SINE/6)),0,0), 1/Animation_Speed)
		end
	elseif TORSOVELOCITY < 1 and HITFLOOR ~= nil then
		ANIM = "Idle"
		if ATTACK == false then
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0.1*COS(SINE/12)), 1/Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(RAD(-2.5*SIN(SINE/12)),0,0), 1/Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(0.75,0.5+0.05*SIN(SINE/12),-0.7) * ANGLES(0,0,RAD(-95)) * ANGLES(RAD(5),0,0) * RIGHTSHOULDERC0, 1/Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-0.75,0.35+0.05*SIN(SINE/12),-0.6) * ANGLES(0,0,RAD(92)) * LEFTSHOULDERC0, 1/Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1,-0.6-0.05*SIN(SINE/12),-0.5) * ANGLES(0,RAD(70),0) * ANGLES(RAD(-1),0,RAD(-25)), 1/Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-1-0.05*SIN(SINE/12),0) * ANGLES(RAD(-5),RAD(-70),0) * ANGLES(RAD(1),0,0), 1/Animation_Speed)
		end
	elseif TORSOVELOCITY > 1 and HITFLOOR ~= nil then
		ANIM = "Walk"
		if ATTACK == false then
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0,0,0.1*COS(SINE/12)) * ANGLES(RAD(10),0,0), 1/Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * ANGLES(RAD(-10-2.5*SIN(SINE/12)),0,0), 1/Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(0.75,0.5+0.05*SIN(SINE/12),-0.7) * ANGLES(0,0,RAD(-95)) * ANGLES(RAD(5),0,0) * RIGHTSHOULDERC0, 1/Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-0.75,0.35+0.05*SIN(SINE/12),-0.6) * ANGLES(0,0,RAD(92)) * LEFTSHOULDERC0, 1/Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1,-0.6-0.05*SIN(SINE/12),-0.5) * ANGLES(0,RAD(70),0) * ANGLES(RAD(-1),0,RAD(-35)), 1/Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1,-1-0.05*SIN(SINE/12),0) * ANGLES(RAD(-15),RAD(-70),0) * ANGLES(RAD(1),0,0), 1/Animation_Speed)
		end
	end
	if EQUIPPED == false then
		if TORSOVELOCITY > 1 then
			BLADE.CFrame = Clerp(BLADE.CFrame, RootPart.CFrame * CF(0.2,1.5+0.15*SIN(SINE/12),4) * ANGLES(RAD(195),RAD(15),RAD(15)), 0.04)
		else
			BLADE.CFrame = Clerp(BLADE.CFrame, RootPart.CFrame * CF(1,1.5+0.15*SIN(SINE/12),4) * ANGLES(RAD(195),RAD(-25),RAD(15)), 0.1)
		end
	end
	if ANIM ~= "Walk" and FADERS then
		if MRANDOM(1,7) == 1 then
			CharacterFade(C3(0,0,0), 65, R_RANDOM(Torso.CFrame,0.5).Position)
		end
	end
	unanchor()
	if Rooted == false then
		Disable_Jump = false
		Humanoid.WalkSpeed = Speed + (DAMAGEMULTIPLIER/5)
	else
		Disable_Jump = true
		Humanoid.WalkSpeed = 0
	end
	if BMUSIC.Parent ~= RootPart then
		BMUSIC = IT("Sound", RootPart)
		BMUSIC.SoundId = "rbxassetid://1074563286"
		BMUSIC.Looped = true
		BMUSIC.Volume = 5
		BMUSIC.Pitch = 1
		BMUSIC:Play()
	end
end)

local function shutdown()
	if Humanoid then pcall(function() Humanoid.WalkSpeed = 16; Humanoid.HipHeight = 0 end) end
	if Effects and Effects.Parent then Effects:Destroy() end
	if WEAPONGUI and WEAPONGUI.Parent then WEAPONGUI:Destroy() end
	if BMUSIC then pcall(function() BMUSIC:Destroy() end) end
	if BLADE and BLADE.Parent then BLADE:Destroy() end
	if EYE and EYE.Parent then EYE:Destroy() end
	if Character then
		for _, v in ipairs(Character:GetChildren()) do
			if v:IsA("Part") and v.Name == "AccessoryGrip" then v:Destroy() end
		end
	end
end

Player.CharacterRemoving:Connect(shutdown)
