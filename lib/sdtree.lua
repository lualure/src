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
local function create(t,attr,val)  
  local function dom(_)  return row.dominate(_,t) end
  local function doms(_) return num.updates(t.rows, dom) end
  return { _t=t, _kids={},
          attr= attr, val= val, 
          stats= doms()}
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
local function grow1(above,rows,lvl,b4,attr,val)
  local function pad() return string.rep('|.. ',1+lvl) end
  if #rows >= the.tree.min then 
    if lvl <= the.tree.maxDepth then 
      local here = lvl == 0 and above or create(tbl.copy(above,rows),attr,val)
      print(pad(), #here._)
      if here.stats.sd < b4 then 
        above._kids[ #above._kids+1 ] = here
        print("here> ",here._t)
        print(splits(here._t))
        local cut= splits(here._t)[1] -- where to splot?
        print("cut", cut)
        -- divide the rows on the values in that split
        local kids= {}
        for _,r in pairs(rows) do
          print("r",pad(),r)
          local val = r.cells[cut.pos]
          if val ~= the.ignore then  -- remember to skip the ignores
            local with    = kids[val] or {}
            with[#with+1] = r  -- push row 
            kids[val]     = with end end
        -- return a node
        for val,with in pairs(kids) do
          print(#with)
          grow1(here,with,lvl+1,here.stats.sd,cut.what,val) 
end end end end end
------------------------------------------------
local function grow(t)
  local root = create(t)
  grow1(root, t.rows,0,10^32) 
  return root end
------------------------------------------------
local function tprint(tr,    lvl)
  if tr then
    lvl = lvl or 0
    print(str.fmt("n= %5.0f mu=%8.3f sd=%8.3f",tr.stats.n, tr.stats.mu, tr.stats.sd), tr)
          --string.rep("|   ",lvl)) -- ..  tr.what .. " = " .. tr.what)
    for what,tr1 in pairs(tr._kids) do
      tprint(tr1,lvl+1) end end end

return {splits=splits,grow=grow,show=tprint}
