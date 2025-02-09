-- listar metoder i en ansluten peripheral

for i,v in ipairs(peripheral.getMethods("back"))
  do print(i..". "..v)
end



-- skriver metoder till en fil (från ChatGPT)

local methods = peripheral.getMethods("back")
local counter = 0

local file = io.open("methods.txt", "w")  -- Open the file in write mode

if file then
  for i, v in ipairs(methods) do
    file:write(i .. ". " .. v .. "\n")  -- Write the line to the file
    counter = counter + 1
  end

  file:close()  -- Close the file when finished
  print("Methods written to methods.txt")
else
  print("Error opening file for writing")
end