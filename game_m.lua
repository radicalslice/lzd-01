game_m = {}

game_m.handle_cammove_done = function()
  __update = game_update 
end

game_m.handle_load_room = function(payload)
  __update = nextroom_update
  current_room_row += payload.new_room_row
  current_room_col += payload.new_room_col

  local curr_x, curr_y = current_room.start_x,current_room.start_y
  --- before this!
  current_room = load_room(current_room_row,current_room_col)
  local new_x, new_y = current_room.start_x,current_room.start_y
  -- after this we know the new room coords
  q.add_event("cammove_start", {
    tgt_x = (new_x - curr_x) * 8,
    tgt_y = (new_y - curr_y) * 8,
  })
end

game_m.handle_get_end_item = function()
  __update = end_update 
  __draw = end_draw 
end
