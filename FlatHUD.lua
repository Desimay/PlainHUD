/*---------------------------------------------------------------------------
Which default HUD elements should be hidden?
---------------------------------------------------------------------------*/

local hideHUDElements = {
	-- if you DarkRP_HUD this to true, ALL of DarkRP's HUD will be disabled. That is the health bar and stuff,
	-- but also the agenda, the voice chat icons, lockdown text, player arrested text and the names above players' heads
	["DarkRP_HUD"] = true,

	-- DarkRP_EntityDisplay is the text that is drawn above a player when you look at them.
	-- This also draws the information on doors and vehicles
	["DarkRP_EntityDisplay"] = false,

	-- DarkRP_ZombieInfo draws information about zombies for admins who use /showzombie.
	["DarkRP_ZombieInfo"] = false,

	-- This is the one you're most likely to replace first
	-- DarkRP_LocalPlayerHUD is the default HUD you see on the bottom left of the screen
	-- It shows your health, job, salary and wallet, but NOT hunger (if you have hungermod enabled)
	["DarkRP_LocalPlayerHUD"] = false,

	-- If you have hungermod enabled, you will see a hunger bar in the DarkRP_LocalPlayerHUD
	-- This does not get disabled with DarkRP_LocalPlayerHUD so you will need to disable DarkRP_Hungermod too
	["DarkRP_Hungermod"] = false,

	-- Drawing the DarkRP agenda
	["DarkRP_Agenda"] = false
}

-- this is the code that actually disables the drawing.
hook.Add("HUDShouldDraw", "HideDefaultDarkRPHud", function(name)
	if hideHUDElements[name] then return false end
end)

/*---------------------------------------------------------------------------
The Custom HUD
only draws health
---------------------------------------------------------------------------*/

surface.CreateFont("HPFont", {font="Trebuchet24", size=34, outline = true, weight = 500})
surface.CreateFont("InfoFont", {font="Trebuchet24", size=28, outline = false, weight = 500})

function AvatarPaint()
	local Avatar = vgui.Create("AvatarImage")
	Avatar:SetSize(128, 128)
	Avatar:SetPos(33, ScrH () - 272)
	Avatar:SetPlayer(LocalPlayer(), 64)
end
timer.Simple(3, function()
	AvatarPaint()
end)

local function AddComma(n)
	local sn = tostring(n)
	local tab = {}
	sn = string.ToTable(sn)
	for i=0,#sn-1 do
		if i%3 == #sn%3 and !(i==0) then
			table.insert(tab, ",")
		end
		table.insert(tab, sn[i+1])
	end
	return string.Implode("",tab)
end
	
local function hudPaint()
	local HP 		= LocalPlayer():Health()
	local Armor		= LocalPlayer():Armor()
	local Job		= LocalPlayer().DarkRPVars.job
	local Group		= LocalPlayer():GetNWString('usergroup')
	local WantInfo	= "";
	local Status	= false;

	if LocalPlayer().DarkRPVars.wanted then
		Status = true
		WantInfo = "Wanted!"
	else
		Status = false
		WantInfo = "Not Wanted!"
	end

	if Group == "superadmin" then 
		Group = "S. Admin"
	elseif Group == "admin" then
		Group = "Admin"
	elseif Group == "moderator" then
		Group = "Mod"
	elseif Group == "donator" then
		Group = "VIP Member"
	elseif Group == "regular" then
		Group = "Member"
	end

	local v1 = LocalPlayer().DarkRPVars.money
	if not v1 then v1 = "" end

	local v2 = LocalPlayer().DarkRPVars.salary
	if not v2 then v2 = "" end

	-- Black Outline and Main BG
	draw.RoundedBox(2, 20, ScrH() - 285, 400, 250, Color(5, 5, 5, 255))
	draw.RoundedBox(2, 25, ScrH() - 280, 390, 240, Color(149, 165, 166,255))

	-- Lines for Sections
	draw.RoundedBox(2, 25, ScrH() - 135, 390, 5, Color(127, 140, 141, 255))
	draw.RoundedBox(2, 170, ScrH() - 280, 5, 145, Color(127, 140, 141, 255))

	-- health and armor
	draw.RoundedBox(2, 120, ScrH() - 120, 200, 20, Color(127, 140, 141, 255))
	draw.RoundedBox(2, 120, ScrH() - 120, math.Clamp(HP, 0, 200) * 2, 20, Color(255, 47, 33,255))
	draw.SimpleText("Health: ", "Trebuchet24", 40, ScrH() - 125, Color(127, 140, 141))

	draw.RoundedBox(2, 120, ScrH() - 80, 200, 20, Color(127, 140, 141, 255))
	draw.RoundedBox(2, 120, ScrH() - 80, math.Clamp(Armor, 0, 200) * 2, 20, Color(52, 152, 219,255))
	draw.SimpleText("Armor: ", "Trebuchet24", 40, ScrH() - 85, Color(127, 140, 141))

	-- Information 
	draw.SimpleText("Money: $"..AddComma(v1), "InfoFont", 185, ScrH() - 272, Color(127, 140, 141))
	draw.SimpleText("Salary: $"..v2, "InfoFont", 185, ScrH() - 248, Color(127, 140, 141))
	draw.SimpleText("Job: "..Job, "InfoFont", 185, ScrH() - 224, Color(127, 140, 141))
	draw.SimpleText("Group: "..Group, "InfoFont", 185, ScrH() - 200, Color(127, 140, 141))
	draw.SimpleText("Status: "..WantInfo, "InfoFont", 185, ScrH() - 176, Color(127, 140, 141))
end
hook.Add("HUDPaint", "DarkRP_Mod_HUDPaint", hudPaint)
