local no=="?"
local id=0
local some=1.05
local function newid() id=id+1; return id end

local function NUM(col) 
  local function norm(num,x)
    return (x - num.lo) / (num.hi - num.lo + 1e-32) 
  end ---------------------------------------------
  local function update(num,x) 
    if x ~= no then
      if x < num.lo then num.lo = x end
      if x > num.hi then num.hi = x end
    end
    return x 
  end --------------------------------------------
  local function dist(num,x,y) 
    if x==no and y== no then
      return 0,0 
    elseif x==no then
      y = norm(num,y)
      x = y < 0.5 and 1 or 0 
    elseif y==no then
      x = norm(num,x)
      y = y < 0.5 and 1 or 0
    else
      x = norm(num,x)
      y = norm(num,y)
    end
    return (x-y)^2, 1 
  end -------------------------------------------
  local num = {
      lo=  10^64,
      hi= -10^64
      col= col}
  num.update = function (x)   return update(num,x) end 
  num.dist   = function (x,y) return dist(num,x,y) end
  return num
end 
------------------------------------------------
local function SYM(col)
  local function dist(j,k) 
    if     j==no and k==no then return 0,0
    elseif j==no           then return 1,1
    elseif k==no           then return 1,1
    elseif j==k            then return 0,1
    else                        return 1,1 end 
  end ------------------------------------------
  return {
    col    = col,
    update = function (x) return x end,
    dist   = dist} 
end 
------------------------------------------
local function dist(heads, row1, row2) 
  d,n=0,10^-64
  for i,head in pairs(heads) do
    incd, incn = head.dist(head,row1[i].cells, row2[i].cells)
    d = d + incd
    n = n + incn end
  return d^0.5/n^0.5 end

function create() {
  east=
}
local tbl={}
do
local function types(cells) 
  local out={}
  for j,v in pairs(cells) do
    what = type(v) == 'number' and NUM or SYM
    out[#out+1] = what(col) end
  return out end

local function row(cells) return {
  cells=cells,
  id= newid() } end

  local function create()  return {
   rows=rows
}
local function xyc(row,west,east,t,      c)
  local a= distance(t,row,west)
  local b= distance(t,row,east)
  local c= c or distance(t,west,east)
  local x= (a^2 + c^2 - b^2) / (2*c)  
  y= a^2 - x^2
  y= y < 0 and 0 or y^0.5
  return x, y, c, b > some*c, a > some*c
end
