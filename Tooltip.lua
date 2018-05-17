local addon, StatWeights = ...

local tt_context = UI.CreateContext("SW_ToolTip")
local tt_window = UI.CreateFrame("Text", "SW_ToolTip_Tooltip", tt_context) 

tt_context:SetStrata("topmost")
tt_window:SetBackgroundColor(0, 0, 0, 0.9)
tt_window:SetFontSize(13)
--Library.LibExtendedWidgets.SetBorder("tooltip", tt_window)

local padding = 10
local verticalOffset = 10

local function displayTooltip(tooltip)
	local left, top, right, bottom = UI.Native.Tooltip:GetBounds()
	local screenHeight = UIParent:GetHeight()
	local height = tt_window:GetHeight()

    
    tt_window:SetVisible(false)

	tt_window:SetText(tooltip, true)
	tt_window:SetPoint("TOPLEFT", UI.Native.Tooltip, "BOTTOMLEFT", padding, verticalOffset)
	tt_window:SetPoint("TOPRIGHT", UI.Native.Tooltip, "BOTTOMRIGHT", -padding, verticalOffset)
    
    tt_window:SetVisible(true)
    
end


local toolTip = UI.CreateFrame("ExtendedTooltip", "SW_Tooltip", tt_context)
toolTip:SetFontSize(14)

local function showTooltip(ttype, shown, buff)
	
    tt_window:SetVisible(false)
    
    toolTip:Hide(UI.Native.Tooltip)
	
    
	if(not (ttype and shown)) then
	   return
    end

	if(not (ttype == "item" or ttype == "itemtype")) then
	   return
    end

	local item = Inspect.Item.Detail(shown)
	if not item then
		return
	end
    
    if not item.stats then
		return
	end
    
    -- weapon DPS
    if item.damageMax and item.damageMin and item.damageDelay then
        item.stats.WDPS = (item.damageMin + item.damageMax)/(2 * item.damageDelay) 
    end 

    
    local tempTip = ""
    local tempSlot 
    
    if string.prefix(item.id, "i") then
        tempSlot = Inspect.Item.Find(item.id)
    end
    
    if SW_SavedWeights[SW_Settings.Role] and SW_Settings.ShowWeight then
    
        tempTip = tempTip .. "Weight: " .. string.format("%.1f", StatWeights:calcWeights(item.stats))
        
            if item.statsRune then
            
                tempTip = tempTip .. " + " .. string.format("%.1f", StatWeights:calcWeights(item.statsRune))
            
            end
        
        tempTip = tempTip .. "\n"
        
    end
    
    if StatWeights.SW_debug then
        tempTip = tempTip .. "\nID: " .. (item.id or "nil") .. "\nCat: " .. (item.category or "nil") .. "\nType: " .. (item.type or "nil")
        tempTip = tempTip .. "\nslot: " .. (tempSlot or "Not Found")    
        local fStats = fragments:equippedStats()
        for k,v in pairs(fStats) do
           tempTip = tempTip .. "\n" .. k .. ": " .. v 
        end
    end
    
    if tempSlot and string.prefix(tempSlot, "seqp") then
        --item is equipped
    else
        --not equipped, get weights
        if SW_Settings.ShowWeight and SW_Settings.ShowEquipped then
            local w1, r1, w2, r2
            w1, r1, w2, r2 = StatWeights:getEquippedWeights(item)

            if w1 then
                tempTip = tempTip .. "\nEquipped: " .. string.format("%.1f", w1)
            end

            if r1 then
                tempTip = tempTip .. " + " .. string.format("%.1f", r1)
            end

            if w2 then
                tempTip = tempTip .. "\nEquipped: " .. string.format("%.1f", w2)
            end

            if r2 then
                tempTip = tempTip .. " + " .. string.format("%.1f", r2)
            end

             if w1 then
                tempTip = tempTip .. "\n"
            end

        end
    end
    
    if item.fragmentAffinity and item.fragmentTier then
        
        local fragElement = fragments.fragmentAffinity[item.fragmentAffinity]
        
        
        if StatWeights.SW_debug then
            if item.infusionLevel then
                tempTip = tempTip .. "\ninfusionLevel: " .. item.infusionLevel
            end
            if item.fragmentAffinity then
                tempTip = tempTip .. "\nfragmentAffinity: " .. item.fragmentAffinity
            end
            if item.fragmentTier then
                tempTip = tempTip .. "\nfragmentTier: " .. item.fragmentTier
            end            
        end
        
        
        
        if SW_Settings.ShowAffinity then
            tempTip = tempTip .. "\nAffinities for "  .. fragElement .. ":\n"
            tempTip = tempTip .. fragments:getAffinityListByElement(fragElement) .. "\n"
        end
        
        if SW_Settings.ShowBest then
            tempTip = tempTip .. "\nBest stats for "  .. fragElement .. ":"
    
            local bestStats = StatWeights:calcFragWeights(fragElement)
            for i = 1, 4 do
                tempTip = tempTip .. "\n" .. Utilities:colorByRarity(Utilities:prettyStatName(bestStats[i].stat), 7 - bestStats[i].affinity)
            end
            tempTip = tempTip .. "\n"
        end

        if SW_Settings.ShowUpgrade then
            local uLevel, uText = fragments:nextFragmentUpgrade(item)
            tempTip = tempTip .. "\nNext upgrade: " .. uText .. " at level " .. uLevel .. "\n"
        end
        
    end
    
    if tempTip == "" then
        --empty tooltip
    else
        --displayTooltip(tempTip)
        toolTip:Show(UI.Native.Tooltip, tempTip, "BOTTOMCENTER", 0,0)
    end
    
end

table.insert(Event.Tooltip, {showTooltip, "StatWeights", "SW_Tooltip"})
