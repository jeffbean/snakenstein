package.path = package.path .. ";../../?.lua"
sock = require "sock"
bitser = require "spec.bitser"

-- Utility functions
function isColliding(this, other)
    return  this.x < other.x + other.w and
            this.y < other.y + other.h and
            this.x + this.w > other.x and
            this.y + this.h > other.y
end

function love.load()
    -- how often an update is sent out
    tickRate = 1/60
    tick = 0

    server = sock.newServer("*", 22122, 2)
    server:setSerialization(bitser.dumps, bitser.loads)

    -- Players are being indexed by peer index here, definitely not a good idea
    -- for a larger game, but it's good enough for this application.
    server:on("connect", function(data, client)
        -- tell the peer what their index is
        client:send("playerNum", client:getIndex())
    end)

    -- receive info on where a player is located
    server:on("mouseY", function(y, client)
        local index = client:getIndex()
        players[index].y = y
    end)
    server:on("mouseX", function(x, client)
        local index = client:getIndex()
        players[index].x = x
    end)

    function newPlayer(x, y)
        return {
            x = x,
            y = y,
            w = 20,
            h = 20,
        }
    end

    function newTreat(x, y)
        return {
            x = x,
            y = y,
            w = 10,
            h = 10,
        }
    end

    local marginX = 50

    players = {
        newPlayer(marginX, love.graphics.getHeight()/2),
        newPlayer(love.graphics.getWidth() - marginX, love.graphics.getHeight()/2)
    }

    treat = newTreat(love.graphics.getWidth()/2, love.graphics.getHeight()/2)

    scores = {0, 0}

end

function love.update(dt)
    server:update()

    -- wait until 2 players connect to start playing
    local enoughPlayers = #server.clients >= 2
    if not enoughPlayers then return end

    for i, player in pairs(players) do
        if isColliding(treat, player) then
          scores[i] = scores[i] + 1
          treat.x = love.math.random(0, love.graphics.getWidth())
          treat.y = love.math.random(0, love.graphics.getHeight())

          server:sendToAll("scores", scores)

          player.x = love.graphics.getWidth()/2
          player.y = love.graphics.getHeight()/2
        end
    end

    tick = tick + dt

    if tick >= tickRate then
        tick = 0

        for i, player in pairs(players) do
            server:sendToAll("playerState", {i, player})
        end

        server:sendToAll("treatState", treat)
    end
end

function love.draw()
    for i, player in pairs(players) do
        love.graphics.rectangle('fill', player.x, player.y, player.w, player.h)
    end

    love.graphics.rectangle('fill', treat.x, treat.y, treat.w, treat.h)

    local score = ("%d - %d"):format(scores[1], scores[2])
    love.graphics.print(score, 5, 5)
end
