local addon, StatWeights = ...

function StatWeights:calcWeights(stats)
    
    local tempWeight = 0
    
    for k, v in pairs(stats) do
        
       tempWeight = tempWeight + v * (SW_SavedWeights[SW_Settings.Role][k] or 0) 
        
    end
    
    return tempWeight
    
end

function StatWeights:calcFragWeights(fElem)
   
    local tempWeight
    local tempList = {}
    local i = 1
    
    fElem = string.lower(fElem)
    
    for k in pairs(fragments[fElem]) do
        tempWeight = fragments[fElem][k].start * (SW_SavedWeights[SW_Settings.Role][k] or 0) 
        tempList[i] = {stat = k, weight = tempWeight, affinity = fragments[fElem][k].affinity}
        i = i + 1
    end
    
    table.sort(tempList, function(a,b) return b.weight < a.weight end)
    
    return tempList
    
end

function StatWeights:calcSecondaryWeights()
    local tempWeight
    local tempList = {}
    local i = 1
    
    for k in pairs(fragments.secondaries) do
        tempWeight = fragments.secondaries[k].max * (SW_SavedWeights[SW_Settings.Role][k] or 0) 
        tempList[i] = {stat = k, weight = tempWeight}
        i = i + 1
    end
    
    table.sort(tempList, function(a,b) return b.weight < a.weight end)
    
    return tempList    
    
    
end


function StatWeights:printFragWeights(fWeights, fNum)
    
    local tempStr = ""
    local relWeight = 0
    
    if not fWeights[fNum] then
        return "\nbad weight data"
    end
    
    tempStr = tempStr ..  Utilities:prettyStatName(fWeights[1].stat) 
    
    if SW_Settings.ShowTier then
        tempStr = tempStr .. " (" .. fWeights[1].affinity ..")"
    end
    
    if fWeights[1].weight ==  0 then  --avoid div by 0
        fWeightss[1].weight = 1 
    end
    

    
    for i = 2, fNum do
        relWeight = fWeights[i].weight/fWeights[1].weight
        tempStr = tempStr .. "\n" .. Utilities:prettyStatName(fWeights[i].stat)
        if SW_Settings.ShowTier then
            tempStr = tempStr .. " (" .. fWeights[i].affinity ..")"    
        end
        if SW_Settings.ShowRelativeWeight then
            tempStr = tempStr .. " [" ..  string.format("%.2f", relWeight) .. "]"
        end
    end   

    
    return tempStr
    
end

function StatWeights:printSecondaryWeights(fWeights, fNum)
    
    local tempStr = ""
    local relWeight = 0
    
    if not fWeights[fNum] then
        return "\nbad weight data"
    end
    
    tempStr = tempStr ..  Utilities:prettyStatName(fWeights[1].stat) 

    
    if fWeights[1].weight ==  0 then  --avoid div by 0
        fWeights[1].weight = 1 
    end
    
    
    for i = 2, fNum do
        relWeight = fWeights[i].weight/fWeights[1].weight
        tempStr = tempStr .. "\n" .. Utilities:prettyStatName(fWeights[i].stat)
        if SW_Settings.ShowRelativeWeight then
            tempStr = tempStr .. " [" ..  string.format("%.2f", relWeight) .. "]"
        end
    end   

    
    return tempStr
    
end


function StatWeights:getEquippedWeights(item)
-- returns four values
    local weight1
    local rune1
    local weight2
    local rune2
    
    if item.fragmentAffinity then  --fragments
        local tempFrag
        local tempWeight
        for i = 1, 11 do
            tempFrag = Inspect.Item.Detail("seqp.f" .. string.format("%02d",i))  --leading 0 on slot ids
            if tempFrag and tempFrag.fragmentAffinity and tempFrag.fragmentAffinity == item.fragmentAffinity and tempFrag.id ~= item.id then
                tempWeight = StatWeights:calcWeights(tempFrag.stats)
                if weight1 then
                    weight2 = tempWeight
                else
                    weight1 = tempWeight
                end
            end
        end
        return weight1, nil, weight2, nil
    end
    
    
    if not item.category then
        return nil, nil, nil, nil
    end
    
    if item.category == "planar lesser" then
        return nil, nil, nil, nil
    end
    
    
    if string.prefix(item.id,"i") then -- valid item id for Find
        tempSlot = Inspect.Item.Find(item.id) or " "
        if string.prefix(tempSlot, "seqp") then --equipped
            return nil, nil, nil, nil
        end
    end
    
    local slot1
    local slot2
    local tempItem


    slot1, slot2 = Utilities:slotByCategory(item.category)
    
    if slot1 then
        tempItem = Inspect.Item.Detail(slot1)
        if tempItem and tempItem.stats then
            
            if tempItem.damageMax and tempItem.damageMin and tempItem.damageDelay then
                tempItem.stats.WDPS = (tempItem.damageMin + tempItem.damageMax)/(2 * tempItem.damageDelay) 
            end 
            
            weight1 = StatWeights:calcWeights(tempItem.stats)

            if tempItem.statsRune then
                 rune1 = StatWeights:calcWeights(tempItem.statsRune)
            end
        end
    end

    if slot2 then
        tempItem = Inspect.Item.Detail(slot2)
        if tempItem and tempItem.stats then
        
            if tempItem.damageMax and tempItem.damageMin and tempItem.damageDelay then
                tempItem.stats.WDPS = (tempItem.damageMin + tempItem.damageMax)/(2 * tempItem.damageDelay) 
            end 
            
            weight2 = StatWeights:calcWeights(tempItem.stats)

            if tempItem.statsRune then
                rune2 = StatWeights:calcWeights(tempItem.statsRune)
            end
        end
    end

   
    
    return weight1, rune1, weight2, rune2
    
end
