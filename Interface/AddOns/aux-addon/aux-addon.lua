module 'aux'

local T = require 'T'

local info = require 'aux.util.info'

_G.aux_scale = 1

_G.aux = {
	character = {},
	faction = {},
	realm = {},
	account = {},
}

M.print = T.vararg-function(arg)
	DEFAULT_CHAT_FRAME:AddMessage(LIGHTYELLOW_FONT_COLOR_CODE .. '<aux> ' .. join(map(arg, tostring), ' '))
end

local bids_loaded
function M.bids_loaded() return bids_loaded end

local current_owner_page
function M.current_owner_page() return current_owner_page end

local event_frame = CreateFrame'Frame'
for event in pairs(T.temp-T.set('ADDON_LOADED', 'VARIABLES_LOADED', 'PLAYER_LOGIN', 'AUCTION_HOUSE_SHOW', 'AUCTION_HOUSE_CLOSED', 'AUCTION_BIDDER_LIST_UPDATE', 'AUCTION_OWNED_LIST_UPDATE')) do
	event_frame:RegisterEvent(event)
end

local set_handler = {}
M.handle = setmetatable({}, {__metatable=false, __newindex=function(_, k, v) set_handler[k](v) end})

do
	local handlers, handlers2 = {}, {}
	function set_handler.LOAD(f)
		tinsert(handlers, f)
	end
	function set_handler.LOAD2(f)
		tinsert(handlers2, f)
	end
	event_frame:SetScript('OnEvent', function()
		if event == 'ADDON_LOADED' then
			if arg1 == 'Blizzard_AuctionUI' then
                auction_ui_loaded()
			end
		elseif event == 'VARIABLES_LOADED' then
			for _, f in pairs(handlers) do f() end
		elseif event == 'PLAYER_LOGIN' then
			for _, f in pairs(handlers2) do f() end
			print('loaded - /aux')
		else
			_M[event]()
		end
	end)
end

do
	local cache = {}
	function handle.LOAD()
		cache.account = aux.account
		do
			local key = format('%s|%s', GetCVar'realmName', UnitName'player')
			aux.character[key] = aux.character[key] or {}
			cache.character = aux.character[key]
		end
		do
			local key = GetCVar'realmName'
			aux.realm[key] = aux.realm[key] or {}
			cache.realm = aux.realm[key]
		end
	end
	function handle.LOAD2()
		do
			local key = format('%s|%s', GetCVar'realmName', UnitFactionGroup'player')
			aux.faction[key] = aux.faction[key] or {}
			cache.faction = aux.faction[key]
		end
	end
	for scope in pairs(T.temp-T.set('character', 'faction', 'realm', 'account')) do
		local scope = scope
		M[scope .. '_data'] = function(key, init)
			if not cache[scope] then error('Cache for ' .. scope .. ' data not ready.', 2) end
			cache[scope][key] = cache[scope][key] or {}
			for k, v in pairs(init or T.empty) do
				if cache[scope][key][k] == nil then
					cache[scope][key][k] = v
				end
			end
			return cache[scope][key]
		end
	end
end

tab_info = {}
function M.TAB(name)
	local tab = T.map('name', name)
	local tab_event = {
		OPEN = function(f) tab.OPEN = f end,
		CLOSE = function(f) tab.CLOSE = f end,
		USE_ITEM = function(f) tab.USE_ITEM = f end,
		CLICK_LINK = function(f) tab.CLICK_LINK = f end,
	}
	tinsert(tab_info, tab)
	return setmetatable({}, {__metatable=false, __newindex=function(_, k, v) tab_event[k](v) end})
end

do
	local index
	function M.get_active_tab() return tab_info[index] end
	function on_tab_click(i)
		CloseDropDownMenus()
		do (index and get_active_tab().CLOSE or nop)() end
		index = i
		do (index and get_active_tab().OPEN or nop)() end
	end
end

M.orig = setmetatable({[_G]=T.acquire()}, {__index=function(self, key) return self[_G][key] end})
M.hook = T.vararg-function(arg)
	local name, object, handler
	if getn(arg) == 3 then
		name, object, handler = unpack(arg)
	else
		object, name, handler = _G, unpack(arg)
	end
	handler = handler or getfenv(3)[name]
	orig[object] = orig[object] or T.acquire()
	assert(not orig[object][name], '"' .. name .. '" is already hooked into.')
	orig[object][name], object[name] = object[name], handler
	return hook
end

do
	local locked
	function M.bid_in_progress() return locked end
	function M.place_bid(type, index, amount, on_success)
		if locked then return end
		local money = GetMoney()
		PlaceAuctionBid(type, index, amount)
		if money >= amount then
			locked = true
			local send_signal, signal_received = signal()
			thread(when, signal_received, function()
				do (on_success or nop)() end
				locked = false
			end)
			thread(when, later(5), send_signal)
			event_listener('CHAT_MSG_SYSTEM', function(kill)
				if arg1 == ERR_AUCTION_BID_PLACED then
					send_signal()
					kill()
				end
			end)
		end
	end
end

do
	local locked
	function M.cancel_in_progress() return locked end
	function M.cancel_auction(index, on_success)
		if locked then return end
		locked = true
		CancelAuction(index)
		local send_signal, signal_received = signal()
		thread(when, signal_received, function()
			do (on_success or nop)() end
			locked = false
		end)
		thread(when, later(5), send_signal)
		event_listener('CHAT_MSG_SYSTEM', function(kill)
			if arg1 == ERR_AUCTION_REMOVED then
				send_signal()
				kill()
			end
		end)
	end
end

function handle.LOAD2()
	AuxFrame:SetScale(aux_scale)
end

function AUCTION_HOUSE_SHOW()
	AuctionFrame:Hide()
	AuxFrame:Show()
	set_tab(1)
end

do
	local handlers = {}
	function set_handler.CLOSE(f)
		tinsert(handlers, f)
	end
	function AUCTION_HOUSE_CLOSED()
		bids_loaded = false
		current_owner_page = nil
		for _, handler in handlers do
			handler()
		end
		set_tab()
		AuxFrame:Hide()
	end
end

function AUCTION_BIDDER_LIST_UPDATE()
	bids_loaded = true
end

do
	local last_owner_page_requested
	function GetOwnerAuctionItems(index)
		last_owner_page_requested = index
		return orig.GetOwnerAuctionItems(index)
	end
	function AUCTION_OWNED_LIST_UPDATE()
		current_owner_page = last_owner_page_requested or 0
	end
end

function auction_ui_loaded()
	AuctionFrame:UnregisterEvent('AUCTION_HOUSE_SHOW')
	AuctionFrame:SetScript('OnHide', nil)
	hook('ShowUIPanel', T.vararg-function(arg)
		if arg[1] == AuctionFrame then return AuctionFrame:Show() end
		return orig.ShowUIPanel(unpack(arg))
	end)
	hook 'GetOwnerAuctionItems' 'SetItemRef' 'UseContainerItem' 'AuctionFrameAuctions_OnEvent'
end

AuctionFrameAuctions_OnEvent = T.vararg-function(arg)
    if AuctionFrameAuctions:IsVisible() then
	    return orig.AuctionFrameAuctions_OnEvent(unpack(arg))
    end
end