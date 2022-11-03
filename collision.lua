function collides(s0, s1)
  local offset_0x, offset_0y = 0,0
  local offset_1x, offset_1y = 0,0

  if s0.width < 8 then
    offset_0x = (8 - s0.width) \ 2
  end

  if s0.height < 8 then
    offset_0y = (8 - s0.height) \ 2
  end

  if s1.width < 8 then
    offset_1x = (8 - s1.width) \ 2
  end

  if s1.height < 8 then
    offset_1y = (8 - s1.height) \ 2
  end

  if (
    (offset_0x + s0.x) < (offset_1x + s1.x + s1.width)
    and (offset_0x + s0.x + s0.width) > (s1.x + offset_1x)
    and (offset_0y + s0.y + s0.height) > (s1.y + offset_1y)
    and (offset_0y + s0.y) < (offset_1y + s1.y + s1.height)
    ) then
    return true
  end

  return false
end
