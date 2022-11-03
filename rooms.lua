door_m = {
  doors = {}
}

door_m.draw = function()
  foreach(door_m.doors, function(d) door_draw(d) end)
end

door_m.handle_room_clear = function()
  foreach(door_m.doors, function(door)
    door.state = "open"
    if door.direction == 0 or door.direction == 1 then
      mset(door.x \ 8, door.y \ 8, 10)
      mset(door.x \ 8, (door.y \ 8) + 1, 10)
    else
      mset(door.x \ 8, door.y \ 8, 10)
      mset((door.x  \ 8) + 1, door.y \ 8, 10)
    end
  end)
end

function door_draw(door)
  if door.state == "open" then
    if door.direction == 0 or door.direction == 1 then
      spr(10, door.x, door.y)
      spr(10, door.x, door.y + 8)
    else 
      spr(10, door.x, door.y)
      spr(10, door.x + 8, door.y)
    end
  else
    -- draw shutter
    if door.direction == 0 or door.direction == 1 then
      mset(door.x \ 8, door.y \ 8, 11)
      mset(door.x \ 8, (door.y \ 8) + 1, 11)
    else 
      mset(door.x \ 8, door.y \ 8, 11)
      mset((door.x  \ 8) + 1, door.y \ 8, 11)
    end
  end
end

function new_door(x, y, direction, state)
    local tmp = {
      x = x,
      y = y,
      direction = direction,
      state = state,
    }

    if direction == 0 or direction == 1 then
      tmp.height = 16
      tmp.width = 8
    else
      tmp.width = 16
      tmp.height = 8
    end

    return tmp
end

function new_item(x, y)
    local tmp = {
      x = x,
      y = y,
      height = 8,
      width = 8,
    }

    return tmp
end

function item_draw(item)
  spr(48, item.x, item.y)
end

item_m = {
  items = {}
}

item_m.draw = function()
  foreach(item_m.items, function(d) item_draw(d) end)
end

room1 = {
  start_x=0,
  start_y=0,
  end_x=12,
  end_y=12,
  baddies = {
    new_baddie(48,24),
  },
  items = {},
  doors = {
    new_door(80, 32, 1, "shut"),
  }
}

room2 = {
  start_x=10,
  start_y=0,
  end_x=21,
  end_y=12,
  baddies = {
    new_baddie(128,24),
    new_baddie(128,42),
  },
  items = {},
  doors = {
    new_door(88, 32, 0, "shut"),
    new_door(120, 80, 3, "shut"),
  }
}

room3 = {
  start_x=10,
  start_y=10,
  end_x=20,
  end_y=18,
  baddies = {},
  items = {
    new_item(124, 124)
  },
  doors = {
    new_door(120, 88, 2, "open"),
  }
}

rooms = {
  { room1, room2 },
  { nil, room3 },
}
