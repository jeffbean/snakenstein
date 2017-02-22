level = {}
padding = 18

dirMap = {
	up = 0,
	down = 1,
	right = 2,
	left = 3
}

function love.load()
	love.graphics.setBackgroundColor(255, 255, 255)
	
	width = love.graphics.getWidth()
  	height = love.graphics.getHeight()

	-- This is the height and the width of the level.
	level.width = width - padding * 2    -- This makes the level as wide as the whole game window.
	level.height = height - padding * 2 -- This makes the level as tall as the whole game window.

	-- This is the coordinates where the level will be rendered.
	level.x = 0 + padding                               
	level.y = 0 + padding     

	player = {
		x = width / 2,
		y = height / 2,
		img = love.graphics.newImage('purple.png'),
		speed = 100,
		color = { 255, 255, 255 },
		direction = dirMap.up,
		score = 0, 
	}

	treat = {
		x = width / 3,
		y = height / 3,
		w = 15,
		h = 15,
	}
end

-- Hello comment
function love.draw()
	-- level
	love.graphics.setColor(0, 0, 0) 
	love.graphics.rectangle('fill', level.x, level.y, level.width, level.height)

	-- treat 
	love.graphics.setColor(110, 110, 110) 
	love.graphics.rectangle('fill', treat.x, treat.y, treat.w, treat.h)

	-- player
	love.graphics.setColor(player.color)
	love.graphics.draw(player.img, player.x, player.y, 0, 1, 1, 0, 0)

	-- score screen
	love.graphics.print("Score: " .. player.score, padding+10, padding+10)

	-- debug prints
	love.graphics.print("player x: " .. player.x, padding*10, padding+10)
	love.graphics.print("player width: " .. player.img:getWidth(), padding*10, padding+25)
	love.graphics.print("level width: " .. level.width, padding*10, padding+40)
	love.graphics.print("FPS: " .. love.timer.getFPS(), 2, 2)
end

function love.focus(f) gameIsPaused = not f end
 
function love.update(dt)
	if gameIsPaused then return end
 
	-- In the case of snake we should be always moving in a direction and will change statefully with a key
	if love.keyboard.isDown('right') then
		-- This makes sure that the character doesn't go pass the game window's right edge.
		if player.direction ~= dirMap.left then 
			player.direction = dirMap.right
		end
	elseif love.keyboard.isDown('left') then
		-- This makes sure that the character doesn't go pass the game window's left edge.
		if player.direction ~= dirMap.right then 
			player.direction = dirMap.left
		end
	elseif love.keyboard.isDown('up') then
		if player.direction ~= dirMap.down then
			player.direction = dirMap.up
		end
	elseif love.keyboard.isDown('down') then
		if player.direction ~= dirMap.up then
			player.direction = dirMap.down
		end
	end

	if player.direction == dirMap.up then
		player.y = math.clamp(player.y - (player.speed * dt), level.y, level.height)
	elseif player.direction == dirMap.down then 
	    player.y = math.clamp(player.y + (player.speed * dt), level.y, level.height - player.img:getWidth() + padding)
	elseif player.direction == dirMap.right then 
		player.x = math.clamp(player.x + (player.speed * dt), level.x, level.width - player.img:getWidth() + padding)
	elseif player.direction == dirMap.left then
	    player.x = math.clamp(player.x - (player.speed * dt), level.x, level.width)
	end

	
end

function math.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end