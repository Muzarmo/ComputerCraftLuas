-- For making Crystallized oil out of Refined oil

while true do

  local tanklevelin = rs.getAnalogInput("left")
  local tanklevelout = rs.getAnalogInput("top")
  local seedslevel = rs.getAnalogInput("back")

print(tanklevelin .. " tanklevelin")
print(tanklevelout .. " tanklevelout")
print(seedslevel .. " seedslevel")


  if tanklevelin > 3 and tanklevelout < 10 and seedslevel > 0 then
    print("Oil available and space available in receiving tank!")
    print("Seeds available!")
    print("Starting Oil crystallizing!")
    print("Depositing Refined Oil")
    rs.setAnalogOutput("left", 15)
    sleep(0.1)
    rs.setAnalogOutput("left", 0)
    sleep(1)

    print("Dropping one crystal seed")
    rs.setAnalogOutput("back", 15)
    sleep(0.1)
    rs.setAnalogOutput("back", 0)
    sleep(1)

    print("Picking up Crystallized Oil")
    print()
    rs.setAnalogOutput("top", 15)
    sleep(0.1)
    rs.setAnalogOutput("top", 0)
    sleep(1)

  elseif tanklevelin <= 3 then
    print("Not enough Refined Oil Available!")
    print("Sleeping for five minutes")
    print()
    rs.setAnalogOutput("bottom", 15)
    sleep(300)
    rs.setAnalogOutput("bottom", 0)

  elseif tanklevelout >= 10 then
    print("Not enough space in receiving tank")
    print("Storage full!")
    print("Sleeping for 15 minutes")
    print()
    rs.setAnalogOutput("bottom", 15)
    sleep(900)
    rs.setAnalogOutput("bottom", 0)

  else
    print("Not enough seeds")
    print("Sleeping for five minutes")
    print()
    rs.setAnalogOutput("bottom", 15)
    sleep(300)
    rs.setAnalogOutput("bottom", 0)
  end
end


