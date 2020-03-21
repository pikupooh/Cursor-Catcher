
WINDOW_WIDTH = 600
ENEMY_WIDTH = 30
ENEMY_SPEED = 35
PADDING = 30
jump = false
gamestate = 1

function reset ()
  score = 0
  cursorX = 0
  cursorY = 0
  time = 0

  enemyX = WINDOW_WIDTH/2 - ENEMY_WIDTH
  enemyY = WINDOW_WIDTH - ENEMY_WIDTH

  enemycenterX = enemyX + ENEMY_WIDTH/2
  enemycenterY = enemyY + ENEMY_WIDTH/2

  count_down = 100
end

function love.load()
  love.window.setTitle('Cursor Catcher')
  love.window.setMode(WINDOW_WIDTH, WINDOW_WIDTH,{
    fullscreen = false,
    resizable = false,
    vsync = true
  })

  reset()

  count_down = 100

end

function resetCount ()
  count_down = math.random(30, 50)
end

function love.keypressed(key)
  if key == 'space' or key == 'return' then
    if gamestate == 1 then
      reset()
      gamestate = 2
    elseif gamestate == 3 then
      reset()
      gamestate = 1
    end
  end

  if key == 'escape' then
    if gamestate == 1 then
      love.event.quit(0)
    elseif gamestate == 3 then
      gamestate = 1
    end
  end

end

function love.update(dt)

  if gamestate == 2 then
    cursorX = love.mouse.getX()
    cursorY = love.mouse.getY()
    enemycenterX = enemyX + ENEMY_WIDTH/2
    enemycenterY = enemyY + ENEMY_WIDTH/2

    time = time + 1
    if time % 10 == 0 then
      score = score + 1
      time = 0
    end

    if cursorX <= ENEMY_WIDTH  or cursorX >= WINDOW_WIDTH - 1 - ENEMY_WIDTH then
      reset()
      goto outofbond
    end
    if cursorY <= ENEMY_WIDTH or cursorY >= WINDOW_WIDTH - 1 - ENEMY_WIDTH then
      reset()
      goto outofbond
    end

    count_down = count_down - 1
    if count_down == 0 then
      jump = true
      x = (cursorX - enemycenterX)
      y = (cursorY - enemyY)
      dx = x / math.sqrt(x*x + y*y)
      dy = y / math.sqrt(x*x + y*y)
      resetCount()
    end

    ::outofbond::

    if jump then
      enemycenterX = enemycenterX + dx * ENEMY_SPEED
      enemycenterY = enemycenterY + dy * ENEMY_SPEED
      enemyX = enemycenterX - ENEMY_WIDTH/2
      enemyY = enemycenterY - ENEMY_WIDTH/2
      if enemyX  < 0 or enemyX + ENEMY_WIDTH   > WINDOW_WIDTH or enemyY   < 0 or enemyY + ENEMY_WIDTH  > WINDOW_WIDTH then
        jump = false
      end

      if jump == false then
        if enemyX > WINDOW_WIDTH - ENEMY_WIDTH then
          enemyX = WINDOW_WIDTH - ENEMY_WIDTH
        end
        if enemyX < 0 then
          enemyX = 0
        end
        if enemyY > WINDOW_WIDTH - ENEMY_WIDTH then
          enemyY = WINDOW_WIDTH - ENEMY_WIDTH
        end
        if enemyY < 0 then
          enemyY = 0
        end
      end
    end

    if cursorX < enemyX + ENEMY_WIDTH  and cursorX > enemyX  then
      if cursorY < enemyY + ENEMY_WIDTH  and cursorY > enemyY  then
        jump = false
        gamestate = 3
      end
    end
  end

end


function love.draw()

  --[[love.graphics.print(tostring(dx))
  love.graphics.print('dx: '..tostring(dx), 0 , 10)
  love.graphics.print('dy: '..tostring(dy), 0, 20)
  love.graphics.print(tostring(dy), 0, 30)
  love.graphics.print(tostring(count_down), 0 , 40)
  love.graphics.print("jump: "..tostring(jump),0,50)]]
  if gamestate == 2 then
    love.graphics.print('SCORE: ' ..tostring(score) , WINDOW_WIDTH - 100, 0)
    love.graphics.printf('PLAYZONE', 0, 0, WINDOW_WIDTH, 'center')
    love.graphics.rectangle('fill', enemyX, enemyY, ENEMY_WIDTH, ENEMY_WIDTH)
    love.graphics.setLineWidth(1)
    love.graphics.line(ENEMY_WIDTH, ENEMY_WIDTH, WINDOW_WIDTH - ENEMY_WIDTH, ENEMY_WIDTH)
    love.graphics.line(ENEMY_WIDTH, WINDOW_WIDTH - ENEMY_WIDTH, WINDOW_WIDTH - ENEMY_WIDTH, WINDOW_WIDTH - ENEMY_WIDTH)
    love.graphics.line(ENEMY_WIDTH, ENEMY_WIDTH, ENEMY_WIDTH, WINDOW_WIDTH - ENEMY_WIDTH)
    love.graphics.line(WINDOW_WIDTH - ENEMY_WIDTH, ENEMY_WIDTH, WINDOW_WIDTH - ENEMY_WIDTH, WINDOW_WIDTH - ENEMY_WIDTH)
  elseif gamestate == 3 then
    love.graphics.rectangle('fill', enemyX, enemyY, ENEMY_WIDTH, ENEMY_WIDTH)
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle('fill', cursorX, cursorY, 5)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("GAME OVER",0 ,  WINDOW_WIDTH/2-50, WINDOW_WIDTH, 'center')
    love.graphics.printf("SCORE: " .. tostring(score),0 ,  WINDOW_WIDTH/2+50, WINDOW_WIDTH, 'center')
  elseif gamestate == 1 then
    love.graphics.printf('CURSOR CATCHER', 0, WINDOW_WIDTH/2 - 50 , WINDOW_WIDTH, 'center')
    love.graphics.printf('PRESS ENTER OR SPACE TO PLAY', 0, WINDOW_WIDTH/2 + 50 , WINDOW_WIDTH, 'center')
  end
end
