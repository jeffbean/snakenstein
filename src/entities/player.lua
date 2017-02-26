Class = require "vendor.hump.class"

local Player = Class{}

function Player:init(world, x, y, color)
    self.world = world
    self.x = x
	self.y = y
	self.color = color

    self.score = 0
        
    self.body = love.physics.newBody(self.world, self.x, self.y, "dynamic") 
    self.shape = love.physics.newCircleShape(20)
    self.fixture = love.physics.newFixture(self.body, self.shape)

    self.fixture:setUserData("Player")
	self.fixture:setRestitution(0.1) --let the player bounce
	self.fixture:setFriction(0.9) -- set friction..
end

function Player:draw()
    love.graphics.setColor(self.color) 
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
end

return Player