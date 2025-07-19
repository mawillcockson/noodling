local font = love.graphics.newFont(12)
local text = nil
local white = { 1, 1, 1, 1 }
local mouse = { x = 0, y = 0 }
local cursor = nil

function love.load()
  local canvas = love.graphics.newCanvas(10, 10)
  love.graphics.setCanvas(canvas)
  love.graphics.clear(1, 0, 0, 1)
  love.graphics.setCanvas()

  cursor = love.mouse.newCursor(canvas:newImageData())
  love.mouse.setCursor(cursor)

  --[[
	love.graphics.setColor(unpack(white))
	text = love.graphics.newText(font, "have not yet seen mouse")
  --]]
end

--[[
function love.update()
	mouse.x, mouse.y = love.mouse.getPosition()
	text:set(string.format("mouse position: %i, %i", mouse.x, mouse.y))
	text_width, text_height = text:getDimensions()
	text_x = mouse.x - text_width
	text_y = mouse.y - text_height
end

function love.draw()
	love.graphics.draw(text, text_x, text_y)
end
--]]
