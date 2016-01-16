-- Inspired by SmegHack :)
-- Created by Sir Francis Billard

Derma_Message( "BillardHack has been successfully loaded!", "BilllardHack", "Close" )

local hook = hook
local draw = draw
local player = player
local ents = ents
local concommand = concommand

local function ShouldShootAt( thing )
		return ( ( tobool( GetConVarNumber( "billardhack_target_npcs" ) ) and thing:IsNPC() ) or thing:IsPlayer() ) and IsValid( thing )
end

local function GetAllTraceEntity()
	for k, v in pairs( player.GetAll() ) do
	print( v:Nick() .. " is looking at " .. tostring( v:GetEyeTrace().Entity ) )
	end
end

local function GetAllTraceTexture()
	for k, v in pairs( player.GetAll() ) do
	print( v:Nick() .. " is looking at " .. tostring( v:GetEyeTrace().HitTexture ) )
	end
end

local function GetAllTracePos()
	for k, v in pairs( player.GetAll() ) do
		print( v:Nick() .. " is looking at exactly " .. tostring( v:GetEyeTrace().HitPos ) )
	end
end

hook.Add( "HUDPaint", "BillardHack_Crosshair", function()
	if tobool( GetConVarNumber( "billardhack_crosshair" ) ) then
		local red = GetConVarNumber( "billardhack_crosshair_r" )
		local green = GetConVarNumber( "billardhack_crosshair_g" )
		local blue = GetConVarNumber( "billardhack_crosshair_b" )
		local alph = GetConVarNumber( "billardhack_crosshair_alpha" )
		local size = GetConVarNumber( "billardhack_crosshair_size" )
		local thickness = GetConVarNumber( "billardhack_crosshair_thickness" )
		draw.RoundedBox( 2, ( ScrW() / 2 ) - ( size / 2 ), ScrH() / 2, size, thickness, Color( red, green, blue, alph ) )
		draw.RoundedBox( 2, ScrW() / 2, ( ScrH() / 2 ) - ( size / 2 ), thickness, size, Color( red, green, blue, alph ) )
	end
end )

hook.Add( "PreDrawHalos", "BillardHack_Wallhack", function()
	if tobool( GetConVarNumber( "billardhack_wallhack" ) ) then
		halo.Add( player.GetAll(), Color( 255, 0, 0 ), 0, 0, 2, true, true )
		halo.Add( ents.FindByClass( "money_printer_*" ), Color( 0, 0, 255 ), 0, 0, 2, true, true )
		halo.Add( ents.FindByClass( "bit_miner_*" ), Color( 0, 0, 255 ), 0, 0, 2, true, true )
		halo.Add( ents.FindByClass( "*_money_printer" ), Color( 0, 0, 255 ), 0, 0, 2, true, true )
		halo.Add( ents.FindByClass( "spawned_*" ), Color( 0, 255, 0 ), 0, 0, 2, true, true )
		halo.Add( ents.FindByClass( "item_*" ), Color( 0, 255, 0 ), 0, 0, 2, true, true )
		halo.Add( ents.FindByClass( "cityrp_*" ), Color( 0, 255, 0 ), 0, 0, 2, true, true )
		halo.Add( ents.FindByClass( "keypad" ), Color( 0, 255, 0 ), 0, 0, 2, true, true )
		halo.Add( ents.FindByClass( "weapon_*" ), Color( 255, 0, 255 ), 0, 0, 2, true, true )
		halo.Add( ents.FindByClass( "m9k_*" ), Color( 255, 0, 255 ), 0, 0, 2, true, true )
		halo.Add( ents.FindByClass( "prop_vehicle_*" ), Color( 255, 255, 0 ), 0, 0, 2, true, true )
		halo.Add( ents.FindByClass( "vehicle_*" ), Color( 255, 255, 0 ), 0, 0, 2, true, true )
	end
end )

hook.Add("Think", "BillardHack_Aimbot", function()
	if tobool( GetConVarNumber( "billardhack_aimbot" ) ) then
		local ply = LocalPlayer()
		local trace = util.GetPlayerTrace( ply )
		local traceRes = util.TraceLine( trace )
		if traceRes.HitNonWorld then
			local target = traceRes.Entity
			if ShouldShootAt( target ) then
				local targethead = target:LookupBone( "ValveBiped.Bip01_Head1" )
				local targetheadpos, targetheadang = target:GetBonePosition( targethead )
				ply:SetEyeAngles( ( targetheadpos - ply:GetShootPos() ):Angle() )
			end
		end
	end
end)

hook.Add("Think", "BillardHack_Triggerbot", function()
	if tobool( GetConVarNumber( "billardhack_triggerbot" ) ) then
		local ply = LocalPlayer()
		local trace = util.GetPlayerTrace( ply )
		local traceRes = util.TraceLine( trace )
		if traceRes.HitNonWorld then
			local target = traceRes.Entity
			if ShouldShootAt( target ) then
				LocalPlayer():ConCommand("+attack")
				timer.Simple( 0.05, function() LocalPlayer():ConCommand("-attack") end )
			end
		end
	end
end)

hook.Add( "CreateMove", "BillardHack_Bhop", function( ucmd )
	if tobool( GetConVarNumber( "billardhack_bhop" ) ) then
		if ucmd:KeyDown( IN_JUMP ) then
			if LocalPlayer():WaterLevel() <= 1 && LocalPlayer():GetMoveType() != MOVETYPE_LADDER && !LocalPlayer():IsOnGround() then
				ucmd:RemoveKey( IN_JUMP )
			end
		end
	end
end )

hook.Add( "HUDPaint", "BillardHack_ESP", function()
	if tobool( GetConVarNumber( "billardhack_esp" ) ) then
		if tobool( GetConVarNumber( "billardhack_esp_info" ) ) then
			for k, v in pairs( player.GetAll() ) do
				local pos = ( v:GetShootPos() + Vector( 0, 0, 20 ) ):ToScreen()
				local clr = team.GetColor( v:Team() )
				local outlineClr = Color( 0, 0, 0, 255 )
				draw.SimpleTextOutlined( v:Nick(), "Default", pos.x, pos.y - 45, clr, 1, 1, 1, outlineClr )
				draw.SimpleTextOutlined( "Health: "..v:Health(), "Default", pos.x, pos.y -30, clr, 1, 1, 1, outlineClr )
				draw.SimpleTextOutlined( "Armor: "..v:Armor(), "Default", pos.x, pos.y - 15, clr, 1, 1, 1, outlineClr )
				if v:GetActiveWeapon():IsValid() then draw.SimpleTextOutlined( v:GetActiveWeapon():GetPrintName(), "Default", pos.x, pos.y, clr, 1, 1, 1, outlineClr ) end
			end
		end
		--[[
		if tobool( GetConVarNumber( "billardhack_esp_boxes" ) ) then
			for k, v in pairs( player.GetAll() ) do
				local pos = ( v:GetShootPos() + Vector( 0, 0, 20 ) ):ToScreen()
				local clr = team.GetColor( v:Team() )
				draw.RoundedBox( 0, v:OBBMaxs().x, v:OBBMins(), 80, 2, clr )
			end
		end
		]]
	end
end )

hook.Add( "HUDPaint", "BillardHack_HUD", function()
	if tobool( GetConVarNumber( "billardhack_hud" ) ) then
		if tobool( GetConVarNumber( "billardhack_hud_health" ) ) then
			local health = LocalPlayer():Health()
			local armor = LocalPlayer():Armor()
		end
	end
end )

CreateClientConVar( "billardhack_crosshair", 0, true, false )
CreateClientConVar( "billardhack_crosshair_r", 255, true, false )
CreateClientConVar( "billardhack_crosshair_g", 50, true, false )
CreateClientConVar( "billardhack_crosshair_b", 50, true, false )
CreateClientConVar( "billardhack_crosshair_alpha", 200, true, false )
CreateClientConVar( "billardhack_crosshair_size", 30, true, false )
CreateClientConVar( "billardhack_crosshair_thickness", 4, true, false )
CreateClientConVar( "billardhack_wallhack", 0, true, false )
CreateClientConVar( "billardhack_aimbot", 0, true, false )
CreateClientConVar( "billardhack_triggerbot", 0, true, false )
CreateClientConVar( "billardhack_target_npcs", 0, true, false )
CreateClientConVar( "billardhack_bhop", 0, true, false )
CreateClientConVar( "billardhack_esp", 0, true, false )
CreateClientConVar( "billardhack_esp_info", 0, true, false )
CreateClientConVar( "billardhack_esp_boxes", 0, true, false )
CreateClientConVar( "billardhack_hud", 0, true, false )
CreateClientConVar( "billardhack_hud_health", 0, true, false )
CreateClientConVar( "billardhack_hud_armor", 0, true, false )

concommand.Add( "billardhack_trace_entity", GetAllTraceEntity )
concommand.Add( "billardhack_trace_texture", GetAllTraceTexture )
concommand.Add( "billardhack_trace_pos", GetAllTracePos )
