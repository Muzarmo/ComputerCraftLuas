if not peripheral then peripheral = {} end
if not colors then colors = {} end

local barHeight = 14
local barX = 44
local barY = 3
local reactor = peripheral.wrap("back")
local monitor = peripheral.wrap("top")

local function drawVerticalBar(percent)
    local filled = math.floor((percent / 100) * barHeight)
    monitor.setCursorPos(barX, barY-1)
    monitor.write("+-+")
    for i = 1, barHeight do
    monitor.setCursorPos(barX, barY + (barHeight-i))
        if i <= filled then
            -- monitor.write("█")
            monitor.setBackgroundColor(colors.black)
            monitor.write("|")
            monitor.setBackgroundColor(colors.purple)
            monitor.write(" ")
            monitor.setBackgroundColor(colors.black)
            monitor.write("|")
        else
            monitor.setBackgroundColor(colors.black)
            monitor.write("| |")
        end
    end
    monitor.setCursorPos(barX, barY+barHeight)
    monitor.write("+-+")
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

