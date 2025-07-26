local env = nil

function love.load(args)
	if args[1] == nil then
		error("must specify a main module after this folder name")
	end

	local filename = args[1]
	local mod = filename:gsub("%.lua$", "")
	env = setmetatable(
		{ filename = filename, mod = mod, love = setmetatable({}, { __index = love }) },
		{ __index = _G }
	)
	setfenv(loadfile(filename), env)()
	setmetatable(env, nil)
	setmetatable(env.love, nil)
	for k, v in pairs(env) do
		print(string.format("%s = %q", k, v))
		if k == "love" then
			for k2, v2 in pairs(v) do
				print(string.format("  %s = %q", k2, v2))
			end
		end
	end

	if env.love.load then
		setfenv(env.love.load, _G)(args)
	end
	if env.love.update then
		love.update = setfenv(env.love.update, _G)
	end
	if env.love.draw then
		love.draw = setfenv(env.love.draw, _G)
	end

  print("done loading main")
end

function love.keyreleased(key, scancode)
	if key == "escape" then
		love.event.quit()
	end
	if env.love.keyreleased then
		setfenv(env.love.keyreleased, _G)(key, scancode)
	end
end
