local addon, StatWeights = ...

StatWeights.RoleList = {}
StatWeights.SW_debug = false

SW_SavedWeights = SW_SavedWeights or {}
SW_Settings = SW_Settings or {}
SW_Rules = SW_Rules or {}


StatWeights.context = UI.CreateContext("StatWeights")
local window = UI.CreateFrame("SimpleWindow", "SW_ConfigWindow", StatWeights.context)

local frame_settings = UI.CreateFrame("Frame", "SW_SettingsFrame", window)
local frame_weights = UI.CreateFrame("Frame", "SW_WeightsFrame", window)
local frame_calc = UI.CreateFrame("Frame", "SW_CalcFrame", window)
local frame_debug = UI.CreateFrame("Frame", "SW_DebugFrame", window)
local frame_recycle = UI.CreateFrame("Frame", "SW_RecycleFrame", window)

local tabs = UI.CreateFrame("SimpleTabView", "SW_TabView", window)

window:SetVisible(false)

local rcyDialog = UI.CreateFrame("SimpleWindow", "SW_rcyWindow", StatWeights.context)




--local player = Inspect.Unit.Detail("player")

local textSet = false
local pLoaded = false
local vLoaded = false -- can't initialize everything til variables loaded and player loaded



local function init() 
    
    window:SetVisible(false)
    window:SetHeight(600)
    window:SetWidth(600)
    window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, 100)
    window:SetTitle("Stat Weights")
	window:SetLayer(1)
	window:SetAlpha(1)
    window:SetCloseButtonVisible(true)

    rcyDialog:SetVisible(false)
    rcyDialog:SetHeight(200)
    rcyDialog:SetWidth(380)
    rcyDialog:SetPoint("TOPLEFT", window, "TOPLEFT", 200, 200)
    rcyDialog:SetTitle("RECYCLE")
	rcyDialog:SetLayer(2)
	rcyDialog:SetAlpha(1)
    rcyDialog:SetCloseButtonVisible(true)
    
    
    tabs:AddTab("Weights", frame_weights)
    tabs:AddTab("Settings", frame_settings)
 --   tabs:AddTab("Calculate", frame_calc)
    tabs:AddTab("Recycle", frame_recycle)
    tabs:AddTab("Debug", frame_debug)
    tabs:SetHeight(500)
    tabs:SetWidth(550)
    tabs:SetPoint("CENTER", window, "CENTER", 0,20)
    tabs:SetVisible(true)
    
    --frame_settings:SetBackgroundColor(0,0,1,0.5)
    --frame_weights:SetBackgroundColor(0,0,1,0.5)
   
    
    -- DEBUG FRAME ------------
    
    frame_debug.statgrid = UI.CreateFrame("SimpleGrid", "SW_Debug_StatGrid", frame_debug)
    frame_debug.statgrid:SetPoint("TOPLEFT", frame_debug, "TOPLEFT", 20,20)
    frame_debug.statgrid:SetHeight(300)
    frame_debug.statgrid:SetWidth(300)
    frame_debug.statgrid:SetBorder(1, 1, 1, 1, 1)
    frame_debug.statgrid:SetMargin(1)
    frame_debug.statgrid:SetCellPadding(1)
    
    frame_debug.lblMainStat = UI.CreateFrame("Text", "txtMainStat", frame_debug.statgrid)
    frame_debug.lblOffStat = UI.CreateFrame("Text", "txtOffStat", frame_debug.statgrid)
    frame_debug.lblEnd = UI.CreateFrame("Text", "txtEnd", frame_debug.statgrid)
    frame_debug.lblPower = UI.CreateFrame("Text", "txtPower", frame_debug.statgrid)
    frame_debug.lblCrit = UI.CreateFrame("Text", "txtCrit", frame_debug.statgrid)
    frame_debug.lblCritPower = UI.CreateFrame("Text", "txtCritPower", frame_debug.statgrid)
    frame_debug.lblWDPS = UI.CreateFrame("Text", "txtWDPS", frame_debug.statgrid)
    frame_debug.lblWDPSMult = UI.CreateFrame("Text", "txtWDPSMult", frame_debug.statgrid)  
    
    frame_debug.txtMainStat = UI.CreateFrame("Text", "txtMainStat", frame_debug.statgrid)
    frame_debug.txtOffStat = UI.CreateFrame("Text", "txtOffStat", frame_debug.statgrid)
    frame_debug.txtEnd = UI.CreateFrame("Text", "txtEnd", frame_debug.statgrid)
    frame_debug.txtPower = UI.CreateFrame("Text", "txtPower", frame_debug.statgrid)
    frame_debug.txtCrit = UI.CreateFrame("Text", "txtCrit", frame_debug.statgrid)
    frame_debug.txtCritPower = UI.CreateFrame("Text", "txtCritPower", frame_debug.statgrid)
    frame_debug.txtWDPS = UI.CreateFrame("Text", "txtWDPS", frame_debug.statgrid)
    frame_debug.txtWDPSMult = UI.CreateFrame("Text", "txtWDPSMult", frame_debug.statgrid)
    
    frame_debug.txtMainStatUB = UI.CreateFrame("Text", "txtMainStatUB", frame_debug.statgrid)
    frame_debug.txtOffStatUB = UI.CreateFrame("Text", "txtOffStatUB", frame_debug.statgrid)
    frame_debug.txtEndUB = UI.CreateFrame("Text", "txtEndUB", frame_debug.statgrid)
    frame_debug.txtPowerUB = UI.CreateFrame("Text", "txtPowerUB", frame_debug.statgrid)
    frame_debug.txtCritUB = UI.CreateFrame("Text", "txtCritUB", frame_debug.statgrid)
    frame_debug.txtCritPowerUB = UI.CreateFrame("Text", "txtCritPowerUB", frame_debug.statgrid)
    
    frame_debug.txtMainStatEQ = UI.CreateFrame("Text", "txtMainStatEQ", frame_debug.statgrid)
    frame_debug.txtOffStatEQ = UI.CreateFrame("Text", "txtOffStatEQ", frame_debug.statgrid)
    frame_debug.txtEndEQ = UI.CreateFrame("Text", "txtEndEQ", frame_debug.statgrid)
    frame_debug.txtPowerEQ = UI.CreateFrame("Text", "txtPowerEQ", frame_debug.statgrid)
    frame_debug.txtCritEQ = UI.CreateFrame("Text", "txtCritEQ", frame_debug.statgrid)
    frame_debug.txtCritPowerEQ = UI.CreateFrame("Text", "txtCritPowerEQ", frame_debug.statgrid)

    frame_debug.txtMainStatRune = UI.CreateFrame("Text", "txtMainStatRune", frame_debug.statgrid)
    frame_debug.txtOffStatRune = UI.CreateFrame("Text", "txtOffStatRune", frame_debug.statgrid)
    frame_debug.txtEndRune = UI.CreateFrame("Text", "txtEndRune", frame_debug.statgrid)
    frame_debug.txtPowerRune = UI.CreateFrame("Text", "txtPowerRune", frame_debug.statgrid)
    frame_debug.txtCritRune = UI.CreateFrame("Text", "txtCritRune", frame_debug.statgrid)
    frame_debug.txtCritPowerRune = UI.CreateFrame("Text", "txtCritPowerRune", frame_debug.statgrid)

    
    frame_debug.txtMainStatBonus = UI.CreateFrame("Text", "txtMainStatBonus", frame_debug.statgrid)
    frame_debug.lblBonus = UI.CreateFrame("Text", "lblBonus", frame_debug.statgrid)
    frame_debug.txtPowerBonus = UI.CreateFrame("Text", "txtPowerBonus", frame_debug.statgrid)  
    
    
    frame_debug.lblMainStat:SetText("placeholder")
    frame_debug.txtMainStat:SetText("000000")
    frame_debug.statgrid:AddRow({frame_debug.lblMainStat,frame_debug.txtMainStat,frame_debug.txtMainStatUB,frame_debug.txtMainStatEQ,frame_debug.txtMainStatRune})
    
    frame_debug.lblOffStat:SetText("placeholder")
    frame_debug.txtOffStat:SetText("000000")
    frame_debug.statgrid:AddRow({frame_debug.lblOffStat,frame_debug.txtOffStat,frame_debug.txtOffStatUB,frame_debug.txtOffStatEQ,frame_debug.txtOffStatRune})
    
    frame_debug.lblEnd:SetText("Endurance")
    frame_debug.txtEnd:SetText("000000")
    frame_debug.statgrid:AddRow({frame_debug.lblEnd,frame_debug.txtEnd,frame_debug.txtEndUB,frame_debug.txtEndEQ,frame_debug.txtEndRune})
    
    frame_debug.lblPower:SetText("placeholder")
    frame_debug.txtPower:SetText("000000")
    frame_debug.statgrid:AddRow({frame_debug.lblPower,frame_debug.txtPower,frame_debug.txtPowerUB,frame_debug.txtPowerEQ,frame_debug.txtPowerRune})

    frame_debug.lblCrit:SetText("placeholder")
    frame_debug.txtCrit:SetText("000000")
    frame_debug.statgrid:AddRow({frame_debug.lblCrit,frame_debug.txtCrit,frame_debug.txtCritUB,frame_debug.txtCritEQ,frame_debug.txtCritRune})

    frame_debug.lblCritPower:SetText("Crit Power")
    frame_debug.txtCritPower:SetText("000000")
    frame_debug.statgrid:AddRow({frame_debug.lblCritPower,frame_debug.txtCritPower,frame_debug.txtCritPowerUB,frame_debug.txtCritPowerEQ,frame_debug.txtCritPowerRune})
    
    frame_debug.lblWDPS:SetText("WDPS")
    frame_debug.txtWDPS:SetText("000000")
    frame_debug.statgrid:AddRow({frame_debug.lblWDPS,frame_debug.txtWDPS})

    frame_debug.lblWDPSMult:SetText("WDPS Mult")
    frame_debug.txtWDPSMult:SetText("000000")
    frame_debug.statgrid:AddRow({frame_debug.lblWDPSMult,frame_debug.txtWDPSMult})
    
    frame_debug.lblBonus:SetText("Bonus")
    frame_debug.statgrid:AddRow({frame_debug.lblBonus,frame_debug.txtMainStatBonus,frame_debug.txtPowerBonus})
    
    
    frame_debug.btnTest = UI.CreateFrame("RiftButton", "btnTest", frame_debug)
    frame_debug.btnTest:SetText("TEST")
    frame_debug.btnTest:SetPoint("BOTTOMRIGHT", frame_debug, "BOTTOMRIGHT", -20,-20)

    function frame_debug.btnTest.Event:LeftPress()
        StatWeights:updateStats()
        frame_debug.statgrid:Layout()
    end
    
    tabs:RemoveTab(4)
    
    
   -- Weights Frame ----------------------
    
    frame_weights.statgrid = UI.CreateFrame("SimpleGrid", "SW_Weights_StatGrid", frame_weights)
    frame_weights.statgrid:SetPoint("TOPLEFT", frame_weights, "TOPLEFT", 15,60)
    frame_weights.statgrid:SetHeight(400)
    frame_weights.statgrid:SetWidth(200)
    frame_weights.statgrid:SetBorder(1, 1, 1, 1, 1)
    frame_weights.statgrid:SetMargin(10)
    frame_weights.statgrid:SetCellPadding(4)
    frame_weights.statgrid:SetBackgroundColor(0.2, 0.2, 0.2, 1)
    
    frame_weights.fraggrid = UI.CreateFrame("SimpleGrid", "SW_Weights_FragGrid", frame_weights)
    frame_weights.fraggrid:SetPoint("TOPLEFT", frame_weights, "TOPLEFT", 200,60)
    frame_weights.fraggrid:SetHeight(400)
    frame_weights.fraggrid:SetWidth(200)
    frame_weights.fraggrid:SetBorder(1, 1, 1, 1, 1)
    frame_weights.fraggrid:SetMargin(10)
    frame_weights.fraggrid:SetCellPadding(10)
    frame_weights.fraggrid:SetBackgroundColor(0.2, 0.2, 0.2, 1)
    
    frame_weights.fraggrid2 = UI.CreateFrame("SimpleGrid", "SW_Weights_FragGrid2", frame_weights)
    frame_weights.fraggrid2:SetPoint("TOPRIGHT", frame_weights, "TOPRIGHT", -15,15)
    frame_weights.fraggrid2:SetHeight(400)
    frame_weights.fraggrid2:SetWidth(200)
    frame_weights.fraggrid2:SetBorder(1, 1, 1, 1, 1)
    frame_weights.fraggrid2:SetMargin(10)
    frame_weights.fraggrid2:SetCellPadding(10)
    frame_weights.fraggrid2:SetBackgroundColor(0.2, 0.2, 0.2, 1)
    
    frame_weights.lblAir = UI.CreateFrame("Text", "lblAir", frame_weights.fraggrid)
    frame_weights.lblAir:SetText("Air Fragments")
    frame_weights.fraggrid:AddRow({frame_weights.lblAir})  
    
    frame_weights.lblFire = UI.CreateFrame("Text", "lblFire", frame_weights.fraggrid2)
    frame_weights.lblFire:SetText("Fire Fragments:")
    frame_weights.fraggrid2:AddRow({frame_weights.lblFire})     
    
      
    
    frame_weights.lblDamageStats = UI.CreateFrame("Text", "lblDamageStats", frame_weights.statgrid)
    frame_weights.lblTankingStats = UI.CreateFrame("Text", "lblTankingStats", frame_weights.statgrid)    
    
    frame_weights.lblMainStat = UI.CreateFrame("Text", "lblMainStat", frame_weights.statgrid)
    frame_weights.lblOffStat = UI.CreateFrame("Text", "lblOffStat", frame_weights.statgrid)
    frame_weights.lblEnd = UI.CreateFrame("Text", "lblEnd", frame_weights.statgrid)
    frame_weights.lblPower = UI.CreateFrame("Text", "lblPower", frame_weights.statgrid)
    frame_weights.lblCrit = UI.CreateFrame("Text", "lblCrit", frame_weights.statgrid)
    frame_weights.lblCritPower = UI.CreateFrame("Text", "lblCritPower", frame_weights.statgrid)
    frame_weights.lblWDPS = UI.CreateFrame("Text", "lblWDPS", frame_weights.statgrid)
    frame_weights.lblGuard = UI.CreateFrame("Text", "lblGuard", frame_weights.statgrid)
    frame_weights.lblBlock = UI.CreateFrame("Text", "lblBlock", frame_weights.statgrid)
    frame_weights.lblDodge = UI.CreateFrame("Text", "lblDodge", frame_weights.statgrid)
    frame_weights.lblMaxHealth = UI.CreateFrame("Text", "lblMaxHealth", frame_weights.statgrid)
    
    frame_weights.txtMainStat = UI.CreateFrame("RiftTextfield", "txtMainStat", frame_weights.statgrid)
    frame_weights.txtOffStat = UI.CreateFrame("RiftTextfield", "txtOffStat", frame_weights.statgrid)
    frame_weights.txtEnd = UI.CreateFrame("RiftTextfield", "txtEnd", frame_weights.statgrid)
    frame_weights.txtPower = UI.CreateFrame("RiftTextfield", "txtPower", frame_weights.statgrid)
    frame_weights.txtCrit = UI.CreateFrame("RiftTextfield", "txtCrit", frame_weights.statgrid)
    frame_weights.txtCritPower = UI.CreateFrame("RiftTextfield", "txtCritPower", frame_weights.statgrid)
    frame_weights.txtWDPS = UI.CreateFrame("RiftTextfield", "txtWDPS", frame_weights.statgrid)
    frame_weights.txtGuard = UI.CreateFrame("RiftTextfield", "txtGuard", frame_weights.statgrid)
    frame_weights.txtBlock = UI.CreateFrame("RiftTextfield", "txtBlock", frame_weights.statgrid)
    frame_weights.txtDodge = UI.CreateFrame("RiftTextfield", "txtDodge", frame_weights.statgrid)
    frame_weights.txtMaxHealth = UI.CreateFrame("RiftTextfield", "txtMaxHealth", frame_weights.statgrid)
    

    frame_weights.lblDamageStats:SetText("    Damage Stats")
    frame_weights.statgrid:AddRow({frame_weights.lblDamageStats})    
    
    frame_weights.lblMainStat:SetText("placeholder")
    frame_weights.txtMainStat:SetText("1")
    frame_weights.txtMainStat:SetWidth(5)
    frame_weights.txtMainStat:SetBackgroundColor(0,0,0)
    function frame_weights.txtMainStat.Event.TextfieldChange()  StatWeights:updateWeights(SW_Settings.MainStat, frame_weights.txtMainStat:GetText() ) end
    frame_weights.statgrid:AddRow({frame_weights.lblMainStat,frame_weights.txtMainStat})
    
    frame_weights.lblOffStat:SetText("placeholder")
    frame_weights.txtOffStat:SetText("0.5")
    frame_weights.txtOffStat:SetWidth(10)
    frame_weights.txtOffStat:SetBackgroundColor(0,0,0)
    function frame_weights.txtOffStat.Event.TextfieldChange()  StatWeights:updateWeights(SW_Settings.OffStat, frame_weights.txtOffStat:GetText() ) end
    frame_weights.statgrid:AddRow({frame_weights.lblOffStat,frame_weights.txtOffStat})
    
    frame_weights.lblPower:SetText("placeholder")
    frame_weights.txtPower:SetText("1")
    frame_weights.txtPower:SetWidth(10)
    frame_weights.txtPower:SetBackgroundColor(0,0,0)
    function frame_weights.txtPower.Event.TextfieldChange()  StatWeights:updateWeights(SW_Settings.Power, frame_weights.txtPower:GetText() ) end
    frame_weights.statgrid:AddRow({frame_weights.lblPower,frame_weights.txtPower})

    frame_weights.lblCrit:SetText("placeholder")
    frame_weights.txtCrit:SetText("0.4")
    frame_weights.txtCrit:SetWidth(10)
    frame_weights.txtCrit:SetBackgroundColor(0,0,0)
    function frame_weights.txtCrit.Event.TextfieldChange()  StatWeights:updateWeights(SW_Settings.Crit, frame_weights.txtCrit:GetText() ) end
    frame_weights.statgrid:AddRow({frame_weights.lblCrit,frame_weights.txtCrit})

    frame_weights.lblCritPower:SetText("Crit Power")
    frame_weights.txtCritPower:SetText("0.7")
    frame_weights.txtCritPower:SetWidth(10)
    frame_weights.txtCritPower:SetBackgroundColor(0,0,0)
    function frame_weights.txtCritPower.Event.TextfieldChange()  StatWeights:updateWeights("critPower", frame_weights.txtCritPower:GetText() ) end
    frame_weights.statgrid:AddRow({frame_weights.lblCritPower,frame_weights.txtCritPower})
    
    frame_weights.lblWDPS:SetText("Weapon DPS")
    frame_weights.txtWDPS:SetText("6")
    frame_weights.txtWDPS:SetWidth(10)
    frame_weights.txtWDPS:SetBackgroundColor(0,0,0)
    function frame_weights.txtWDPS.Event.TextfieldChange()  StatWeights:updateWeights("WDPS", frame_weights.txtWDPS:GetText() ) end
    frame_weights.statgrid:AddRow({frame_weights.lblWDPS,frame_weights.txtWDPS})
    
    
    frame_weights.lblTankingStats:SetText("    Tanking Stats")
    frame_weights.statgrid:AddRow({frame_weights.lblTankingStats}) 
    
    frame_weights.lblEnd:SetText("Endurance")
    frame_weights.txtEnd:SetText("0")
    frame_weights.txtEnd:SetWidth(10)
    frame_weights.txtEnd:SetBackgroundColor(0,0,0)
    function frame_weights.txtEnd.Event.TextfieldChange()  StatWeights:updateWeights("endurance", frame_weights.txtEnd:GetText() ) end
    frame_weights.statgrid:AddRow({frame_weights.lblEnd,frame_weights.txtEnd})    
    
    frame_weights.lblGuard:SetText("Guard")
    frame_weights.txtGuard:SetText("0")
    frame_weights.txtGuard:SetWidth(10)
    frame_weights.txtGuard:SetBackgroundColor(0,0,0)
    function frame_weights.txtGuard.Event.TextfieldChange()  StatWeights:updateWeights("guard", frame_weights.txtGuard:GetText() ) end
    frame_weights.statgrid:AddRow({frame_weights.lblGuard,frame_weights.txtGuard})  
    
    frame_weights.lblBlock:SetText("Block")
    frame_weights.txtBlock:SetText("0")
    frame_weights.txtBlock:SetWidth(10)
    frame_weights.txtBlock:SetBackgroundColor(0,0,0)
    function frame_weights.txtBlock.Event.TextfieldChange()  StatWeights:updateWeights("block", frame_weights.txtBlock:GetText() ) end
    frame_weights.statgrid:AddRow({frame_weights.lblBlock,frame_weights.txtBlock}) 
    
    frame_weights.lblDodge:SetText("Dodge")
    frame_weights.txtDodge:SetText("0")
    frame_weights.txtDodge:SetWidth(10)
    frame_weights.txtDodge:SetBackgroundColor(0,0,0)
    function frame_weights.txtDodge.Event.TextfieldChange()  StatWeights:updateWeights("dodge", frame_weights.txtDodge:GetText() ) end
    frame_weights.statgrid:AddRow({frame_weights.lblDodge,frame_weights.txtDodge}) 

    frame_weights.lblMaxHealth:SetText("Max Health")
    frame_weights.txtMaxHealth:SetText("0")
    frame_weights.txtMaxHealth:SetWidth(10)
    frame_weights.txtMaxHealth:SetBackgroundColor(0,0,0)
    function frame_weights.txtMaxHealth.Event.TextfieldChange()  StatWeights:updateWeights("maxHealth", frame_weights.txtMaxHealth:GetText() ) end
    frame_weights.statgrid:AddRow({frame_weights.lblMaxHealth,frame_weights.txtMaxHealth}) 
    
    frame_weights.statgrid:SetColumnWidth(2,56)
    frame_weights.statgrid:Layout()
    
    
    frame_weights.selRoles = UI.CreateFrame("SimpleSelect", "selRoles", frame_weights)
    frame_weights.selRoles:SetPoint("TOPLEFT", frame_weights, "TOPLEFT", 20,20)
    function frame_weights.selRoles.Event:ItemSelect(item, value, index)
       -- print((item or "nil")  .. ", " .. (value or "nil") .. ", " ..  (index or "nil"))
        StatWeights:checkRoleStats()
        local val = value or SW_Settings.Role or 1
        SW_Settings.Role = val
        
        frame_weights.txtMainStat:SetText(tostring(SW_SavedWeights[val][SW_Settings.MainStat]))
        frame_weights.txtOffStat:SetText(tostring(SW_SavedWeights[val][SW_Settings.OffStat]))
        frame_weights.txtPower:SetText(tostring(SW_SavedWeights[val][SW_Settings.Power]))
        frame_weights.txtCrit:SetText(tostring(SW_SavedWeights[val][SW_Settings.Crit]))
        frame_weights.txtCritPower:SetText(tostring(SW_SavedWeights[val]["critPower"]))
        frame_weights.txtEnd:SetText(tostring(SW_SavedWeights[val]["endurance"]))
        frame_weights.txtWDPS:SetText(tostring(SW_SavedWeights[val]["WDPS"]))
        frame_weights.txtGuard:SetText(tostring(SW_SavedWeights[val]["guard"]))
        frame_weights.txtBlock:SetText(tostring(SW_SavedWeights[val]["block"]))
        frame_weights.txtDodge:SetText(tostring(SW_SavedWeights[val]["dodge"]))
        frame_weights.txtMaxHealth:SetText(tostring(SW_SavedWeights[val]["maxHealth"]))
        
        StatWeights:updateFragmentWeightList()
        
        
    end    

    
    frame_weights.lblCopy = UI.CreateFrame("Text", "lblCopy", frame_weights)
    frame_weights.lblCopy:SetPoint("BOTTOMLEFT", frame_weights, "BOTTOMLEFT", 20,-20)
    frame_weights.lblCopy:SetText("Copy weights from: ")
    
    frame_weights.selCopy = UI.CreateFrame("SimpleSelect", "selCopy", frame_weights)
    frame_weights.selCopy:SetPoint("BOTTOMLEFT", frame_weights.lblCopy, "BOTTOMRIGHT", 5,0)
    function frame_weights.selCopy.Event:ItemSelect(item, value, index)
        
        local v1 = frame_weights.selRoles:GetSelectedValue()
        if not v1 then return end
        if not value then return end
        
        for k, v in pairs(SW_SavedWeights[value]) do
            SW_SavedWeights[v1][k] = v
        end
        
        frame_weights.selRoles:SetSelectedValue(v1)
        
    end    
    
end


-- Settings Frame ----------------------------------------

frame_settings.tooltipgrid = UI.CreateFrame("SimpleGrid", "SW_Settings_TooltipGrid", frame_settings)
frame_settings.tooltipgrid:SetPoint("TOPLEFT", frame_settings, "TOPLEFT", 30,30)
frame_settings.tooltipgrid:SetHeight(400)
frame_settings.tooltipgrid:SetWidth(200)
frame_settings.tooltipgrid:SetBorder(1, 1, 1, 1, 1)
frame_settings.tooltipgrid:SetMargin(10)
frame_settings.tooltipgrid:SetCellPadding(4)
frame_settings.tooltipgrid:SetBackgroundColor(0.2, 0.2, 0.2, 1)

frame_settings.weightgrid = UI.CreateFrame("SimpleGrid", "SW_Settings_WeightGrid", frame_settings)
frame_settings.weightgrid:SetPoint("TOPLEFT", frame_settings.tooltipgrid, "BOTTOMLEFT", 0,20)
frame_settings.weightgrid:SetHeight(400)
frame_settings.weightgrid:SetWidth(200)
frame_settings.weightgrid:SetBorder(1, 1, 1, 1, 1)
frame_settings.weightgrid:SetMargin(10)
frame_settings.weightgrid:SetCellPadding(4)
frame_settings.weightgrid:SetBackgroundColor(0.2, 0.2, 0.2, 1)

frame_settings.recyclegrid = UI.CreateFrame("SimpleGrid", "SW_Settings_RecycleGrid", frame_settings)
frame_settings.recyclegrid:SetPoint("TOPLEFT", frame_settings.weightgrid, "BOTTOMLEFT", 0,20)
frame_settings.recyclegrid:SetHeight(400)
frame_settings.recyclegrid:SetWidth(200)
frame_settings.recyclegrid:SetBorder(1, 1, 1, 1, 1)
frame_settings.recyclegrid:SetMargin(10)
frame_settings.recyclegrid:SetCellPadding(4)
frame_settings.recyclegrid:SetBackgroundColor(0.2, 0.2, 0.2, 1)

frame_settings.buttongrid = UI.CreateFrame("SimpleGrid", "SW_Settings_ButtonGrid", frame_settings)
frame_settings.buttongrid:SetPoint("TOPRIGHT", frame_settings, "TOPRIGHT", -30,30)
frame_settings.buttongrid:SetHeight(400)
frame_settings.buttongrid:SetWidth(200)
frame_settings.buttongrid:SetBorder(1, 1, 1, 1, 1)
frame_settings.buttongrid:SetMargin(10)
frame_settings.buttongrid:SetCellPadding(4)
frame_settings.buttongrid:SetBackgroundColor(0.2, 0.2, 0.2, 1)


frame_settings.lblTooltip = UI.CreateFrame("Text", "SW_Settings_lblTooltip", frame_settings.tooltipgrid)
frame_settings.lblTooltip:SetText("Tooltip Settings")
frame_settings.lblTooltip:SetFontSize(16)
frame_settings.tooltipgrid:AddRow({frame_settings.lblTooltip})

frame_settings.cbWeight = UI.CreateFrame("ExtendedCheckBox", "SW_Settings_cbWeight", frame_settings.tooltipgrid)
frame_settings.cbWeight:SetText("Show Stat Weight")
function frame_settings.cbWeight.Event.CheckboxChange() SW_Settings.ShowWeight = frame_settings.cbWeight:GetChecked() end
frame_settings.tooltipgrid:AddRow({frame_settings.cbWeight})

frame_settings.lblPlanarFrag = UI.CreateFrame("Text", "SW_Settings_lblPlanarFrag", frame_settings.tooltipgrid)
frame_settings.lblPlanarFrag:SetText("   Planar Fragments")
frame_settings.lblPlanarFrag:SetFontSize(14)
frame_settings.tooltipgrid:AddRow({frame_settings.lblPlanarFrag})

frame_settings.cbAffinity = UI.CreateFrame("ExtendedCheckBox", "SW_Settings_cbAffinity", frame_settings.tooltipgrid)
frame_settings.cbAffinity:SetText("Show Affinity List")
function frame_settings.cbAffinity.Event.CheckboxChange() SW_Settings.ShowAffinity = frame_settings.cbAffinity:GetChecked() end
frame_settings.tooltipgrid:AddRow({frame_settings.cbAffinity})

frame_settings.cbBest = UI.CreateFrame("ExtendedCheckBox", "SW_Settings_cbBest", frame_settings.tooltipgrid)
frame_settings.cbBest:SetText("Show Top Stats")
function frame_settings.cbBest.Event.CheckboxChange() SW_Settings.ShowBest = frame_settings.cbBest:GetChecked() end
frame_settings.tooltipgrid:AddRow({frame_settings.cbBest})

frame_settings.cbUpgrade = UI.CreateFrame("ExtendedCheckBox", "SW_Settings_cbUpgrade", frame_settings.tooltipgrid)
frame_settings.cbUpgrade:SetText("Show Next Secondary Upgrade Level")
function frame_settings.cbUpgrade.Event.CheckboxChange() SW_Settings.ShowUpgrade = frame_settings.cbUpgrade:GetChecked() end
frame_settings.tooltipgrid:AddRow({frame_settings.cbUpgrade})

frame_settings.tooltipgrid:Layout()


frame_settings.lblWeight = UI.CreateFrame("Text", "SW_Settings_lblWeight", frame_settings.weightgrid)
frame_settings.lblWeight:SetText("Weight Settings")
frame_settings.lblWeight:SetFontSize(16)
frame_settings.weightgrid:AddRow({frame_settings.lblWeight})

frame_settings.cbWeightTier = UI.CreateFrame("ExtendedCheckBox", "SW_Settings_cbWeightTier", frame_settings.weightgrid)
frame_settings.cbWeightTier:SetText("Show Fragment Tier")
function frame_settings.cbWeightTier.Event.CheckboxChange() 
    SW_Settings.ShowTier = frame_settings.cbWeightTier:GetChecked() 
    StatWeights:updateFragmentWeightList()
end
frame_settings.weightgrid:AddRow({frame_settings.cbWeightTier})

frame_settings.cbRelWeight = UI.CreateFrame("ExtendedCheckBox", "SW_Settings_cbRelWeight", frame_settings.weightgrid)
frame_settings.cbRelWeight:SetText("Show Relative Weight")
function frame_settings.cbRelWeight.Event.CheckboxChange() 
    SW_Settings.ShowRelativeWeight = frame_settings.cbRelWeight:GetChecked() 
    StatWeights:updateFragmentWeightList()
end
frame_settings.weightgrid:AddRow({frame_settings.cbRelWeight})


frame_settings.lblRecycle = UI.CreateFrame("Text", "SW_Settings_lblRecycle", frame_settings.recyclegrid)
frame_settings.lblRecycle:SetText("Recycle Settings")
frame_settings.lblRecycle:SetFontSize(16)
frame_settings.recyclegrid:AddRow({frame_settings.lblRecycle})

frame_settings.cbRecycleAllRules = UI.CreateFrame("ExtendedCheckBox", "SW_Settings_cbRecycleAllRules", frame_settings.recyclegrid)
frame_settings.cbRecycleAllRules:SetText("Use ALL saved rules when recycling")
function frame_settings.cbRecycleAllRules.Event.CheckboxChange() 
    SW_Settings.Recycle.AllRules = frame_settings.cbRecycleAllRules:GetChecked() 
end
frame_settings.recyclegrid:AddRow({frame_settings.cbRecycleAllRules})

frame_settings.lblRecycleAllRules = UI.CreateFrame("Text", "SW_Settings_lblRecycleAllRules", frame_settings.recyclegrid)
frame_settings.lblRecycleAllRules:SetText("      (Ignores any unsaved rules)")
frame_settings.recyclegrid:AddRow({frame_settings.lblRecycleAllRules})


frame_settings.cbRecycleShowConfirm = UI.CreateFrame("ExtendedCheckBox", "SW_Settings_cbRecycleShowConfirm", frame_settings.recyclegrid)
frame_settings.cbRecycleShowConfirm:SetText("Show Recycle Confirmation Box")
function frame_settings.cbRecycleShowConfirm.Event.CheckboxChange() 
    SW_Settings.Recycle.ShowConfirm = frame_settings.cbRecycleShowConfirm:GetChecked() 
end
frame_settings.recyclegrid:AddRow({frame_settings.cbRecycleShowConfirm})


frame_settings.lblButton = UI.CreateFrame("Text", "SW_Settings_lblButton", frame_settings.buttongrid)
frame_settings.lblButton:SetText("Button Settings")
frame_settings.lblButton:SetFontSize(16)
frame_settings.buttongrid:AddRow({frame_settings.lblButton})

frame_settings.cbShowButton = UI.CreateFrame("ExtendedCheckBox", "SW_Settings_cbShowButton", frame_settings.buttongrid)
frame_settings.cbShowButton:SetText("Show Button")
function frame_settings.cbShowButton.Event.CheckboxChange() 
    SW_Settings.ShowButton = frame_settings.cbShowButton:GetChecked() 
    StatWeights:ToggleButton(frame_settings.cbShowButton:GetChecked())
end
frame_settings.buttongrid:AddRow({frame_settings.cbShowButton})

frame_settings.cbLockButton = UI.CreateFrame("ExtendedCheckBox", "SW_Settings_cbLockButton", frame_settings.buttongrid)
frame_settings.cbLockButton:SetText("Lock Button Position")
function frame_settings.cbLockButton.Event.CheckboxChange() 
    SW_Settings.LockButton = frame_settings.cbLockButton:GetChecked() 
end
frame_settings.buttongrid:AddRow({frame_settings.cbLockButton})

frame_settings.cbButtonRClick = UI.CreateFrame("ExtendedCheckBox", "SW_Settings_cbButtonRClick", frame_settings.buttongrid)
frame_settings.cbButtonRClick:SetText("Right Click to Recycle")
function frame_settings.cbButtonRClick.Event.CheckboxChange() 
    SW_Settings.ButtonRClick = frame_settings.cbButtonRClick:GetChecked() 
end
frame_settings.buttongrid:AddRow({frame_settings.cbButtonRClick})


---------------------------------------------------------
-- Recycle Frame ----------------------------------------
---------------------------------------------------------

frame_recycle.elementgrid = UI.CreateFrame("SimpleGrid", "SW_Recycle_ElementGrid", frame_recycle)
frame_recycle.elementgrid:SetPoint("TOPLEFT", frame_recycle, "TOPLEFT", 15,10)
frame_recycle.elementgrid:SetHeight(400)
frame_recycle.elementgrid:SetWidth(200)
frame_recycle.elementgrid:SetBorder(1, 1, 1, 1, 1)
frame_recycle.elementgrid:SetMargin(10)
frame_recycle.elementgrid:SetCellPadding(4)
frame_recycle.elementgrid:SetBackgroundColor(0.2, 0.2, 0.2, 1)


frame_recycle.lblElement = UI.CreateFrame("Text", "SW_Recycle_lblElement", frame_recycle.elementgrid)
frame_recycle.lblElement:SetText("  Element")
frame_recycle.lblElement:SetFontSize(16)
frame_recycle.elementgrid:AddRow({frame_recycle.lblElement})

frame_recycle.cbElementAir = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbElementAir", frame_recycle.elementgrid)
frame_recycle.cbElementAir:SetText("Air", true)
function frame_recycle.cbElementAir.Event.CheckboxChange() 
    SW_Settings.Recycle.Air = frame_recycle.cbElementAir:GetChecked() 
end

frame_recycle.cbElementDeath = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbElementDeath", frame_recycle.elementgrid)
frame_recycle.cbElementDeath:SetText("Death", true)
function frame_recycle.cbElementDeath.Event.CheckboxChange() 
    SW_Settings.Recycle.Death = frame_recycle.cbElementDeath:GetChecked() 
end

frame_recycle.cbElementEarth = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbElementEarth", frame_recycle.elementgrid)
frame_recycle.cbElementEarth:SetText("Earth", true)
function frame_recycle.cbElementEarth.Event.CheckboxChange() 
    SW_Settings.Recycle.Earth = frame_recycle.cbElementEarth:GetChecked() 
end

frame_recycle.cbElementFire = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbElementFire", frame_recycle.elementgrid)
frame_recycle.cbElementFire:SetText("Fire", true)
function frame_recycle.cbElementFire.Event.CheckboxChange() 
    SW_Settings.Recycle.Fire = frame_recycle.cbElementFire:GetChecked() 
end

frame_recycle.cbElementLife = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbElementLife", frame_recycle.elementgrid)
frame_recycle.cbElementLife:SetText("Life", true)
function frame_recycle.cbElementLife.Event.CheckboxChange() 
    SW_Settings.Recycle.Life = frame_recycle.cbElementLife:GetChecked() 
end

frame_recycle.cbElementWater = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbElementWater", frame_recycle.elementgrid)
frame_recycle.cbElementWater:SetText("Water", true)
function frame_recycle.cbElementWater.Event.CheckboxChange() 
    SW_Settings.Recycle.Water = frame_recycle.cbElementWater:GetChecked() 
end

frame_recycle.elementgrid:AddRow({frame_recycle.cbElementAir, frame_recycle.cbElementFire})
frame_recycle.elementgrid:AddRow({frame_recycle.cbElementDeath, frame_recycle.cbElementLife})
frame_recycle.elementgrid:AddRow({frame_recycle.cbElementEarth, frame_recycle.cbElementWater})




frame_recycle.raritygrid = UI.CreateFrame("SimpleGrid", "SW_Recycle_RarityGrid", frame_recycle)
frame_recycle.raritygrid:SetPoint("TOPLEFT", frame_recycle, "TOPLEFT", 370,10)
frame_recycle.raritygrid:SetHeight(400)
frame_recycle.raritygrid:SetWidth(200)
frame_recycle.raritygrid:SetBorder(1, 1, 1, 1, 1)
frame_recycle.raritygrid:SetMargin(10)
frame_recycle.raritygrid:SetCellPadding(4)
frame_recycle.raritygrid:SetBackgroundColor(0.2, 0.2, 0.2, 1)

frame_recycle.lblRarity = UI.CreateFrame("Text", "SW_Recycle_lblRarity", frame_recycle.raritygrid)
frame_recycle.lblRarity:SetText("  Rarity")
frame_recycle.lblRarity:SetFontSize(16)
frame_recycle.raritygrid:AddRow({frame_recycle.lblRarity})

frame_recycle.cbRarity1 = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbWeightTier", frame_recycle.raritygrid)
frame_recycle.cbRarity1:SetText("Common", true)
function frame_recycle.cbRarity1.Event.CheckboxChange() 
    SW_Settings.Recycle.Rarity[2] = frame_recycle.cbRarity1:GetChecked() 
end
frame_recycle.raritygrid:AddRow({frame_recycle.cbRarity1})

frame_recycle.cbRarity2 = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbWeightTier2", frame_recycle.raritygrid)
frame_recycle.cbRarity2:SetText(Utilities:colorByRarity("Uncommon", 3), true)
function frame_recycle.cbRarity2.Event.CheckboxChange() 
    SW_Settings.Recycle.Rarity[3] = frame_recycle.cbRarity2:GetChecked() 
end
frame_recycle.raritygrid:AddRow({frame_recycle.cbRarity2})

frame_recycle.cbRarity3 = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbWeightTier3", frame_recycle.raritygrid)
frame_recycle.cbRarity3:SetText(Utilities:colorByRarity("Rare", 4), true)
function frame_recycle.cbRarity3.Event.CheckboxChange() 
    SW_Settings.Recycle.Rarity[4] = frame_recycle.cbRarity3:GetChecked() 
end
frame_recycle.raritygrid:AddRow({frame_recycle.cbRarity3})

frame_recycle.cbRarity4 = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbWeightTier4", frame_recycle.raritygrid)
frame_recycle.cbRarity4:SetText(Utilities:colorByRarity("Epic", 5), true)
function frame_recycle.cbRarity4.Event.CheckboxChange() 
    SW_Settings.Recycle.Rarity[5] = frame_recycle.cbRarity4:GetChecked() 
end
frame_recycle.raritygrid:AddRow({frame_recycle.cbRarity4})

frame_recycle.cbRarity5 = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbWeightTier5", frame_recycle.raritygrid)
frame_recycle.cbRarity5:SetText(Utilities:colorByRarity("Relic", 6), true)
function frame_recycle.cbRarity5.Event.CheckboxChange() 
    SW_Settings.Recycle.Rarity[6] = frame_recycle.cbRarity5:GetChecked() 
end
frame_recycle.raritygrid:AddRow({frame_recycle.cbRarity5})


frame_recycle.martialgrid = UI.CreateFrame("SimpleGrid", "SW_Recycle_MartialGrid", frame_recycle)
frame_recycle.martialgrid:SetPoint("TOPLEFT", frame_recycle.raritygrid, "BOTTOMLEFT", 0,20)
frame_recycle.martialgrid:SetBorder(1, 1, 1, 1, 1)
frame_recycle.martialgrid:SetMargin(10)
frame_recycle.martialgrid:SetCellPadding(4)
frame_recycle.martialgrid:SetBackgroundColor(0.2, 0.2, 0.2, 1)


frame_recycle.cbMartial = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbMartial", frame_recycle.martialgrid)
frame_recycle.cbMartial:SetText("Martial")
function frame_recycle.cbMartial.Event.CheckboxChange() 
    SW_Settings.Recycle.Martial = frame_recycle.cbMartial:GetChecked() 
end
frame_recycle.martialgrid:AddRow({frame_recycle.cbMartial})

frame_recycle.cbMystical = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbMystical", frame_recycle.martialgrid)
frame_recycle.cbMystical:SetText("Mystical")
function frame_recycle.cbMystical.Event.CheckboxChange() 
    SW_Settings.Recycle.Mystical = frame_recycle.cbMystical:GetChecked() 
end
frame_recycle.martialgrid:AddRow({frame_recycle.cbMystical})




frame_recycle.tiergrid = UI.CreateFrame("SimpleGrid", "SW_Recycle_TierGrid", frame_recycle)
frame_recycle.tiergrid:SetPoint("TOPLEFT", frame_recycle, "TOPLEFT", 230,10)
frame_recycle.tiergrid:SetHeight(400)
frame_recycle.tiergrid:SetWidth(200)
frame_recycle.tiergrid:SetBorder(1, 1, 1, 1, 1)
frame_recycle.tiergrid:SetMargin(10)
frame_recycle.tiergrid:SetCellPadding(4)
frame_recycle.tiergrid:SetBackgroundColor(0.2, 0.2, 0.2, 1)

frame_recycle.lblTier = UI.CreateFrame("Text", "SW_Recycle_lblTier", frame_recycle.tiergrid)
frame_recycle.lblTier:SetText("  Tier")
frame_recycle.lblTier:SetFontSize(16)
frame_recycle.tiergrid:AddRow({frame_recycle.lblTier})

frame_recycle.cbTier1 = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbWeightTier", frame_recycle.tiergrid)
frame_recycle.cbTier1:SetText("1 (Best)", true)
function frame_recycle.cbTier1.Event.CheckboxChange() 
    SW_Settings.Recycle.Tier[1] = frame_recycle.cbTier1:GetChecked() 
end
frame_recycle.tiergrid:AddRow({frame_recycle.cbTier1})

frame_recycle.cbTier2 = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbWeightTier2", frame_recycle.tiergrid)
frame_recycle.cbTier2:SetText("2", true)
function frame_recycle.cbTier2.Event.CheckboxChange() 
    SW_Settings.Recycle.Tier[2] = frame_recycle.cbTier2:GetChecked() 
end
frame_recycle.tiergrid:AddRow({frame_recycle.cbTier2})

frame_recycle.cbTier3 = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbWeightTier3", frame_recycle.tiergrid)
frame_recycle.cbTier3:SetText("3", true)
function frame_recycle.cbTier3.Event.CheckboxChange() 
    SW_Settings.Recycle.Tier[3] = frame_recycle.cbTier3:GetChecked() 
end
frame_recycle.tiergrid:AddRow({frame_recycle.cbTier3})

frame_recycle.cbTier4 = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbWeightTier4", frame_recycle.tiergrid)
frame_recycle.cbTier4:SetText("4", true)
function frame_recycle.cbTier4.Event.CheckboxChange() 
    SW_Settings.Recycle.Tier[4] = frame_recycle.cbTier4:GetChecked() 
end
frame_recycle.tiergrid:AddRow({frame_recycle.cbTier4})

frame_recycle.cbTier5 = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbWeightTier5", frame_recycle.tiergrid)
frame_recycle.cbTier5:SetText("5", true)
function frame_recycle.cbTier5.Event.CheckboxChange() 
    SW_Settings.Recycle.Tier[5] = frame_recycle.cbTier5:GetChecked() 
end
frame_recycle.tiergrid:AddRow({frame_recycle.cbTier5})

frame_recycle.cbTier6 = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbWeightTier6", frame_recycle.tiergrid)
frame_recycle.cbTier6:SetText("6 (Worst)", true)
function frame_recycle.cbTier6.Event.CheckboxChange() 
    SW_Settings.Recycle.Tier[6] = frame_recycle.cbTier6:GetChecked() 
end
frame_recycle.tiergrid:AddRow({frame_recycle.cbTier6})

frame_recycle.lblLevel = UI.CreateFrame("Text", "SW_Recycle_lblTier", frame_recycle.tiergrid)
frame_recycle.lblLevel:SetText("\n  Max Level\n  To Recycle")
frame_recycle.lblLevel:SetFontSize(16)
frame_recycle.tiergrid:AddRow({frame_recycle.lblLevel})

frame_recycle.slLevel = UI.CreateFrame("SimpleSlider", "SW_Recycle_slLevel", frame_recycle.tiergrid)
frame_recycle.slLevel:SetRange(0,15)
frame_recycle.slLevel:SetWidth(100)
frame_recycle.tiergrid:AddRow({frame_recycle.slLevel})
function frame_recycle.slLevel.Event.SliderChange() 
    SW_Settings.Recycle.LevelMax = frame_recycle.slLevel:GetPosition() 
end


frame_recycle.statgrid = UI.CreateFrame("SimpleGrid", "SW_Recycle_StatGrid", frame_recycle)
frame_recycle.statgrid:SetPoint("TOPLEFT", frame_recycle, "TOPLEFT", 15,140)
frame_recycle.statgrid:SetHeight(400)
frame_recycle.statgrid:SetWidth(200)
frame_recycle.statgrid:SetBorder(1, 1, 1, 1, 1)
frame_recycle.statgrid:SetMargin(10)
frame_recycle.statgrid:SetCellPadding(4)
frame_recycle.statgrid:SetBackgroundColor(0.2, 0.2, 0.2, 1)

frame_recycle.lblStat = UI.CreateFrame("Text", "SW_Recycle_lblStat", frame_recycle.statgrid)
frame_recycle.lblStat:SetText("  Main Stat")
frame_recycle.lblStat:SetFontSize(16)
frame_recycle.statgrid:AddRow({frame_recycle.lblStat})

frame_recycle.cbDexterity = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbDexterity", frame_recycle.statgrid)
frame_recycle.cbDexterity:SetText("Dexterity")
function frame_recycle.cbDexterity.Event.CheckboxChange() 
    SW_Settings.Recycle.Dexterity = frame_recycle.cbDexterity:GetChecked() 
end

frame_recycle.cbIntelligence = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbIntelligence", frame_recycle.statgrid)
frame_recycle.cbIntelligence:SetText("Intelligence")
function frame_recycle.cbIntelligence.Event.CheckboxChange() 
    SW_Settings.Recycle.Intelligence = frame_recycle.cbIntelligence:GetChecked() 
end

frame_recycle.cbStrength = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbStrength", frame_recycle.statgrid)
frame_recycle.cbStrength:SetText("Strength")
function frame_recycle.cbStrength.Event.CheckboxChange() 
    SW_Settings.Recycle.Strength = frame_recycle.cbStrength:GetChecked() 
end

frame_recycle.cbWisdom = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbWisdom", frame_recycle.statgrid)
frame_recycle.cbWisdom:SetText("Wisdom")
function frame_recycle.cbWisdom.Event.CheckboxChange() 
    SW_Settings.Recycle.Wisdom = frame_recycle.cbWisdom:GetChecked() 
end

frame_recycle.cbAttackPower = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbAttackPower", frame_recycle.statgrid)
frame_recycle.cbAttackPower:SetText("Attack Power")
function frame_recycle.cbAttackPower.Event.CheckboxChange() 
    SW_Settings.Recycle.AttackPower = frame_recycle.cbAttackPower:GetChecked() 
end

frame_recycle.cbSpellPower = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbSpellPower", frame_recycle.statgrid)
frame_recycle.cbSpellPower:SetText("Spell Power")
function frame_recycle.cbSpellPower.Event.CheckboxChange() 
    SW_Settings.Recycle.SpellPower = frame_recycle.cbSpellPower:GetChecked() 
end

frame_recycle.cbPhysCrit = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbPhysCrit", frame_recycle.statgrid)
frame_recycle.cbPhysCrit:SetText("Phys Crit")
function frame_recycle.cbPhysCrit.Event.CheckboxChange() 
    SW_Settings.Recycle.PhysCrit = frame_recycle.cbPhysCrit:GetChecked() 
end

frame_recycle.cbSpellCrit = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbSpellCrit", frame_recycle.statgrid)
frame_recycle.cbSpellCrit:SetText("Spell Crit")
function frame_recycle.cbSpellCrit.Event.CheckboxChange() 
    SW_Settings.Recycle.SpellCrit = frame_recycle.cbSpellCrit:GetChecked() 
end

frame_recycle.cbCritPower = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbCritPower", frame_recycle.statgrid)
frame_recycle.cbCritPower:SetText("Crit Power")
function frame_recycle.cbCritPower.Event.CheckboxChange() 
    SW_Settings.Recycle.CritPower = frame_recycle.cbCritPower:GetChecked() 
end

frame_recycle.cbGuard = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbGuard", frame_recycle.statgrid)
frame_recycle.cbGuard:SetText("Guard")
function frame_recycle.cbGuard.Event.CheckboxChange() 
    SW_Settings.Recycle.Guard = frame_recycle.cbGuard:GetChecked() 
end

frame_recycle.cbBlock = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbBlock", frame_recycle.statgrid)
frame_recycle.cbBlock:SetText("Block")
function frame_recycle.cbBlock.Event.CheckboxChange() 
    SW_Settings.Recycle.Block = frame_recycle.cbBlock:GetChecked() 
end

frame_recycle.cbDodge = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbDodge", frame_recycle.statgrid)
frame_recycle.cbDodge:SetText("Dodge")
function frame_recycle.cbDodge.Event.CheckboxChange() 
    SW_Settings.Recycle.Dodge = frame_recycle.cbDodge:GetChecked() 
end

frame_recycle.cbEndurance = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbEndurance", frame_recycle.statgrid)
frame_recycle.cbEndurance:SetText("Endurance")
function frame_recycle.cbEndurance.Event.CheckboxChange() 
    SW_Settings.Recycle.Endurance = frame_recycle.cbEndurance:GetChecked() 
end

frame_recycle.cbMaxHealth = UI.CreateFrame("ExtendedCheckBox", "SW_Recycle_cbMaxHealth", frame_recycle.statgrid)
frame_recycle.cbMaxHealth:SetText("Max Health")
function frame_recycle.cbMaxHealth.Event.CheckboxChange() 
    SW_Settings.Recycle.MaxHealth = frame_recycle.cbMaxHealth:GetChecked() 
end

frame_recycle.btnCheckStats = UI.CreateFrame("RiftButton", "btnCheckStats", frame_recycle.statgrid)
frame_recycle.btnCheckStats:SetText("All")
frame_recycle.btnCheckStats:SetWidth(60)
frame_recycle.btnCheckStats.CheckAll = true
function frame_recycle.btnCheckStats.Event:LeftPress()
    frame_recycle.cbDexterity:SetChecked(frame_recycle.btnCheckStats.CheckAll)
    frame_recycle.cbIntelligence:SetChecked(frame_recycle.btnCheckStats.CheckAll)
    frame_recycle.cbStrength:SetChecked(frame_recycle.btnCheckStats.CheckAll)
    frame_recycle.cbWisdom:SetChecked(frame_recycle.btnCheckStats.CheckAll)
    frame_recycle.cbAttackPower:SetChecked(frame_recycle.btnCheckStats.CheckAll)
    frame_recycle.cbSpellPower:SetChecked(frame_recycle.btnCheckStats.CheckAll)
    frame_recycle.cbPhysCrit:SetChecked(frame_recycle.btnCheckStats.CheckAll)
    frame_recycle.cbSpellCrit:SetChecked(frame_recycle.btnCheckStats.CheckAll)
    frame_recycle.cbCritPower:SetChecked(frame_recycle.btnCheckStats.CheckAll)
    frame_recycle.cbGuard:SetChecked(frame_recycle.btnCheckStats.CheckAll)
    frame_recycle.cbBlock:SetChecked(frame_recycle.btnCheckStats.CheckAll)
    frame_recycle.cbDodge:SetChecked(frame_recycle.btnCheckStats.CheckAll)
    frame_recycle.cbEndurance:SetChecked(frame_recycle.btnCheckStats.CheckAll)
    frame_recycle.cbMaxHealth:SetChecked(frame_recycle.btnCheckStats.CheckAll)
    
    if frame_recycle.btnCheckStats.CheckAll then
        frame_recycle.btnCheckStats.CheckAll =  false
        frame_recycle.btnCheckStats:SetText("None")
    else
        frame_recycle.btnCheckStats.CheckAll =  true
        frame_recycle.btnCheckStats:SetText("All")       
    end
end


frame_recycle.statgrid:AddRow({frame_recycle.cbDexterity, frame_recycle.cbIntelligence})
frame_recycle.statgrid:AddRow({frame_recycle.cbStrength, frame_recycle.cbWisdom})
frame_recycle.statgrid:AddRow({frame_recycle.cbAttackPower, frame_recycle.cbSpellPower})
frame_recycle.statgrid:AddRow({frame_recycle.cbPhysCrit, frame_recycle.cbSpellCrit})
frame_recycle.statgrid:AddRow({frame_recycle.cbCritPower, frame_recycle.cbGuard})
frame_recycle.statgrid:AddRow({frame_recycle.cbBlock, frame_recycle.cbDodge})
frame_recycle.statgrid:AddRow({frame_recycle.cbEndurance, frame_recycle.cbMaxHealth})
frame_recycle.statgrid:AddRow({frame_recycle.btnCheckStats})


frame_recycle.btnFrags = UI.CreateFrame("RiftButton", "btnFrags", frame_recycle)
frame_recycle.btnFrags:SetText("RECYCLE")
frame_recycle.btnFrags:SetHeight(45)
frame_recycle.btnFrags:SetPoint("TOPLEFT", frame_recycle, "TOPLEFT", 340,320)
function frame_recycle.btnFrags.Event:LeftPress()
    StatWeights:fragRecycle()
end

function StatWeights:fragRecycle()
    
    local count    
    count =  fragments:checkFragments()
    
    if SW_Settings.Recycle.ShowConfirm then
        if count > 0 then
            rcyDialog.lblCount:SetText("Recycle ".. count .. " Fragments?")
            rcyDialog.btnRecycle:SetEnabled(true)
            rcyDialog:SetVisible(true)
       else
            rcyDialog.lblCount:SetText("No Fragments Meet Criteria")
            rcyDialog.btnRecycle:SetEnabled(false)
            rcyDialog:SetVisible(true)  
        end
    else 
        if count > 0 then
            print("Recycling " .. count .. " fragments")
            Command.Fragment.Recycle(fragments.toRecycle)
            fragments.toRecycle = {}            
        else
            print("No matching fragments to recycle")
        end
    end
end

frame_recycle.lblSaveRule = UI.CreateFrame("Text", "lblSaveRule", frame_recycle)
frame_recycle.lblSaveRule:SetText("Save Rule As: ")
frame_recycle.lblSaveRule:SetFontSize(16)
frame_recycle.lblSaveRule:SetPoint("BOTTOMLEFT", frame_recycle, "BOTTOMLEFT", 20, -40)

frame_recycle.txtSaveRule = UI.CreateFrame("RiftTextfield", "txtSaveRule", frame_recycle)
frame_recycle.txtSaveRule:SetPoint("BOTTOMLEFT", frame_recycle.lblSaveRule, "BOTTOMRIGHT", 10, 0)
frame_recycle.txtSaveRule:SetBackgroundColor(0,0,0,1)

frame_recycle.btnSaveRule = UI.CreateFrame("RiftButton", "btnSaveRule", frame_recycle)
frame_recycle.btnSaveRule:SetPoint("BOTTOMLEFT", frame_recycle.txtSaveRule, "BOTTOMRIGHT", 10, 5)
frame_recycle.btnSaveRule:SetText("SAVE")
frame_recycle.btnSaveRule:SetWidth(80)

function frame_recycle.btnSaveRule.Event:LeftPress()
    
    if frame_recycle.txtSaveRule:GetText() == "" then  return end
    
    SW_Settings.Recycle.Rules[frame_recycle.txtSaveRule:GetText()] = {
        
        Air = frame_recycle.cbElementAir:GetChecked(),
        Death = frame_recycle.cbElementDeath:GetChecked(),
        Earth = frame_recycle.cbElementEarth:GetChecked(),
        Fire = frame_recycle.cbElementFire:GetChecked(), 
        Life = frame_recycle.cbElementLife:GetChecked(),
        Water = frame_recycle.cbElementWater:GetChecked(),
        
        Dexterity = frame_recycle.cbDexterity:GetChecked(),
        Intelligence = frame_recycle.cbIntelligence:GetChecked(),
        Strength = frame_recycle.cbStrength:GetChecked(),
        Wisdom = frame_recycle.cbWisdom:GetChecked(),
        AttackPower = frame_recycle.cbAttackPower:GetChecked(),
        SpellPower = frame_recycle.cbSpellPower:GetChecked(),
        PhysCrit = frame_recycle.cbPhysCrit:GetChecked(),
        SpellCrit = frame_recycle.cbSpellCrit:GetChecked(),
        CritPower = frame_recycle.cbCritPower:GetChecked(),
        Guard = frame_recycle.cbGuard:GetChecked(),
        Block = frame_recycle.cbBlock:GetChecked(),
        Dodge = frame_recycle.cbDodge:GetChecked(),
        Endurance = frame_recycle.cbEndurance:GetChecked(),
        MaxHealth = frame_recycle.cbMaxHealth:GetChecked(),
        
        Tier = {
            frame_recycle.cbTier1:GetChecked(),
            frame_recycle.cbTier2:GetChecked(),
            frame_recycle.cbTier3:GetChecked(),
            frame_recycle.cbTier4:GetChecked(),
            frame_recycle.cbTier5:GetChecked(),
            frame_recycle.cbTier6:GetChecked(),              
        },

        Rarity = {
            frame_recycle.cbRarity1:GetChecked(),
            frame_recycle.cbRarity2:GetChecked(),
            frame_recycle.cbRarity3:GetChecked(),
            frame_recycle.cbRarity4:GetChecked(),
            frame_recycle.cbRarity5:GetChecked(),            
            
        },
       
        LevelMax = frame_recycle.slLevel:GetPosition(),
        
        Martial = frame_recycle.cbMartial:GetChecked(),
        Mystical = frame_recycle.cbMystical:GetChecked(),
    }
    
    SW_Rules[SW_Settings.name][frame_recycle.txtSaveRule:GetText()] = SW_Settings.Recycle.Rules[frame_recycle.txtSaveRule:GetText()]
    
    StatWeights:updateRules()
    frame_recycle.selRules:SetSelectedItem(frame_recycle.txtSaveRule:GetText(), true)
    print("Saved rule \"" .. frame_recycle.txtSaveRule:GetText() .. "\"")
    
end

frame_recycle.lblLoadRule = UI.CreateFrame("Text", "lblLoadRule", frame_recycle)
frame_recycle.lblLoadRule:SetFontSize(16)
frame_recycle.lblLoadRule:SetText("Load Rule: ")
frame_recycle.lblLoadRule:SetPoint("BOTTOMLEFT", frame_recycle, "BOTTOMLEFT", 20, -10)



frame_recycle.selRules = UI.CreateFrame("SimpleSelect", "selRules", frame_recycle)
frame_recycle.selRules:SetPoint("BOTTOMLEFT", frame_recycle.lblLoadRule, "BOTTOMRIGHT", 10,-2)
function frame_recycle.selRules.Event:ItemSelect()

    local rule = frame_recycle.selRules:GetSelectedItem()
    
    if not SW_Settings.Recycle.Rules[rule] then return end
    
    frame_recycle.cbElementAir:SetChecked(SW_Settings.Recycle.Rules[rule].Air)
    frame_recycle.cbElementDeath:SetChecked(SW_Settings.Recycle.Rules[rule].Death)
    frame_recycle.cbElementEarth:SetChecked(SW_Settings.Recycle.Rules[rule].Earth)
    frame_recycle.cbElementFire:SetChecked(SW_Settings.Recycle.Rules[rule].Fire) 
    frame_recycle.cbElementLife:SetChecked(SW_Settings.Recycle.Rules[rule].Life)
    frame_recycle.cbElementWater:SetChecked(SW_Settings.Recycle.Rules[rule].Water)   

    frame_recycle.cbDexterity:SetChecked(SW_Settings.Recycle.Rules[rule].Dexterity)
    frame_recycle.cbIntelligence:SetChecked(SW_Settings.Recycle.Rules[rule].Intelligence)
    frame_recycle.cbStrength:SetChecked(SW_Settings.Recycle.Rules[rule].Strength)
    frame_recycle.cbWisdom:SetChecked(SW_Settings.Recycle.Rules[rule].Wisdom)
    frame_recycle.cbAttackPower:SetChecked(SW_Settings.Recycle.Rules[rule].AttackPower)
    frame_recycle.cbSpellPower:SetChecked(SW_Settings.Recycle.Rules[rule].SpellPower)
    frame_recycle.cbPhysCrit:SetChecked(SW_Settings.Recycle.Rules[rule].PhysCrit)
    frame_recycle.cbSpellCrit:SetChecked(SW_Settings.Recycle.Rules[rule].SpellCrit)
    frame_recycle.cbCritPower:SetChecked(SW_Settings.Recycle.Rules[rule].CritPower)
    frame_recycle.cbGuard:SetChecked(SW_Settings.Recycle.Rules[rule].Guard)
    frame_recycle.cbBlock:SetChecked(SW_Settings.Recycle.Rules[rule].Block)
    frame_recycle.cbDodge:SetChecked(SW_Settings.Recycle.Rules[rule].Dodge)
    frame_recycle.cbEndurance:SetChecked(SW_Settings.Recycle.Rules[rule].Endurance)
    frame_recycle.cbMaxHealth:SetChecked(SW_Settings.Recycle.Rules[rule].MaxHealth)

    frame_recycle.cbTier1:SetChecked(SW_Settings.Recycle.Rules[rule].Tier[1])
    frame_recycle.cbTier2:SetChecked(SW_Settings.Recycle.Rules[rule].Tier[2])
    frame_recycle.cbTier3:SetChecked(SW_Settings.Recycle.Rules[rule].Tier[3])
    frame_recycle.cbTier4:SetChecked(SW_Settings.Recycle.Rules[rule].Tier[4])
    frame_recycle.cbTier5:SetChecked(SW_Settings.Recycle.Rules[rule].Tier[5])
    frame_recycle.cbTier6:SetChecked(SW_Settings.Recycle.Rules[rule].Tier[6])

    frame_recycle.cbRarity1:SetChecked(SW_Settings.Recycle.Rules[rule].Rarity[1])
    frame_recycle.cbRarity2:SetChecked(SW_Settings.Recycle.Rules[rule].Rarity[2])
    frame_recycle.cbRarity3:SetChecked(SW_Settings.Recycle.Rules[rule].Rarity[3])
    frame_recycle.cbRarity4:SetChecked(SW_Settings.Recycle.Rules[rule].Rarity[4])
    frame_recycle.cbRarity5:SetChecked(SW_Settings.Recycle.Rules[rule].Rarity[5])
                                                
    frame_recycle.slLevel:SetPosition(SW_Settings.Recycle.Rules[rule].LevelMax or 0)
    
    if SW_Settings.Recycle.Rules[rule].Martial == nil then SW_Settings.Recycle.Rules[rule].Martial = true end
    frame_recycle.cbMartial:SetChecked(SW_Settings.Recycle.Rules[rule].Martial)
    if SW_Settings.Recycle.Rules[rule].Mystical == nil then SW_Settings.Recycle.Rules[rule].Mystical = true end
    frame_recycle.cbMystical:SetChecked(SW_Settings.Recycle.Rules[rule].Mystical)
    
    frame_recycle.txtSaveRule:SetText(rule)

end  

frame_recycle.btnDelete = UI.CreateFrame("RiftButton", "btnDelete", frame_recycle)
frame_recycle.btnDelete:SetText("DELETE")
frame_recycle.btnDelete:SetPoint("BOTTOMLEFT", frame_recycle.btnSaveRule, "BOTTOMRIGHT", 14,0)
frame_recycle.btnDelete:SetWidth(80)
function frame_recycle.btnDelete.Event:LeftPress()
    if frame_recycle.selRules:GetSelectedItem() ~= "" and SW_Settings.Recycle.Rules[frame_recycle.selRules:GetSelectedItem()] then
        SW_Settings.Recycle.Rules[frame_recycle.selRules:GetSelectedItem()] = nil
        SW_Rules[SW_Settings.name][frame_recycle.selRules:GetSelectedItem()] = nil
        StatWeights:updateRules()
    end
end


frame_recycle.lblLoadAltRule = UI.CreateFrame("Text", "lblLoadAltRule", frame_recycle)
frame_recycle.lblLoadAltRule:SetFontSize(16)
frame_recycle.lblLoadAltRule:SetText("Load Alt Rule: ")
frame_recycle.lblLoadAltRule:SetPoint("BOTTOMLEFT", frame_recycle.selRules, "BOTTOMRIGHT", 60, 2)

frame_recycle.selAltRules = UI.CreateFrame("SimpleSelect", "selAltRules", frame_recycle)
frame_recycle.selAltRules:SetPoint("BOTTOMLEFT", frame_recycle.lblLoadAltRule, "BOTTOMRIGHT", 10,-2)
function frame_recycle.selAltRules.Event:ItemSelect()
    
    local rule = frame_recycle.selAltRules:GetSelectedValue()
    
    local rTable = string.split(rule, "#.#.$.$")
    
    if not rTable and not rTable[2] then return end
    
    if not SW_Rules[rTable[1]][rTable[2]] then return end

    frame_recycle.cbElementAir:SetChecked(SW_Rules[rTable[1]][rTable[2]].Air)
    frame_recycle.cbElementDeath:SetChecked(SW_Rules[rTable[1]][rTable[2]].Death)
    frame_recycle.cbElementEarth:SetChecked(SW_Rules[rTable[1]][rTable[2]].Earth)
    frame_recycle.cbElementFire:SetChecked(SW_Rules[rTable[1]][rTable[2]].Fire) 
    frame_recycle.cbElementLife:SetChecked(SW_Rules[rTable[1]][rTable[2]].Life)
    frame_recycle.cbElementWater:SetChecked(SW_Rules[rTable[1]][rTable[2]].Water)   

    frame_recycle.cbDexterity:SetChecked(SW_Rules[rTable[1]][rTable[2]].Dexterity)
    frame_recycle.cbIntelligence:SetChecked(SW_Rules[rTable[1]][rTable[2]].Intelligence)
    frame_recycle.cbStrength:SetChecked(SW_Rules[rTable[1]][rTable[2]].Strength)
    frame_recycle.cbWisdom:SetChecked(SW_Rules[rTable[1]][rTable[2]].Wisdom)
    frame_recycle.cbAttackPower:SetChecked(SW_Rules[rTable[1]][rTable[2]].AttackPower)
    frame_recycle.cbSpellPower:SetChecked(SW_Rules[rTable[1]][rTable[2]].SpellPower)
    frame_recycle.cbPhysCrit:SetChecked(SW_Rules[rTable[1]][rTable[2]].PhysCrit)
    frame_recycle.cbSpellCrit:SetChecked(SW_Rules[rTable[1]][rTable[2]].SpellCrit)
    frame_recycle.cbCritPower:SetChecked(SW_Rules[rTable[1]][rTable[2]].CritPower)
    frame_recycle.cbGuard:SetChecked(SW_Rules[rTable[1]][rTable[2]].Guard)
    frame_recycle.cbBlock:SetChecked(SW_Rules[rTable[1]][rTable[2]].Block)
    frame_recycle.cbDodge:SetChecked(SW_Rules[rTable[1]][rTable[2]].Dodge)
    frame_recycle.cbEndurance:SetChecked(SW_Rules[rTable[1]][rTable[2]].Endurance)
    frame_recycle.cbMaxHealth:SetChecked(SW_Rules[rTable[1]][rTable[2]].MaxHealth)

    frame_recycle.cbTier1:SetChecked(SW_Rules[rTable[1]][rTable[2]].Tier[1])
    frame_recycle.cbTier2:SetChecked(SW_Rules[rTable[1]][rTable[2]].Tier[2])
    frame_recycle.cbTier3:SetChecked(SW_Rules[rTable[1]][rTable[2]].Tier[3])
    frame_recycle.cbTier4:SetChecked(SW_Rules[rTable[1]][rTable[2]].Tier[4])
    frame_recycle.cbTier5:SetChecked(SW_Rules[rTable[1]][rTable[2]].Tier[5])
    frame_recycle.cbTier6:SetChecked(SW_Rules[rTable[1]][rTable[2]].Tier[6])

    frame_recycle.cbRarity1:SetChecked(SW_Rules[rTable[1]][rTable[2]].Rarity[1])
    frame_recycle.cbRarity2:SetChecked(SW_Rules[rTable[1]][rTable[2]].Rarity[2])
    frame_recycle.cbRarity3:SetChecked(SW_Rules[rTable[1]][rTable[2]].Rarity[3])
    frame_recycle.cbRarity4:SetChecked(SW_Rules[rTable[1]][rTable[2]].Rarity[4])
    frame_recycle.cbRarity5:SetChecked(SW_Rules[rTable[1]][rTable[2]].Rarity[5])
                                                
    frame_recycle.slLevel:SetPosition(SW_Rules[rTable[1]][rTable[2]].LevelMax or 0)
    
    if SW_Rules[rTable[1]][rTable[2]].Martial == nil then SW_Rules[rTable[1]][rTable[2]].Martial = true end
    frame_recycle.cbMartial:SetChecked(SW_Rules[rTable[1]][rTable[2]].Martial)
    if SW_Rules[rTable[1]][rTable[2]].Mystical == nil then SW_Rules[rTable[1]][rTable[2]].Mystical = true end
    frame_recycle.cbMystical:SetChecked(SW_Rules[rTable[1]][rTable[2]].Mystical)
    
    frame_recycle.txtSaveRule:SetText(rTable[2])
       
end

-- Recycle Confirm Dialog ----------------------------------------

rcyDialog.btnRecycle = UI.CreateFrame("RiftButton", "rcy_btnRecycle", rcyDialog)
rcyDialog.btnRecycle:SetText("Recycle")
rcyDialog.btnRecycle:SetPoint("TOPLEFT", rcyDialog, "TOPLEFT", 40, 140)
function rcyDialog.btnRecycle.Event:LeftPress()
    rcyDialog:SetVisible(false)
    Command.Fragment.Recycle(fragments.toRecycle)
    fragments.toRecycle = {}
end


rcyDialog.btnCancel = UI.CreateFrame("RiftButton", "rcy_btnCancel", rcyDialog)
rcyDialog.btnCancel:SetText("Cancel")
rcyDialog.btnCancel:SetPoint("TOPLEFT", rcyDialog, "TOPLEFT", 190, 140)
function rcyDialog.btnCancel.Event:LeftPress()
    rcyDialog:SetVisible(false)
    fragments.toRecycle = {}
end

rcyDialog.lblCount =  UI.CreateFrame("Text", "rcy_lblCount", rcyDialog)
rcyDialog.lblCount:SetFontSize(20)
rcyDialog.lblCount:SetText("No Fragments Meet Criteria")
rcyDialog.lblCount:SetPoint("TOPLEFT", rcyDialog, "TOPLEFT", 50, 70)


-------------------------------------------------------------
---- end UI  ------------------------------------------------
-------------------------------------------------------------


local function showConfigWindow()
    StatWeights:updateFragmentWeightList()
    window:SetVisible(true)
end


function StatWeights:toggleConfigWindow()
    StatWeights:updateFragmentWeightList()
    window:SetVisible(not window:GetVisible())
end


local function initCalling()
    
    if SW_Settings then
       if SW_Settings.calling and SW_Settings.name then
            return
        end
    end
    
    local player = Inspect.Unit.Detail("player")
    
    if player.availability == "full" then
        SW_Settings = SW_Settings or {}
        SW_Settings["calling"] = player.calling
        SW_Settings["name"] = player.name


        if player.calling == "warrior" then
            SW_Settings["OffStat"] = "dexterity"
            SW_Settings["OffStatLabel"] = "Dexterity"
            SW_Settings["MainStat"] = "strength"
            SW_Settings["MainStatLabel"] = "Strength"
            SW_Settings["Power"] = "powerAttack"
            SW_Settings["PowerLabel"] = "Attack Power"
            SW_Settings["Crit"] = "critAttack"
            SW_Settings["CritLabel"] = "Phys Crit"
        elseif player.calling == "cleric" then
            SW_Settings["OffStat"] = "intelligence"
            SW_Settings["OffStatLabel"] = "Intelligence"
            SW_Settings["MainStat"] = "wisdom"
            SW_Settings["MainStatLabel"] = "Wisdom"
            SW_Settings["Power"] = "powerSpell"
            SW_Settings["PowerLabel"] = "Spell Power"
            SW_Settings["Crit"] = "critSpell"
            SW_Settings["CritLabel"] = "Spell Crit"  
        elseif player.calling == "mage" then
            SW_Settings["MainStat"] = "intelligence"
            SW_Settings["MainStatLabel"] = "Intelligence"
            SW_Settings["OffStat"] = "wisdom"
            SW_Settings["OffStatLabel"] = "Wisdom"
            SW_Settings["Power"] = "powerSpell"
            SW_Settings["PowerLabel"] = "Spell Power"
            SW_Settings["Crit"] = "critSpell"
            SW_Settings["CritLabel"] = "Spell Crit"      
        else
            SW_Settings["MainStat"] = "dexterity"
            SW_Settings["MainStatLabel"] = "Dexterity"
            SW_Settings["OffStat"] = "strength"
            SW_Settings["OffStatLabel"] = "Strength"
            SW_Settings["Power"] = "powerAttack"
            SW_Settings["PowerLabel"] = "Attack Power"
            SW_Settings["Crit"] = "critAttack"
            SW_Settings["CritLabel"] = "Phys Crit"           
        end
    end   
    
end

local function setCallingText()
    
    if textSet then
        return
    end

    if SW_Settings then
        if SW_Settings.calling then
            frame_debug.lblMainStat:SetText(SW_Settings.MainStatLabel)    
            frame_debug.lblOffStat:SetText(SW_Settings.OffStatLabel)
            frame_debug.lblPower:SetText(SW_Settings.PowerLabel)    
            frame_debug.lblCrit:SetText(SW_Settings.CritLabel)
            frame_debug.statgrid:Layout()

            frame_weights.lblMainStat:SetText(SW_Settings.MainStatLabel)    
            frame_weights.lblOffStat:SetText(SW_Settings.OffStatLabel)
            frame_weights.lblPower:SetText(SW_Settings.PowerLabel)    
            frame_weights.lblCrit:SetText(SW_Settings.CritLabel)
            frame_weights.statgrid:Layout()

            StatWeights:updateStats()   
            
            textSet = true
        end
    end

end
    
function StatWeights:updateRoles()
        
    StatWeights.RoleList = StatWeights:getRoles()
    local tempRoles = StatWeights:getRoles()   
    local ValueList = {}
        
    for i = 1, #tempRoles do
       ValueList[i] = i     
    end
        
    if SW_SavedWeights.DPS then
        ValueList[#ValueList + 1] = "DPS" 
        tempRoles[#tempRoles + 1] = "DPS Default"
    end
    if SW_SavedWeights.Heal then
        ValueList[#ValueList + 1] = "Heal" 
        tempRoles[#tempRoles + 1] = "Heal Default"
    end
    if SW_SavedWeights.Tank then
        ValueList[#ValueList + 1] = "Tank" 
        tempRoles[#tempRoles + 1] = "Tank Default"
    end

    frame_weights.selRoles:SetItems(tempRoles, ValueList)
    frame_weights.selRoles:ResizeToFit()
        
    frame_weights.selCopy:SetItems(tempRoles, ValueList)
    frame_weights.selCopy:ResizeToFit()
        
    StatWeights:checkRoleStats() 
        
end
    
function StatWeights:updateRules()
    
    local ruleList = {}
        
    for k in pairs(SW_Settings.Recycle.Rules) do
        ruleList[#ruleList+1] =  k    
    end
        
    frame_recycle.selRules:SetItems(ruleList)
    frame_recycle.selRules:ResizeToFit()
        
end
    
function StatWeights:updateAltRules()
        
    local ruleList = {}
    local valList = {}
        
    for alt in pairs(SW_Rules) do
        if alt == SW_Settings.name then -- not an alt
                
        else            
            for rule in pairs(SW_Rules[alt]) do
                ruleList[#ruleList+1] = alt .. " -- " .. rule
                valList[#valList+1] =  alt .. "#.#.$.$" .. rule
            end
        end
    end
    
    frame_recycle.selAltRules:SetItems(ruleList, valList)
    frame_recycle.selAltRules:ResizeToFit()
end

function StatWeights:checkRoleStats()
    
    for i = 1, #StatWeights.RoleList do
        if not SW_SavedWeights[i] then   -- defaults
            SW_SavedWeights[i] = {}
        end
        
            SW_SavedWeights[i][SW_Settings.MainStat] = SW_SavedWeights[i][SW_Settings.MainStat] or 1
            SW_SavedWeights[i][SW_Settings.OffStat] = SW_SavedWeights[i][SW_Settings.OffStat] or 0.5
            SW_SavedWeights[i][SW_Settings.Power] = SW_SavedWeights[i][SW_Settings.Power] or 1
            SW_SavedWeights[i][SW_Settings.Crit] = SW_SavedWeights[i][SW_Settings.Crit] or 0.4
            SW_SavedWeights[i]["critPower"] = SW_SavedWeights[i]["critPower"] or 0.8
            SW_SavedWeights[i]["endurance"] = SW_SavedWeights[i]["endurance"] or 0
            SW_SavedWeights[i]["WDPS"] = SW_SavedWeights[i]["WDPS"] or 0
            SW_SavedWeights[i]["guard"] = SW_SavedWeights[i]["guard"] or 0
            SW_SavedWeights[i]["block"] = SW_SavedWeights[i]["block"] or 0
            SW_SavedWeights[i]["dodge"] = SW_SavedWeights[i]["dodge"] or 0
            SW_SavedWeights[i]["maxHealth"] = SW_SavedWeights[i]["maxHealth"] or 0
    
    end
 
    if not SW_SavedWeights.DPS then   -- default DPS
        SW_SavedWeights.DPS = {}      
        SW_SavedWeights.DPS[SW_Settings.MainStat] = 1
        SW_SavedWeights.DPS[SW_Settings.OffStat] = 0.5
        SW_SavedWeights.DPS[SW_Settings.Power] = 1
        SW_SavedWeights.DPS[SW_Settings.Crit] = 0.4
        SW_SavedWeights.DPS["critPower"] = 0.8
        SW_SavedWeights.DPS["endurance"] = 0
        SW_SavedWeights.DPS["WDPS"] = 0
        SW_SavedWeights.DPS["guard"] = 0
        SW_SavedWeights.DPS["block"] = 0
        SW_SavedWeights.DPS["dodge"] = 0
        SW_SavedWeights.DPS["maxHealth"] = 0
    end    

    if not SW_SavedWeights.Heal then   -- default Heal
        SW_SavedWeights.Heal = {}      
        SW_SavedWeights.Heal[SW_Settings.MainStat] = 1
        SW_SavedWeights.Heal[SW_Settings.OffStat] = 0.5
        SW_SavedWeights.Heal[SW_Settings.Power] = 1
        SW_SavedWeights.Heal[SW_Settings.Crit] = 0.4
        SW_SavedWeights.Heal["critPower"] = 0.8
        SW_SavedWeights.Heal["endurance"] = 0
        SW_SavedWeights.Heal["WDPS"] = 0
        SW_SavedWeights.Heal["guard"] = 0
        SW_SavedWeights.Heal["block"] = 0
        SW_SavedWeights.Heal["dodge"] = 0
        SW_SavedWeights.Heal["maxHealth"] = 0
    end      
    
    if not SW_SavedWeights.Tank then   -- default Tank
        SW_SavedWeights.Tank = {}      
        SW_SavedWeights.Tank[SW_Settings.MainStat] = 0.7
        SW_SavedWeights.Tank[SW_Settings.OffStat] = 0
        SW_SavedWeights.Tank[SW_Settings.Power] = 0
        SW_SavedWeights.Tank[SW_Settings.Crit] = 0
        SW_SavedWeights.Tank["critPower"] = 0
        SW_SavedWeights.Tank["endurance"] = 0.9
        SW_SavedWeights.Tank["WDPS"] = 0
        SW_SavedWeights.Tank["guard"] = 1
        SW_SavedWeights.Tank["block"] = 0.3
        SW_SavedWeights.Tank["dodge"] = 0.25
        SW_SavedWeights.Tank["maxHealth"] = 0.085
    end  
end


function StatWeights:updateStats()
    if SW_Settings.MainStat and Inspect.Stat(SW_Settings.MainStat) then
        frame_debug.txtMainStat:SetText(Inspect.Stat(SW_Settings.MainStat).." ")
        frame_debug.txtOffStat:SetText(Inspect.Stat(SW_Settings.OffStat).." ")
        frame_debug.txtEnd:SetText(Inspect.Stat("endurance").." ")
        frame_debug.txtPower:SetText(Inspect.Stat(SW_Settings.Power).." ")
        frame_debug.txtCrit:SetText(Inspect.Stat(SW_Settings.Crit).." ")
        frame_debug.txtCritPower:SetText(Inspect.Stat("critPower").." ")
        
        frame_debug.txtMainStatUB:SetText(Inspect.Stat(SW_Settings.MainStat .. "Unbuffed").." ")
        frame_debug.txtOffStatUB:SetText(Inspect.Stat(SW_Settings.OffStat .. "Unbuffed").." ")
        frame_debug.txtEndUB:SetText(Inspect.Stat("enduranceUnbuffed").." ")
        frame_debug.txtPowerUB:SetText(Inspect.Stat(SW_Settings.Power .. "Unbuffed").." ")
        frame_debug.txtCritUB:SetText(Inspect.Stat(SW_Settings.Crit .. "Unbuffed").." ")
        frame_debug.txtCritPowerUB:SetText(Inspect.Stat("critPowerUnbuffed").." ")
        
        
        local tempEQ, tempRune = Utilities:EquipmentStats()
        frame_debug.txtMainStatEQ:SetText((tempEQ[SW_Settings.MainStat] or 0) .." ")
        frame_debug.txtOffStatEQ:SetText((tempEQ[SW_Settings.OffStat] or 0) .." ")
        frame_debug.txtEndEQ:SetText((tempEQ["endurance"] or 0) .." ")
        frame_debug.txtPowerEQ:SetText((tempEQ[SW_Settings.Power] or 0) .." ")
        frame_debug.txtCritEQ:SetText((tempEQ[SW_Settings.Crit] or 0) .." ")
        frame_debug.txtCritPowerEQ:SetText((tempEQ["critPower"] or 0) .." ")
        
        frame_debug.txtMainStatRune:SetText((tempRune[SW_Settings.MainStat] or 0) .." ")
        frame_debug.txtOffStatRune:SetText((tempRune[SW_Settings.OffStat] or 0) .." ")
        frame_debug.txtEndRune:SetText((tempRune["endurance"] or 0) .." ")
        frame_debug.txtPowerRune:SetText((tempRune[SW_Settings.Power] or 0) .." ")
        frame_debug.txtCritRune:SetText((tempRune[SW_Settings.Crit] or 0) .." ")
        frame_debug.txtCritPowerRune:SetText((tempRune["critPower"] or 0) .." ")
        
        frame_debug.txtMainStatBonus:SetText(string.format("%.3f",Utilities:GuessBonus(SW_Settings.MainStat)))
        frame_debug.txtPowerBonus:SetText(string.format("%.3f",Utilities:GuessPowerBonus(SW_Settings.calling)))
        
        
        --weapon dps calc
        local wslot = Utility.Item.Slot.Equipment("handmain")
        local wdetail = Inspect.Item.Detail(wslot)
        if wdetail and wdetail.damageMin then
           local WDPS = (wdetail.damageMin + wdetail.damageMax)/(2*wdetail.damageDelay) 
            frame_debug.txtWDPS:SetText(string.format("%.1f", WDPS))
        else 
            frame_debug.txtWDPS:SetText("0")
        end
        ---determine if there's an offhand for wdps calc
        local wmult = 5
        wslot = Utility.Item.Slot.Equipment("handoff")
        wdetail = Inspect.Item.Detail(wslot)
        if wdetail then
            wmult = 6.5
        end
        frame_debug.txtWDPSMult:SetText(string.format("%.1f", wmult))
        
    end
end

function StatWeights:updateWeights(name, weight)
   
    if SW_SavedWeights[SW_Settings.Role] and tonumber(weight) then
        if SW_SavedWeights[SW_Settings.Role][name] then
            SW_SavedWeights[SW_Settings.Role][name] = tonumber(weight) 
        end
        
        StatWeights:updateFragmentWeightList()
        
    end
    
end

local function varsLoaded()   
    StatWeights:doSettings(1) 
    Command.Event.Detach(Event.Addon.SavedVariables.Load.End, varsLoaded)
end

local function charLoaded()
    StatWeights:doSettings(2) 
    Command.Event.Detach(Event.Unit.Availability.Full, charLoaded) 
end

function StatWeights:doSettings(xLoaded)
    
    if xLoaded == 1 then
        vLoaded = true
       -- print("Load Vars")
    elseif xLoaded == 2 then
        pLoaded = true
      --  print("Char Load")
    end
    
    if (vLoaded and pLoaded) then   -- vars and player ready
   
        initCalling()
        setCallingText()
        StatWeights:updateRoles()
        StatWeights:updateAltRules()
        
        SW_Settings.Role = SW_Settings.Role or 1
        frame_weights.selRoles:SetSelectedValue(SW_Settings.Role)
        
        SW_Rules[SW_Settings.name] = SW_Rules[SW_Settings.name] or {} 

        if SW_Settings.ShowWeight == nil then SW_Settings.ShowWeight = true end 
        SW_Settings.ShowAffinity = SW_Settings.ShowAffinity or false
        if SW_Settings.ShowBest == nil then SW_Settings.ShowBest = true end
        if SW_Settings.ShowUpgrade == nil then SW_Settings.ShowUpgrade = true end
        if SW_Settings.ShowEquipped == nil then SW_Settings.ShowEquipped = true end
        if SW_Settings.ShowTier == nil then SW_Settings.ShowTier = true end
        if SW_Settings.ShowRelativeWeight == nil then SW_Settings.ShowRelativeWeight = true end
        if SW_Settings.ShowButton == nil then SW_Settings.ShowButton = true end
        SW_Settings.LockButton = SW_Settings.LockButton or false
        if SW_Settings.ButtonRClick == nil then SW_Settings.ButtonRClick = true end
        
        SW_Settings.Recycle = SW_Settings.Recycle or {}
        SW_Settings.Recycle.Air = SW_Settings.Recycle.Air or false
        SW_Settings.Recycle.Death = SW_Settings.Recycle.Death or false
        SW_Settings.Recycle.Earth = SW_Settings.Recycle.Earth or false
        SW_Settings.Recycle.Fire = SW_Settings.Recycle.Fire or false
        SW_Settings.Recycle.Life = SW_Settings.Recycle.Life or false
        SW_Settings.Recycle.Water = SW_Settings.Recycle.Water or false

        SW_Settings.Recycle.Dexterity = SW_Settings.Recycle.Dexterity or false
        SW_Settings.Recycle.Intelligence = SW_Settings.Recycle.Intelligence or false
        SW_Settings.Recycle.Strength = SW_Settings.Recycle.Strength or false
        SW_Settings.Recycle.Wisdom = SW_Settings.Recycle.Wisdom or false
        SW_Settings.Recycle.AttackPower = SW_Settings.Recycle.AttackPower or false
        SW_Settings.Recycle.SpellPower = SW_Settings.Recycle.SpellPower or false
        SW_Settings.Recycle.PhysCrit = SW_Settings.Recycle.PhysCrit or false
        SW_Settings.Recycle.SpellCrit = SW_Settings.Recycle.SpellCrit or false
        SW_Settings.Recycle.Guard = SW_Settings.Recycle.Guard or false
        SW_Settings.Recycle.Block = SW_Settings.Recycle.Block or false
        SW_Settings.Recycle.Dodge = SW_Settings.Recycle.Dodge or false
        SW_Settings.Recycle.CritPower = SW_Settings.Recycle.CritPower or false
        SW_Settings.Recycle.Endurance = SW_Settings.Recycle.Endurance or false
        SW_Settings.Recycle.MaxHealth = SW_Settings.Recycle.MaxHealth or false
        
        if SW_Settings.Recycle.ShowConfirm == nil then SW_Settings.Recycle.ShowConfirm = true end 
        SW_Settings.Recycle.AllRules = SW_Settings.Recycle.AllRules or false
        
        SW_Settings.Recycle.LevelMin = SW_Settings.Recycle.LevelMin or 0
        SW_Settings.Recycle.LevelMax = SW_Settings.Recycle.levelMax or 0

        if SW_Settings.Martial == nil then SW_Settings.Martial = true end
        if SW_Settings.Mystical == nil then SW_Settings.Mystical = true end
        
        SW_Settings.Recycle.Tier = SW_Settings.Recycle.Tier or {}
        for i = 1, 6 do
            SW_Settings.Recycle.Tier[i] = SW_Settings.Recycle.Tier[i] or false
        end
        
        SW_Settings.Recycle.Rarity = SW_Settings.Recycle.Rarity or {}
        for i = 1, 6 do -- 6 = red, 2 = white
            SW_Settings.Recycle.Rarity[i] = SW_Settings.Recycle.Rarity[i] or false
        end
        
        SW_Settings.Recycle.Rules = SW_Settings.Recycle.Rules or {} 
        
        frame_settings.cbWeight:SetChecked(SW_Settings.ShowWeight)
        frame_settings.cbAffinity:SetChecked(SW_Settings.ShowAffinity)
        frame_settings.cbBest:SetChecked(SW_Settings.ShowBest)
        frame_settings.cbUpgrade:SetChecked(SW_Settings.ShowUpgrade)
        frame_settings.cbWeightTier:SetChecked(SW_Settings.ShowTier)
        frame_settings.cbRelWeight:SetChecked(SW_Settings.ShowRelativeWeight)
        frame_settings.cbRecycleAllRules:SetChecked(SW_Settings.Recycle.AllRules)
        frame_settings.cbRecycleShowConfirm:SetChecked(SW_Settings.Recycle.ShowConfirm)
        frame_settings.cbShowButton:SetChecked(SW_Settings.ShowButton)
        frame_settings.cbLockButton:SetChecked(SW_Settings.LockButton)
        frame_settings.cbButtonRClick:SetChecked(SW_Settings.ButtonRClick)
        
        frame_recycle.cbElementAir:SetChecked(SW_Settings.Recycle.Air)
        frame_recycle.cbElementDeath:SetChecked(SW_Settings.Recycle.Death)
        frame_recycle.cbElementEarth:SetChecked(SW_Settings.Recycle.Earth)
        frame_recycle.cbElementFire:SetChecked(SW_Settings.Recycle.Fire)    
        frame_recycle.cbElementLife:SetChecked(SW_Settings.Recycle.Life)
        frame_recycle.cbElementWater:SetChecked(SW_Settings.Recycle.Water)
        
        frame_recycle.cbDexterity:SetChecked(SW_Settings.Recycle.Dexterity)
        frame_recycle.cbIntelligence:SetChecked(SW_Settings.Recycle.Intelligence)
        frame_recycle.cbStrength:SetChecked(SW_Settings.Recycle.Strength)
        frame_recycle.cbWisdom:SetChecked(SW_Settings.Recycle.Wisdom)
        frame_recycle.cbAttackPower:SetChecked(SW_Settings.Recycle.AttackPower)
        frame_recycle.cbSpellPower:SetChecked(SW_Settings.Recycle.SpellPower)
        frame_recycle.cbPhysCrit:SetChecked(SW_Settings.Recycle.PhysCrit)
        frame_recycle.cbSpellCrit:SetChecked(SW_Settings.Recycle.SpellCrit)
        frame_recycle.cbCritPower:SetChecked(SW_Settings.Recycle.CritPower)
        frame_recycle.cbGuard:SetChecked(SW_Settings.Recycle.Guard)
        frame_recycle.cbBlock:SetChecked(SW_Settings.Recycle.Block)
        frame_recycle.cbDodge:SetChecked(SW_Settings.Recycle.Dodge)
        frame_recycle.cbEndurance:SetChecked(SW_Settings.Recycle.Endurance)
        frame_recycle.cbMaxHealth:SetChecked(SW_Settings.Recycle.MaxHealth)
        
        frame_recycle.cbTier1:SetChecked(SW_Settings.Recycle.Tier[1])
        frame_recycle.cbTier2:SetChecked(SW_Settings.Recycle.Tier[2])
        frame_recycle.cbTier3:SetChecked(SW_Settings.Recycle.Tier[3])
        frame_recycle.cbTier4:SetChecked(SW_Settings.Recycle.Tier[4])
        frame_recycle.cbTier5:SetChecked(SW_Settings.Recycle.Tier[5])
        frame_recycle.cbTier6:SetChecked(SW_Settings.Recycle.Tier[6])
        
        frame_recycle.cbRarity1:SetChecked(SW_Settings.Recycle.Rarity[2])
        frame_recycle.cbRarity2:SetChecked(SW_Settings.Recycle.Rarity[3])
        frame_recycle.cbRarity3:SetChecked(SW_Settings.Recycle.Rarity[4])
        frame_recycle.cbRarity4:SetChecked(SW_Settings.Recycle.Rarity[5])
        frame_recycle.cbRarity5:SetChecked(SW_Settings.Recycle.Rarity[6])
        
        frame_recycle.slLevel:SetPosition(SW_Settings.Recycle.LevelMax)
        
        frame_recycle.cbMartial:SetChecked(SW_Settings.Recycle.Martial or true)
        frame_recycle.cbMystical:SetChecked(SW_Settings.Recycle.Mystical or true)
        
        StatWeights:updateRules()
        StatWeights:setButton()

        Command.Event.Attach(Event.TEMPORARY.Role, function(_, role) frame_weights.selRoles:SetSelectedIndex(role) end , "Role Change")
        
        print("StatWeights loaded.  Use /sw to open the settings window")
    end
        

    
end

function StatWeights:checkRole(_,role)
    --print(role.. " " .. type(role))
    frame_weights.selRoles:SetSelectedIndex(role)
    
    
end

local function toggleDebug()
   
    if StatWeights.SW_debug then 
        StatWeights.SW_debug = false
        print("StatWeights debug mode OFF")
        tabs:RemoveTab(4)
        Command.Event.Detach(Event.Stat, function() StatWeights:updateStats() end, "Update Stats")
    else
        StatWeights.SW_debug = true
        print("StatWeights debug mode ON")   
        tabs:AddTab("Debug", frame_debug)
        Command.Event.Attach(Event.Stat, function() StatWeights:updateStats() end, "Update Stats")
        StatWeights:updateStats()
    end
    
end

function StatWeights:updateFragmentWeightList()
    local tempResults = {}
    local tempStr = ""
    local tempStr2 = ""

    
    tempResults = StatWeights:calcFragWeights("air")
    tempStr =  tempStr .. "Air Fragments:\n"
    tempStr = tempStr .. StatWeights:printFragWeights(tempResults, 4)


    tempResults = StatWeights:calcFragWeights("death")
    tempStr =  tempStr .. "\n\nDeath Fragments:\n"
    tempStr = tempStr .. StatWeights:printFragWeights(tempResults, 4)    
    
    
    tempResults = StatWeights:calcFragWeights("earth")
    tempStr =  tempStr .. "\n\nEarth Fragments:\n"
    tempStr = tempStr .. StatWeights:printFragWeights(tempResults, 4)
    
    
    tempResults = StatWeights:calcFragWeights("fire")
    tempStr2 =  tempStr2 .. "Fire Fragments:\n"
    tempStr2 = tempStr2 .. StatWeights:printFragWeights(tempResults, 4)  
    
    
    tempResults = StatWeights:calcFragWeights("life")
    tempStr2 =  tempStr2 .. "\n\nLife Fragments:\n"
    tempStr2 = tempStr2 .. StatWeights:printFragWeights(tempResults, 4)
    
    
    tempResults = StatWeights:calcFragWeights("water")
    tempStr2 =  tempStr2 .. "\n\nWater Fragments:\n"
    tempStr2 = tempStr2 .. StatWeights:printFragWeights(tempResults, 4)
    
    tempResults = StatWeights:calcSecondaryWeights()
    tempStr2 =  tempStr2 .. "\n\nSecondaries:\n"
    tempStr2 = tempStr2 .. StatWeights:printSecondaryWeights(tempResults, 5)
    
    frame_weights.lblAir:SetText(tempStr) 
    frame_weights.fraggrid:RemoveAllRows()
    frame_weights.fraggrid:AddRow({frame_weights.lblAir}) 
    frame_weights.fraggrid:Layout()
    
    frame_weights.lblFire:SetText(tempStr2) 
    frame_weights.fraggrid2:RemoveAllRows()
    frame_weights.fraggrid2:AddRow({frame_weights.lblFire}) 
    frame_weights.fraggrid2:Layout()    
    
end

local function printFrags(stats)
    
    fragments:printFragments(stats)
    
end

init()

table.insert(Command.Slash.Register("sw"), {showConfigWindow, "StatWeights", "Slash command"})
table.insert(Command.Slash.Register("statweights"), {showConfigWindow, "StatWeights", "Slash command"})
table.insert(Command.Slash.Register("swdebug"), {toggleDebug, "StatWeights", "Slash command"})
table.insert(Command.Slash.Register("printfrags"), {printFrags, "StatWeights", "Slash command"})
table.insert(Command.Slash.Register("pf"), {printFrags, "StatWeights", "Slash command"})
Command.Event.Attach(Event.Addon.SavedVariables.Load.End, varsLoaded, "Loaded Variable Settings")
Command.Event.Attach(Event.Unit.Availability.Full, charLoaded, "Loaded Player Settings")

