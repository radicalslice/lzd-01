function new_baddie(x, y)
  local baddie = {
      sprite = 16,
      x = x,
      y = y,
      starting_x = x,
      starting_y = y,
      dx = 0,
      dy = 0,
      height = 8,
      width = 8,
      direction = 3,
      state = "init",
      ttl = 0,
  }

  return baddie
end

function baddie_draw(baddie)
  spr(baddie.sprite + baddie.direction, baddie.x, baddie.y)
end

function baddie_update(baddie)
  baddie.ttl -= 1
  local fake_x, fake_y = baddie.x,baddie.y
  fake_x += baddie.dx
  fake_y += baddie.dy
  if baddie.direction == BTN_R then
    fake_x += 6
  end
  if baddie.direction == BTN_D then
    fake_y += 6
  end
  local curr_map_x = fake_x \ 8
  local curr_map_y = fake_y \ 8
  local bitmask = fget(mget(curr_map_x, curr_map_y))
  if (bitmask & (1 << 0) > 0) or (bitmask & (1 << 1) > 0) then
    -- do something else!
    if baddie.direction == BTN_R then
      baddie.direction = BTN_L
      walk_left(baddie)
    elseif baddie.direction == BTN_L then
      baddie.direction = BTN_R
      walk_right(baddie)
    elseif baddie.direction == BTN_U then
      baddie.direction = BTN_D
      walk_down(baddie)
    elseif baddie.direction == BTN_D then
      baddie.direction = BTN_U
      walk_up(baddie)
    end
    return
  else
    baddie.x += baddie.dx
    baddie.y += baddie.dy
  end

  if baddie.ttl <= 0 then
    -- make a decision
    if rnd() > 0.2 then -- gives a value between 0 and 1.0
      -- 80% of the time
      baddie.state = "walk"
      -- minimum of 30 frames and 150 frames
      baddie.ttl = ceil(rnd(120) + 30)

      baddie.direction = flr(rnd(4))

      local vel = 0.1
      if baddie.direction == BTN_U then
        walk_up(baddie)
      elseif baddie.direction == BTN_D then
        walk_down(baddie)
      elseif baddie.direction == BTN_R then
        walk_right(baddie)
      elseif baddie.direction == BTN_L then
        walk_left(baddie)
      end
    else
      baddie.state = "wait"
      baddie.dx = 0
      baddie.dy = 0
      baddie.ttl = ceil(rnd(15) + 15)
    end
  end
end

function walk_up(sprite)
  local vel = 0.3
  sprite.dx = 0
  sprite.dy = -vel
end

function walk_right(sprite)
  local vel = 0.3
  sprite.dx = vel
  sprite.dy = 0
end

function walk_left(sprite)
  local vel = 0.3
  sprite.dx = -vel
  sprite.dy = 0
end

function walk_down(sprite)
  local vel = 0.3
  sprite.dx = 0
  sprite.dy = vel
end

baddie_m = {
  baddies = {}
}

baddie_m.update = function()
  foreach(baddie_m.baddies, function(b) baddie_update(b) end)
end

baddie_m.draw = function()
  foreach(baddie_m.baddies, function(b) baddie_draw(b) end)
end

baddie_m.handle_attacked = function(payload)
  del(baddie_m.baddies, payload.baddie)

  if #baddie_m.baddies == 0 then
    q.add_event("room_clear")
  end

end

