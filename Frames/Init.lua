local frozArena = LibStub("AceAddon-3.0"):GetAddon("frozArena")

frozArena.frames = {
	OnEnable = function ()
		SetCVar("showArenaEnemyCastbar", true)
	
		-- ArenaEnemyFrames gets repositioned all time, so we'll just make our own & anchor everything to it
		frozArena.ArenaEnemyFrames = CreateFrame("Frame", nil, UIParent)
		frozArena.ArenaEnemyFrames:SetMovable(true)
		frozArena.ArenaEnemyFrames:SetClampedToScreen(true)
		frozArena.ArenaEnemyFrames:SetSize(130, 50)
		
		ArenaEnemyBackground:SetParent(frozArena.ArenaEnemyFrames)
		ArenaPrepBackground:SetParent(frozArena.ArenaEnemyFrames)
		
		-- Loop through all of the arena frames
		for i = 1, 5 do
			-- Make a 'for loop' to modify both ArenaEnemyFramex and ArenaPrepFramex
			for k, v in pairs({"ArenaEnemyFrame"..i, "ArenaPrepFrame"..i}) do
				local frame = _G[v]
				
				frame:SetParent(frozArena.ArenaEnemyFrames)
				
				if k == 1 then
					-- Stuff that only needs to be done to arena frames (but not prep frames)
					
					local cc = frame["CC"]
					
					-- Make trinket icons movable
					cc:SetMovable(true)
					cc:SetClampedToScreen(true)
					cc:EnableMouse(true)
					
					-- Find fontstring for trinket cooldown count
					for _, region in next, { cc.Cooldown:GetRegions() } do
						if region:GetObjectType() == "FontString" then
							cc.Cooldown.Text = region
						end
					end
					
					-- Create mock castbars for test mode
					frame.castFrame = CreateFrame("StatusBar", nil, frame, "frozArenaCastBarTemplate")
					frame.castFrame:SetAllPoints(frame.castBar)
					frame.castFrame.Icon:SetAllPoints(frame.castBar.Icon)
					frame.castFrame:EnableMouse(true)
					
					frame.castBar:SetMovable(true)
					frame.castBar:SetClampedToScreen(true)
				else
					-- Stuff that only needs to be done to prep frames (but not arena frames)
					frame.name = _G[v.."Name"]
					frame.healthbar = _G[v.."HealthBar"]
					frame.manabar = _G[v.."ManaBar"]
					frame.specPortrait = _G[v.."SpecPortrait"]
					frame.specBorder = _G[v.."SpecBorder"]
				end
				
				frame.texture = _G[v.."Texture"]
				frame.background = _G[v.."Background"]
				frame.healthtext = _G[v.."HealthBarText"]
				frame.healthtextleft = _G[v.."HealthBarTextLeft"]
				frame.healthtextright = _G[v.."HealthBarTextRight"]
				frame.manatext = _G[v.."ManaBarText"]
				frame.manatextleft = _G[v.."ManaBarTextLeft"]
				frame.manatextright = _G[v.."ManaBarTextRight"]
				
				frame.background:SetPoint("TOPLEFT", frame.healthbar, "TOPLEFT", 0, 0)
				frame.background:SetPoint("BOTTOMRIGHT", frame.manabar, "BOTTOMRIGHT", 0, 0)
				
				frame.specFrame = CreateFrame("Frame", nil, frame, "frozArenaSpecIconTemplate")
				frame.specFrame:SetMovable(true)
				frame.specFrame:SetClampedToScreen(true)
				frame.specFrame:EnableMouse(true)
					
				frame.specPortrait:ClearAllPoints()
				frame.specPortrait:SetPoint("CENTER", frame.specFrame, "CENTER", 0, 0)
				frame.specPortrait:SetParent(frame.specFrame)
				
				frame.specBorder:ClearAllPoints()
				frame.specBorder:SetPoint("CENTER", frame.specFrame, "CENTER", 12, -12)
				frame.specBorder:SetParent(frame.specFrame)
				
			end
			
			_G["ArenaEnemyFrame"..i.."PetFrame"]:SetParent(frozArena.ArenaEnemyFrames)
		end
		
		frozArena.events:Fire("frozArena_OnEnable")
	end,
	arenaFrames = {
		ArenaEnemyFrame1,
		ArenaEnemyFrame2,
		ArenaEnemyFrame3,
		ArenaEnemyFrame4,
		ArenaEnemyFrame5
	},
	healthBars = {
		ArenaEnemyFrame1HealthBar = 1,
		ArenaEnemyFrame2HealthBar = 1,
		ArenaEnemyFrame3HealthBar = 1,
		ArenaEnemyFrame4HealthBar = 1,
		ArenaEnemyFrame5HealthBar = 1
	},
	textTable = {
		"healthtext",
		"healthtextleft",
		"healthtextright",
		"manatext",
		"manatextleft",
		"manatextright",
	},
}