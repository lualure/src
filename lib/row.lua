local id=  require "id"
local lst= require "lists"
local num= require "num"
-----------------------------------------------------------

local function create()
  return {id=id.new(),   cells={}} end
-----------------------------------------------------------
local function update(i,cells,t)
  i.cells=lst.copy(cells)
  for _,head in pairs(t.all.cols) do
    head.what.update(head, cells[head.pos]) end
  return i end
-----------------------------------------------------------
local function copy(i)
  local j = create()
  j.cells = lst.copy(i.cells)
  return j
end
----------------------------------------------------------
local function distance(i,j,t)
  local d,n=0,10^-64
  for _,col in pairs(t.x.cols) do
    local f = col.what.distance
    local d1,n1 = f(col, i.cells[col.pos], j.cells[col.pos])
    d = d + d1
    n = n + n1 end
  return d^0.5 / n^0.5 end
-----------------------------------------------------------
local function x(i,west,east,t,      c)
  local c= c or distance(west,east,t)
  local b= distance(i,east,t)
  local a= distance(i,west, t)
  return (a^2 + c^2 - b^2) / (2*c),c  
end
-----------------------------------------------------------
local function extrapolate(i,west, east,f,t,c)
  -- west is the lesser of west,east
  local x0,c = x(i,west,east,t,c)
  local x1,x2,y1,y2 = 0,c,f(west,t), f(east,t)
  local m  = (y2 - y1) / (x2 - x1) -- rise/run
  local b  = y2 - m*x2  -- the slope
  return m * x0 + b
end
------------------------------------------------------------
local function dominate1(i,j,t)
  local e,n = 2.71828,#t.goals
  local sum1,sum2=0,0
  for _,col in pairs(t.goals)  do
    local w= col.weight
    local x= num.norm(col, i.cells[col.pos])
    local y= num.norm(col, j.cells[col.pos])
    sum1 = sum1 - e^(w * (x-y)/n)
    sum2 = sum2 - e^(w * (y-x)/n) 
  end 
  return sum1/n < sum2/n 
end
-----------------------------------------------------------
local function dominate(i,t) 
  local tmp = 0
  for x,j in pairs(t.rows) do
    if i.id ~= j.id then 
      if dominate1(i,j,t) then
        tmp= tmp + 1  end end end 
  return tmp end
--i.dom end
-----------------------------------------------------------
return {create=create, update=update,dominate=dominate,copy=copy}
