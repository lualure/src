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
  local function pad()       return str.fmt("%-20s",string.rep('| ',lvl)) end
  local function likeAbove() return tbl.copy(above._t,rows)  end
  if #rows >= the.tree.min then 
    if lvl <= the.tree.maxDepth then 
      local here = lvl == 0 and above or create(likeAbove(), attr,val) 
      if here.stats.sd < b4 then 
        above._kids[ #above._kids+1 ] = here
        local cut= splits(here._t)[1] -- where to splot?
        print(str.fmt("%5.2f %5.2f %5s",here.stats.mu, here.stats.sd, here.stats.n),
              pad(),attr,val)
        -- divide the rows on the values in that split
        local kids= {}
        for _,r in pairs(rows) do
          local val = r.cells[cut.pos]
          if val ~= the.ignore then  -- remember to skip the ignores
            local with    = kids[val] or {}
            with[#with+1] = r  -- push row 
            kids[val]     = with end end
        -- return a node
        for val,with in pairs(kids) do
          if #with <  #rows then
            grow1(here,with,lvl+1,here.stats.sd,cut.what,val) end end end end end end
------------------------------------------------
local function grow(t)
  local root = create(t)
  grow1(root, t.rows,0,10^32) 
  print(#root._kids)
  return root end
------------------------------------------------
local function tprint(tr,    seen,lvl)
  local function pad()       return string.rep('| ',lvl-1) end
  local function left(x)     return str.fmt("%-20s",x) end
  lvl = lvl or 0
  seen= seen or {}
  if not seen[tr]  then
    seen[tr] = true
    local suffix=""
    if #tr._kids == 0 then
      suffix =  str.fmt("\t: n=%s mu=%-.2f sd=%-.2f",tr.stats.n, tr.stats.mu, tr.stats.sd) end
    print(left(pad() .. (tr.attr or "") .. " = " .. (tr.val or "")), suffix)
    for j=1,#tr._kids do
        tprint(tr._kids[j],seen,lvl+1) end end  end
---------------------------------------------
---- leaft prune with t-test.
---- print the ranges

return {splits=splits,grow=grow,show=tprint}
