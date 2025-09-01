-- Copyright (c) 2025 Jonas Costa Campos
-- Receiver script for a CompositeWorks Microcontroller (https://github.com/jonasCCa/CompositeWorks)

ticks = 0
ticksToPost = 60 // property.getNumber("frequency")
port = math.floor(property.getNumber("port"))
id = property.getText("ID")

local f = false
compositeNumber = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
compositeBool   = {f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f}

function onTick()
	ticks = ticks + 1
	
	if ticks >= ticksToPost then
		ticks = 0
		async.httpGet(port, "/getComposite?id="..id)
	end
	
	for i = 1, 32 do
		output.setNumber(i, compositeNumber[i])
		output.setBool(i, compositeBool[i])
	end
end
	
function httpReply(port, request_body, response_body)
	local i = 1
	for str in string.gmatch(response_body, '([^,]+)') do
		compositeNumber[i] = tonumber(str)
		
		if i == 33 then
			for j = 1, 32 do
				if string.sub(str, j, j) == "1" then
					compositeBool[j] = true
				else
					compositeBool[j] = false
				end
			end
		end

		i = i + 1
	end
end