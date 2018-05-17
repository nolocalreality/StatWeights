-- functions require utilities.lua and LibString
local addon, StatWeights = ...

fragments = {}

fragments.toRecycle = {}    

fragments.titles = {
    Aggressive = "powerAttack",
    Calculating = "powerSpell",
    Elusive = "dodge",
    Enlightened = "intelligence",
    Impenetrable = "guard",
    Mighty = "strength",
    Nimble = "dexterity",
    Precise = "critSpell",
    Punishing = "critPower",
    Sagacious = "wisdom",
    Stalwart = "endurance",
    Unassailable = "block",
    Unerring = "critAttack",
    Vital = "maxHealth"
}

fragments.fragmentAffinity = {
    [1] = "Earth",
    [2] = "Air",
    [3] = "Fire",
    
    [5] = "Water",
    [6] = "Life",   
    [7] = "Death"
    
}

fragments.affinity = {}

fragments.affinity.dexterity = {
    [1] = "Fire",
    [2] = "Death",
    [3] = "Earth",
    [4] = "Air",
    [5] = "Water",
    [6] = "Life"
}

fragments.affinity.intelligence = {
    [1] = "Air",
    [2] = "Fire",
    [3] = "Water",
    [4] = "Life",
    [5] = "Earth",
    [6] = "Death"
}

fragments.affinity.strength = {
    [1] = "Death",
    [2] = "Earth",
    [3] = "Fire",
    [4] = "Water",
    [5] = "Life",
    [6] = "Air"
}

fragments.affinity.wisdom = {
    [1] = "Earth",
    [2] = "Life",
    [3] = "Air",
    [4] = "Death",
    [5] = "Fire",
    [6] = "Water"
}

fragments.affinity.powerAttack = {
    [1] = "Fire",
    [2] = "Water",
    [3] = "Death",
    [4] = "Life",
    [5] = "Air",
    [6] = "Earth"
}

fragments.affinity.powerSpell = {
    [1] = "Fire",
    [2] = "Water",
    [3] = "Death",
    [4] = "Life",
    [5] = "Air",
    [6] = "Earth"
}

fragments.affinity.critAttack = {
    [1] = "Water",
    [2] = "Death",
    [3] = "Fire",
    [4] = "Earth",
    [5] = "Life",
    [6] = "Air"
}

fragments.affinity.critSpell = {
    [1] = "Water",
    [2] = "Death",
    [3] = "Fire",
    [4] = "Earth",
    [5] = "Life",
    [6] = "Air"
}

fragments.affinity.critPower = {
    [1] = "Death",
    [2] = "Fire",
    [3] = "Water",
    [4] = "Air",
    [5] = "Earth",
    [6] = "Life"
}

fragments.affinity.block = {
    [1] = "Life",
    [2] = "Earth",
    [3] = "Air",
    [4] = "Water",
    [5] = "Fire",
    [6] = "Death"
}

fragments.affinity.dodge = {
    [1] = "Air",
    [2] = "Life",
    [3] = "Earth",
    [4] = "Fire",
    [5] = "Death",
    [6] = "Water"
}

fragments.affinity.guard = {
    [1] = "Earth",
    [2] = "Air",
    [3] = "Life",
    [4] = "Death",
    [5] = "Water",
    [6] = "Fire"
}

fragments.affinity.endurance = {
    [1] = "Water",
    [2] = "Air",
    [3] = "Life",
    [4] = "Earth",
    [5] = "Death",
    [6] = "Fire"
}

fragments.affinity.maxHealth = {
    [1] = "Life",
    [2] = "Water",
    [3] = "Death",
    [4] = "Fire",
    [5] = "Air",
    [6] = "Earth"
}


fragments.air = {
    dexterity = {affinity = 4, start = 180},
    intelligence = {affinity = 1, start = 299},
    strength = {affinity = 6, start = 83},
    wisdom = {affinity = 3, start = 204},
    powerAttack = {affinity = 5, start = 95},
    powerSpell = {affinity = 5, start = 95},
    critAttack = {affinity = 6, start = 146},
    critSpell = {affinity = 6, start = 146},
    critPower = {affinity = 4, start = 234},
    block = {affinity = 3, start = 357},
    dodge = {affinity = 1, start = 264},
    guard = {affinity = 2, start = 234},
    endurance = {affinity = 2, start = 264},
    maxHealth = {affinity = 5, start = 1220},
}

fragments.death = {
    dexterity = {affinity = 2, start = 264},
    intelligence = {affinity = 6, start = 83},
    strength = {affinity = 1, start = 299},
    wisdom = {affinity = 4, start = 180},
    powerAttack = {affinity = 3, start = 158},
    powerSpell = {affinity = 3, start = 158},
    critAttack = {affinity = 2, start = 463},
    critSpell = {affinity = 2, start = 463},
    critPower = {affinity = 1, start = 389},
    block = {affinity = 6, start = 146},
    dodge = {affinity = 5, start = 108},
    guard = {affinity = 4, start = 159},
    endurance = {affinity = 5, start = 122},
    maxHealth = {affinity = 3, start = 2040},   
}

fragments.earth = {
    dexterity = {affinity = 3, start = 204},
    intelligence = {affinity = 5, start = 122},
    strength = {affinity = 2, start = 264},
    wisdom = {affinity = 1, start = 299},
    powerAttack = {affinity = 6, start = 64},
    powerSpell = {affinity = 6, start = 64},
    critAttack = {affinity = 4, start = 315},
    critSpell = {affinity = 4, start = 315},
    critPower = {affinity = 5, start = 159},
    block = {affinity = 2, start = 463},
    dodge = {affinity = 3, start = 180},
    guard = {affinity = 1, start = 264},
    endurance = {affinity = 4, start = 180},
    maxHealth = {affinity = 6, start = 830},   
}

fragments.fire = {
    dexterity = {affinity = 1, start = 299},
    intelligence = {affinity = 2, start = 264},
    strength = {affinity = 3, start = 204},
    wisdom = {affinity = 5, start = 122},
    powerAttack = {affinity = 1, start = 232},
    powerSpell = {affinity = 1, start = 232},
    critAttack = {affinity = 3, start = 357},
    critSpell = {affinity = 3, start = 357},
    critPower = {affinity = 2, start = 344},
    block = {affinity = 5, start = 214},
    dodge = {affinity = 4, start = 159},
    guard = {affinity = 6, start = 73},
    endurance = {affinity = 6, start = 83},
    maxHealth = {affinity = 4, start = 1800},
}

fragments.life = {
    dexterity = {affinity = 6, start = 83},
    intelligence = {affinity = 4, start = 180},
    strength = {affinity = 5, start = 122},
    wisdom = {affinity = 2, start = 264},
    powerAttack = {affinity = 4, start = 139},
    powerSpell = {affinity = 4, start = 139},
    critAttack = {affinity = 5, start = 214},
    critSpell = {affinity = 5, start = 214},
    critPower = {affinity = 6, start = 108},
    block = {affinity = 1, start = 524},
    dodge = {affinity = 2, start = 243},
    guard = {affinity = 3, start = 180},
    endurance = {affinity = 3, start = 204},
    maxHealth = {affinity = 1, start = 2990},    
}

fragments.water = {
    dexterity = {affinity = 5, start = 122},
    intelligence = {affinity = 3, start = 204},
    strength = {affinity = 4, start = 180},
    wisdom = {affinity = 6, start = 83},
    powerAttack = {affinity = 2, start = 205},
    powerSpell = {affinity = 2, start = 205},
    critAttack = {affinity = 1, start = 524},
    critSpell = {affinity = 1, start = 524},
    critPower = {affinity = 3, start = 264},
    block = {affinity = 4, start = 315},
    dodge = {affinity = 6, start = 73},
    guard = {affinity = 5, start = 108},
    endurance = {affinity = 1, start = 299},
    maxHealth = {affinity = 2, start = 2640},
}


fragments.secondaries = {
    dexterity = {min = 21, max = 50, boost = 107},
    intelligence = {min = 21, max = 50, boost = 107},
    strength = {min = 21, max = 50, boost = 107},
    wisdom = {min = 21, max = 50, boost = 107},
    powerAttack = {min = 16, max = 39, boost = 84},
    powerSpell = {min = 16, max = 39, boost = 84},
    critAttack = {min = 37, max = 88, boost = 188},
    critSpell = {min = 37, max = 88, boost = 188},
    critPower = {min = 27, max = 65, boost = 139},
    block = {min = 23, max = 54, boost = 115},
    dodge ={min = 18, max = 44, boost = 94},
    guard = {min = 18, max = 44, boost = 94},
    endurance = {min = 21, max = 50, boost = 107},
    maxHealth = {min = 210, max = 500, boost = 1070},   
}

-- four types of names
-- Calculating Earth Planar Fragment
-- Calculating Earth War Fragment
-- Vital Martial/Mystical Earth Fragment
-- Vital Martial/Mystical Earth War Fragment
-- not needed with addition of item.fragmentTier
function fragments:testAffinity(fName)
    
    local fragName = string.split(fName, " ")
    local fragStat = fragments.titles[fragName[1]]
    local fragAff = 0
    
    
    if fragName[3] == "Planar" or fragName[3] == "War" then
        fragAff = fragments[string.lower(fragName[2])][fragStat].affinity
    elseif fragName[2] == "Martial" or fragName[2] == "Mystical" then
        fragAff = fragments[string.lower(fragName[3])][fragStat].affinity
    end
        
    return fragAff or 0
    
end

-- not needed with addition of item.fragmentAffinity
function fragments:getElement(fName)
    
    local fragName = string.split(fName, " ")
    local fragElem = ""
    
    
    if fragName[3] == "Planar" or fragName[3] == "War" then
        fragElem = fragName[2]
    elseif fragName[2] == "Martial" or fragName[2] == "Mystical" then
        fragElem = fragName[3]
    end
        
    return fragElem or false    
    
end


function fragments:getAffinityListByElement(fElement)
    
    local affList = {}
    local affString = ""
    local fElem = string.lower(fElement)
    local aff
    
    if fragments[fElem] then
        for k in pairs(fragments[fElem]) do
            aff = fragments[fElem][k].affinity
            if affList[aff] then
                affList[aff] = affList[aff] .. ", " .. Utilities:prettyStatName(k)
            else
                affList[aff] = Utilities:prettyStatName(k)
            end
        end
        
        for k, v in ipairs(affList) do
             affString = affString .. Utilities:colorByRarity(v,7-k) .. "\n"
        end
        
        affString = string.sub(affString, 1, -2)
    end
    
    return affString
    
end


-- four types of names
-- Calculating Earth Planar Fragment
-- Calculating Earth War Fragment
-- Vital Martial/Mystical Earth Fragment
-- Vital Martial/Mystical Earth War Fragment
-- not needed with addition of item.fragmentAffinity
function fragments:isFragmentName(fName)
   
    local fragName = string.split(fName, " ") 
    
    
    if fragName[4] and fragName[4] == "Fragment" then
        if fragName[3] == "Planar" or fragName[3] == "War" or fragName[2] == "Martial" or fragName[2] == "Mystical" then
            return true
        end    
    end
    
    if fragName[5] and fragName[5] == "Fragment" then
        if fragName[4] == "War" then
            return true
        end
    end
    
    return false
    
end

-- determines when next secondary stat change is, and what type of change
-- returns two values, integer level and string "stat upgrade", "new stat" or "already max"
-- input is frag - table result of Inspect.Item.Detail
function fragments:nextFragmentUpgrade(frag)
    local iLevel
    local nextLevel
    local statCount
    local statChange
    
    
    iLevel = frag.infusionLevel or -1
    
    if iLevel == -1 then
        return 0, "unknown"
    end
    
    if iLevel >= 15 then 
        return 15, "already max" 
    end
    
    nextLevel = 3 - (iLevel % 3) + iLevel
    if nextLevel == 15 then 
        return 15, "stat upgrade" 
    end
    
    
    if frag.rarity then -- white/common items have no rarity
        
        if frag.rarity == "uncommon" then
            if nextLevel > 3 then
                statChange = "new stat"
            else
                statChange = "stat upgrade"
            end
        elseif frag.rarity == "rare" then
            if nextLevel > 6 then
                statChange = "new stat"
            else
                statChange = "stat upgrade"
            end    
        elseif frag.rarity == "epic" then
            if nextLevel > 9 then
                statChange = "new stat"
            else
                statChange = "stat upgrade"
            end    
        elseif frag.rarity == "relic" then
            statChange = "stat upgrade"
        end
    else
        statChange = "new stat"
    end
    
    return nextLevel, statChange 
end

function fragments:checkFragments()
    
    local allFrags = Inspect.Item.Detail("sf01") 
    local rcyCount = 0
    local affTest, levelTest, tierTest, rarityTest, eleTest, mmTest
    local fragStat, fragName
    
    
    fragments.toRecycle = {}
    
    for k in pairs(allFrags) do
        
        if SW_Settings.Recycle.AllRules then
            for k2 in pairs(SW_Settings.Recycle.Rules) do
                affTest =  SW_Settings.Recycle.Rules[k2][fragments.fragmentAffinity[allFrags[k].fragmentAffinity]]    
                levelTest = allFrags[k].infusionLevel <= (SW_Settings.Recycle.Rules[k2].LevelMax or SW_Settings.Recycle.Rules[k2].levelMax or 0) -- compatability issue, was lowercase in earlier versions
                tierTest = SW_Settings.Recycle.Rules[k2].Tier[tonumber(allFrags[k].fragmentTier)]
                
                allFrags[k].rarity = allFrags[k].rarity or "common"  -- common items have no rarity for.. reasons...        
                rarityTest = SW_Settings.Recycle.Rules[k2].Rarity[(Utilities.Rarity[allFrags[k].rarity] - 1)] -- skip sellable  
             
                fragName = string.split(allFrags[k].name, " ")
                fragStat = string.gsub(Utilities:prettyStatName(fragments.titles[fragName[1]]), " ", "")              
                eleTest = SW_Settings.Recycle.Rules[k2][fragStat]
                
                if fragName[2] == "Martial" and not SW_Settings.Recycle.Rules[k2].Martial then
                    mmTest = false
                elseif fragName[2] == "Mystical" and not SW_Settings.Recycle.Rules[k2].Mystical then
                    mmTest = false
                else 
                    mmTest = true
                end
                
                
                if affTest and levelTest and rarityTest and tierTest and eleTest and mmTest then
                    rcyCount = rcyCount +1
                    fragments.toRecycle[rcyCount] = allFrags[k].id  
                    break -- to prevent adding same fragment multiple times to list
                end
            end
        else
    
            affTest =  SW_Settings.Recycle[fragments.fragmentAffinity[allFrags[k].fragmentAffinity]]
            levelTest = allFrags[k].infusionLevel <= SW_Settings.Recycle.LevelMax
            tierTest = SW_Settings.Recycle.Tier[tonumber(allFrags[k].fragmentTier)]   

            allFrags[k].rarity = allFrags[k].rarity or "common"  -- common items have no rarity for.. reasons...        
            rarityTest = SW_Settings.Recycle.Rarity[Utilities.Rarity[allFrags[k].rarity]]

            fragName = string.split(allFrags[k].name, " ")
            fragStat = string.gsub(Utilities:prettyStatName(fragments.titles[fragName[1]]), " ", "")
         --   print(fragName[1] .. ", " .. fragStat)
            eleTest = SW_Settings.Recycle[fragStat]
            
            if fragName[2] == "Martial" and not SW_Settings.Recycle.Martial then
                mmTest = false
            elseif fragName[2] == "Mystical" and not SW_Settings.Recycle.Mystical then
                mmTest = false
            else 
                mmTest = true
            end
            
            if affTest and levelTest and rarityTest and tierTest and eleTest and mmTest then
                rcyCount = rcyCount +1
                fragments.toRecycle[rcyCount] = allFrags[k].id  
            end
        end
        
    end
    
    return rcyCount
    
end


function fragments:equippedStats()
    local fStats = {} 
    local tempFrag
    
    for i = 1, 11 do
        tempFrag = Inspect.Item.Detail("seqp.f" .. string.format("%02d",i))  --leading 0 on slot ids
        if tempFrag then
            for k,v in pairs(tempFrag.stats) do
                fStats[k] = (fStats[k] or 0) + v
            end
        end
    end    
  
    return fStats
    
end

function fragments:printFragments(stats)
    local fStats = {} 
    local tempPF = ""

    
    fStats = fragments:equippedStats()
    
    --fun with metatables!
    local mt = {}
    mt.__index = function(table, key) return 0 end
    setmetatable(fStats, mt)
    
    if (stats ~= "tank") then
        tempPF = SW_Settings.MainStatLabel .. ": " .. fStats[SW_Settings.MainStat]
        tempPF = tempPF .. ",  " .. SW_Settings.OffStatLabel .. ": " .. fStats[SW_Settings.OffStat] .. "\n"
        tempPF = tempPF .. SW_Settings.PowerLabel .. ": " .. fStats[SW_Settings.Power] .. ",  "
        tempPF = tempPF .. SW_Settings.CritLabel .. ": " .. fStats[SW_Settings.Crit]
        tempPF = tempPF .. ",  Crit Power: " .. fStats.critPower .. "\n"
        
    end
    
    if (stats ~= "dps") then
        tempPF = tempPF .. "Endurance: " .. fStats.endurance
        tempPF = tempPF .. ",  Max Health: " .. fStats.maxHealth .. "\n"
        tempPF = tempPF .. "Block: " .. fStats.block
        tempPF = tempPF .. ",  Dodge: " .. fStats.dodge .. ",  "
        tempPF = tempPF .. "Guard: " .. fStats.guard
    else --trim the exta newline
        tempPF = tempPF:sub(1,-2)
    end
    
    print(tempPF)
    
    
end
