Class = require "vendor.hump.class"

local Player = Class{}

local CHAIN_PART_RADIUS = 10
local CHAIN_PART_COUNT = 5

function Player:init(world, x, y, color)
    self.world = world
    self.x = x
	self.y = y
	self.color = color
	self.image = love.graphics.newImage("images/chain.png")

    self.score = 0

    -- body
    self.head = love.physics.newBody(self.world, self.x, self.y, "dynamic") 
    self.head:setLinearDamping(5)
    self.head:setMass (0.1)
    -- end of snake, will be last chained part
    self.tail = love.physics.newBody(self.world, self.x + 50, self.y + 50, "dynamic")
    self.tail:setLinearDamping(2)
    self.tail:setMass (0.1)
    -- shape

    self.shape = love.physics.newCircleShape(12)
    -- Head fixture
    self.headFixture = love.physics.newFixture(self.head, self.shape)
    self.headFixture:setUserData("Head")
	self.headFixture:setRestitution(0.1) --let the player bounce
	self.headFixture:setFriction(0.1) -- set friction..
	self.headFixture:setCategory(2)  

    -- Tail section
    self.tailFixture = love.physics.newFixture(self.tail, self.shape)
    self.tailFixture:setUserData("Tail")
	self.tailFixture:setCategory(3) 

    -- create chain parts
    self.chain = {}

	for i = 1, CHAIN_PART_COUNT, 1 do
		local part = {}
		part.body = love.physics.newBody(world, 0, 0, "dynamic")
		part.shape = love.physics.newCircleShape(5)
		part.fixture = love.physics.newFixture(part.body, part.shape)
		part.fixture:setUserData("chain")
		part.body:setPosition(i*CHAIN_PART_RADIUS,0)
		part.body:setLinearDamping(8)

		-- chainparts should not collide with itself
		part.fixture:setGroupIndex(-1)
		part.fixture:setMask(2, 3, 4);

		table.insert(self.chain, part)

		if (i>1) then
			--love.physics.newWeldJoint(self.chain[i-1].body, self.chain[i].body, 20/2, 0, -20/2, 0, false)
			love.physics.newRevoluteJoint(self.chain[i-1].body, self.chain[i].body, i*CHAIN_PART_RADIUS - CHAIN_PART_RADIUS/2, 0, false)
		end
	end
    -- first body attach rope
	love.physics.newRopeJoint(self.head, self.chain[1].body, self.head:getX(), self.head:getY(), self.chain[1].body:getX(), self.chain[1].body:getY(), self.shape:getRadius(), true)
    love.physics.newRopeJoint(self.chain[CHAIN_PART_COUNT].body, self.tail, self.chain[CHAIN_PART_COUNT].body:getX(), self.chain[CHAIN_PART_COUNT].body:getY(), self.tail:getX(), self.tail:getY(), self.shape:getRadius(), true)

    local startX, startY = self.head:getPosition()
    local aimX, aimY = self.tail:getPosition()
    for i = 1, CHAIN_PART_COUNT, 1 do
        local chainX = startX + (i/CHAIN_PART_COUNT) * (aimX - startX)
        local chainY = startY + (i/CHAIN_PART_COUNT) * (aimY - startY)
        self.chain[i].body:setPosition(chainX, chainY)
    end
end

function Player:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.head:getX(), self.head:getY(), self.shape:getRadius())
	love.graphics.setColor(255, 255, 255, 50)
    for i = 1, CHAIN_PART_COUNT, 1 do
		love.graphics.draw(self.image, self.chain[i].body:getX(), self.chain[i].body:getY(), self.chain[i].body:getAngle(), 1,1,self.image:getWidth() /2, self.image:getHeight()/2)
	end
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.tail:getX(), self.tail:getY(), self.shape:getRadius())

end

function Player:update(dt)
    if love.keyboard.isDown('right') then
		self.head:applyForce(200, 0)
	end
	if love.keyboard.isDown('left') then
	    self.head:applyForce(-200, 0)
	end
	if love.keyboard.isDown('up') then
		self.head:applyForce(0, -200)
	end
	if love.keyboard.isDown('down') then
		self.head:applyForce(0, 200)
	end
end

return Player