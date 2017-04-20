Class = require "vendor.hump.class"

local Wall = Class{}

function Wall:init(points, color)
    self.points = points

    self.x, self.y = self.points[1],  self.points[2]
	self.w, self.h = self.points[3], self.points[4]
	self.color = color
    
    -- self.body = love.physics.newBody(self.world, self.x, self.y, "static") 
    -- self.shape = love.physics.newRectangleShape(unpack(self.points))
    -- self.fixture = love.physics.newFixture(self.body, self.shape)
    -- self.fixture:setUserData("Wall")
end

function Wall:draw()
    love.graphics.setColor(self.color) 
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function Wall:update(dt)
end

return Wall