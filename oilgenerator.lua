-- program for stopping Actually Additions Oil Generator when a Mekanism Energy Cube is full

local cube = peripheral.wrap("back")

while true do
  local cellEnergy = cube.getEnergy()
  local cellMaxEnergy = cube.getMaxEnergy()
  local percentEnergy = math.ceil((cellEnergy / cellMaxEnergy)*100)
  local rfEnergy = cellEnergy * 0.4
  local rfMaxEnergy = cellMaxEnergy * 0.4

 --[[  print("test " .. cellEnergy .. " cellEnergy")
  print("test " .. cellMaxEnergy .. " cellMaxEnergy")
  print("test " .. percentEnergy .. " percentEnergy")
  print("test " .. rfEnergy .. " rfEnergy")
  print("test " .. rfMaxEnergy .. " rfMaxEnergy") ]]

  print(rfEnergy .. " / ".. rfMaxEnergy .. " RF")
  print(percentEnergy .. "%")

  if (percentEnergy) > 90 then
    rs.setAnalogOutput("bottom", 15)
    print("Output OFF")
    print()
  else
    rs.setAnalogOutput("bottom", 0)
    print("Output ON")
    print()
  end
  sleep(10)
end