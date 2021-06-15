script_name('money_separator.lua') -- https://www.blast.hk/threads/39380/
script_author('Royan_Millans, edited dmitriyewich, https://vk.com/dmitriyewichmods')
script_url("https://vk.com/dmitriyewichmods")
script_dependencies("samp.events")
script_properties('work-in-pause')
script_version('1.3')
script_version_number(13)

local lsampev, sampev = pcall(require, 'samp.events') assert(lsampev, 'Library \'SAMP.Lua\' not found.') -- https://github.com/THE-FYP/SAMP.Lua

function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do wait(0) end

	wait(-1)
end

function comma_value(n) -- by kikito
	return n:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub(",", "%.")
end

function separator(text)
    if text:find("%$") then
        for S in string.gmatch(text, "(%$%d+)") do
            text = string.gsub(text, S, comma_value(S))
        end
        for S in string.gmatch(text, "(%d+%$)") do
            S = string.sub(S, 0, #S-1)
            text = string.gsub(text, S, comma_value(S))
        end
    end
	text = string.gsub(text, "%$%.", "%$")
	text = string.gsub(text, "%s%.", " ")
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
