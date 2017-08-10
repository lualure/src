require "show"
local R=require "random"
local no="?"
local id=0
local some=1.05

---------------------------------------------
-- ### Misc utils

local function newid() id=id+1; return id end

local function shuffle( t )
  for i= 1,#t do
    local j = i + math.floor((#t - i) * R.r() + 0.5)
    t[i],t[j] = t[j], t[i] 
  end
  return t end
---------------------------------------------
-- ### Rows of tables
local function ROW(tbl,cells)  return {
  id=newid(),
  cells=cells } end

---------------------------------------------
-- ### `Num`eric columns

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
  local function distance(num,x,y) 
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
      hi= -10^64,
      col= col}
  num.update = function (x)   return update(num,x) end 
  num.distance = function (x,y) return distance(num,x,y) end
  return num
end 
---------------------------------------------
-- ### `Sym`bolic columns

local function SYM(col)
  local function distance(x,y) 
    if     x==no and j==no then return 0,0
    elseif x==no           then return 1,1
    elseif y==no           then return 1,1
    elseif x==y            then return 0,1
    else                        return 1,1 end 
  end ------------------------------------------
  return {
    col      = col,
    update   = function (x) return x end,
    distance = distance} 
end 
------------------------------------------
-- ### Tables 

local function TABLE(rows0,xcols,ycols) 
  local function types(cells,out) 
    for j,v in pairs(cells) do
      what = type(v) == 'number' and NUM or SYM
      out[#out+1] = what(col) end
    return out 
  end ----------------------
  local function update(t,cells) 
    t.rows[#t.rows] = ROW(cells)
    for i,x in pairs(t.headers) do x.update(cells[i]) end 
  end ----------------------
  local function updates(t, listOfCells) 
    for _,cells in pairs(listOfCells) do update(t,cells) end
  end ---------------------
  local function distance(t, row1, row2, cols) 
    cols = cols or t.xcols
    local d,n = 0, 10^-64
    for i in some(cols) do 
      incd, incn = header[i].dist(row1[i].cells, row2[i].cells)
      d = d + incd
      n = n + incn end
    return d^0.5/n^0.5 
  end ---------------------
  local function furthest(t,one)
     local best,out=-1,one
     for j,row in pairs(t.rows) do
        local d= distance(t,one,two) 
        if d > best then
          best,out=d,two end end
     return out
  end
  local function defaultXcols(most,out)
    for i=1, most - 1 do out[#out+1]  = i end
    return out
  end ---------------------
  t= {
    types = types(rows0[1],{}),
    xcols = xcols or defaultXcols(#rows0[1], {}),
    ycols = ycols or {#rows0[1]},
    rows  = {},
    updates= function (rows) return updates(t,rows) end  } 
  updates( shuffle(rows0))
  t.west = furthest(t, t.rows[1])
  t.east = furthest(t, t.west) 
  return tbl
end
------------------------------------------
local function xyc(row,west,east,t,      c)
  local a= distance(t,row,west)
  local b= distance(t,row,east)
  local c= c or distance(t,west,east)
  local x= (a^2 + c^2 - b^2) / (2*c)  
  y= a^2 - x^2
  y= y < 0 and 0 or y^0.5
  return x, y, c, b > some*c, a > some*c
end
