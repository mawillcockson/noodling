local white = { 1, 1, 1, 1 }
local black = { 0, 0, 0, 1 }
local font = love.graphics.newFont(12)
local text_label = love.graphics.newText(font, { white, "have not yet seen a mouse" })
local text = { x = 0, y = 0, width = 0, height = 0, max = { width = 0, height = 0 } }
local mouse = { x = 0, y = 0 }
local window = { width = 0, height = 0 }
local max = { width = 0, height = 0 }
local canvas = nil
local cursor_max = { width = 0, height = 0 }

local function defaulttbl(factory)
	local tbl = {}
	local meta = {}
	meta.__index = function(orig, key)
		local default = factory()
		rawset(orig, key, default)
		return default
	end
	return setmetatable(tbl, meta)
end

local cursors = defaulttbl(function()
	return {}
end)

local function update_text(x, y)
	text_label:set(
		string.format("mouse position: %i, %i", type(x) ~= "nil" and x or mouse.x, type(y) ~= "nil" and y or mouse.y)
	)
	text.width, text.height = text_label:getDimensions()
	return { width = text.width, height = text.height }
end

local function triangle_pointing_at(x, y)
	return { x, y, x, y + 15, x + 10, y + 12 }
end

local function drawCursor()
	love.graphics.clear(unpack(black))
	love.graphics.setColor(unpack(white))
	love.graphics.draw(text_label, text.max.width - text.width, text.max.height - text.height)
	love.graphics.polygon("fill", triangle_pointing_at(text.max.width, text.max.height))
end

local function newCanvas()
	return love.graphics.newCanvas(text.max.width + cursor_max.width, text.max.height + cursor_max.height)
end

local calls_until_reset = 300

local function makeCursor(x, y)
	if calls_until_reset < 1 then
		canvas:release()
		canvas = nil
		canvas = newCanvas()
		print(string.format("%7dkB", math.floor(collectgarbage("count"))))
		calls_until_reset = 300
	end
	canvas:renderTo(drawCursor)
	local image_data = canvas:newImageData()
	local ok, cursor = pcall(love.mouse.newCursor, image_data, text.max.width, text.max.height)
	--[[
	local ok = true
	local cursor = love.mouse.newCursor(image_data, text.max.width, text.max.height)
  --]]
	if not ok then
		return error(string.format("error at x,y = %d,%d: %s", x, y, cursor))
	end
	if not image_data:release() then
		print("object previously released")
	end
	image_data = nil
	calls_until_reset = calls_until_reset - 1
	return cursor
end

function love.load()
	window.width, window.height = love.graphics.getDimensions()
	for x = 0, window.width, 1 do
		for y = 0, window.height, 1 do
			update_text(x, y)
			text.max.width = math.max(0, text.max.width, text.width)
			text.max.height = math.max(0, text.max.height, text.height)
		end
	end

	for i, v in pairs(triangle_pointing_at(0, 0)) do
		if i % 2 == 1 then
			cursor_max.width = math.max(0, cursor_max.width, v)
		else
			cursor_max.height = math.max(0, cursor_max.height, v)
		end
	end

	canvas = newCanvas()
	local temp = {}
	for i = 1, 10000 do
		update_text(0, 0)
		local cursor = makeCursor(-1, i)
		--temp[#temp + 1] = cursor
	end
	temp = nil
	print("collecting garbage...")
	collectgarbage("collect")
	print("done")

	for x = 0, window.width, 1 do
		for y = 0, window.height, 1 do
			update_text(x, y)
			cursors[x][y] = makeCursor(x, y)
		end
	end

	text_label:set({ white, "have not yet seen a mouse" })
	love.mouse.setCursor(makeCursor(-1, -1))
end

function love.mousemoved(x, y, _, _, _)
	mouse.x = x
	mouse.y = y
	local cursor = cursors[x][y]
	if cursor then
		love.mouse.setCursor(cursor)
	end
end
