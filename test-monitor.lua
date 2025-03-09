local barHeight = 10
local textX = 1
local barX = 45
local barY = 2
local reactor = peripheral.wrap("back")
local monitor = peripheral.wrap("top")

local function drawVerticalBar(percent)
    local filled = math.floor((percent / 100) * barHeight)

    for i = 1, barHeight do
    monitor.setCursorPos(barX, barY + (barHeight-i))
        if i <= filled then
            -- monitor.write("█")
            monitor.setBackgroundColor(colors.purple)
            monitor.write(" ")
        else
            monitor.setBackgroundColor(colors.black)
            monitor.write(" ")
        end
    end
end


local storedenergy = reactor.getEnergyStored()
local percentenergy = math.ceil(storedenergy / 100000)

drawVerticalBar(percentenergy)




-- w, h = term.getSize()
--
-- print("Height " .. h)
-- print("Width " .. w)
--
-- -- detta ger storlek på den "vanliga" terminalen?
--
-- local monitor = peripheral.wrap("top")
--
-- local monw, monh = monitor.getSize()
--
-- print("Monitor height: " .. monh)
-- print("Monitor width: " .. monw)

