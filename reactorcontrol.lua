-- Minecraft Big Reactors Reactor
-- Base idea is to lower control rods to the current reactor energy buffer level as way of a simple control mechanism.
-- Being expanded upon since then

local reactor
reactor = peripheral.wrap("back")
storedenergy = reactor.getEnergyStored()
percentenergy = math.ceil(storedenergy / 100000)
local newlevel = percentenergy
local lastlevel = percentenergy

while true do
    storedenergy = reactor.getEnergyStored()
    percentenergy = math.ceil(storedenergy / 100000)
    newlevel = percentenergy

    print("Reactor has " .. storedenergy .. " RF")
    print("That is " .. percentenergy .. " % of total capacity")
    print("Newlevel is " .. newlevel)
    print("Lastlevel is " .. lastlevel)
    print("Newlevel - lastlevel is " .. (newlevel - lastlevel))

    if (newlevel - lastlevel) < -5 then
        reactor.setAllControlRodLevels(0)
        print("Energy level dropping quick, control rods fully retracted")

    elseif percentenergy <= 50 then
        reactor.setAllControlRodLevels(0)
        print("Energy level below 50%, control rods fully retracted")

    elseif percentenergy > 50 and percentenergy <= 90 then
        print("Normal operation. Control rods at energy level")
        reactor.setAllControlRodLevels(percentenergy)

    elseif percentenergy > 90 then
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
-- kanske medel av fem senaste ändringarna? kan man göra det i en array som lägger till en och sparkar ut en? Funktion för det? 
