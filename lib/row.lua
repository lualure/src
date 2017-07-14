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
  if not i.dom then
    i.dom=0
    for x,j in pairs(t.rows) do
      if i.id ~= j.id then 
        if dominate1(i,j,t) then
          i.dom = i.dom + 1  end end end end 
  return i.dom end
-----------------------------------------------------------
return {create=create, update=update,dominate=dominate}
