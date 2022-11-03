cam = {
  x=0,
  y=0,
  tgt_x=0,
  tgt_y=0,
  vel_x=0,
  vel_y=0,
}

cam.handle_cammove_start = function(payload)
  printh("plx: "..payload.tgt_x)
  printh("ply: "..payload.tgt_y)
  cam.set_tgt(cam.x + payload.tgt_x, cam.y + payload.tgt_y, 30)
end

cam.set_tgt = function(new_x, new_y, frames)
  cam.tgt_x = new_x
  cam.tgt_y = new_y

  local dx = cam.tgt_x - cam.x
  local dy = cam.tgt_y - cam.y
  
  cam.vel_x = dx \ frames
  cam.vel_y = dy \ frames
end

cam.update = function()
  local tolerance = 5

  if cam.tgt_x != cam.x then
    cam.x += cam.vel_x
    if abs(cam.x - cam.tgt_x) < tolerance then
      cam.x = cam.tgt_x
      cam.vel_x = 0
      q.add_event("cammove_done")
    end
  end

  if cam.tgt_y != cam.y then
    cam.y += cam.vel_y
    if abs(cam.y - cam.tgt_y) < tolerance then
      cam.y = cam.tgt_y
      cam.vel_y = 0
      q.add_event("cammove_done")
    end
  end
end

