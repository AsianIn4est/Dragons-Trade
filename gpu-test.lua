local component = require("component")
local event = require("event")
local gpu = component.gpu

local mx, my = gpu.getResolution()
gpu.fill(1, 1, mx, my, " ")

while 1 do
 
  local e, _, x, y, b, p = event.pull()
  if e == "touch" then
    gpu.set(x,y,"+"..x..";"..y)
    gpu.set(1,1,b.."["..x..", "..y.."] - "..p)
  end
  if b == 1 then gpu.fill(1,1,mx,my,' ') end
end
