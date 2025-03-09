-- Minecraft Big Reactors Reactor
-- Base idea is to lower control rods to the current reactor energy buffer level as way of a simple control mechanism.
-- Being expanded upon since then

local energylevels = {0, 0, 0, 0, 0}
local reactor = peripheral.wrap("back")
local monitor = peripheral.wrap("top")
local storedenergy = reactor.getEnergyStored()
local percentenergy = math.ceil(storedenergy / 100000)
local newlevel = percentenergy
local lastlevel = percentenergy
local trendvalue = percentenergy

local highlevel = 85
local midlevel = 50

local barHeight = 14
local barX = 44
local barY = 3

local function calcTrend(energylevels, leveldiff)
    table.remove(energylevels, 1)
    table.insert(energylevels, leveldiff)

    local sum = 0

    for _, v in ipairs(energylevels) do
        sum = sum + v
    end

    return sum / #energylevels
end

local function drawVerticalBar(percent)
    local filled = math.floor((percent / 100) * barHeight)
    monitor.setCursorPos(barX, barY-1)
    monitor.write("+-+")
    for i = 1, barHeight do
        monitor.setCursorPos(barX, barY + (barHeight-i))
        if i <= filled then
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


while true do

    monitor.clear()
    monitor.setCursorPos(1,1)
    storedenergy = reactor.getEnergyStored()
    percentenergy = math.ceil(storedenergy / 100000)
    newlevel = percentenergy

    leveldiff = newlevel - lastlevel
    trendvalue = calcTrend(energylevels, leveldiff)
    print("Trendvalue is " .. trendvalue)
    print("Reactor buffer is " .. storedenergy .. " RF")
    print("That is " .. percentenergy .. " % of total capacity")
    print("Newlevel is " .. newlevel)
    print("Lastlevel is " .. lastlevel)
    print("Leveldiff " .. leveldiff)
    print("Leveldiff history:")

    for i, v in ipairs(energylevels) do
        print("[" .. i .. "] " .. v)
    end

    if percentenergy <= midlevel then
        reactor.setAllControlRodLevels(0)
        print("Energy level below 50%\nControl rods fully retracted")

    elseif leveldiff < -5 then
        reactor.setAllControlRodLevels(0)
        print("Energy level dropping quick.\nControl rods fully retracted")

    elseif trendvalue < -3 then
        reactor.setAllControlRodLevels(0)
        print("Energy is trending downwards.\nControl rods fully retracted")

    elseif percentenergy > midlevel and percentenergy <= highlevel then
        print("Normal operation.\nControl rods at energy level")
        reactor.setAllControlRodLevels(percentenergy)

    elseif percentenergy > highlevel then
        reactor.setAllControlRodLevels(100)
        print("Energy level high.\nControl rods fully inserted")

    else
        print("No change in control rods")

    end

    drawVerticalBar(percentenergy)

    sleep(10)
    lastlevel = newlevel

    print()

end
