-- some functions related to roles
local addon, StatWeights = ...


function StatWeights:getRoles()
    
    local rolelist = {}
    local templist = Inspect.Role.List()
    local rolenum
    
    for k,v in pairs(templist) do
        rolenum = tonumber(string.sub(k,-2,-1),16) + 1
        rolelist[rolenum] = v
    end
    
    return rolelist
    
end

