Class = require "vendor.hump.class"

Player = Class{}

local GRID_SIZE = 10
local direction = {
	up = 0,
	down = 1,
	right = 2,
	left = 3
}

function Player:init(x, y, color)
	-- TODO: not default to direction right since many players willl start different places
    self.direction = direction.right
	self.x = x
	self.y = y
	self.speed = 100
	self.color = color
    self.score = 0

	self.entities = {}
	
	-- -- for the many parts of the snake, start with 3 units
	-- for i=1, self.score+3, 1 do
		-- print("Putting snake" .. i .. " at position x" .. self.x .. " y" .. self.y)
		-- table.insert(self.entities.body, Player(self.x + GRID_SIZE * i, self.y + GRID_SIZE * i))
	-- end
end

function Player:draw()
    love.graphics.setColor(self.color) 
	-- draw the head thing
	love.graphics.rectangle("fill", self.x, self.y, GRID_SIZE, GRID_SIZE)
    for _,o in ipair(self.entities.body) do
        love.graphics.rectangle("fill", o.x, o.y, GRID_SIZE, GRID_SIZE)
    end
end

function Player:update(dt)
	-- In the case of snake we should be always moving in a direction and will change statefully with a key
	if love.keyboard.isDown('right') then
		-- This makes sure that the character doesn't go pass the game window's right edge.
		if player.direction ~= direction.left then 
			player.direction = direction.right
		end
	elseif love.keyboard.isDown('left') then
		-- This makes sure that the character doesn't go pass the game window's left edge.
		if player.direction ~= direction.right then 
			player.direction = direction.left
		end
	elseif love.keyboard.isDown('up') then
		if player.direction ~= direction.down then
			player.direction = direction.up
		end
	elseif love.keyboard.isDown('down') then
		if player.direction ~= direction.up then
			player.direction = direction.down
		end
	end

	if player.direction == direction.up then
		player.y = math.clamp(player.y - (player.speed * dt), level.y, level.height)
	elseif player.direction == direction.down then 
	    player.y = math.clamp(player.y + (player.speed * dt), level.y, level.height - player.w + padding)
	elseif player.direction == direction.right then 
		player.x = math.clamp(player.x + (player.speed * dt), level.x, level.width - player.w + padding)
	elseif player.direction == direction.left then
	    player.x = math.clamp(player.x - (player.speed * dt), level.x, level.width)
	end

	if CheckCollision(player, treat) then
		player.score = player.score + 1
		treat.x, treat.y = randPos()
	end
end

function math.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end

function CheckCollision(box1, box2)
    if box1.x > box2.x + box2.w - 1 or -- Is box1 on the right side of box2?
       box1.y > box2.y + box2.h - 1 or -- Is box1 under box2?
       box2.x > box1.x + box1.w - 1 or -- Is box2 on the right side of box1?
       box2.y > box1.y + box1.h - 1    -- Is b2 under b1?
    then
        return false
    else
        return true
    end
end

function randPos()
	local x,y
	x = math.random(1, level.width)
	y = math.random(1, level.height)
	print("Random x"..x.." y"..y)
	return x,y
end

