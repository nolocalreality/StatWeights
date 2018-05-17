local addon, StatWeights = ...

--- mostly borrowed from Gadgets (wtGadgetButton.lua)

local btnSW = UI.CreateFrame("Texture", "btnSW", StatWeights.context)
local img = "UI/btn_reset_"
btnSW:SetTexture(addon.identifier, img .. "(normal).png")


local btnDragging = false
local btnStartX = 0
local btnStartY = 0
local btnMouseStartX = 0
local btnMouseStartY = 0
local btnDragged = false

local function btnDragStart()
	
	local mouse = Inspect.Mouse()
	btnDragging = true
	btnStartX = btnSW:GetLeft()
	btnStartY = btnSW:GetTop()
	btnMouseStartX = mouse.x
	btnMouseStartY = mouse.y
	btnDragged = false	
    
end

local draggedEnough = false
local function btnDragMove()
    
	if btnDragging then
		local mouse = Inspect.Mouse()

		if not draggedEnough then
			local deltaX = math.abs(mouse.x - btnMouseStartX)
			local deltaY = math.abs(mouse.y - btnMouseStartY)
			if deltaX > 8 or deltaY > 8 then
				draggedEnough = true
			end
		end

		if not draggedEnough then return end
        
        btnDragged = true
        
        if SW_Settings.LockButton then return end

		local x = mouse.x - btnMouseStartX + btnStartX
		local y = mouse.y - btnMouseStartY + btnStartY
		btnSW:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x, y)
		SW_Settings.btnX = x
		SW_Settings.btnY = y
			
	end
end

local function btnDragStop()
	btnDragging = false
	draggedEnough = false
	-- try to detect a left click instead of a drag
	if not btnDragged then
		StatWeights:toggleConfigWindow()
	end
end

local function btnRecycle()  
    if SW_Settings.ButtonRClick then
        StatWeights:fragRecycle()
    end
end

local function btnMouseIn()
    btnSW:SetTexture(addon.identifier, img .. "(over).png")
end

local function btnMouseOut()
    btnSW:SetTexture(addon.identifier, img .. "(normal).png")
end


btnSW:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h) btnDragStart() end, "Event.UI.Input.Mouse.Left.Down")

btnSW:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function(self, h) btnDragMove() end, "Event.UI.Input.Mouse.Cursor.Move")

btnSW:EventAttach(Event.UI.Input.Mouse.Left.Up, function(self, h) btnDragStop() end, "Event.UI.Input.Mouse.Left.Up")

btnSW:EventAttach(Event.UI.Input.Mouse.Left.Upoutside, function(self, h) btnDragStop() end, "Event.UI.Input.Mouse.Left.Upoutside")

btnSW:EventAttach(Event.UI.Input.Mouse.Right.Click, function(self, h) btnRecycle() end, "Event.UI.Input.Mouse.Right.Click")

btnSW:EventAttach(Event.UI.Input.Mouse.Cursor.In, function(self, h) btnMouseIn() end, "Event.UI.Input.Mouse.Cursor.In")

btnSW:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function(self, h) btnMouseOut() end, "Event.UI.Input.Mouse.Cursor.Out")


function StatWeights:ResetButton()
	btnSW:ClearPoint("LEFT")
	btnSW:ClearPoint("TOP")
	btnSW:SetPoint("CENTER", UIParent, "CENTER")
end

function StatWeights:ToggleButton(show)
   btnSW:SetVisible(show) 
end


function StatWeights:setButton()
    if SW_Settings.btnX and SW_Settings.btnY then
        btnSW:SetPoint("TOPLEFT", UIParent, "TOPLEFT", SW_Settings.btnX, SW_Settings.btnY)
    else
        btnSW:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 300, 300)
    end   
    btnSW:SetVisible(SW_Settings.ShowButton)
end




