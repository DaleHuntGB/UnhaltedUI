-- =================================================== --
-- USER OPTIONS ====================================== --
-- =================================================== --

-- =================================================== --
-- Created By Unhalted - 2024 ======================== --
-- Discord: unhalted ================================= --
-- KoFi: https://ko-fi.com/unhalted ================== --
-- =================================================== --

local UserOptions = {
    showDamageText = true,
    showHealingText = true,
    skipCinematics = true,
    hideTalkingHead = true,
    autoScreenshot = true,
    setUIFonts = true,
    drawBackdrops = true,
    dmgMeterSize = {226, 201},
    healMeterSize = {227, 201},
    dmgMeterAnchors = {"BOTTOMRIGHT", "BOTTOMRIGHT", -10, 10},
    healMeterAnchors = {"BOTTOMRIGHT", "BOTTOMRIGHT", -237, 10},
    backdropColor = {8/255, 8/255, 8/255, 0.75},
}
-- =================================================== --
-- END OF USER OPTIONS =============================== --
-- =================================================== --

-- =================================================== --
-- DO NOT TOUCH ANYTHING BELOW THIS ================== --
-- UNLESS YOU KNOW WHAT YOU'RE DOING ================= --
-- =================================================== --

UH = {}
UnhaltedUI = CreateFrame("Frame", "UnhaltedUI", UIParent)
UnhaltedUI:RegisterEvent("ADDON_LOADED")
UnhaltedUI:SetScript("OnEvent", function(self, event, addon)
    if event == "ADDON_LOADED" and addon == "UnhaltedUI" then
        UH:Init()
    end
end)

function UH:Init()
    if UserOptions.drawBackdrops then
        UH:DrawBackdrops("Details Damage Meter Backdrop", UserOptions.dmgMeterSize[1], UserOptions.dmgMeterSize[2], UserOptions.dmgMeterAnchors[1], UserOptions.dmgMeterAnchors[2], UserOptions.dmgMeterAnchors[3], UserOptions.dmgMeterAnchors[4])
        UH:DrawBackdrops("Details Healing Meter Backdrop", UserOptions.healMeterSize[1], UserOptions.healMeterSize[2], UserOptions.healMeterAnchors[1], UserOptions.healMeterAnchors[2], UserOptions.healMeterAnchors[3], UserOptions.healMeterAnchors[4])
    end
    if UserOptions.setUIFonts then
        UH:SetUIFonts()
    end
    if UserOptions.skipCinematics then
        UH:SkipCinematics()
    end
    if UserOptions.hideTalkingHead then
        UH:HideTalkingHeadFrame()
    end
    if UserOptions.autoScreenshot then
        UH:AutoScreenshot()
    end
    UH:SetupCVars()
end

function UH:DrawBackdrops(frameName, frameW, frameH, anchorPoint, relativePoint, xOfs, yOfs)
    BackdropFrame = CreateFrame("Frame", frameName, UIParent, "BackdropTemplate")
    BackdropFrame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = true,
        tileSize = 16,
        edgeSize = 1,
        insets = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0
        }
    })
    BackdropFrame:SetBackdropColor(UserOptions.backdropColor[1], UserOptions.backdropColor[2], UserOptions.backdropColor[3], UserOptions.backdropColor[4])
    BackdropFrame:SetBackdropBorderColor(0.0, 0.0, 0.0, 1.0)
    BackdropFrame:SetSize(frameW, frameH)
    BackdropFrame:SetPoint(anchorPoint, UIParent, relativePoint, xOfs, yOfs)
    BackdropFrame:SetFrameStrata("LOW")
end

function UH:SetFont(obj, font, size, style, sR, sG, sB, sA, sX, sY, r, g, b, a)
	if not obj then return end
	if style == 'NONE' or not style then style = '' end
	local shadow = strsub(style, 0, 6) == 'SHADOW'
	if shadow then style = strsub(style, 7) end -- shadow isnt a real style
	obj:SetFont(font, size, style)
	obj:SetShadowColor(sR or 0, sG or 0, sB or 0, sA or (shadow and (style == '' and 1 or 0.6)) or 0)
	obj:SetShadowOffset(sX or (shadow and 1) or 0, sY or (shadow and -1) or 0)
	if r and g and b then
		obj:SetTextColor(r, g, b)
	end
	if a then
		obj:SetAlpha(a)
	end
end

function UH:SetUIFonts()
    local Class = select(2, UnitClass("player"))
    local ClassColor = RAID_CLASS_COLORS[Class]
    UH:SetFont(CharacterStatsPane.ItemLevelCategory.Title, "Fonts\\FRIZQT__.ttf", 12, "OUTLINE", 0, 0, 0, 0, 0, 0, ClassColor.r, ClassColor.g, ClassColor.b, 1.0)
    UH:SetFont(CharacterStatsPane.AttributesCategory.Title, "Fonts\\FRIZQT__.ttf", 12, "OUTLINE", 0, 0, 0, 0, 0, 0, ClassColor.r, ClassColor.g, ClassColor.b, 1.0)
    UH:SetFont(CharacterStatsPane.EnhancementsCategory.Title, "Fonts\\FRIZQT__.ttf", 12, "OUTLINE", 0, 0, 0, 0, 0, 0, ClassColor.r, ClassColor.g, ClassColor.b, 1.0)
end

function UH:SkipCinematics()
    local SkipCinematicsFrame = CreateFrame("Frame")
    SkipCinematicsFrame:RegisterEvent("CINEMATIC_START")
    SkipCinematicsFrame:SetScript("OnEvent", function(self, event, ...)
        if event == "CINEMATIC_START" then
            CinematicFrame_CancelCinematic()
        end
    end)
    MovieFrame_PlayMovie = function(...) GameMovieFinished() end
end

function UH:HideTalkingHeadFrame()
    HideTalkingHead = CreateFrame("Frame")
    HideTalkingHead:RegisterEvent("TALKINGHEAD_REQUESTED")
    HideTalkingHead:SetScript("OnEvent", function(self, event, ...)
        if event == "TALKINGHEAD_REQUESTED" then
            TalkingHeadFrame:Hide()
        end
    end)
end

function UH:AutoScreenshot()
    local AutoScreenshot = CreateFrame("Frame")
    AutoScreenshot:RegisterEvent("ACHIEVEMENT_EARNED")
    AutoScreenshot:SetScript("OnEvent", function(self, event, ...) C_Timer.After(1, function() Screenshot() end) end)
end

function UH:SetupCVars()
    if UserOptions.showDamageText then
        SetCVar("floatingCombatTextCombatDamage", 1)
    else
        SetCVar("floatingCombatTextCombatDamage", 0)
    end
    if UserOptions.showHealingText then
        SetCVar("floatingCombatTextCombatHealing", 1)
    else
        SetCVar("floatingCombatTextCombatHealing", 0)
    end
end

