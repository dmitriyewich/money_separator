script_name('money_separator.lua') -- https://www.blast.hk/threads/39380/
script_author('Royan_Millans, edited dmitriyewich, https://vk.com/dmitriyewichmods')
script_description("The usual fakeskin on hooks, mimgui. Sets an individual skin by the player's nickname. Any time the server changes the skin, you will have the skin you installed. When unlinking a skin, the skin that was before binding is returned.")
script_url("https://vk.com/dmitriyewichmods")
script_dependencies("samp.events", "encoding")
script_properties('work-in-pause')
script_version('1.2')
script_version_number(12)

local dlstatus = require "moonloader".download_status
local lsampev, sampev = pcall(require, 'samp.events') -- https://github.com/THE-FYP/SAMP.Lua
local lencoding, encoding = pcall(require, 'encoding') assert(lencoding, 'Library \'encoding\' not found.')
local point = '.'				 

encoding.default = 'CP1251'
u8 = encoding.UTF8
CP1251 = encoding.CP1251

function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do wait(0) end
	checklibs()
	while not sampIsLocalPlayerSpawned() do wait(0) end
	wait(-1)
end

function comma_value(n)
	local num = string.match(n,'(%d+)')
	local result = num:reverse():gsub('(%d%d%d)','%1'..point):reverse()
	if string.char(result:byte(1)) == point then result = result:sub(2) end
	return result
end

function separator(text)
	if text:find("$") then
		for S in string.gmatch(text, "(%$%d+)") do
	    	local replace = comma_value(S)
	    	text = text.gsub(text, S, '\r%$'..replace)
			-- text = text:gsub('%$', '\r%$')
	    end
		for S in string.gmatch(text, "(%d+%$)") do
			S = string.sub(S, 0, #S-1)
	    	local replace = comma_value(S)
	    	text = string.gsub(text, S, replace..'')			
	    end
	    for S in string.gmatch(text, "(%d+%s%$)") do
	    	S = string.sub(S, 0, #S-1)
	    	local replace = comma_value(S)
	    	text = string.gsub(text, S, replace..'')
	    end
	end
	return text
end
if lsampev then
	function sampev.onServerMessage(color, text)
		if text then text = separator(text) end
		text = string.gsub(text, '\r', '')
		return {color, text}
	end
	
	function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
		if text then text = separator(text) end
		if title then title = separator(title) end
		return {dialogId, style, title, button1, button2, text}
	end

	function sampev.onCreate3DText(id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text)
		if text then text = separator(text) end
		return {id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text}
	end

	function sampev.onPlayerChatBubble(playerId, color, distance, duration, message)
		if message then message = separator(message) end
		return {playerId, color, distance, duration, message}
	end																				
	function sampev.onTextDrawSetString(id, text)
		if text then text = separator(text) end
		return {id, text}
	end
	function sampev.onSetObjectMaterialText(bs, data)
		data.text = separator(data.text)
		return {bs, data}
	end

	function sampev.onShowTextDraw(id, data)
		data.text = separator(data.text)
		return {id, data}
	end

	function sampev.onDisplayGameText(style, time, text)
		if text then text = separator(text) end
		return {style, time, text}
	end
end

function checklibs()
	if not lsampev then
		lua_thread.create(function()
			print(u8:decode'Подгрузка необходимых библиотек..')
			--samp.lua
			createDirectory(getWorkingDirectory()..'\\lib\\samp')
			createDirectory(getWorkingDirectory()..'\\lib\\samp\\events')
			downloadFile('events', getWorkingDirectory()..'\\lib\\samp\\events.lua', 'https://raw.githubusercontent.com/THE-FYP/SAMP.Lua/master/samp/events.lua')
		 	while not doesFileExist(getWorkingDirectory()..'\\lib\\samp\\events.lua') do wait(0) end
			downloadFile('raknet', getWorkingDirectory()..'\\lib\\samp\\raknet.lua', 'https://raw.githubusercontent.com/THE-FYP/SAMP.Lua/master/samp/raknet.lua')
		 	while not doesFileExist(getWorkingDirectory()..'\\lib\\samp\\raknet.lua') do wait(0) end
			downloadFile('synchronization', getWorkingDirectory()..'\\lib\\samp\\synchronization.lua', 'https://raw.githubusercontent.com/THE-FYP/SAMP.Lua/master/samp/synchronization.lua')
		 	while not doesFileExist(getWorkingDirectory()..'\\lib\\samp\\synchronization.lua') do wait(0) end
			downloadFile('bitstream_io', getWorkingDirectory()..'\\lib\\samp\\events\\bitstream_io.lua', 'https://raw.githubusercontent.com/THE-FYP/SAMP.Lua/master/samp/events/bitstream_io.lua')
		 	while not doesFileExist(getWorkingDirectory()..'\\lib\\samp\\events\\bitstream_io.lua') do wait(0) end
			downloadFile('core', getWorkingDirectory()..'\\lib\\samp\\events\\core.lua', 'https://raw.githubusercontent.com/THE-FYP/SAMP.Lua/master/samp/events/core.lua')
		 	while not doesFileExist(getWorkingDirectory()..'\\lib\\samp\\events\\core.lua') do wait(0) end
			downloadFile('extra_types', getWorkingDirectory()..'\\lib\\samp\\events\\extra_types.lua', 'https://raw.githubusercontent.com/THE-FYP/SAMP.Lua/master/samp/events/extra_types.lua')
		 	while not doesFileExist(getWorkingDirectory()..'\\lib\\samp\\events\\extra_types.lua') do wait(0) end
			downloadFile('handlers', getWorkingDirectory()..'\\lib\\samp\\events\\handlers.lua', 'https://raw.githubusercontent.com/THE-FYP/SAMP.Lua/master/samp/events/handlers.lua')
		 	while not doesFileExist(getWorkingDirectory()..'\\lib\\samp\\events\\handlers.lua') do wait(0) end
			downloadFile('utils', getWorkingDirectory()..'\\lib\\samp\\events\\utils.lua', 'https://raw.githubusercontent.com/THE-FYP/SAMP.Lua/master/samp/events/utils.lua')
		 	while not doesFileExist(getWorkingDirectory()..'\\lib\\samp\\events\\utils.lua') do wait(0) end			
			print(u8:decode'Подгрузка необходимых библиотек окончена. Перезагружаюсь..')
			noErrorDialog = true
			wait(1000)
			thisScript():reload()
		end)
		return false
	end
	return true
end

function downloadFile(name, path, link)
	if not doesFileExist(path) then 
		downloadUrlToFile(link, path, function(id, status, p1, p2)
			if status == dlstatus.STATUSEX_ENDDOWNLOAD then
				print('Файл {006AC2}«'..name..'»{FFFFFF} загружен!')
			end
		end)
	end
end