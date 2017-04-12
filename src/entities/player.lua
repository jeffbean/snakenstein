Class = require "vendor.hump.class"

local Player = Class{}

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
	-- -- for the many parts of the snake, start with 3 units
	-- for i=1, self.score+3, 1 do
		-- print("Putting snake" .. i .. " at position x" .. self.x .. " y" .. self.y)
		-- table.insert(self.entities.body, Player(self.x + GRID_SIZE * i, self.y + GRID_SIZE * i))
	-- end
end

function Player:draw()
    love.graphics.setColor(self.color) 
	-- draw the head thing
	-- love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
	love.graphics.rectangle("fill", self.x, self.y, GRID_SIZE, GRID_SIZE)
    -- for _,o in ipair(self.entities.body) do
        -- love.graphics.rectangle("fill", o.x, o.y, GRID_SIZE, GRID_SIZE)
    -- end
end

function Player:update(dt)
	-- In the case of snake we should be always moving in a direction and will change statefully with a key
	if love.keyboard.isDown('right') then
		-- This makes sure that the character doesn't go pass the game window's right edge.
		if self.direction ~= direction.left then 
			self.direction = direction.right
		end
	elseif love.keyboard.isDown('left') then
		-- This makes sure that the character doesn't go pass the game window's left edge.
		if self.direction ~= direction.right then 
			self.direction = direction.left
		end
	elseif love.keyboard.isDown('up') then
		if self.direction ~= direction.down then
			self.direction = direction.up
		end
	elseif love.keyboard.isDown('down') then
		if self.direction ~= direction.up then
			self.direction = direction.down
		end
	end
	-- self.body:(true)
	-- if self.direction == direction.up then
	-- 	self.body:setY(self.body:getY() - (self.speed * dt))
	-- elseif self.direction == direction.down then 
	--     self.body:setY(self.body:getY() + (self.speed * dt))
	-- elseif self.direction == direction.right then 
	-- 	self.body:setX(self.body:getX() + (self.speed * dt))
	-- elseif self.direction == direction.left then
	--     self.body:setX(self.body:getX() - (self.speed * dt))
	-- end
	-- if love.keyboard.isDown('right') then
	-- 	self.body:applyLinearImpulse(10, 0)
	-- end
	-- if love.keyboard.isDown('left') then
	--     self.body:applyLinearImpulse(-10, 0)
	-- end
	-- if love.keyboard.isDown('up') then
	-- 	self.body:applyLinearImpulse(0, -10)
	-- end
	-- if love.keyboard.isDown('down') then
	-- 	self.body:applyLinearImpulse(0, 10)
	-- end
	if self.direction == direction.up then
		self.y = math.clamp(self.y - (self.speed * dt), 15, height)
	elseif self.direction == direction.down then 
	    self.y = math.clamp(self.y + (self.speed * dt), 15, height - GRID_SIZE)
	elseif self.direction == direction.right then 
		self.x = math.clamp(self.x + (self.speed * dt), 15, width - GRID_SIZE)
	elseif self.direction == direction.left then
	    self.x = math.clamp(self.x - (self.speed * dt), 15, width)
	end
	-- if CheckCollision(self, objects.entities) then
	-- 	player.score = player.score + 1
	-- 	treat.x, treat.y = randPos()
	-- end
	print("player..", self.direction, ".. x:[", self.x, "]")
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

return Player