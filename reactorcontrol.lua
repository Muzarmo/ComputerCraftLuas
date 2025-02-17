-- Minecraft Big Reactors Reactor
-- Base idea is to lower control rods to the current reactor energy buffer level as way of a simple control mechanism.
-- Being expanded upon since then

local reactor
reactor = peripheral.wrap("back")
local newlevel = 100
local lastlevel = 100

while true do
    storedenergy = reactor.getEnergyStored()
    percentenergy = math.ceil(storedenergy / 100000)

    print("Reactor has " .. storedenergy .. " RF")
    print("That is " .. percentenergy.. " % of total capacity")

    if (newlevel - lastlevel) < -5 then
        reactor.setAllControlRodLevels(0)
        print("Energy level dropping quick, control rods fully retracted")

    elseif percentenergy <= 50 then
        reactor.setAllControlRodLevels(0)
        print("Energy level below 50%, control rods fully retracted")
        sleep(2)
    elseif percentenergy > 50 and percentenergy <= 90 then
        print("Normal operation. Control rods at energy level")
        reactor.setAllControlRodLevels(percentenergy)
        sleep(5)
    elseif percentenergy > 90 then
        reactor.setAllControlRodLevels(100)
        print("Energy level high. Control rods fully inserted")
        sleep(20)
    else
        print("No change in control rods")
        sleep(5)
    end

    lastlevel = newlevel
    newlevel = percentenergy

    print()



end
