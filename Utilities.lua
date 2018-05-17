-- wraps the text in html <font> tag to color according to rarity.
-- rarity goes from 1(grey) to 7(transcendent)
-- special values = 8(ascended) and 9(quest item)
-- rgb values from imhothar's bags addon
local addon, StatWeights = ...

Utilities = {}
Utilities.Rarity = {
    [1] = "sellable",
    [2] = "common",
    [3] = "uncommon",
    [4] = "rare",
    [5] = "epic",
    [6] = "relic",
    [7] = "transcendent",
    [8] = "eternal",
    [9] = "ascended",
    [10] = "quest",
    ["sellable"] = 1,
    ["common"] = 2,
    ["uncommon"] = 3,
    ["rare"] = 4,
    ["epic"] = 5,
    ["relic"] = 6,
    ["transcendent"] = 7,
    ["eternal"] = 8,
    ["ascended"] = 9,
    ["quest"] = 10
}

Utilities.RarityColor = {}
Utilities.RarityColor.Hex = {
        [1] = "#888888", --grey
        [2] = "#ffffff",
        [3] = "#00cc00",  
        [4]	= "#2681fe",
        [5]	= "#b049ff",
        [6] = "#ff9900",
        [7] = "#cf1313",    --transcendent
        [8] = "#6bd3f7",   --eternal
        [9] = "#ffaaff",  --ascended
        [10] = "#ffff00" --quest item  
}
Utilities.RarityColor.RGB = {
        [1] = {0.53, 0.53, 0.53}, --grey
        [2] = {1, 1, 1},
        [3] = {0.0, 0.8, 0.0},  
        [4]	= {0.148, 0.51, 0.977},
        [5]	= {0.69, 0.29, 1},
        [6] = {1.0, 0.6, 0.0 },
        [7] = {0.81, 0.07, 0.07},    --transcendent
        [8] = {0.42, 0.83, 0.97},  --eternal
        [9] = {1, 0.67, 1},  --ascended
        [10] = {1.0, 1.0, 0.0} --quest item       
}

Utilities.EquipmentSlots = {
    ["cape"] = true ,
    ["shoulders"] = true,
    ["helmet"] = true,
    ["chest"] = true,
    ["gloves"] = true,
    ["belt"] = true,
    ["legs"] = true,
    ["feet"] = true,
    ["neck"] = true,
    ["trinket"] = true,
    ["seal"] = true,
    ["ring1"] = true, 
    ["ring2"] = true,
    ["earring1"] = true,
    ["earring2"] = true,
    ["ranged"] = true,
    ["handmain"] = true,
    ["handoff"] = true,
    ["focus"] = true,
}

Utilities.PAMax = {  -- rough guess of max PA bonuses
    ["powerAttack"] = 500,
    ["powerSpell"] = 500,
    ["dexterity"] = 300,
    ["strength"] = 300,
    ["intelligence"] = 300,
    ["wisdom"] = 300,
    ["endurance"] = 345,
    ["critPower"] = 15,
    
}

function Utilities:colorByRarity(text, rarity)
   
    local rtext = text

    
    if Utilities.RarityColor.Hex[rarity] then
       rtext = "<font color=\"" .. Utilities.RarityColor.Hex[rarity] .. "\">" .. text .. "</font>"
    end
    
    return rtext
    
end
    


function Utilities:prettyStatName(sName)
   local s = sName
    
    if s == "critAttack" then
        s = "Phys Crit"
    elseif s == "critSpell" then
        s = "Spell Crit"
    elseif s == "powerAttack" then
        s = "Attack Power"
    elseif s == "powerSpell" then
        s = "Spell Power"
    elseif s == "critPower" then
        s = "Crit Power"
    elseif s == "maxHealth" then
        s = "Max Health"
    else -- capitalize
        s = string.upper(string.sub(s,1,1)) .. string.sub(s, 2, -1)
    end
    
    
    return s
        
end


function Utilities:slotByCategory(sCat)
    
    local arrCat = string.split(sCat, " ")
    local tSlot = "nil"
    local tSlot2 = "nil"
    local twoSlots = false
    
    -- essences have only two words
    if sCat == "planar vessel" then
        tSlot = Utility.Item.Slot.Equipment("focus")
    elseif sCat == "planar lesser" then
        
    elseif sCat == "planar lesser" then
        
    end
       
    -- weapons
    if arrCat[1] == "weapon" then
        if arrCat[2] == "ranged" then
            tSlot = Utility.Item.Slot.Equipment("ranged")
        else
            twoSlots = true
            tSlot = Utility.Item.Slot.Equipment("handmain")
            tSlot2 = Utility.Item.Slot.Equipment("handoff")    
        end
    end
    
    -- armor
    -- has three words except for cape
    if arrCat[1] == "armor" then
        if arrCat[2] == "cape" then
            tSlot = Utility.Item.Slot.Equipment("cape")
        elseif arrCat[3] == "head" then
            tSlot = Utility.Item.Slot.Equipment("helmet")
        elseif arrCat[3] == "shoulders" then
            tSlot = Utility.Item.Slot.Equipment("shoulders")
        elseif arrCat[3] == "chest" then
            tSlot = Utility.Item.Slot.Equipment("chest")  
        elseif arrCat[3] == "hands" then
            tSlot = Utility.Item.Slot.Equipment("gloves")    
        elseif arrCat[3] == "waist" then
            tSlot = Utility.Item.Slot.Equipment("belt")              
        elseif arrCat[3] == "legs" then
            tSlot = Utility.Item.Slot.Equipment("legs")  
        elseif arrCat[3] == "feet" then
            tSlot = Utility.Item.Slot.Equipment("feet")  
        elseif arrCat[3] == "neck" then
            tSlot = Utility.Item.Slot.Equipment("neck")  
        elseif arrCat[3] == "trinket" then
            tSlot = Utility.Item.Slot.Equipment("trinket")  
        elseif arrCat[3] == "seal" then
            tSlot = Utility.Item.Slot.Equipment("seal") 
        elseif arrCat[3] == "ring" then
            twoSlots = true
            tSlot = Utility.Item.Slot.Equipment("ring1")
            tSlot2 = Utility.Item.Slot.Equipment("ring2")
        elseif arrCat[3] == "earring" then
            twoSlots = true
            tSlot = Utility.Item.Slot.Equipment("earring1")
            tSlot2 = Utility.Item.Slot.Equipment("earring2")
             
            
        end
        
    end
    
    if tSlot == "nil" then -- no slot found
        return nil, nil
    elseif twoSlots then
        return tSlot, tSlot2
    else
        return tSlot, nil
    end
    
    
end



-- returns two tables, the first is the stats of all equipment added together (including runes),
-- the second table is only runes
function Utilities:EquipmentStats()
   
    local tslot
    local tequip
    local tstats = {}
    local trune = {}
    
    for k in pairs(Utilities.EquipmentSlots) do
        tslot = Utility.Item.Slot.Equipment(k) 
        if tslot then
            tequip = Inspect.Item.Detail(tslot)
            if tequip and tequip.stats then
                for k,v in pairs(tequip.stats) do
                     tstats[k] = (tstats[k] or 0) + v         
                end
            end
            if tequip and tequip.statsRune then
                for k,v in pairs(tequip.statsRune) do
                    trune[k] = (trune[k] or 0) + v  
                    tstats[k] = (tstats[k] or 0) + v
                end
            end
            
        end
    end

    -- Add fragment stats
    local tempFrag
    
    for i = 1, 11 do
        tempFrag = Inspect.Item.Detail("seqp.f" .. string.format("%02d",i))  --leading 0 on slot ids
        if tempFrag then
            for k,v in pairs(tempFrag.stats) do
                tstats[k] = (tstats[k] or 0) + v
            end
        end
    end 
    
    return tstats, trune
    
end


function Utilities:GuessBonus(stat)

    local eqStats, _ = Utilities:EquipmentStats()
    local statUB = 0
    local bonus = 0
    
    local PAbase = 315  -- main stat bonus for Max PA
    local statBase = 95  -- Main Stat base value at 70
    
    if not eqStats[stat] then
        print(stat)
        return 4
    end
    
    statUB = Inspect.Stat(stat .. "Unbuffed")
    
    if not statUB then
        return 5
    end
    
    bonus = (statUB - eqStats[stat] - PAbase - statBase)/(eqStats[stat] + statBase)
    
    return bonus
    
end


function Utilities:GuessPowerBonus(calling)

    local eqStats, _ = Utilities:EquipmentStats()
    local statUB = 0
    local bonus = 0
    local mainStat = "dexterity"
    local offStat = "strength"
    local stat = "powerAttack"
    local basePower
    
    local PAbase = 580
    
    if calling == "cleric" then
        mainStat = "wisdom"
        offStat = "intelligence"
        stat = "powerSpell"
    elseif calling == "mage" then
        offStat = "wisdom"
        mainStat = "intelligence"
        stat = "powerSpell"
    elseif calling == "warrior" then
        offStat = "dexterity"
        mainStat = "strength"
    end
    
    if not eqStats[stat] then
        print(stat)
        return 4
    end
    
    statUB = Inspect.Stat(stat .. "Unbuffed")
    
    if not statUB then
        return 5
    end            
            
    basePower =  eqStats[stat] + 0.75 * (Inspect.Stat(mainStat .. "Unbuffed") or 0) + 0.25 * (Inspect.Stat(offStat .. "Unbuffed") or 0)
    
    bonus = (statUB - basePower - PAbase)/basePower
    
    return bonus
    
end

