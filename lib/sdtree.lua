-- # sdtree : iterative divisions to minimize sd

-- Assumes discrete data

require "show"
local the=require "config"
local num=require "num"
local lst=require "lists"
local row=require "row"
local tbl=require "tbl"
local str=require "str"
------------------------------------------------
local function create(t,what,stats)  return {
  _here=t,
  what=what,
  stats=stats,
  _kids={}}
end
------------------------------------------------
local function splits(t,y,z,     cols) 
  y = y or function (_) return row.dominate(_,t) end
  z = z or function (_) return _.sd end
  -----------------------------------------------
  local function xpect(col)
    if not col._score then
      col._score=0
      for _,num in pairs(col.nums) do
        col._score = col._score+ z(num)* num.n / col.n end end
    return col._score end
  -----------------------------------------------
  local function whatif(head)
    local col = {pos=head.pos, what=head.txt, nums={},_score=nil,n=0} 
    for _,row in pairs(t.rows) do
       local x = row.cells[col.pos]
       if x ~= the.ignore then
         col.n = col.n + 1
         col.nums[x] = num.update(col.nums[x] or num.create(), 
                                  y(row))  end end
    return col end
  -------------------  
  return lst.sort( lst.collect(t.x.cols, whatif),
                   function(a,b) 
                     return xpect(a) < xpect(b) end)
end

------------------------------------------------
local function grow1(t,y,z,sd0,lvl,    
                     stats,cut,kids,node,useful) -- locals
  -- convenience function
  local function dom(_)  return row.dominate(_,t) end
  local function doms(_) return num.updates(t.rows, dom) end
  -- termination criteria
  if #t.rows < the.tree.min  then return end
  if lvl > the.tree.maxDepth then return end
  stats = doms()
  if sd0 and  stats.sd >= sd0 then return end 
  print(string.rep("|... ",lvl))
  -- find best column for splitting
  cut=  splits(t,y,z)[1]
  -- divide the rows on that column's value
  kids= {}
  for _,r in pairs(t.rows) do
    local val = r.cells[cut.pos]
    if val ~= the.ignore then  -- remember to skip the ignores
      local b4  = kids[val] or {}
      b4[#b4+1] = r.cells   -- push row onto the cache
      kids[val] = b4 end end
  -- return a node
  node = create(t,cut.txt,stats)
  for kid,rows in pairs(kids) do
    tmp = grow1(tbl.copy(t,rows), y,z,stats.sd,lvl+1) 
    if tmp then node._kids[kid] = tmp end end
  -- if no kid was useful then do not return the useless node
  return node 
end 

local function grow(t)
  return grow1(t,nil,nil,nil,0) end

local function tprint(tr,    lvl)
  if tr then
    lvl = lvl or 0
    print(str.fmt("n= %5.0f mu=%8.3f sd=%8.3f",tr.stats.n, tr.stats.mu, tr.stats.sd), tr)
          --string.rep("|   ",lvl)) -- ..  tr.what .. " = " .. tr.what)
    for what,tr1 in pairs(tr._kids) do
      tprint(tr1,lvl+1) end end end
  

return {splits=splits,grow=grow,show=tprint}
