-- Minecraft Big Reactors Reactor
-- Base idea is to lower control rods to the current reactor energy buffer level as way of a simple control mechanism.
-- Being expanded upon since then

local function calcTrend(energylevels, leveldiff)
    table.remove(energylevels, 1)
    table.insert(energylevels, leveldiff)

    local sum = 0

    for _, v in ipairs(energylevels) do
        sum = sum + v
    end

    return sum / #energylevels
end


local energylevels = {0, 0, 0, 0, 0}
local reactor = peripheral.wrap("back")
local storedenergy = reactor.getEnergyStored()
local percentenergy = math.ceil(storedenergy / 100000)
local newlevel = percentenergy
local lastlevel = percentenergy
local trendvalue = percentenergy

local highlevel = 85
local midlevel = 50

while true do
    storedenergy = reactor.getEnergyStored()
    percentenergy = math.ceil(storedenergy / 100000)
    newlevel = percentenergy

    leveldiff = newlevel - lastlevel
    trendvalue = calcTrend(energylevels, leveldiff)
    print("Trendvalue is " .. trendvalue)
    print("Reactor has " .. storedenergy .. " RF")
    print("That is " .. percentenergy .. " % of total capacity")
    print("Newlevel is " .. newlevel)
    print("Lastlevel is " .. lastlevel)
    print("Leveldiff " .. leveldiff)

    if percentenergy <= midlevel then
        reactor.setAllControlRodLevels(0)
        print("Energy level below 50%. Control rods fully retracted")

    elseif leveldiff < -5 then
        reactor.setAllControlRodLevels(0)
        print("Energy level dropping quick. Control rods fully retracted")

    elseif trendvalue < -3 then
        reactor.setAllControlRodLevels(0)
        print("Energy is trending downwards. Control rods fully retracted")

    elseif percentenergy > midlevel and percentenergy <= highlevel then
        print("Normal operation. Control rods at energy level")
        reactor.setAllControlRodLevels(percentenergy)

    elseif percentenergy > highlevel then
        reactor.setAllControlRodLevels(100)
        print("Energy level high. Control rods fully inserted")
        sleep(10)

    else
        print("No change in control rods")

    end

    sleep(10)
    lastlevel = newlevel

    print()

end


-- rod change behöver egentligen ngn mer långsiktig variabel att rätta sig efter, typ trend i tid snarare än iteration av if-loopen
-- blivit lite förvirrad vad det var jag ville med trendvalue egentligen. jag tror att jag tänkte mig att ha ett trendvalue som jämförde diffen på level-values
-- - men det kanske är smartare att göra som chatgpt ville. eller på något annat sätt?
-- Nej, jag gör som jag ville och ser hur det faller ut.

