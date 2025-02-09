
a = {1,2,3,4,5}
local i = 1

while a[i] do

    print(a[i])
    rs.setAnalogOutput("bottom", 15)
    sleep(0.1)
    rs.setAnalogOutput("bottom", 0)
    sleep(0.5)
    i = i +1

end