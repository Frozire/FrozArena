local frozArena = LibStub("AceAddon-3.0"):GetAddon("frozArena")

frozArena.options = {
	name = "frozArena",
	handler = frozArena,
	type = "group",
	args = {
		test = {
			name = "Preview",
			type = "execute",
			func = function() frozArena.test:TestMode(not frozArena.test.active) end,
			order = 0,
		},
		general = {
			name = "General",
			type = "group",
			order = 1,
			args = {
				optionsHeader = {
					name = "Scaling",
					type = "header",
					order = 1,
				},
				simpleFrames = {
					name = "Simple arena frames",
					desc = "Removes the unitframe texture and makes icons square-shaped",
					type = "toggle",
					order = 2,
					width = "double",
					get = function() return frozArena.db.profile.simpleFrames end,
					set = function(info, val) frozArena.db.profile.simpleFrames = val frozArena:RefreshConfig() end,
				},
				mirroredFrames = {
					name = "Mirrored arena frames",
					type = "toggle",
					order = 3,
					width = "double",
					get = function() return frozArena.db.profile.mirroredFrames end,
					set = function(info, val) frozArena.db.profile.mirroredFrames = val frozArena:RefreshConfig() end,
				},
				classColours = {
					name = "Class-coloured health bars",
					type = "toggle",
					order = 4,
					width = "double",
					get = function() return frozArena.db.profile.classColours end,
					set = function(info, val) frozArena.db.profile.classColours = val frozArena:RefreshConfig() end,
				},
				hideNames = {
					name = "Hide player names",
					type = "toggle",
					order = 5,
					width = "double",
					get = function() return frozArena.db.profile.hideNames end,
					set = function(info, val) frozArena.db.profile.hideNames = val frozArena:RefreshConfig() end,
				},
				statusText = {
					name = "Health/mana text",
					desc = "Must have party text enabled in Blizz options for this to work",
					type = "toggle",
					order = 6,
					width = "double",
					get = function() return frozArena.db.profile.statusText end,
					set = function(info, val) frozArena.db.profile.statusText = val frozArena:RefreshConfig() end,
				},
				scalingHeader = {
					name = "Scaling",
					type = "header",
					order = 7,
				},
				scale = {
					name = "Scale",
					type = "range",
					order = 8,
					min = 0.1,
					max = 5.0,
					softMin = 0.5,
					softMax = 3.0,
					step = 0.01,
					bigStep = 0.1,
					get = function() return frozArena.db.profile.scale end,
					set = function(info, val) if frozArena:Combat() then return end frozArena.db.profile.scale = val frozArena.ArenaEnemyFrames:SetScale(val) end,
				},
				specScale = {
					name = "Spec Icon Scale",
					type = "range",
					order = 9,
					min = 0.1,
					max = 5.0,
					softMin = 0.5,
					softMax = 3.0,
					step = 0.01,
					bigStep = 0.1,
					get = function() return frozArena.db.profile.specScale end,
					set = function(info, val) if frozArena:Combat() then return end frozArena.db.profile.specScale = val frozArena:RefreshConfig() end,
				},
				trinketSize = {
					name = "Trinket Icon Size",
					type = "range",
					order = 10,
					min = 4,
					max = 100,
					softMin = 6,
					softMax = 60,
					step = 1,
					bigStep = 1,
					get = function() return frozArena.db.profile.trinketSize end,
					set = function(info, val) if frozArena:Combat() then return end frozArena.db.profile.trinketSize = val frozArena:RefreshConfig() end,
				},
				castBarScale = {
					name = "Cast Bar Scale",
					type = "range",
					order = 11,
					min = 0.1,
					max = 5.0,
					softMin = 0.5,
					softMax = 3.0,
					step = 0.01,
					bigStep = 0.1,
					get = function() return frozArena.db.profile.castBarScale end,
					set = function(info, val) if frozArena:Combat() then return end frozArena.db.profile.castBarScale = val frozArena:RefreshConfig() end,
				},
				statusTextFontSize = {
					name = "Health/Mana Font Size",
					desc = "Font size of text for health & mana bars",
					type = "range",
					order = 12,
					min = 4,
					max = 32,
					softMin = 4,
					softMax = 32,
					step = 1,
					bigStep = 1,
					get = function() return frozArena.db.profile.statusTextFontSize end,
					set = function(info, val) frozArena.db.profile.statusTextFontSize = val frozArena:RefreshConfig() end,
				},
			},
		},
		help = {
			name = "Help",
			type = "group",
			order = 2,
			args = {
				howToMoveHeader = {
					name = "How do I move stuff?",
					type = "header",
					order = 1,
				},
				howToMoveDesc = {
					name = "Ctrl + Shift + Click",
					type = "description",
					order = 2,
				},
				whatToMoveHeader = {
					name = "What can I move?",
					type = "header",
					order = 3,
				},
				whatToMoveDesc = {
					name = " - Arena frame|n - Spec icon|n - Trinket|n - Cast bar|n - DR Tracker (The |cFFFF4400orange|r one)",
					type = "description",
					order = 4,
				},
			},
		},
		credits = {
			name = "Credits",
			type = "group",
			order = -1,
			args = {
				creditsHeader = {
					name = "Credits",
					type = "header",
					order = 1,
				},
				howToMoveDesc = {
					name = "Thanks",
					type = "description",
					order = 2,
				},
			},
		},
	},
}

-- Default Saved Variables
frozArena.defaults = {
	profile = {
		position = { "TOPRIGHT", MinimapCluster, "BOTTOMRIGHT", -100, -25 },
		specPosition = { "CENTER", nil, "CENTER", 50, -12 },
		trinketPosition = { "RIGHT", nil, "LEFT", -12, -3 },
		castBarPosition = { "RIGHT", nil, "LEFT", -32, -3 },
		statusTextFontSize = 10,
		trinketFontSize = 16,
		trinketSize = 18,
		scale = 1.75,
		specScale = 1.0,
		castBarScale = 1.0,
		classColours = true,
		hideNames = false,
		mirroredFrames = false,
		simpleFrames = true,
		statusText = false,
	},
}