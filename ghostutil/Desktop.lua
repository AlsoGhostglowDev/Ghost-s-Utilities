---@meta Dekstop
---@author T-Bar
---@package ghostutil

---	                             WARNING: Some of these functions are super dangerous and 
---                             could harm your system if you don't use them with caution!
---                                                Please use with care.
---
---   (GhostglowDev / T-Bar is NOT responsible for any harm done to any computer as a result of using these function without care)
---@class Desktop
local desktop = {};

local nircmdPath = 'ghostutil/nircmd/'
local d = require "ghostutil.Debug"

---Runs a command prompt code
---@param codeToRun string The cmd code to run
desktop.runCMDCode = function(codeToRun)
    if codeToRun == nil then d.error("pc.runCMDCode:1: the cmd command is not defined!") else
        os.execute(codeToRun) 
    end
end

---[NirCMD] Runs a nircmd code (more powerful than using runCMDCode)
---@param codeToRun string The nircmd code to run, must start with 'nircmd.exe' to run on nircmd
---@param includeNircmdTag? boolean Do you want the 'nircmd.exe' tag to automatically be added?
desktop.runNircmdCode = function(codeToRun, includeNircmdTag)
    if codeToRun == nil then d.error("pc.runNircmdCode:1: the nircmd command is not defined!") else
        os.execute('cd /d ' ..nircmdPath.. ' & ' ..tostring((includeNircmdTag and "nircmd.exe " or "") .. codeToRun))
    end
end

---[NirCMD] Creates an info box
---@param message string The message inside the infobox
---@param title string The title of the infobox
desktop.infobox = function(message, title)
    if message == nil or title == nil then d.error("pc:infobox:"..(message == nil and "1" or "2")..": The argument ") else
        os.execute([[cd /d ]] ..nircmdPath.. [[ & nircmd.exe infobox "]] ..message.. [[" "]] ..title.. [["]])
    end
end

---[NirCMD] Creates an question box, includes a "yes" or "no" option and activates a nircmd function or exe when yes is clicked
---@param message string The message inside the qbox
---@param title string The title of the qbox
---@param yesFunction? string What happens when you press "yes". it can be a nircmd command or a program, defined in "whatToRun"
---@param whatToRun? string What to run if "yes" is pressed. can be "command" or "program"
---@param onTop? boolean Do you want the message box to be the top-most window?
desktop.qbox = function(message, title, yesFunction, whatToRun, onTop)
    whatToRun = whatToRun or "program"
    if message == nil or title == nil then d.error("pc.qbox:"..(message == nil and "1" or ((message == nil and title == nil) and "1-2" or "2"))..": The argument "..(message == nil and "message" or ((message == nil and title == nil) and "message and title" or "title")).." is not defined!") else
        os.execute([[cd /d ]] ..nircmdPath.. [[ & nircmd.exe ]]..(whatToRun:lower() == "program" and "qbox" or "qboxcom") ..(onTop and 'top' or '').. [[ "]] ..message.. [[" "]] ..title.. [[" ]] ..(whatToRun:lower() == 'program' and '"'..yesFunction..'"' or yesFunction))
    end
end

---[NirCMD] Runs a nircmd script (.ncl)
---@param script string path where the script is, starting in the folder where nircmd.exe is
--note that this is still in development as the script needs to be in a subfolder following the nircmdPath
desktop.runNircmdScript = function(script)
    os.execute([[cd /d ]] ..nircmdPath.. [[ & nircmd.exe script "]] ..tostring(script).. [["]]) 
end

---[NirCMD] Turns off your monitor (be careful with this, use at your own risk)
desktop.turnMonitorOff = function()
    os.execute([[cd /d ]] ..nircmdPath.. [[ & nircmd.exe monitor off]]) 
end

---[NirCMD] Terminates the current session of Windows (be careful with this, use at your own risk)
---@param shutdownType string can be:
---"logoff": Shut down all running processes, log off the current user, and display the log on dialog to allow another user to log into the system.
---"reboot": Shut down the entire system, and then reboot. 
---"poweroff": Shut down the entire system, and then turn off the power. (Only for systems that support this feature!) 
---"shutdown": Simply shut down the entire system, without reboot and without turning the power off. 
---@param additionalOption? string Can be:
--"force": Forces all applications to terminate immediately. Using this option can caused the current running application to lose data. Use it only in extreme cases ! 
--"forceifhung": Forces applications to terminate if they are not responding. This option is only available in Windows 2000/XP. 
desktop.exitwin = function(shutdownType, additionalOption)
    os.execute([[cd /d ]] ..nircmdPath.. [[ & nircmd.exe exitwin ]] ..shutdownType.. [[ ]] ..additionalOption) 
end

---[NirCMD] Initiates a system shutdown (be careful with this, use at your own risk)
---@param message string the message displayed before shutdown
---@param timeOutInSeconds number number of seconds to wait before shutdown
---@param shutdownType string can be "reboot" or "force"
desktop.initshutdown = function(message, timeOutInSeconds, shutdownType)
    os.execute([[cd /d ]] ..nircmdPath.. [[ & nircmd.exe initshutdown "]] ..tostring(message).. [[" ]] ..tostring(timeOutInSeconds).. [[ ]] ..tostring(string.lower(shutdownType))) 
end

---[NirCMD] Performs a monitor action (be careful with this, use at your own risk)
---@param action string the action to perform. Can be:
--"off": Turn off the monitor 
--"async_off": Turn off the monitor. Use this value if NirCmd remains in memory when using monitor off. 
--"on": Turn on the monitor 
--"low": Set the monitor to low power state. 
desktop.performMonitorAction = function(action)
    os.execute([[cd /d ]] ..nircmdPath.. [[ & nircmd.exe monitor ]] ..tostring(string.lower(action))) 
end

---[NirCMD] Performs a CDROM tray action (be careful with this, use at your own risk)
---@param action string the action to perform. Can be:
--"open": opens the CDROM disk tray.
--"close": closes the CDROM disk tray.
---@param drive string the drive, can be "J" or "R"
desktop.performCDROMAction = function(action, drive)
    if action == nil then d.error('pc.performCDROMAction:1: The argument action is not defined!') else
        os.execute([[cd /d ]] ..nircmdPath.. [[ & nircmd.exe cdrom ]] ..tostring(string.lower(action)).. (drive ~= nil and [[ ]] ..tostring(string.lower(drive)).. [[:]] or ""))
    end
end

---[NirCMD] Sets the system's volume
---@param volume number The new volume, must be somewhere in between 0 (silent) or 65535 (full volume)
---@param component? string What volume component you want to change (default is master). can be: master, waveout, synth, cd, microphone, phone, aux, line, headphones, wavein (must be in "" for visa
---@param deviceIndex? number Specifies the sound device index (useful for pc's with more than 1 sound card)
desktop.setSystemVolume = function(volume, component, deviceIndex)
    if volume == nil then
        d.error("pc:setSystemVolume:1: The argument volume is not defined!")
        return
    end

    deviceIndex = deviceIndex or ""
    os.execute([[cd /d ]] ..nircmdPath.. [[ & nircmd.exe setsysvolume ]] ..tostring(volume).. [[ ]] ..(component or 'master').. [[ ]].. tostring(deviceIndex))
end

---[NirCMD] Sets the system's volume for both the left and right channel (pan)
---@param leftChannel number The volume on the left channel, must be somewhere in between 0 (silent) or 65535 (full volume)
---@param rightChannel number The volume on the right channel, must be somewhere in between 0 (silent) or 65535 (full volume)
---@param component? string What volume component you want to change (default is master). can be: master, waveout, synth, cd, microphone, phone, aux, line, headphones, wavein (must be in "" for visa
---@param deviceIndex? number Specifies the sound device index (useful for pc's with more than 1 sound card)
desktop.setSystemVolume2 = function(leftChannel, rightChannel, component, deviceIndex)
    if leftChannel == nil or rightChannel == nil then
        d.error("pc.setSystemVolume2:"..(leftChannel == nil and "1" or ((leftChannel == nil and rightChannel == nil) and "1-2" or "2"))..": The argument "..(leftChannel == nil and "left" or ((leftChannel == nil and rightChannel == nil) and "left and right" or "right")).." is not defined!")
        return
    end 

    deviceIndex = deviceIndex or ""
    os.execute([[cd /d ]] ..nircmdPath.. [[ & nircmd.exe setsysvolume2 ]] ..tostring(leftChannel).. [[ ]] ..tostring(rightChannel).. [[ ]] ..(component or 'master').. [[ ]].. tostring(deviceIndex))
end

---[NirCMD] Sends a key. The system behaves exactly as if you pressed that key
---@param key string The key that you want to send
---@param keyOption? string The options, can be "press", "down", or "up"
desktop.sendKey = function(key, keyOption)
    if key == nil then d.error("pc.sendKey:1: The key is not defined!") else
        os.execute([[cd /d ]] ..nircmdPath.. [[ & nircmd.exe sendkey ]] ..tostring(key).. [[ ]] ..tostring((keyOption or 'down')))
    end
end

---[NirCMD] Sends a mouse input. The system behaves exactly as if you pressed that mouse button
---@param mouseButton string The button that you want to send, can be "left", "right", or "middle"
---@param keyOption string The property, can be "down", "up", "click", or "dblclick"
desktop.sendMouse = function(mouseButton, keyOption)
    os.execute([[cd /d ]] ..nircmdPath.. [[ & nircmd.exe sendmouse ]] ..tostring((mouseButton or 'left')).. [[ ]] ..tostring((keyOption or 'down')))
end

---[NirCMD] Sends a mouse wheel input.
---@param scrollLength number How many units do you want the wheel input to scroll?
desktop.sendMouseWheel = function(scrollLength)
    if scrollLength == nil then d.error("pc.sendMouseWheel:1: The argument scrollLength is not defined!") else
        os.execute([[cd /d ]] ..nircmdPath.. [[ & nircmd.exe sendmouse wheel ]] ..tostring(120 * scrollLength))
    end
end

---[CMD] Shutdowns your computer, simple enough (be careful with this, use at your own risk)
---@param message string the message displayed before shutdown
---@param timeOutInSeconds number number of seconds to wait before shutdown
desktop.commandShutdown = function(message, timeOutInSeconds)
    os.execute([[shutdown /s /t ]] ..tonumber(timeOutInSeconds).. [[ /c "]] ..tostring(message).. [["]]) 
end

return desktop;