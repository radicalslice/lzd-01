player = {
  sprite = 0,
  x = 16,
  y = 24,
  dx = 0,
  dy = 0,
  ttl = 30,
  height = 8,
  width = 8,
  health = 3,
  invincible_ttl = 90,
  direction = 3,
  weapon = nil,
  state = "base",
}

function new_weapon(x, y, direction)
  local width, height = 0,0
  if direction == BTN_U or direction == BTN_D then
    width = 2
    height = 16
    if direction == BTN_U then
      y -= 16
    else
      y += 8
    end
  else
    width = 16
    height = 2
    if direction == BTN_L then
      x -= 16
    else
      x += 8
    end
  end
  local tmp = {
    x=x,
    y=y,
    direction=direction,
    width=width,
    height=height,
    state="base",
  }

  tmp.update = function()
  
  end

  tmp.draw = function()
    if direction == BTN_U then
      spr(34, tmp.x, tmp.y)
      spr(34, tmp.x, tmp.y + 8)
    elseif direction == BTN_D then
      spr(34, tmp.x, tmp.y)
      spr(34, tmp.x, tmp.y + 8)
    elseif direction == BTN_R then
      spr(32, tmp.x, tmp.y)
      spr(32, tmp.x + 8, tmp.y)
    elseif direction == BTN_L then
      spr(32, tmp.x, tmp.y)
      spr(32, tmp.x + 8, tmp.y)
    end
  end

  return tmp
end

player.draw = function()
  if player.invincible_ttl > 0 then
    local clothing_colors = {9, 10, 11}
    local body_colors = {12,13,14}
    pal(9, clothing_colors[(frame_counter % #clothing_colors)+1])
    pal(12, body_colors[(frame_counter % #body_colors)+1])
  end

  spr(player.sprite + player.direction, player.x, player.y)

  if player.weapon != nil then
    player.weapon.draw()
  end

  pal()
end

function player_update_base()

  if btnp(BTN_O) then
    player.state = "attacking"
    player.ttl = 30
    player.weapon = new_weapon(player.x,player.y,player.direction)
    return
  end

  player.dx = 0
  player.dy = 0

  local vel = 0.8

  if btn(BTN_L) then
    player.dx = -vel
    player.direction = BTN_L
  end

  if btn(BTN_R) then
    player.dx += vel
    player.direction = BTN_R
  end

  if btn(BTN_U) then
    player.dy = -vel
    player.direction = BTN_U
  end

  if btn(BTN_D) then
    player.dy = vel
    player.direction = BTN_D
  end

  local fake_x, fake_y = player.x,player.y
  fake_x += player.dx
  fake_y += player.dy
  if player.dx > 0 then
    fake_x += 6
  end
  if player.dy > 0 then
    fake_y += 6
  end
  
  local curr_map_x = (fake_x \ 8)
  local curr_map_y = (fake_y \ 8)

  if fget(mget(curr_map_x, curr_map_y), 0) then
    player.dx = 0
    player.dy = 0
    return
  else
    player.x += player.dx
    player.y += player.dy
  end
end

function player_update_attacking()
  player.ttl -= 1

  if player.ttl < 0 then
    player.state = "base"
    player.ttl = 0
    player.weapon = nil
  end
end

player.update = function()
  if player.state == "base" then
    player_update_base()
  elseif player.state == "attacking" then
    player_update_attacking()
  end

  if player.invincible_ttl > 0 then
    player.invincible_ttl -= 1
  end

  if player.weapon != nil then
    player.weapon.update()
  end
end

player.handle_collision = function()
  if player.invincible_ttl == 0 then
    player.health -= 1

    if player.health <= 0 then
      player.x = 16
      player.y = 24
      player.state = "base"
      player.weapon = nil
      player.health = 3
    end

    player.invincible_ttl = 90
  end
end

player.handle_load_room = function()
  if player.direction == 0 then
    player.x -= 25
  elseif player.direction == 1 then
    player.x += 25
  elseif player.direction == 2 then
    player.y -= 25
  else
    player.y += 25
  end
end
