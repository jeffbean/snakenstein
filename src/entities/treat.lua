Class = require "vendor.hump.class"

local Treat = Class{}

function Treat:init(x, y, w, h, color)
    self.x = x
	self.y = y
    self.w = w  
    self.h = h
	self.color = color

    -- self.body = love.physics.newBody(self.world, self.x, self.y, "static") 
    -- self.shape = love.physics.newRectangleShape(self.w, self.h)
    -- self.fixture = love.physics.newFixture(self.body, self.shape, 1) -- density of 1

    -- self.fixture:setUserData("Treat")
end

function Treat:draw()
    love.graphics.setColor(self.color) 
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end

function Treat:update(dt)
end

return Treat