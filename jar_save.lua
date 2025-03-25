


local jars = {}

for address, type in component.list() do
  if type == "jar_void" then
    table.insert(jars, address)
  end
end

print("Void Jars")
for _, addr in ipairs(jars) do
  print(addr)
end

print("Warded Jars")
