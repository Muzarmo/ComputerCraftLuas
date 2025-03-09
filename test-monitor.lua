local barHeight = 10
local textX = 1
local barX = 10
local barY = 2

local function drawVerticalBar(percent)
    local filled = math.floor((percent / 100) * barHeight)

    for i = 1, barHeight do
    monitor.setCursorPos(barX, barY + (barHeight-i)
        if i <= filled then
            monitor.write("█")
        else
            monitor.write(" ")
        end
    end
end





w, h = term.getSize()

print("Height " .. h)
print("Width " .. w)

-- detta ger storlek på den "vanliga" terminalen?

local monitor = peripheral.wrap("top")

local monw, monh = monitor.getSize()

print("Monitor height: " .. monh)
print("Monitor width: " .. monw)

