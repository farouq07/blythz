local fortnite = (getgenv and getgenv()) or shared
local bytexfesettings = fortnite.neptunian or {}
if type(bytexfesettings) ~= "table" then bytexfesettings = {} end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

local chara, Humanoid, Torso, Head, RootPart, RootJoint
local LeftArm, RightArm, LeftLeg, RightLeg
local RW, LW, RH, LH

local attack = false
local Anim = "Idle"
local zhold = false
local sine = 0
local change = 1

local EffectsFolder = Instance.new("Folder")

local Create = function(class)
	return function(props)
		local inst = Instance.new(class)
		for k, v in pairs(props) do
			if k ~= "Parent" then inst[k] = v end
		end
		if props and props.Parent then inst.Parent = props.Parent end
		return inst
	end
end

local rp = RaycastParams.new()
rp.FilterType = Enum.RaycastFilterType.Exclude

local function rayCast(pos, dir, range, ignore)
	rp.FilterDescendantsInstances = ignore and {ignore} or {}
	local hit = workspace:Raycast(pos, dir.Unit * (range or 999.999), rp)
	if hit then return hit.Instance, hit.Position end
	return nil, nil
end

local function so(id, par, pit, vol)
	local sou = Instance.new("Sound")
	sou.Parent = par or workspace
	sou.Volume = vol or 1
	sou.Pitch = pit or 1
	sou.SoundId = "rbxassetid://"..id
	sou.PlayOnRemove = true
	sou:Destroy()
end

local function newMotor(part0, part1, c0, c1)
	return Create("Motor6D"){
		Parent = part0,
		Part0 = part0,
		Part1 = part1,
		C0 = c0,
		C1 = c1,
	}
end

local function clerp(a, b, t)
	return a:Lerp(b, t)
end

local function PlayAnimationFromTable(tbl, speed)
	RootJoint.C0 = clerp(RootJoint.C0, tbl[1], speed)
	Torso.Neck.C0 = clerp(Torso.Neck.C0, tbl[2], speed)
	RW.C0 = clerp(RW.C0, tbl[3], speed)
	LW.C0 = clerp(LW.C0, tbl[4], speed)
	RH.C0 = clerp(RH.C0, tbl[5], speed)
	LH.C0 = clerp(LH.C0, tbl[6], speed)
end

local ArtificialHB = Instance.new("BindableEvent")
local frame = 1/30
local tf = 0

RunService.Heartbeat:Connect(function(s)
	tf = tf + s
	if tf >= frame then
		for _ = 1, math.floor(tf/frame) do ArtificialHB:Fire() end
		tf = tf - frame*math.floor(tf/frame)
	end
end)

local function swait(num)
	if num == 0 or num == nil then
		ArtificialHB.Event:Wait()
	else
		for _ = 1, num do ArtificialHB.Event:Wait() end
	end
end

local function RemoveOutlines(part)
	part.TopSurface, part.BottomSurface, part.LeftSurface, part.RightSurface, part.FrontSurface, part.BackSurface = 10,10,10,10,10,10
end

local function GetDudesTorso(c)
	return c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
end

local function BodyVel(part, faws)
	local bv = Instance.new("BodyVelocity")
	bv.P = 10000000
	bv.MaxForce = Vector3.new(1e7,1e7,1e7)
	bv.Velocity = faws
	bv.Parent = part
	Debris:AddItem(bv, 0.2)
end

local function MagnitudeDmg(par, magni, dmg)
	for _, c in pairs(workspace:GetDescendants()) do
		local hum = c:FindFirstChildOfClass("Humanoid")
		if hum and c ~= chara then
			local torso = GetDudesTorso(c)
			if torso and magni >= (torso.Position - par.Position).Magnitude then
				hum:TakeDamage(dmg or 5)
			end
		end
	end
end

local Effects = {}

local function makeEffect(defaultTransparency, partProps, meshMaker, loopBody, lifetime, factor)
	local p = Instance.new("Part")
	p.Anchored = true
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	for k, v in pairs(partProps) do p[k] = v end
	p.Transparency = defaultTransparency
	p.Parent = EffectsFolder
	local m = meshMaker and meshMaker(p) or nil
	coroutine.wrap(function()
		for i = 0, 1, factor do
			swait()
			if loopBody then loopBody(p, m, i) end
		end
		if p and p.Parent then p:Destroy() end
	end)()
	return p
end

Effects.Block = function(cf, partsize, meshstart, meshadd, matr, colour, spin, inverse, factor)
	return makeEffect(inverse and 1 or 0, {BrickColor = BrickColor.new(colour), Size = partsize, Material = matr, CFrame = cf}, function(p)
		local m = Instance.new("BlockMesh", p); m.Scale = meshstart; return m
	end, function(p, m, i)
		p.Transparency = inverse and (1 - i) or i
		m.Scale = m.Scale + meshadd
		if spin then p.CFrame = p.CFrame * CFrame.Angles(math.random(-50,50), math.random(-50,50), math.random(-50,50)) end
	end, nil, factor)
end

Effects.Sphere = function(cf, partsize, meshstart, meshadd, matr, colour, inverse, factor)
	return makeEffect(inverse and 1 or 0, {BrickColor = BrickColor.new(colour), Size = partsize, Material = matr, CFrame = cf}, function(p)
		local m = Instance.new("SpecialMesh", p); m.MeshType = "Sphere"; m.Scale = meshstart; return m
	end, function(p, m, i)
		p.Transparency = inverse and (1 - i) or i
		m.Scale = m.Scale + meshadd
	end, nil, factor)
end

Effects.Cylinder = function(cf, partsize, meshstart, meshadd, matr, colour, inverse, factor)
	return makeEffect(inverse and 1 or 0, {BrickColor = BrickColor.new(colour), Size = partsize, Material = matr, CFrame = cf}, function(p)
		local m = Instance.new("CylinderMesh", p); m.Scale = meshstart; return m
	end, function(p, m, i)
		p.Transparency = inverse and (1 - i) or i
		m.Scale = m.Scale + meshadd
	end, nil, factor)
end

Effects.Wave = function(cf, meshstart, meshadd, colour, spin, inverse, factor)
	return makeEffect(inverse and 1 or 0, {BrickColor = BrickColor.new(colour), Size = Vector3.new(), CFrame = cf}, function(p)
		local m = Instance.new("SpecialMesh", p); m.MeshId = "rbxassetid://20329976"; m.Scale = meshstart; return m
	end, function(p, m, i)
		p.Transparency = inverse and (1 - i) or i
		m.Scale = m.Scale + meshadd
		p.CFrame = p.CFrame * CFrame.Angles(0, math.rad(spin), 0)
	end, nil, factor)
end

Effects.Ring = function(cf, meshstart, meshadd, colour, inverse, factor)
	return makeEffect(inverse and 1 or 0, {BrickColor = BrickColor.new(colour), Size = Vector3.new(), CFrame = cf}, function(p)
		local m = Instance.new("SpecialMesh", p); m.MeshId = "rbxassetid://3270017"; m.Scale = meshstart; return m
	end, function(p, m, i)
		p.Transparency = inverse and (1 - i) or i
		m.Scale = m.Scale + meshadd
	end, nil, factor)
end

Effects.Meshed = function(cf, meshstart, meshadd, colour, meshid, textid, spin, inverse, factor)
	return makeEffect(inverse and 1 or 0, {BrickColor = BrickColor.new(colour), Size = Vector3.new(), CFrame = cf}, function(p)
		local m = Instance.new("SpecialMesh", p); m.MeshId = meshid; m.TextureId = textid; m.Scale = meshstart; return m
	end, function(p, m, i)
		p.Transparency = inverse and (1 - i) or i
		m.Scale = m.Scale + meshadd
		p.CFrame = p.CFrame * CFrame.Angles(0, math.rad(spin), 0)
	end, nil, factor)
end

Effects.Explode = function(cf, partsize, meshstart, meshadd, matr, colour, move, inverse, factor)
	return makeEffect(inverse and 1 or 0, {BrickColor = BrickColor.new(colour), Size = partsize, Material = matr, CFrame = cf * CFrame.Angles(math.rad(math.random(-360,360)), math.rad(math.random(-360,360)), math.rad(math.random(-360,360)))}, function(p)
		local m = Instance.new("SpecialMesh", p); m.MeshType = "Sphere"; m.Scale = meshstart; return m
	end, function(p, m, i)
		p.Transparency = inverse and (1 - i) or i
		m.Scale = m.Scale + meshadd
		p.CFrame = p.CFrame * CFrame.new(0, move, 0)
	end, nil, factor)
end

local LuvGun

local function buildGun()
	LuvGun = Instance.new("Model")
	LuvGun.Name = "LuvGun"
	LuvGun.Parent = chara

	local Handle = Create("Part"){
		Parent = LuvGun, Name = "Handaru",
		BrickColor = BrickColor.new("Carnation pink"),
		Material = Enum.Material.SmoothPlastic,
		Size = Vector3.new(0.2,1.1,0.5),
		CFrame = CFrame.new(0,0,0),
		CanCollide = false,
		Color = Color3.new(1,0.596078,0.862745),
	}
	RemoveOutlines(Handle)
	Create("ManualWeld"){
		Parent = Handle, Name = "HWeld",
		Part0 = Handle, Part1 = RightArm,
		C0 = CFrame.new(0,0,0,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849),
		C1 = CFrame.new(-0.164215088,-1.07379532,0.339058399,-1,0,0,0,0,-1,-0,-1,-0),
	}

	local function gunPart(props, meshProps)
		local p = Create("Part"){
			Parent = LuvGun, Name = "Part",
			BrickColor = props.bc or BrickColor.new("Pink"),
			Material = Enum.Material.SmoothPlastic,
			Size = props.size,
			CFrame = CFrame.new(0,0,0),
			CanCollide = false,
			Color = props.color or Color3.new(1,0.4,0.8),
		}
		RemoveOutlines(p)
		if meshProps then
			local m = Instance.new(meshProps.class, p)
			if meshProps.scale then m.Scale = meshProps.scale end
			if meshProps.type then m.MeshType = meshProps.type end
		end
		Create("ManualWeld"){
			Parent = p, Name = "Weld",
			Part0 = p, Part1 = Handle,
			C0 = props.c0 or CFrame.new(),
			C1 = props.c1 or CFrame.new(),
		}
		return p
	end

	gunPart({size = Vector3.new(0.3,0.2,0.1), bc = BrickColor.new("Pink"), c1 = CFrame.new(0,1.56618547,1.17111206,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "BlockMesh", scale = Vector3.new(0.8,0.5,0.8)})
	gunPart({size = Vector3.new(0.3,0.2,0.1), bc = BrickColor.new("Pink"), c1 = CFrame.new(0,1.60091519,1.36807442,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "BlockMesh", scale = Vector3.new(0.8,0.5,0.8)})
	gunPart({size = Vector3.new(0.1,0.6,0.6), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(0,-0.577195883,1.39673233,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "SpecialMesh", type = Enum.MeshType.Cylinder})
	gunPart({size = Vector3.new(0.1,0.7,0.2), bc = BrickColor.new("Pink"), c1 = CFrame.new(0.0999946594,1.49102044,0.168943405,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "SpecialMesh", type = Enum.MeshType.Wedge})
	gunPart({size = Vector3.new(0.1,0.1,0.8), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(-0.0499954224,1.82368135,3.20732307,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "SpecialMesh", type = Enum.MeshType.Wedge})
	gunPart({size = Vector3.new(0.1,0.1,0.2), bc = BrickColor.new("Pink"), c1 = CFrame.new(0,1.43892598,-0.126499176,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "SpecialMesh", scale = Vector3.new(0.2,1,1), type = Enum.MeshType.Wedge})
	gunPart({size = Vector3.new(0.4,0.4,0.1), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(-0.149993896,0.949253559,1.12756157,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "SpecialMesh", scale = Vector3.new(1.2,1,1.2), type = Enum.MeshType.Cylinder})
	gunPart({size = Vector3.new(0.6,0.8,0.6), bc = BrickColor.new("Lily white"), c1 = CFrame.new(1.14440918e-05,-0.134031534,1.31858826,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "CylinderMesh"})
	gunPart({size = Vector3.new(0.1,0.1,0.8), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(0.0500030518,1.82368135,3.20732307,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "SpecialMesh", type = Enum.MeshType.Wedge})
	gunPart({size = Vector3.new(0.1,0.7,0.2), bc = BrickColor.new("Pink"), c1 = CFrame.new(-0.0999984741,1.49102044,0.168943405,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "SpecialMesh", type = Enum.MeshType.Wedge})
	gunPart({size = Vector3.new(0.2,0.4,0.6), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(1.14440918e-05,0.456851482,1.21440125,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "SpecialMesh", type = Enum.MeshType.Cylinder})
	gunPart({size = Vector3.new(0.1,0.1,1.7), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(0.150001526,0.474580526,-1.27651405,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)})
	gunPart({size = Vector3.new(3.9,0.4,0.4), bc = BrickColor.new("Pink"), c1 = CFrame.new(0,1.01003361,1.47226334,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "SpecialMesh", type = Enum.MeshType.Cylinder})
	gunPart({size = Vector3.new(1.9,0.1,0.1), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(0.200000763,0.723151445,2.43672752,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "SpecialMesh", type = Enum.MeshType.Wedge})
	gunPart({size = Vector3.new(0.1,0.1,0.1), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(-0.149993896,0.318296194,-2.16284752,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "SpecialMesh", type = Enum.MeshType.Wedge})
	gunPart({size = Vector3.new(0.3,0.1,1.9), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(0,0.723151445,2.43672752,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)})
	gunPart({size = Vector3.new(0.1,0.5,0.1), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(-0.149993896,0.022854805,-2.11075401,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)})
	gunPart({size = Vector3.new(0.1,0.6,0.6), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(1.14440918e-05,0.309133291,1.240448,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "SpecialMesh", type = Enum.MeshType.Cylinder})
	gunPart({size = Vector3.new(0.1,0.1,0.1), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(-0.149993896,-0.272586584,-2.0586586,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "SpecialMesh", type = Enum.MeshType.Wedge})
	gunPart({size = Vector3.new(0.1,0.1,0.1), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(0.150001526,-0.272586584,-2.0586586,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "SpecialMesh", type = Enum.MeshType.Wedge})
	gunPart({size = Vector3.new(0.4,0.3,0.4), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(0,1.38622999,3.893713,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "SpecialMesh", scale = Vector3.new(1,1.2,1), type = Enum.MeshType.Cylinder})
	gunPart({size = Vector3.new(0.3,0.3,0.4), bc = BrickColor.new("Pink"), c1 = CFrame.new(0,1.3254528,3.5490303,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "SpecialMesh", type = Enum.MeshType.Cylinder})
	gunPart({size = Vector3.new(0.1,0.5,0.1), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(0.150001526,0.022854805,-2.11075401,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)})
	gunPart({size = Vector3.new(0.1,0.4,0.1), bc = BrickColor.new("Carnation pink"), c0 = CFrame.new(0,0,0,1,0,0,0,0.939692736,-0.342019916,0,0.342019886,0.939692736), c1 = CFrame.new(0,0.349468231,0.64012146,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)})
	gunPart({size = Vector3.new(0.1,0.3,0.4), bc = BrickColor.new("Really black"), color = Color3.new(0.0666667,0.0666667,0.0666667), c1 = CFrame.new(0,1.41227698,4.04143715,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "SpecialMesh", scale = Vector3.new(1.1,1,1), type = Enum.MeshType.Cylinder})
	gunPart({size = Vector3.new(0.1,0.5,0.1), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(0,0.170215845,0.452602386,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)})
	gunPart({size = Vector3.new(0.4,0.4,3.9), bc = BrickColor.new("Pink"), c1 = CFrame.new(0,0.81307435,1.50698853,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)})
	gunPart({size = Vector3.new(0.2,0.1,0.1), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(0,-0.272586584,-2.0586586,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)})
	gunPart({size = Vector3.new(0.1,0.1,0.1), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(0.150001526,0.318296194,-2.16284752,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "SpecialMesh", type = Enum.MeshType.Wedge})
	gunPart({size = Vector3.new(0.2,0.2,0.4), bc = BrickColor.new("Pink"), c1 = CFrame.new(0,1.07056713,3.54320145,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "SpecialMesh", type = Enum.MeshType.Cylinder})
	gunPart({size = Vector3.new(0.1,0.1,1.7), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(-0.149997711,0.474580288,-1.27651405,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)})
	gunPart({size = Vector3.new(0.5,0.3,1.9), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(0,0.920113564,2.40199661,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)})
	gunPart({size = Vector3.new(0.3,0.5,0.2), bc = BrickColor.new("Pink"), c0 = CFrame.new(0,0,0,1,0,0,0,0.939692736,-0.342019916,0,0.342019886,0.939692736), c1 = CFrame.new(0,1.36407137,1.95359993,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)})
	gunPart({size = Vector3.new(0.3,0.2,2.1), bc = BrickColor.new("Pink"), c1 = CFrame.new(0,1.41561127,0.893039703,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)})
	gunPart({size = Vector3.new(0.3,0.3,0.2), bc = BrickColor.new("Pink"), c1 = CFrame.new(0,1.00444555,0.00087928772,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)})
	gunPart({size = Vector3.new(0.3,0.2,0.1), bc = BrickColor.new("Pink"), c1 = CFrame.new(0,1.67037416,1.76199532,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "BlockMesh", scale = Vector3.new(0.8,0.5,0.8)})
	gunPart({size = Vector3.new(0.3,0.2,0.1), bc = BrickColor.new("Pink"), c1 = CFrame.new(0,1.63564491,1.56503677,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "BlockMesh", scale = Vector3.new(0.8,0.5,0.8)})
	gunPart({size = Vector3.new(0.3,0.2,0.1), bc = BrickColor.new("Pink"), c1 = CFrame.new(0,1.53145647,0.974153519,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "BlockMesh", scale = Vector3.new(0.8,0.5,0.8)})
	gunPart({size = Vector3.new(0.3,0.2,0.1), bc = BrickColor.new("Pink"), c1 = CFrame.new(0,1.49672723,0.777194977,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "BlockMesh", scale = Vector3.new(0.8,0.5,0.8)})
	gunPart({size = Vector3.new(0.3,0.2,0.1), bc = BrickColor.new("Pink"), c1 = CFrame.new(0,1.46199775,0.58023262,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "BlockMesh", scale = Vector3.new(0.8,0.5,0.8)})
	gunPart({size = Vector3.new(1.9,0.1,0.1), bc = BrickColor.new("Carnation pink"), c1 = CFrame.new(-0.199993134,0.723151445,2.43672752,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849)}, {class = "SpecialMesh", type = Enum.MeshType.Wedge})

	local shotPt = Create("Part"){
		Parent = LuvGun, Name = "ShotPt",
		Transparency = 1,
		Material = Enum.Material.SmoothPlastic,
		Size = Vector3.new(0.1,0.1,0.1),
		CFrame = CFrame.new(0,0,0),
		CanCollide = false,
	}
	RemoveOutlines(shotPt)
	Create("ManualWeld"){
		Parent = shotPt, Name = "Weld",
		Part0 = shotPt, Part1 = Handle,
		C0 = CFrame.new(),
		C1 = CFrame.new(3.81469727e-06,1.42964172,4.13991356,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849),
	}

	return LuvGun, Handle, shotPt
end

local function attachHatBlade()
	local hatid = bytexfesettings.bhatid
	local hatcf = bytexfesettings.bcframele
	local hatlimb = bytexfesettings.bhatlimb or "Right Arm"
	if not (bytexfesettings.usinghats and hatid and hatcf) then return end
	local timeout = 0
	while not (chara and chara:FindFirstChild(hatlimb)) and timeout < 5 do
		task.wait(0.1); timeout = timeout + 0.1
	end
	pcall(function()
		local acc
		for _, v in ipairs(chara:GetChildren()) do
			if v:IsA("Accessory") or v:IsA("Hat") then acc = v; break end
		end
		if not acc then return end
		local handle = acc:FindFirstChild("Handle")
		if not handle then return end
		for _, v in ipairs(handle:GetChildren()) do
			if v:IsA("Weld") or v:IsA("Motor6D") or v:IsA("WeldConstraint") then v:Destroy() end
		end
		local grip = Instance.new("Part")
		grip.Name = "AccessoryGrip"; grip.Size = Vector3.new(0.2,0.2,0.2)
		grip.Transparency = 1; grip.CanCollide = false; grip.Anchored = false
		grip.Parent = chara
		local gw = Instance.new("Motor6D")
		gw.Name = "GripWeld"; gw.Part0 = chara:FindFirstChild(hatlimb) or RightArm; gw.Part1 = grip
		gw.C0 = hatcf; gw.Parent = grip
		local ap = Instance.new("AlignPosition")
		ap.Attachment0 = Instance.new("Attachment", handle)
		ap.Attachment1 = Instance.new("Attachment", grip)
		ap.RigidityEnabled = false; ap.Responsiveness = 200; ap.MaxForce = 100000
		ap.Parent = handle
		local ao = Instance.new("AlignOrientation")
		ao.Attachment0 = ap.Attachment0; ao.Attachment1 = ap.Attachment1
		ao.MaxTorque = 100000; ao.Responsiveness = 200; ao.Parent = handle
	end)
end

local musicSound

local function bindCharacter(c)
	chara = c
	Humanoid = c:WaitForChild("Humanoid")
	Torso = c:WaitForChild("Torso")
	Head = c:WaitForChild("Head")
	RootPart = c:WaitForChild("HumanoidRootPart")
	LeftArm = c:WaitForChild("Left Arm")
	RightArm = c:WaitForChild("Right Arm")
	LeftLeg = c:WaitForChild("Left Leg")
	RightLeg = c:WaitForChild("Right Leg")
	RootJoint = RootPart:WaitForChild("RootJoint")

	for _, v in ipairs(c:GetDescendants()) do
		if v:IsA("Animator") then v:Destroy() end
		if v:IsA("Animation") then v:Destroy() end
	end
	local animate = c:FindFirstChild("Animate")
	if animate then animate:Destroy() end

	Humanoid.WalkSpeed = 16

	RootJoint.C1 = CFrame.new(0,0,0)
	RootJoint.C0 = CFrame.new(0,0,0)
	Torso.Neck.C1 = CFrame.new(0,0,0)
	Torso.Neck.C0 = CFrame.new(0,1.5,0)

	RW = newMotor(Torso, RightArm, CFrame.new(1.5,0,0), CFrame.new(0,0,0))
	LW = newMotor(Torso, LeftArm, CFrame.new(-1.5,0,0), CFrame.new(0,0,0))
	RH = newMotor(Torso, RightLeg, CFrame.new(0.5,-2,0), CFrame.new(0,0,0))
	LH = newMotor(Torso, LeftLeg, CFrame.new(-0.5,-2,0), CFrame.new(0,0,0))

	EffectsFolder = Instance.new("Folder")
	EffectsFolder.Name = "Effects"
	EffectsFolder.Parent = chara

	local _, _, shotPt = buildGun()
	LuvGun:SetAttribute("ShotPt", shotPt:GetFullName())

	musicSound = Instance.new("Sound")
	musicSound.Name = "mus"
	musicSound.SoundId = "rbxassetid://1131624146"
	musicSound.Looped = true
	musicSound.Volume = 1
	musicSound.Parent = Head
	musicSound:Play()
end

local function getShotPt()
	local gun = chara and chara:FindFirstChild("LuvGun")
	if not gun then return nil end
	return gun:FindFirstChild("ShotPt")
end

local function shoot()
	attack = true
	for i = 0, 1, 0.3 do
		swait()
		PlayAnimationFromTable({
			CFrame.new(0,0,0,0.64278698,0,-0.766044974,0,1,0,0.766044974,0,0.64278698),
			CFrame.new(0.0823832005,1.55974865,-0.0981806219,0.604022264,0.219845936,0.766044974,-0.342019916,0.939692736,0,-0.719846904,-0.262002617,0.64278698),
			CFrame.new(1.02804303,0.5,-0.52656126,0.64278698,0.766044974,0,0,0,-1,-0.766044974,0.64278698,0),
			CFrame.new(-1.28728318,0.203263342,-0.756378591,0.875030518,-0.0895627737,0.475710154,0.480547935,0.0424276218,-0.875941575,0.0582684875,0.995077074,0.0801646709),
			CFrame.new(0.499997735,-1.99999893,-1.11758709e-06,0.866025209,0,-0.500000298,0,1,0,0.500000298,0,0.866025209),
			CFrame.new(-0.500001431,-1.99999893,-9.983778e-07,0.766043782,0,0.64278847,0,1,0,-0.64278847,0,0.766043782),
		}, 0.4)
	end
	Humanoid.WalkSpeed = 2
	local ref = Instance.new("Part")
	ref.Size = Vector3.new(0.1,0.1,0.1)
	ref.Anchored = true
	ref.CanCollide = false
	ref.CanQuery = false
	ref.Transparency = 1
	ref.Parent = workspace
	repeat
		local pt = getShotPt()
		so(1145251796, pt or Head, math.random(95,105)/100, 3)
		ref.CFrame = Mouse.Hit
		MagnitudeDmg(ref, 2, 5)
		for i = 0, 1, 0.5 do
			swait()
			PlayAnimationFromTable({
				CFrame.new(2.25380063e-06,0,0.100001052,0.64278698,0,-0.766044974,0,1,0,0.766044974,0,0.64278698),
				CFrame.new(0.0823859125,1.55974913,-0.0981838703,0.604022264,0.219845936,0.766044974,-0.342019916,0.939692736,0,-0.719846904,-0.262002617,0.64278698),
				CFrame.new(1.25785875,0.5,-0.333723217,0.64278698,0.766044974,0,0,0,-1,-0.766044974,0.64278698,0),
				CFrame.new(-1.05747044,0.203263938,-0.563540041,0.875030518,-0.0895627737,0.475710154,0.480547935,0.0424276218,-0.875941575,0.0582684875,0.995077074,0.0801646709),
				CFrame.new(0.423390329,-1.99999893,-0.0642812699,0.866025209,0,-0.500000298,0,1,0,0.500000298,0,0.866025209),
				CFrame.new(-0.57660532,-1.99999893,-0.0642794371,0.766043782,0,0.64278847,0,1,0,-0.64278847,0,0.766043782),
			}, 0.4)
		end
		for i = 0, 1, 0.5 do
			swait()
			PlayAnimationFromTable({
				CFrame.new(0,0,0,0.64278698,0,-0.766044974,0,1,0,0.766044974,0,0.64278698),
				CFrame.new(0.0823832005,1.55974865,-0.0981806219,0.604022264,0.219845936,0.766044974,-0.342019916,0.939692736,0,-0.719846904,-0.262002617,0.64278698),
				CFrame.new(1.02804303,0.5,-0.52656126,0.64278698,0.766044974,0,0,0,-1,-0.766044974,0.64278698,0),
				CFrame.new(-1.28728318,0.203263342,-0.756378591,0.875030518,-0.0895627737,0.475710154,0.480547935,0.0424276218,-0.875941575,0.0582684875,0.995077074,0.0801646709),
				CFrame.new(0.499997735,-1.99999893,-1.11758709e-06,0.866025209,0,-0.500000298,0,1,0,0.500000298,0,0.866025209),
				CFrame.new(-0.500001431,-1.99999893,-9.983778e-07,0.766043782,0,0.64278847,0,1,0,-0.64278847,0,0.766043782),
			}, 0.4)
		end
	until zhold == false
	ref:Destroy()
	Humanoid.WalkSpeed = 16
	attack = false
end

local function doge()
	attack = true
	Humanoid.WalkSpeed = 0
	so(536642316, Torso, 1, 1)
	local bv = Instance.new("BodyVelocity")
	bv.P = 1e7; bv.MaxForce = Vector3.new(1e7,1e7,1e7)
	bv.Velocity = RootPart.CFrame.LookVector*50
	bv.Parent = RootPart
	for i = 0, 1, 0.2 do
		swait()
		PlayAnimationFromTable({
			CFrame.new(0,-0.413182259,-0.492409885,1,0,0,0,0.173647001,0.984807968,0,-0.984807968,0.173647001),
			CFrame.new(0,1.39017391,0.409808099,1,0,0,0,0.499998748,-0.866026163,0,0.866026163,0.499998748),
			CFrame.new(0.858022809,0.339910388,-0.78796947,0.296197057,0.813798428,0.499999553,0.171009049,0.469846249,-0.866025627,-0.939693213,0.342018723,1.7801861e-07),
			CFrame.new(-1.12680423,-0.351213962,-0.287614167,0.0669000372,0.109107949,0.991776109,0.843825459,0.52423954,-0.114593051,-0.532431304,0.844552159,-0.05699642),
			CFrame.new(0.5,-2,-2.86102295e-06,1,0,0,0,1,0,0,0,1),
			CFrame.new(-0.5,-2,-2.86102295e-06,1,0,0,0,1,0,0,0,1),
		}, 0.4)
		bv.Velocity = RootPart.CFrame.LookVector*50
	end
	for i = 0, 1, 0.2 do
		swait()
		PlayAnimationFromTable({
			CFrame.new(0,-1.30470812,-0.622091293,1,0,0,0,-0.866025984,0.499998987,0,-0.499998987,-0.866025984),
			CFrame.new(0,1.47984993,-0.230206192,1,0,0,0,0.939693034,0.34201926,0,-0.34201926,0.939693034),
			CFrame.new(0.858022809,0.339910388,-0.78796947,0.296197057,0.813798428,0.499999553,0.171009049,0.469846249,-0.866025627,-0.939693213,0.342018723,1.7801861e-07),
			CFrame.new(-1.12680423,-0.351213962,-0.287614167,0.0669000372,0.109107949,0.991776109,0.843825459,0.52423954,-0.114593051,-0.532431304,0.844552159,-0.05699642),
			CFrame.new(0.5,-1.19999313,-0.600002289,1,0,0,0,1,0,0,0,1),
			CFrame.new(-0.5,-1.19999313,-0.600002289,1,0,0,0,1,0,0,0,1),
		}, 0.4)
		bv.Velocity = RootPart.CFrame.LookVector*50
	end
	for i = 0, 1, 0.2 do
		swait()
		PlayAnimationFromTable({
			CFrame.new(0,-2.22375727,0.305265486,1,0,0,0,0.500000238,-0.866025388,0,0.866025388,0.500000238),
			CFrame.new(0,1.35128808,-0.383415997,1,0,0,0,0.766043901,0.642788529,0,-0.64278847,0.766043901),
			CFrame.new(0.858022809,0.339910388,-0.78796947,0.296197057,0.813798428,0.499999553,0.171009049,0.469846249,-0.866025627,-0.939693213,0.342018723,1.7801861e-07),
			CFrame.new(-1.12680423,-0.351213962,-0.287614167,0.0669000372,0.109107949,0.991776109,0.843825459,0.52423954,-0.114593051,-0.532431304,0.844552159,-0.05699642),
			CFrame.new(0.5,-1.19999337,-0.599998593,1,0,0,0,1.00000024,0,0,0,1.00000024),
			CFrame.new(-0.500003815,-1.35979521,-0.923200667,1,0,0,0,0.866025388,-0.500000238,0,0.500000238,0.866025388),
		}, 0.4)
		bv.Velocity = RootPart.CFrame.LookVector*50
	end
	bv:Destroy()
	Humanoid.WalkSpeed = 16
	attack = false
end

local function bdoge()
	attack = true
	Humanoid.WalkSpeed = 0
	so(536642316, Torso, 1, 1)
	local bv = Instance.new("BodyVelocity")
	bv.P = 1e7; bv.MaxForce = Vector3.new(1e7,1e7,1e7)
	bv.Velocity = RootPart.CFrame.LookVector*-50
	bv.Parent = RootPart
	for i = 0, 1, 0.2 do
		swait()
		PlayAnimationFromTable({
			CFrame.new(0,-2.22375727,0.305265486,1,0,0,0,0.500000238,-0.866025388,0,0.866025388,0.500000238),
			CFrame.new(0,1.35128808,-0.383415997,1,0,0,0,0.766043901,0.642788529,0,-0.64278847,0.766043901),
			CFrame.new(0.858022809,0.339910388,-0.78796947,0.296197057,0.813798428,0.499999553,0.171009049,0.469846249,-0.866025627,-0.939693213,0.342018723,1.7801861e-07),
			CFrame.new(-1.12680423,-0.351213962,-0.287614167,0.0669000372,0.109107949,0.991776109,0.843825459,0.52423954,-0.114593051,-0.532431304,0.844552159,-0.05699642),
			CFrame.new(0.5,-1.19999337,-0.599998593,1,0,0,0,1.00000024,0,0,0,1.00000024),
			CFrame.new(-0.500003815,-1.35979521,-0.923200667,1,0,0,0,0.866025388,-0.500000238,0,0.500000238,0.866025388),
		}, 0.4)
		bv.Velocity = RootPart.CFrame.LookVector*-50
	end
	for i = 0, 1, 0.2 do
		swait()
		PlayAnimationFromTable({
			CFrame.new(0,-1.30470812,-0.622091293,1,0,0,0,-0.866025984,0.499998987,0,-0.499998987,-0.866025984),
			CFrame.new(0,1.47984993,-0.230206192,1,0,0,0,0.939693034,0.34201926,0,-0.34201926,0.939693034),
			CFrame.new(0.858022809,0.339910388,-0.78796947,0.296197057,0.813798428,0.499999553,0.171009049,0.469846249,-0.866025627,-0.939693213,0.342018723,1.7801861e-07),
			CFrame.new(-1.12680423,-0.351213962,-0.287614167,0.0669000372,0.109107949,0.991776109,0.843825459,0.52423954,-0.114593051,-0.532431304,0.844552159,-0.05699642),
			CFrame.new(0.5,-1.19999313,-0.600002289,1,0,0,0,1,0,0,0,1),
			CFrame.new(-0.5,-1.19999313,-0.600002289,1,0,0,0,1,0,0,0,1),
		}, 0.4)
		bv.Velocity = RootPart.CFrame.LookVector*-50
	end
	bv:Destroy()
	Humanoid.WalkSpeed = 16
	attack = false
end

local function adoge()
	attack = true
	Humanoid.WalkSpeed = 0
	so(536642316, Torso, 1, 1)
	Effects.Wave(RootPart.CFrame*CFrame.Angles(math.rad(90),0,0), Vector3.new(), Vector3.new(1,0.1,1), "White", math.random(-10,10), false, 0.1)
	BodyVel(RootPart, RootPart.CFrame.LookVector*50)
	for i = 0, 1, 0.1 do
		swait()
		PlayAnimationFromTable({
			CFrame.new(0,-0.095761165,-0.251516223,1,0,0,0,0.939692736,0.342019886,0,-0.342019916,0.939692736),
			CFrame.new(0,1.43075883,0.149916381,1,0,0,0,0.939692736,-0.342019916,0,0.342019886,0.939692736),
			CFrame.new(0.858022809,0.339910388,-0.78796947,0.296197057,0.813798428,0.499999553,0.171009049,0.469846249,-0.866025627,-0.939693213,0.342018723,1.7801861e-07),
			CFrame.new(-1.12680423,-0.351213962,-0.287614167,0.0669000372,0.109107949,0.991776109,0.843825459,0.52423954,-0.114593051,-0.532431304,0.844552159,-0.05699642),
			CFrame.new(0.5,-1.96527231,0.196966231,1,0,0,0,0.984807789,0.173648685,0,-0.173648715,0.984807789),
			CFrame.new(-0.5,-1.43618584,-0.205210268,1,0,0,0,0.939692438,0.342020929,0,-0.342020959,0.939692438),
		}, 0.4)
	end
	Humanoid.WalkSpeed = 16
	attack = false
end

local function badoge()
	attack = true
	Humanoid.WalkSpeed = 0
	so(536642316, Torso, 1, 1)
	Effects.Wave(RootPart.CFrame*CFrame.Angles(math.rad(-90),0,0), Vector3.new(), Vector3.new(1,0.1,1), "White", math.random(-10,10), false, 0.1)
	BodyVel(RootPart, RootPart.CFrame.LookVector*-50)
	for i = 0, 1, 0.1 do
		swait()
		PlayAnimationFromTable({
			CFrame.new(0,-0.210508779,0.312937856,1,0,0,0,0.866025388,-0.500000238,0,0.500000238,0.866025388),
			CFrame.new(0,1.4075644,-0.288293391,1,0,0,0,0.866025388,0.500000238,0,-0.500000238,0.866025388),
			CFrame.new(0.858022809,0.339910388,-0.78796947,0.296197057,0.813798428,0.499999553,0.171009049,0.469846249,-0.866025627,-0.939693213,0.342018723,1.7801861e-07),
			CFrame.new(-1.12680423,-0.351213962,-0.287614167,0.0669000372,0.109107949,0.991776109,0.843825459,0.52423954,-0.114593051,-0.532431304,0.844552159,-0.05699642),
			CFrame.new(0.5,-1.9652698,0.196958005,1,0,0,0,0.984807789,0.173648715,0,-0.173648685,0.984807789),
			CFrame.new(-0.5,-1.43618536,-0.205215126,1,0,0,0,0.939692676,0.342020601,0,-0.342020601,0.939692676),
		}, 0.4)
	end
	Humanoid.WalkSpeed = 16
	attack = false
end

local function safeShoot()
	if not chara or not chara.Parent then return end
	if not getShotPt() then return end
	if attack == false then
		zhold = true
		local ok, err = pcall(shoot)
		if not ok then warn("[shoot] "..tostring(err)); attack = false; zhold = false end
	end
end

local function safeDoge(fn)
	if not chara or not chara.Parent or not Humanoid then return end
	local ok, err = pcall(fn)
	if not ok then warn("[doge] "..tostring(err)); attack = false end
end

local function bindAndAttach(c)
	local ok, err = pcall(bindCharacter, c)
	if not ok then warn("[bind] "..tostring(err)); return end
	attachHatBlade()
end

bindAndAttach(Player.Character or Player.CharacterAdded:Wait())

local function shutdown()
	if Humanoid then
		pcall(function() Humanoid.WalkSpeed = 16 end)
	end
	if EffectsFolder and EffectsFolder.Parent then EffectsFolder:Destroy() end
	if musicSound and musicSound.Parent then pcall(function() musicSound:Destroy() end) end
	if LuvGun and LuvGun.Parent then LuvGun:Destroy() end
	if chara then
		for _, v in ipairs(chara:GetChildren()) do
			if v:IsA("Part") and v.Name == "AccessoryGrip" then v:Destroy() end
		end
	end
end

Player.CharacterRemoving:Connect(shutdown)

Mouse.Button1Down:Connect(function() safeShoot() end)
Mouse.Button1Up:Connect(function() zhold = false end)

UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if not chara or not chara.Parent or not Humanoid then return end
	local k = input.KeyCode.Name:lower()
	if k == "m" and musicSound and musicSound.Parent then
		if musicSound.IsPlaying then musicSound:Stop()
		elseif musicSound.IsPaused then musicSound:Resume()
		else musicSound:Play() end
	end
	if attack == false then
		if k == "q" then
			if Anim == "Fall" or Anim == "Jump" then safeDoge(badoge) else safeDoge(bdoge) end
		elseif k == "e" then
			if Anim == "Fall" or Anim == "Jump" then safeDoge(adoge) else safeDoge(doge) end
		end
	end
end)

UIS.InputEnded:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.Z then zhold = false end
end)

RunService.RenderStepped:Connect(function()
	if not chara or not chara.Parent then return end
	if not RootPart or not RootPart.Parent then return end
	if not Humanoid or Humanoid.Health <= 0 then return end
	local Torsovelocity = (RootPart.Velocity * Vector3.new(1,0,1)).Magnitude
	local hit = rayCast(RootPart.Position, (CFrame.new(RootPart.Position, RootPart.Position - Vector3.new(0,1,0))).LookVector, 4, chara)
	sine = sine + change
	if RootPart.Velocity.Y > 1 and hit == nil then
		Anim = "Jump"
		if attack == false then
			PlayAnimationFromTable({
				CFrame.new(0,0.0382082276,-0.0403150208,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849),
				CFrame.new(0,1.46579528,0.0939689279,1,0,0,0,0.939692855,-0.342019796,0,0.342019796,0.939692855),
				CFrame.new(1.20945489,-0.213504896,3.55388607e-07,0.939692736,0.342019916,1.53461215e-07,-0.342019945,0.939692736,1.93715096e-07,-8.56816769e-08,-2.23517418e-07,1.00000012),
				CFrame.new(-1.20945573,-0.213503733,5.0439985e-07,0.939692736,-0.342019916,-1.53461215e-07,0.342019945,0.939692736,1.93715096e-07,8.56816769e-08,-2.23517418e-07,1.00000012),
				CFrame.new(0.5,-1.99739456,-0.0180913229,1,0,0,0,1.00000012,0,0,0,1.00000012),
				CFrame.new(-0.5,-1.30000103,-0.39999947,1,0,0,0,0.939692676,0.342020601,0,-0.342020601,0.939692676),
			}, 0.3)
		end
	elseif RootPart.Velocity.Y < -1 and hit == nil then
		Anim = "Fall"
		if attack == false then
			PlayAnimationFromTable({
				CFrame.new(0,-0.0646628663,0.0399149321,1,0,0,0,0.984807849,-0.173647985,0,0.173647985,0.984807849),
				CFrame.new(0,1.4913609,-0.128171027,1,0,0,0,0.939692855,0.342019796,0,-0.342019796,0.939692855),
				CFrame.new(1.55285025,0.466259956,-9.26282269e-08,0.766043842,-0.642788351,-6.46188241e-08,0.642788291,0.766043961,-7.4505806e-08,1.04308128e-07,1.49011612e-08,1.00000012),
				CFrame.new(-1.5605253,0.475036323,-2.10609159e-07,0.766043842,0.642788351,6.46188241e-08,-0.642788291,0.766043961,-7.4505806e-08,-1.04308128e-07,1.49011612e-08,1.00000012),
				CFrame.new(0.500000954,-1.9973948,-0.0180922765,1,0,0,0,1.00000012,0,0,0,1.00000012),
				CFrame.new(-0.499999046,-1.30000043,-0.400000483,1,0,0,0,0.939692855,0.342019796,0,-0.342019796,0.939692855),
			}, 0.3)
		end
	elseif Torsovelocity < 1 and hit ~= nil then
		Anim = "Idle"
		if attack == false then
			change = 1
			PlayAnimationFromTable({
				CFrame.new(-0.0769465268,-7.7815578e-08,-0.031559173,0.939695537,1.01607293e-06,0.342021346,7.9855522e-07,1.00000191,5.12654879e-07,-0.342019558,2.16066837e-07,0.939692855) * CFrame.new(0,0.05*math.cos(sine/10),0),
				CFrame.new(0.0615186803,1.4999913,0.0559706129,0.939695537,7.9855522e-07,-0.342019558,1.01607293e-06,1.00000191,2.16066837e-07,0.342021346,5.12654879e-07,0.939692855),
				CFrame.new(0.858022809,0.339910388,-0.78796947,0.296197057,0.813798428,0.499999553,0.171009049,0.469846249,-0.866025627,-0.939693213,0.342018723,1.7801861e-07),
				CFrame.new(-1.12680423,-0.351213962,-0.287614167,0.0669000372,0.109107949,0.991776109,0.843825459,0.52423954,-0.114593051,-0.532431304,0.844552159,-0.05699642),
				CFrame.new(0.500003159,-2.00000715,-1.98185444e-06,0.939692736,0,-0.342019916,0,1,0,0.342019886,0,0.939692736) * CFrame.new(0,-0.05*math.cos(sine/10),0),
				CFrame.new(-0.500018835,-2.0000062,2.08616257e-07,0.939692438,0,0.342020929,0,1,0,-0.342020959,0,0.939692438) * CFrame.new(0,-0.05*math.cos(sine/10),0),
			}, 0.3)
		end
	elseif Torsovelocity > 2 and hit ~= nil then
		Anim = "Walk"
		if attack == false then
			Humanoid.WalkSpeed = 16
			PlayAnimationFromTable({
				CFrame.new(0,0,0,1,0,0,0,1,0,0,0,1) * CFrame.new(0,0-0.08*math.cos(sine/2.5),0),
				CFrame.new(0,1.48263013,-0.0984808952,1,0,0,0,0.984807849,0.173647985,0,-0.173647985,0.984807849),
				CFrame.new(0.858022809,0.339910388,-0.78796947,0.296197057,0.813798428,0.499999553,0.171009049,0.469846249,-0.866025627,-0.939693213,0.342018723,1.7801861e-07),
				CFrame.new(-1.12680423,-0.351213962,-0.287614167,0.0669000372,0.109107949,0.991776109,0.843825459,0.52423954,-0.114593051,-0.532431304,0.844552159,-0.05699642),
				CFrame.new(0.540300786,-1.99793816,-9.82598067e-07,0.998698533,-0.0510031395,6.36324955e-07,0.0510031395,0.998698533,-1.00461093e-05,-8.35937328e-08,1.08393433e-05,1.00000024) * CFrame.new(0,0,0+0.5*math.cos(sine/5)) * CFrame.Angles(math.rad(0-30*math.cos(sine/5)),0,0),
				CFrame.new(-0.539563596,-1.99794078,1.12228372e-06,0.998635888,0.0523072146,-1.77852357e-07,-0.0523072146,0.998635888,-1.00715051e-05,-3.89727461e-07,1.08406466e-05,1.00000024) * CFrame.new(0,0,0-0.5*math.cos(sine/5)) * CFrame.Angles(math.rad(0+30*math.cos(sine/5)),0,0),
			}, 0.3)
		end
	end
end)
