local frozArena = LibStub("AceAddon-3.0"):GetAddon("frozArena")

frozArena.test = {
	testModeClasses = { "ROGUE", "MAGE", "PRIEST" },
	specIcons = { 132320, 135846, 135940 },
	active = false,
	TestMode = function (info, setting)
		if frozArena:Combat() then return end
		
		if setting ~= nil then
			frozArena.test.active = setting
		end
		
		if not frozArena.test.active then
			-- If test mode is disabled & we are outside of a pvp environment, hide the frames
			local _, instanceType = IsInInstance()
			if instanceType ~= "pvp" and instanceType ~= "arena" then frozArena.ArenaEnemyFrames:Hide() end
			
			-- Hide castbar dragframes
			for i = 1, 5 do
				local arenaFrame = _G["ArenaEnemyFrame"..i]
				arenaFrame.castFrame:Hide()
			end
		else
			frozArena.ArenaEnemyFrames:Show()
			
			for i = 1, 3 do
				local arenaFrame = _G["ArenaEnemyFrame"..i]
				local petFrame = _G["ArenaEnemyFrame"..i.."PetFrame"]
				
				arenaFrame:Show()
				if SHOW_ARENA_ENEMY_PETS == "1" then petFrame:Show() else petFrame:Hide() end
				
				arenaFrame.castFrame:Show()
				
				arenaFrame.CC.Icon:SetTexture("Interface\\Icons\\ability_pvp_gladiatormedallion")
				CooldownFrame_Set(arenaFrame.CC.Cooldown, GetTime(), 120, 1, true)
				
				arenaFrame.healthbar:Show()
				arenaFrame.healthbar:SetMinMaxValues(0,100)
				arenaFrame.healthbar:SetValue(100)
				arenaFrame.healthbar.forceHideText = false
				arenaFrame.manabar:Show()
				arenaFrame.manabar:SetMinMaxValues(0,100)
				arenaFrame.manabar:SetValue(100)
				arenaFrame.manabar.forceHideText = false

				if frozArena.db.profile.simpleFrames then
					arenaFrame.classPortrait:SetTexture(frozArena.data.general.classIcons[frozArena.test.testModeClasses[i]])
					arenaFrame.classPortrait:SetTexCoord(0, 1, 0, 1)
					arenaFrame.specBorder:Hide()
					arenaFrame.specPortrait:SetTexture(frozArena.test.specIcons[i])
				else
					arenaFrame.classPortrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
					arenaFrame.classPortrait:SetTexCoord(unpack(CLASS_ICON_TCOORDS[frozArena.test.testModeClasses[i]]))
					arenaFrame.specBorder:Show()
					SetPortraitToTexture(arenaFrame.specPortrait, frozArena.test.specIcons[i])
				end
				
				if frozArena.db.profile.hideNames then
					arenaFrame.name:SetText("")
				else
					arenaFrame.name:SetText("arena"..i)
				end
				
				local c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[frozArena.test.testModeClasses[i]] or RAID_CLASS_COLORS[frozArena.test.testModeClasses[i]]
				
				if frozArena.db.profile.classColours then arenaFrame.healthbar:SetStatusBarColor(c.r, c.g, c.b)
				else arenaFrame.healthbar:SetStatusBarColor(0, 1, 0)
				end
				
				if i == 1 then c = PowerBarColor["ENERGY"]
				else c = PowerBarColor["MANA"]
				end
				
				arenaFrame.manabar:SetStatusBarColor(c.r, c.g, c.b)
			end
			
			ArenaEnemyBackground:SetPoint("BOTTOMLEFT", "ArenaEnemyFrame3PetFrame", "BOTTOMLEFT", -15, -10)
			if (SHOW_PARTY_BACKGROUND == "1") then ArenaEnemyBackground:Show() else ArenaEnemyBackground:Hide() end
		end
		
		frozArena.events:Fire("frozArena_TestMode")
	end
}