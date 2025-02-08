-- Minecraft Big Reactors Reactor
-- Lowers control rods to the current reactor energy buffer level. Simple control mechanism.

local reactor
reactor = peripheral.wrap("back")

while true do
    storedenergy = reactor.getEnergyStored()
    percentenergy = math.ceil(storedenergy / 100000)

    print("Reactor has " .. storedenergy .. " RF")
    print("That is " .. percentenergy.. " % of total capacity")
    rodlevel = 100
    lastlevel = 100

    if percentenergy < 5 then
        reactor.setAllControlRodLevels(0)
        print("Energy level low, retracting control rods!")
        sleep(2)
    elseif percentenergy >= 5 and percentenergy < 95 then
        print("Normal operation. Control rods at energy level")
        reactor.setAllControlRodLevels(percentenergy)
        sleep(5)
    elseif percentenergy >= 96 then
        reactor.setAllControlRodLevels(100)
        print("Energy level high. Control rods fully inserted")
        sleep(20)
    else
        print("No change in control rods")
        sleep(5)
    end



end
