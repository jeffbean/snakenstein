Class = require "vendor.hump.class"

local Player = Class{}

local GRID_SIZE = 10
local direction = {
	up = 0,
	down = 1,
	right = 2,
	left = 3
}

function Player:init(world, x, y, color)
	self.world = world
	-- TODO: not default to direction right since many players willl start different places
    self.direction = direction.right
	self.x = x
	self.y = y

	self.speed = 100
	self.color = color
    self.score = 0
	self.body = love.physics.newBody(self.world, self.x, self.y, "dynamic")
	self.shape = love.physics.newCircleShape(20)
    self.fixture = love.physics.newFixture(self.body, self.shape)


	self.fixture:setUserData("Player")
	-- -- for the many parts of the snake, start with 3 units
	-- for i=1, self.score+3, 1 do
		-- print("Putting snake" .. i .. " at position x" .. self.x .. " y" .. self.y)
		-- table.insert(self.entities.body, Player(self.x + GRID_SIZE * i, self.y + GRID_SIZE * i))
	-- end
end

function Player:draw()
    love.graphics.setColor(self.color) 
	-- draw the head thing
	love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
	-- love.graphics.rectangle("fill", self.x, self.y, GRID_SIZE, GRID_SIZE)
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
	if love.keyboard.isDown('right') then
		self.body:applyLinearImpulse(10, 0)
	end
	if love.keyboard.isDown('left') then
	    self.body:applyLinearImpulse(-10, 0)
	end
	if love.keyboard.isDown('up') then
		self.body:applyLinearImpulse(0, -10)
	end
	if love.keyboard.isDown('down') then
		self.body:applyLinearImpulse(0, 10)
	end
	print("player..", self.direction, ".. x:[", self.body:getX(), "]")
end

return Player