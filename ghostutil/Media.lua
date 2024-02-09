---@meta Media
---@author T-Bar

---@class Media
local media = {};

local d = require "ghostutil.Debug"
local o = require "ghostutil.OutdateHandler"

function _gcall(func)
	if func ~= "createpost" then return end 
	local libs = {
		{'MP4Handler', 'vlc'},
		{'FileSystem', 'sys'},
		{'MP4Sprite', 'vlc'},
		{'FlxSound', 'flixel.sound'},
		(version >= "0.7.0" and {'FlxSound', 'flixel.system'} or {}),
		{'Event', 'openfl.events'}
	}
	
    for i = 1, #libs do
		addHaxeLibrary(libs[i][1], libs[i][2])
	end

	o.addHaxeLibrary("Paths")
end

---Plays a video... but better! must be an .mp4 and must be in 1280x720 (until further improvement)
---@param tag? string The tag of the video, can be used to locate it easily
---@param videoPath string The path of the video, should be in the "videos" folder
---@param skippable boolean Is the video skippable?
media.playVideo = function(tag, videoPath, skippable)
	if runHaxeCode([[return FileSystem.exists(Paths.video("]] ..tostring(videoPath).. [["));]]) == nil then
		d.error("media.playVideo:1: the video 'videoPath' does not exist!")
	else
		runHaxeCode([[
			var ]] ..tostring((tag or 'ghostVideo')).. [[ = new MP4Handler();
			]] ..tostring((tag or 'ghostVideo')).. [[.playVideo(Paths.video("]] ..tostring(videoPath).. [["));
			]] ..tostring((tag or 'ghostVideo')).. [[.finishCallback = function()
			{
				if(]] ..tostring((tag or 'ghostVideo')).. [[ != null)
				{
					game.callOnLuas('onVideoCompleted', ["]]..tostring((tag or 'ghostVideo'))..[["]);
					]] ..tostring((tag or 'ghostVideo')).. [[ = null;
				}
			}
			
			if(]] ..tostring(skippable).. [[ == true) //this is stupid but hey it works
				FlxG.stage.removeEventListener('enterFrame', ]] ..tostring((tag or 'ghostVideo')).. [[.update);
		]])
	end
end

---Sets the property of a video
---@param tag string The tag of the video that you want to change values on
---@param var string The value you want to change
---@param val string The new value
media.setVideoProperty = function(tag, var, val)
	if tag == nil then
		d.error("media.setVideoProperty:1: The video with a tag of " ..tag.. " doesn't exist!")
	else
		runHaxeCode(tostring(tag).. [[.]] ..var.. [[ = ]] ..tostring(val).. [[;]])
	end
end

---Sets the volume of a video
---@param tag string The tag of the video that you want to change values on
---@param vol number The new volume
media.setVideoVolume = function(tag, vol)
	if tag == nil then
		d.error("media.setVideoVolume:1: The video with a tag of " ..tag.. " doesn't exist!")
	else
		runHaxeCode(tostring(tag).. [[.volume = ]] ..tostring(vol).. [[;]])
	end
end

---Pauses a video
---@param tag string The tag of the video that you want to pause
media.pauseVideo = function(tag)
	if tag == nil then
		d.error("media.pauseVideo:1: The video with a tag of " ..tag.. " doesn't exist!")
	else
		runHaxeCode(tostring(tag).. [[.pause();]])
	end
end

---Resumes a video
---@param tag string The tag of the video that you want to resume
media.resumeVideo = function(tag)
	if tag == nil then
		d.error("media.resumeVideo:1: The video with a tag of " ..tag.. " doesn't exist!")
	else
		runHaxeCode(tostring(tag).. [[.resume();]])
	end
end

---Plays a sound from a URL
---@param tag string The tag of the sound. Used for connecting other functions to this sound
---@param soundURL string The url of the mp3
---@param looped? boolean Should the sound loop?
---@param AutoDestroy? boolean Should the sound auto destroy when finished?
media.playStreamSound = function(tag, soundURL, looped, AutoDestroy)
	runHaxeCode(
		(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartSounds.set(']] ..tostring(tag).. [[', new FlxSound());
		]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartSounds[']]..tag..[['].loadStream("]] ..tostring(soundURL).. [[", ]] ..tostring((looped or 'false')).. [[, ]] ..tostring((AutoDestroy or 'false')).. [[, function(){ game.callOnLuas("onSoundFinished", ["]]..(tag)..[["]); }, function(){ game.callOnLuas("onSoundLoaded", ["]]..(tag)..[["]); });
	]])
end

---Plays a Media.lua made sound
---@param tag string The tag of the sound you want to play
---@param forceRestart boolean Should the sound force restart?
media.playSound = function(tag, forceRestart)
	runHaxeCode(
		(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartSounds.set(']] ..tostring(tag).. [[', new FlxSound());
		]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartSounds[']]..tag..[['].play(]] ..tostring((forceRestart or 'false')).. [[);
	]])
end

---Sets a proximity on a sound. The further away you are from the x,y position, the more quiet the sound will be
---@param tag string The tag of the sound you want to set the proximity on
---@param xPos number The x position of the x,y position
---@param yPos number The y position of the x,y position
---@param object string The object the x,y position focuses on (only detects lua made objects for now)
---@param radius number The maximum distance the sound can go before its completely silent
---@param pan? boolean Whether panning should be used in addition to the volume changes
media.setSoundProximity = function(tag, xPos, yPos, object, radius, pan)
	if tag ~= nil then
		runHaxeCode(
			(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartSounds.set(']] ..tostring(tag).. [[', new FlxSound());
			]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartSounds[']]..tag..[['].proximity(]] ..tostring((xPos or "0")).. [[, ]] ..tostring((yPos or "0")).. [[, game.getLuaObject("]] ..tostring(object).. [["), ]] ..tostring((radius or "5")).. [[, ]] ..tostring((pan or "true")).. [[);
		]])
	else
		d.error("media.setSoundProximity:1: The tag does not exist!")
	end
end

---Plays a sound with start and end points
---@param tag string The tag of the sound you want to play
---@param startTime? number The start point of the sound (in milliseconds)
---@param endTime number The end point of the sound (in milliseconds)
---@param forceRestart? boolean Should the sound force restart?
media.playSoundWithPoints = function(tag, startTime, endTime, forceRestart)
	runHaxeCode(
		(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartSounds.set(']] ..tostring(tag).. [[', new FlxSound());
		]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartSounds[']]..tag..[['].play(]] ..tostring((forceRestart or 'false')).. [[, ]] ..tostring((startTime or '0')).. [[, ]] ..tostring(endTime).. [[);
	]])
end

---Gets the sound volume of the specified sound
---@param tag string The tag of the sound you want to get the volume
media.getSoundVolume = function(tag)
	runHaxeCode([[
		if (]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartSounds[']]..tag..[['] != null)
			return ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartSounds[']]..tag..[['].getActualVolume();
	]])
end

---Sets the sound's position. (Might need to use media.setSoundProximity)
---@param tag string The tag of the sound you want to set position
---@param xPos number The new position of the sound
media.setSoundPosition = function(tag, pos)
	if tag ~= nil then
		runHaxeCode([[
			if (]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.modchartSounds[']]..tag..[['] != null)
				return ]]..(version >= "0.7.0" and "game" or "PlayState.instance")..[[.setPosition(]] ..tostring((pos[1] or '0')).. [[, ]] ..tostring((pos[2] or '0')).. [[);
		]])
	else
		d.error("media.setSoundPosition:1: The tag does not exist!")
	end
end

return media;