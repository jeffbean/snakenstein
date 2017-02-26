Class = require "vendor.hump.class"

local Wall = Class{}

function Wall:init(world, points, color)
    self.world = world
    self.points = points

    self.x = self.points[1]
	self.y = self.points[2]
	self.width, self.height = self.points[3], self.points[4]
	self.color = color
    
    self.body = love.physics.newBody(self.world, self.x, self.y, "static") 
    self.shape = love.physics.newRectangleShape(unpack(self.points))
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData("Wall")
end

function Wall:draw()
    love.graphics.setColor(self.color) 
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end

function Wall:update(dt)
end

return Wall