-- # sdtree : iterative divisions to minimize sd

-- Assumes discrete data

require "show"
local the=require "config"
local num=require "num"
local lst=require "lst"
------------------------------------------------
local function create(t0,rows)  return {
  here=tbl.copy(t0,rows),
  breaks={}}
end
------------------------------------------------
local function rankcolumns(t,head, y,z,     cols) 
  y = y or function (_) row.dominate(_,t) end
  z = z or function (_) return z.sd end
  -----------------------------------------------
  local function xpect(col)
    if not col._score then
      col._score=0
      for _,num in pairs(col.nums) do
        col._score = col.w + z(num)* num.n / col.n end end
    return col._score end
  -----------------------------------------------
  local function gather(head)
    local col = {_score = nil, pos=head.pos, nums={},n=0} 
    for _,row in t.rows do
       local x = row.cells[col.pos]
       if x ~= the.ignore then
         col.n = col.n + 1
         col.nums[x] = num.update(col.nums[x] or num.create(), 
                                  y(row))  end end
    return col end
  -------------------  
  return lst.sort( collect(t.x.cols, gather),
                   function(a,b) 
                     return xpect(a) < xpect(b) end)
end
