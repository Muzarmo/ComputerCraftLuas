-- For sending redstone pulses to a Mechanical user, setting fire to Bedrock to make infinity dust
-- Burning time seems to be 19-31 seconds, 80% lower than 29s
local pulseno = 1

while true do
    print("Starting redstone pulses every 28s")
    print()
    while true do
        print("Sending redstone pulse number ".. pulseno)
        rs.setAnalogOutput("back", 15)
        sleep(0.1)
        rs.setAnalogOutput("back", 0)
        pulseno = pulseno + 1
        sleep(28)
    end
end