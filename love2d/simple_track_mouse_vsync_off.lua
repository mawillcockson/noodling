local white = { 1, 1, 1, 1 }
local black = { 0, 0, 0, 1 }
local font = love.graphics.newFont(12)
local text = love.graphics.newText(font, { white, "have not yet seen mouse" })
local text_x, text_y, text_width, text_height = unpack({ 0, 0, 0, 0 })
local mouse = { x = 0, y = 0 }

function love.load()
	local width, height = love.graphics.getDimensions()
	love.window.updateMode(width, height, { vsync = false })
	love.graphics.clear(black)
	love.graphics.setColor(unpack(white))
end

function love.mousemoved(x, y, _, _, _)
	mouse.x = x
	mouse.y = y
end

function love.update()
	text:set(string.format("mouse position: %i, %i", mouse.x, mouse.y))
	text_width, text_height = text:getDimensions()
	text_x = mouse.x - text_width
	text_y = mouse.y - text_height
end

function love.draw()
	love.graphics.draw(text, text_x, text_y)
end
