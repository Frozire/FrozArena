local frozArena = LibStub("AceAddon-3.0"):GetAddon("frozArena")

function frozArena:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("frozArenaDB", frozArena.defaults, true)
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
	self.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("frozArena", frozArena.options)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("frozArena")
	self:RegisterChatCommand("farena", "ChatCommand")
end

function frozArena:ChatCommand(input)
	if not input or input:trim() == "" then
		LibStub("AceConfigDialog-3.0"):Open("frozArena")
	else
		LibStub("AceConfigCmd-3.0").HandleCommand(frozArena, "farena", "frozArena", input)
	end
end

function frozArena:OnEnable()
	frozArena.frames:OnEnable()

	frozArena:SecureHook("PartyMemberBackground_SetOpacity")
	frozArena:SecureHook("HealthBar_OnValueChanged", "ClassColours")
	frozArena:SecureHook("UnitFrameHealthBar_Update", "ClassColours")
	frozArena:SecureHook("ArenaEnemyFrame_SetMysteryPlayer")
	frozArena:SecureHook("ArenaEnemyFrame_UpdatePlayer")
	frozArena:SecureHook("ArenaPrepFrames_UpdateFrames")
	frozArena:RegisterEvent("PLAYER_ENTERING_WORLD")
	
	frozArena.events:Fire("frozArena_OnEnable")

	self:RefreshConfig()
end

-- We want to call this function when most settings are changed
function frozArena:RefreshConfig()

	if self:Combat() then return end
	
	self.ArenaEnemyFrames:ClearAllPoints()
	self.ArenaEnemyFrames:SetPoint(unpack(self.db.profile.position))
	self.ArenaEnemyFrames:SetScale(self.db.profile.scale)
	
	local _, instanceType = IsInInstance()
	
	local font, _, flags = ArenaEnemyFrame1.healthtext:GetFont()
	
	-- Loop through all of the arena frames
	for i = 1, 5 do
		-- Make a 'for loop' to modify both ArenaEnemyFramex and ArenaPrepFramex
		for k, v in pairs({"ArenaEnemyFrame"..i, "ArenaPrepFrame"..i}) do
			local frame = _G[v]
			
			frame.specFrame:SetScale(self.db.profile.specScale)
			frame.specFrame:ClearAllPoints()
			frame.specFrame:SetPoint(self.db.profile.specPosition[1], frame, self.db.profile.specPosition[3], self.db.profile.specPosition[4], self.db.profile.specPosition[5])
			self:SetupDrag(frame.specFrame, nil, self.db.profile.specPosition, true, true)
			

			frame.healthbar:ClearAllPoints()
			frame.manabar:ClearAllPoints()
			
			for k, v in pairs(frozArena.frames.textTable) do
				frame[v]:ClearAllPoints()
			end

			
			if self.db.profile.mirroredFrames then
				frame.name:SetPoint("BOTTOMLEFT", 32, 24)
				frame.classPortrait:SetPoint("TOPRIGHT", -83, -6)
				if self.db.profile.simpleFrames then
					frame.healthbar:SetPoint("TOPLEFT", frame.classPortrait, "TOPRIGHT", 2, -2)
					
					frame.manabar:SetPoint("TOP", frame.healthbar, "BOTTOM", 0, 0)
					frame.manabar:SetPoint("BOTTOMLEFT", frame.classPortrait, "BOTTOMRIGHT", 2, 2)
				else
					frame.texture:SetTexCoord(0.796, 0, 0, 0.5)
					frame.healthbar:SetPoint("TOPLEFT", frame, "TOPLEFT", 29, -12)
					
					frame.manabar:SetPoint("TOPLEFT", frame, "TOPLEFT", 29, -20)
				end
			else
				frame.name:SetPoint("BOTTOMLEFT", 3, 24)
				frame.classPortrait:SetPoint("TOPRIGHT", -13, -6)
				if self.db.profile.simpleFrames then
					frame.healthbar:SetPoint("TOPRIGHT", frame.classPortrait, "TOPLEFT", -2, -2)
					
					frame.manabar:SetPoint("TOP", frame.healthbar, "BOTTOM", 0, 0)
					frame.manabar:SetPoint("BOTTOMRIGHT", frame.classPortrait, "BOTTOMLEFT", -2, 2)
				else
					frame.texture:SetTexCoord(0, 0.796, 0, 0.5)
					frame.healthbar:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -12)
					
					frame.manabar:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -20)
				end
			end
			
			if self.db.profile.simpleFrames then
				frame.texture:Hide()
				frame.classPortrait:SetSize(30, 30)
				
				frame.healthbar:SetHeight(19)
				
				frame.healthtext:SetPoint("CENTER", frame.healthbar)
				frame.healthtextleft:SetPoint("LEFT", frame.healthbar)
				frame.healthtextright:SetPoint("RIGHT", frame.healthbar)
				
				frame.manatext:SetPoint("CENTER", frame.manabar)
				frame.manatextleft:SetPoint("LEFT", frame.manabar)
				frame.manatextright:SetPoint("RIGHT", frame.manabar)
			else
				frame.texture:Show()
				frame.classPortrait:SetSize(26, 26)
				
				frame.healthbar:SetHeight(8)
				
				frame.healthtext:SetPoint("CENTER", frame.healthbar, 0, 2)
				frame.healthtextleft:SetPoint("LEFT", frame.healthbar, 0, 2)
				frame.healthtextright:SetPoint("RIGHT", frame.healthbar, 0, 2)
				
				frame.manatext:SetPoint("CENTER", frame.manabar, 0, 2)
				frame.manatextleft:SetPoint("LEFT", frame.manabar, 0, 2)
				frame.manatextright:SetPoint("RIGHT", frame.manabar, 0, 2)
			end
			
			-- Make frame movable
			self:SetupDrag(frame, self.ArenaEnemyFrames, self.db.profile.position, false, false)

			-- Also adding drag functionality to health & mana bars for ease of use
			for _, v in pairs({v.."HealthBar", v.."ManaBar"}) do
				self:SetupDrag(_G[v], self.ArenaEnemyFrames, self.db.profile.position, false, false)
			end
			
			frame:ClearAllPoints()
			
			if i == 1 then
				-- Anchor first frame to the top of ArenaEnemyFrames
				frame:SetPoint("TOP")
			elseif k == 1 then
				-- Anchor all remaining remaining frames underneath the previous frame
				frame:SetPoint("TOP", _G["ArenaEnemyFrame"..i-1], "BOTTOM", 0, -20)
			else
				frame:SetPoint("TOP", _G["ArenaPrepFrame"..i-1], "BOTTOM", 0, -20)
			end
			
			if instanceType ~= "pvp" then
				frame:SetPoint("RIGHT", -2)
			else
				-- When in a battleground, shift frames left to make space for faction icon (these are really flag carriers, not arena opponents)
				frame:SetPoint("RIGHT", -18)
			end
			
			if k == 1 then
				-- Trinkets: position & font size
				local cc = frame["CC"]
				cc:SetSize(self.db.profile.trinketSize, self.db.profile.trinketSize)
				cc:ClearAllPoints()
				cc:SetPoint(self.db.profile.trinketPosition[1], frame, self.db.profile.trinketPosition[3], self.db.profile.trinketPosition[4], self.db.profile.trinketPosition[5])
				local fontFace, _, fontFlags = cc.Cooldown.Text:GetFont()
				cc.Cooldown.Text:SetFont(fontFace, frozArena.db.profile.trinketFontSize, fontFlags)
				cc.Cooldown:SetHideCountdownNumbers(false)
				self:SetupDrag(cc, nil, self.db.profile.trinketPosition, true, true)
				
				frame.castBar:SetScale(self.db.profile.castBarScale)
				frame.castBar:ClearAllPoints()
				frame.castBar:SetPoint(self.db.profile.castBarPosition[1], frame, self.db.profile.castBarPosition[3], self.db.profile.castBarPosition[4], self.db.profile.castBarPosition[5])
				self:SetupDrag(frame.castFrame, frame.castBar, self.db.profile.castBarPosition, true, true)
				
				frame.healthbar.textLockable = self.db.profile.statusText
				frame.manabar.textLockable = self.db.profile.statusText
				
				for k, v in pairs(frozArena.frames.textTable) do
					frame[v]:SetFont(font, self.db.profile.statusTextFontSize, flags)
					
					if self.db.profile.statusText then
						frame[v]:Show()
					else
						frame[v]:Hide()
					end
				end
			end
		end
	end
	
	self.events:Fire("frozArena_RefreshConfig")
	
	if frozArena.test.active then frozArena.test:TestMode() end
end

function frozArena:PLAYER_ENTERING_WORLD()
	local _, instanceType = IsInInstance()
	if instanceType == "pvp" or instanceType == "arena" then
		frozArena.test.active = false
		frozArena.test:TestMode()
		self.ArenaEnemyFrames:Show()
		
		-- Prevent objective tracker from anchoring itself to arena frames while in arena/bg
		SetCVar("showArenaEnemyFrames", false)
		ArenaEnemyFrames_CheckEffectiveEnableState(ArenaEnemyFrames)
	else
		self.ArenaEnemyFrames:Hide()
		SetCVar("showArenaEnemyFrames", true)
	end
end

function frozArena:Combat()
	if InCombatLockdown() then
		self:Print("Must leave combat to do that.")
		return true
	end
end

function frozArena:PartyMemberBackground_SetOpacity()
	-- Fix opacity slider for ArenaPrepBackground
	local alpha = 1.0 - OpacityFrameSlider:GetValue();
	if ( ArenaPrepBackground_SetOpacity ) then
		ArenaPrepBackground_SetOpacity();
	end
end

function frozArena:ArenaEnemyFrame_SetMysteryPlayer(frame)
	if self.db.profile.simpleFrames then
		frame.classPortrait:SetTexture(134400)
	end
end

function frozArena:ArenaEnemyFrame_UpdatePlayer(frame)
	if self.db.profile.simpleFrames then
			local id = frame:GetID()
				
			local _, class = UnitClass(frame.unit)
			if class then
				frame.classPortrait:SetTexture(classIcons[class])
				frame.classPortrait:SetTexCoord(0, 1, 0, 1)
			end
			local specID = GetArenaOpponentSpec(id)
			if specID and specID > 0 then 
				local _, _, _, specIcon = GetSpecializationInfoByID(specID)
				frame.specBorder:Hide()
				frame.specPortrait:SetTexture(specIcon)
			end
	end
	if self.db.profile.hideNames and frame.name then
		frame.name:SetText("")
	end
end

function frozArena:ArenaPrepFrames_UpdateFrames()
	local numOpps = GetNumArenaOpponentSpecs()
	for i=1, 5 do
		local prepFrame = _G["ArenaPrepFrame"..i];
		if i <= numOpps then 
			local specID = GetArenaOpponentSpec(i)
			if specID > 0 then 
				if self.db.profile.simpleFrames then
					local _, _, _, specIcon, _, class = GetSpecializationInfoByID(specID)
					if class then
						prepFrame.classPortrait:SetTexture(classIcons[class]);
						prepFrame.classPortrait:SetTexCoord(0, 1, 0, 1)
					end
					prepFrame.specPortrait:SetTexture(specIcon)
					prepFrame.specBorder:Hide()
				else
					prepFrame.specBorder:Show()
				end
			end
		end
	end
end

function frozArena:ClassColours(statusbar)
	if not self.db.profile.classColours then return end
	if healthBars[statusbar:GetName()] then
		local _, class = UnitClass(statusbar.unit)
		if not class then return end
		
		local c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
		
		if not statusbar.lockColor then statusbar:SetStatusBarColor(c.r, c.g, c.b) end
	end
end

function frozArena:OnMouseDown(frame)
	if IsShiftKeyDown() and IsControlKeyDown() and not frame.targetFrame.isMoving then
		frame.targetFrame:StartMoving()
		frame.targetFrame.isMoving = true
	end
end

function frozArena:OnMouseUp(frame)
	if frame.targetFrame.isMoving then
		frame.targetFrame:StopMovingOrSizing()
		frame.targetFrame.isMoving = false
		
		if frame.setting then
			frame.setting[1], frame.setting[2], frame.setting[3] = "CENTER", "UIParent", "BOTTOMLEFT"
			frame.setting[4], frame.setting[5] = frame.targetFrame:GetCenter()
		end
		
		if frame.keepRelative then
			frame.setting[1], frame.setting[2], frame.setting[3] = "CENTER", frame.targetFrame:GetParent(), "CENTER"
			frame.setting[4], frame.setting[5] = self:CalcPoint(frame.targetFrame)
		end
		
		if frame.refreshConfig then self:RefreshConfig() end
	end
end

function frozArena:SetupDrag(frame, targetFrame, setting, keepRelative, refreshConfig)
	frame.setting = setting
	
	if not frame.setupDrag then
		if not targetFrame then targetFrame = frame end
		frame.targetFrame = targetFrame
		frame.keepRelative = keepRelative
		frame.refreshConfig = refreshConfig
		frame.setupDrag = true
	
		self:SecureHookScript(frame, "OnMouseDown", OnMouseDown)
		self:SecureHookScript(frame, "OnMouseUp", OnMouseUp)
	end
end

function frozArena:CalcPoint(frame)
	local parentX, parentY = frame:GetParent():GetCenter()
	local frameX, frameY = frame:GetCenter()
	
	parentX, parentY, frameX, frameY = parentX + 0.5, parentY + 0.5, frameX + 0.5, frameY + 0.5
	
	if ( not frameX ) then return end

	local scale = frame:GetScale()
	
	parentX, parentY = floor(parentX), floor(parentY)
	frameX, frameY = floor(frameX * scale), floor(frameY * scale)
	frameX, frameY = floor((parentX - frameX) * -1), floor((parentY - frameY) * -1)
	
	return frameX/scale, frameY/scale
end