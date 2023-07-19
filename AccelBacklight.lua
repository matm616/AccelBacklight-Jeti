-- AccelBacklight.lua

-- Helper functions to run when var changed in form
--------------------------------------------------
local function accelAngleChanged(value)
	accelAngle = value
	system.pSave("accelAngle",accelAngle)
end

local function idleModeChanged(value)
	local switchCaseTable = {
		[1] = 0,
		[2] = 1,
		[3] = 2,
		[4] = 3
	}
	idleMode = switchCaseTable[value]
	system.pSave("idleMode",idleMode)
end

local function ActiveModeChanged(value)
	local switchCaseTable = {
		[1] = 0,
		[2] = 1,
		[3] = 2,
		[4] = 3
	}
	activeMode = switchCaseTable[value]
	system.pSave("activeMode",activeMode)
end

local function printToCmdChanged(value)
	printToCmd = value
	system.pSave("printToCmd",printToCmd)
end
--------------------------------------------------

-- Form to set vars
local function initForm()
	local backlightModeSwitchCaseTable = {
		[0] = 1,
		[1] = 2,
		[2] = 3,
		[3] = 4
	}

	form.addRow(2)
	form.addLabel({label="Activation Angle"})
	form.addIntbox(accelAngle, -90, 90, 40, 0, 5, accelAngleChanged)

	form.addRow(2)
	form.addLabel({label="Idle Backlight Mode"})
	form.addSelectbox({"Always Off", "10s", "60s", "Always On"}, backlightModeSwitchCaseTable[idleMode], true, idleModeChanged, {})

	form.addRow(2)
	form.addLabel({label="Active Backlight Mode"})
	form.addSelectbox({"Always Off", "10s", "60s", "Always On"}, backlightModeSwitchCaseTable[activeMode], true, ActiveModeChanged, {})
		
	form.addRow(2)
	form.addLabel({label="Print to Console"})
	form.addSelectbox({"No", "Yes"}, printToCmd, true, printToCmdChanged, {})
	
	collectgarbage()
end

-- Helper function to print only when printToCmd is set to 1
local function printCmd(text)
	if (printToCmd == 2) then
		print(text)
	end
end

-- Loop function is called in regular intervals
local function loop()
	if (system.getIMU()["p"] > accelAngle) then
		if (lastMode == activeMode) then
			return
		end
		dt = system.getDateTime()
		printCmd("Turning ON backlight - " .. (string.format("Time: %d-%02d-%02d, %d:%02d:%02d", dt.year, dt.mon, dt.day, dt.hour, dt.min, dt.sec)))
		system.setProperty("BacklightMode", activeMode)
		lastMode = activeMode
	else
		if (lastMode == idleMode) then
			return
		end
		dt = system.getDateTime()
		printCmd("Turning OFF backlight - " .. (string.format("Time: %d-%02d-%02d, %d:%02d:%02d", dt.year, dt.mon, dt.day, dt.hour, dt.min, dt.sec)))
		system.setProperty("BacklightMode", idleMode)
		lastMode = idleMode
	end
end


-- Application initialization.
local function init(code)
	accelAngle = system.pLoad("accelAngle")
	if (accelAngle == nil) then
		accelAngle = 40
		system.pSave("accelAngle", accelAngle)
	end
	
	idleMode = system.pLoad("idleMode")
	if (idleMode == nil) then
		idleMode = 0
		system.pSave("idleMode", idleMode)
	end
	
	activeMode = system.pLoad("activeMode")
	if (activeMode == nil) then
		activeMode = 3
		system.pSave("activeMode", activeMode)
	end
	
	printToCmd = system.pLoad("printToCmd")
	if (printToCmd == nil) then
		printToCmd = 1
		system.pSave("printToCmd", printToCmd)
	end
	
	lastMode = system.getProperty("BacklightMode")
	
	system.registerForm(1, MENU_APPS, "Accel. Backlight Config", initForm, nil, printForm)
	
	dt = system.getDateTime()
	print("Application initialized - " .. (string.format("Time: %d-%02d-%02d, %d:%02d:%02d", dt.year, dt.mon, dt.day, dt.hour, dt.min, dt.sec)))
	collectgarbage()
end

-- Application interface
return {init = init, loop = loop, author = "matm616", version = "1.0", name = "AccelBacklight"}