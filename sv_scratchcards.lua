ScratchCards = {}
ScratchCards.Win = {}
ScratchCards.CardPrice = -600 --Must be negative or will add money upon purchase
ScratchCards.Win.AmountHigher = 4800 --Highest amount of money you get if you win
ScratchCards.Win.AmountLower = 1200 --Lowest amount of money you get if you win
ScratchCards.Win.Chance = 5 -- Percent chance out of 100

--All created/written/read files are relative to GarrysMod/garrysmod/data if you want to change them

if not file.Exists( "darkrp_scratch_cards" ) then
	file.CreateDir( "darkrp_scratch_cards" )
end

function GivePlayerScratchCardLoot( ply )

end

hook.Add( "PlayerSay", "ScratchCardsBuyCardHook", function( ply, text, teamChat )
 	if not IsValid( ply ) then return end
 	if text == "/buyscratchcard" then
 		local PlayerSteamID = tostring( ply:SteamID() )
 		if file.Exists( "darkrp_scratch_cards/"..PlayerSteamID..".lua" ) then
 			local PlayerScratchCards = file.Read( PlayerSteamID..".lua" )
 			local PlayerNewScratchCards = tonumber( PlayerScratchCards ) + 1
 			file.Write( "darkrp_scratch_cards/"..PlayerSteamID..".lua", PlayerNewScratchCards )
 			ply:addMoney( ScratchCards.CardPrice )
 		else
 			file.Write( "darkrp_scratch_cards/"..PlayerSteamID..".lua", 1 ) --Give them one scratch card
 		end
 	end
end )

hook.Add( "PlayerSay", "ScratchCardsUseCardHook", function( ply, text, teamChat )
 	if not IsValid( ply ) then return end
 	if text == "/scratch" then
 		local PlayerSteamID = tostring( ply:SteamID() )
 		if file.Exists( "darkrp_scratch_cards/"..PlayerSteamID..".lua" ) then
 			local PlayerScratchCards = file.Read( PlayerSteamID..".lua" )
 			if PlayerScratchCards < 1 then
 				ply:ChatPrint( "You do not have any scratch cards!" )
 				return
 			end
 			local PlayerNewScratchCards = tonumber( PlayerScratchCards ) - 1
 			file.Write( "darkrp_scratch_cards/"..PlayerSteamID..".lua", PlayerNewScratchCards )
 			GivePlayerScratchCardLoot( ply )
 		else
 			ply:ChatPrint( "You do not have any scratch cards!" )
 		end
 	end
end )
