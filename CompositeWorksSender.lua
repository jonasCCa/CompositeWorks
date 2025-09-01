-- Copyright (c) 2025 Jonas Costa Campos
-- Sender script for a CompositeWorks Microcontroller (https://github.com/jonasCCa/CompositeWorks)

ticks = 0
ticksToPost = 60 // property.getNumber("frequency")
port = math.floor(property.getNumber("port"))

local f = false
compositeNumber = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
compositeBool   = {f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f}

response = false

function onTick()
	ticks = ticks + 1
	
	if ticks >= ticksToPost then
		ticks = 0
		
		local n = ""
		local b = ""
		
		for i=1,32 do
			compositeNumber[i] = input.getNumber(i)
			compositeBool[i] = input.getBool(i)
			
			n = n..compositeNumber[i]
			if compositeBool[i] == true then
				b = b.."1"
			else
				b = b.."0"
			end
			
			if i < 32 then
				n = n..","
				b = b..","
			end
		end
		
		async.httpGet(port, "/postComposite?n="..n.."&b="..b)
	end

	output.setBool(1, response)
end

function httpReply(port, request_body, response_body)
	response = response_body == "OK"
end