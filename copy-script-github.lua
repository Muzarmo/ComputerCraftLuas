
-- Define the GitHub raw URL for the reactor script
local url = "https://raw.githubusercontent.com/Muzarmo/ComputerCraftLuas/refs/heads/master/reactorcontrol.lua"

-- Define the path where the script will be saved locally
local filePath = "startup.lua"

-- Function to download the file
function downloadFile(url, filePath)
    local response = http.get(url)  -- Perform the GET request to fetch the file
    if response then
        local file = fs.open(filePath, "w")  -- Open the file for writing
        file.write(response.readAll())  -- Write the content to the file
        file.close()  -- Close the file after writing
        print("Download complete: " .. filePath)
    else
        print("Failed to download the file.")
    end
end

downloadFile(url, filePath)
