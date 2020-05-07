function EyeSpyBall_OnLoad(self)
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("UNIT_AURA")
	SLASH_EYESPY1 = "/eyespy";
	SlashCmdList.EYESPY = function()
		print("|cFFFF00FFEyeSpy:|r Showing previous instance data")
		ShowPreviousData();
	end
	print("|cFFFF00FFEye-m|r watching you!");
end

local inInstance = nil
local trackingEyes = false
local countOfEyes = 0
local isEyeBallSpawn = false
local isEyeAnymore = {}


function EyeSpyBall_OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		inInstance, instanceType = IsInInstance();
		if inInstance and not trackingEyes then
			StartTrackingEyes();
		elseif not inInstance and trackingEyes then
			StopTrackingEyes();
		end
		
	end
	if event == "UNIT_AURA" then
		if trackingEyes then
			isEyeAnymore = {}
				for i = 1, 255 do
					local name, _, _, _, _, _, _, _, 
					_, spellId = UnitAura("player",i,"HARMFUL")
					if isEyeBallSpawn == false then
							if spellId == 315161 then
								table.insert(isEyeAnymore,i)
								isEyeBallSpawn = true;
							end
					elseif isEyeBallSpawn == true then
							if spellId == 315161 then
								table.insert(isEyeAnymore,i)
							end
					end
				end
				if isEyeBallSpawn then
					local counter = 0
					for index in pairs(isEyeAnymore) do
						counter = counter + 1;
					end
					
					if counter == 0 then
						countOfEyes = countOfEyes + 1;
						isEyeBallSpawn = false;
					end
				end
		end
	end
end

function StartTrackingEyes()
	trackingEyes = true;
	countOfEyes = 0;
end

function StopTrackingEyes()
	print("You had |cFFFF00FF" .. tostring(countOfEyes) .. "|r eyeballs within that instance.")
	if eyeTableCreated then
		table.insert(completeEyeDataSet,countOfEyes);
		trackingEyes = false;
	else
		eyeTableCreated = true;
		completeEyeDataSet = {};
		table.insert(completeEyeDataSet,countOfEyes);
		trackingEyes = false;
	end
end

function ShowPreviousData()

	local counter = 0;
	for index in pairs(completeEyeDataSet) do
		counter = counter + 1;
	end
	
	if counter > 0 then
		local lastCountOfEyes = completeEyeDataSet[counter];
		print("You had |cFFFF00FF" .. tostring(lastCountOfEyes) .. "|r eyeballs within your last instance.")
	end
end