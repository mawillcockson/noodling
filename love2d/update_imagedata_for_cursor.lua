local white = { 1, 1, 1, 1 }
local black = { 0, 0, 0, 1 }
local font = love.graphics.newFont(12)
local text_label = love.graphics.newText(font, { white, "have not yet seen a mouse" })
local text = { x = 0, y = 0, width = 0, height = 0, max = { width = 0, height = 0 } }
local mouse = { x = 0, y = 0 }
local window = { width = 0, height = 0 }
local max = { width = 0, height = 0 }
local canvas = nil

local function update_text(x, y)
	text_label:set(
		string.format("mouse position: %i, %i", type(x) ~= "nil" and x or mouse.x, type(y) ~= "nil" and y or mouse.y)
	)
	text.width, text.height = text_label:getDimensions()
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

local function makeCursor()
	canvas:renderTo(drawCursor)
	return love.mouse.newCursor(canvas:newImageData(), text.max.width, text.max.height)
end

function love.load()
	window.width, window.height = love.graphics.getDimensions()
	for x = 1, window.width, 1 do
		for y = 1, window.height, 1 do
			update_text(x, y)
			text.max.width = math.max(0, text.max.width, text.width)
			text.max.height = math.max(0, text.max.height, text.height)
		end
	end
	print(string.format("text.max.width: %i\ntext.max.height: %i", text.max.width, text.max.height))

	local cursor_max = { width = 0, height = 0 }
	for i, v in pairs(triangle_pointing_at(0, 0)) do
		if i % 2 == 0 then
			cursor_max.width = math.max(0, cursor_max.width, v)
		else
			cursor_max.height = math.max(0, cursor_max.height, v)
		end
	end

	canvas = love.graphics.newCanvas(text.max.width + cursor_max.width, text.max.height + cursor_max.height)

	love.mouse.setCursor(makeCursor())
end

function love.mousemoved(x, y, _, _, _)
	mouse.x = x
	mouse.y = y
	update_text()
	love.mouse.setCursor(makeCursor())
end
