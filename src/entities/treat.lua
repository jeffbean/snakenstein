Class = require "vendor.hump.class"

local Treat = Class{}

function Treat:init(world, x, y, w, h, color)
    self.world = world
    self.x = x
	self.y = y
    self.w = w  
    self.h = h
	self.color = color

    self.isFlagged = false

    self.body = love.physics.newBody(self.world, self.x, self.y, "static") 
    self.shape = love.physics.newRectangleShape(self.w, self.h)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1) -- density of 1

    self.fixture:setUserData("Treat")
end

function Treat:draw()
    love.graphics.setColor(self.color) 
    love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
end

function Treat:update(dt)
    if self.isFlagged then
		x, y = randPos()
		self.body:setPosition(x, y)
		self.isFlagged = false
	end
end

return Treat