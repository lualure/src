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
local function create(t,yfun,pos,attr,val)  
  return { _t=t, 
          _kids={},
          yfun = yfun,
          pos=pos, -- split data at this pos
          attr= attr, val= val, 
          stats= num.updates(t.rows,  yfun)}
end
-----------------------------------------------
local function splits(t,y)
  local function xpect(col)
    local tmp = 0
    for _,x in pairs(col.nums) do
      tmp = tmp +  x.sd * x.n / col.n end 
    return tmp end
  -----------------------------------------------
  local function whatif(head,y)
    local col = {pos=head.pos, what=head.txt, nums={},n=0} 
    for _,row in pairs(t.rows) do
       local x = row.cells[col.pos]
       if x ~= the.ignore then
         col.n = col.n + 1
         col.nums[x] = num.update(col.nums[x] or num.create(), 
                                  y(row))  end end
    return {key=xpect(col), val=col} end
  -------------------  
  local out = {}
  for _,h in pairs(t.x.cols) do 
    out[#out+1] = whatif(h,y) end
  table.sort(out, function (x,y) 
                      return x.key < y.key end)
  return lst.collect(out, function (x) 
                              return x.val end) end
------------------------------------------------
local function grow1(above,yfun,rows,lvl,b4,pos,attr,val)
  local function pad()       return str.fmt("%-20s",string.rep('| ',lvl)) end
  local function likeAbove() return tbl.copy(above._t,rows)  end
  --print(pad())
  if #rows >= the.tree.min then 
    if lvl <= the.tree.maxDepth then 
      local here = lvl == 0 and above or create(likeAbove(), yfun,pos,attr,val) 
      if here.stats.sd < b4 then 
        if lvl > 0 then 
          above._kids[ #above._kids+1 ] = here 
        end
        local cuts= splits(here._t, yfun) -- where to split?
        local cut= cuts[1] -- where to split?
        -- divide the rows on the values in that split
        local kids= {}
        for _,r in pairs(rows) do
          local val = r.cells[cut.pos]
          if val ~= the.ignore then  -- remember to skip the ignores
            local rows1    = kids[val] or {}
            rows1[#rows1+1] = r  -- push row 
            kids[val]     = rows1 end end
        -- return a node
        for val,rows1 in pairs(kids) do
          if #rows1 <  #rows then
            grow1(here,yfun,rows1,lvl+1,here.stats.sd,cut.pos,cut.what,val) 
  end end end end end end
------------------------------------------------
local function grow(t, y)
  local yfun = tbl[y](t)
  local root = create(t,yfun)
  grow1(root, yfun, t.rows,0,10^32) 
  return root end
------------------------------------------------
local function tprint(tr,    lvl)
  local function pad()       return string.rep('| ',lvl-1) end
  local function left(x)     return str.fmt("%-20s",x) end
  lvl = lvl or 0
  local suffix=""
  if #tr._kids == 0 or lvl ==0 then
      suffix =  str.fmt("n=%s mu=%-.2f sd=%-.2f",
                        tr.stats.n, tr.stats.mu, tr.stats.sd) end
  if lvl ==0 then
    print("\n".. suffix)
  else
    print(left(pad() .. (tr.attr or "") .. " = " .. (tr.val or "")),
          "\t:",suffix) end 
  for j=1,#tr._kids do
      tprint(tr._kids[j],lvl+1) end end  
---------------------------------------------
local function leaf(tr,cells,  lvl)
  lvl=lvl or 0
  for j,kid in pairs(tr._kids) do
    local pos,val = kid.pos, kid.val
    if cells[kid.pos] == kid.val then
      return leaf(kid, cells, bins, lvl+1) end end 
  return tr end
--------------------------------------------
return {splits=splits,grow=grow,show=tprint,leaf=leaf}
