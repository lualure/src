-- # table : utilities

local the=require "config"
local num=require "num"
local sym=require "sym"
local row=require "row"
local csv=require "csv"
local lst=require "lists"
local super=require "superrange"
-------------------------------------------------------------
local function create() return {
  rows={}, 
  spec={}, 
  goals={} , less={}, more={}, 
  index={},
  -- goals={less={}, more={}, cols={}}
  all={nums={}, syms={}, cols={}}, -- all columns
  x  ={nums={}, syms={}, cols={}}, -- all independent columns
  y  ={nums={}, syms={}, cols={}}  -- all depednent   columns
} end
-------------------------------------------------------------
local function meta(i,txt)
  local spec =  {
    {when= "%$", what= num, weight= 1, where= {i.all.cols, i.x.cols, i.all.nums,                  i.x.nums}},
    {when= "<",  what= num, weight=-1, where= {i.all.cols, i.y.cols, i.all.nums, i.goals, i.less, i.y.nums}},
    {when= ">",  what= num, weight= 1, where= {i.all.cols, i.y.cols, i.all.nums, i.goals, i.more, i.y.nums}},
    {when= "!",  what= sym, weight= 1, where= {i.all.cols, i.y.cols,             i.all.syms}},
    {when= "",   what= sym, weight= 1, where= {i.all.cols, i.x.cols,             i.all.syms,      i.x.syms}}}
  for _,want in pairs(spec) do
    if string.find(txt,want.when) ~= nil then
      return want.what, want.weight, want.where end end end
-------------------------------------------------------------
local function header(i,cells)
  i.spec = cells
  for col,cell in ipairs(cells) do
    local what, weight, wheres = meta(i,cell)
    local one = what.create()
    one.pos   = col
    one.txt   = cell
    one.what  = what
    one.weight= weight
    i.index[one.txt] = one
    for _,where in pairs(wheres) do
      where[ #where + 1 ] = one end end end
-------------------------------------------------------------
local function data(i,cells)
  local new = row.update(row.create(),cells,i)
  i.rows[#i.rows+1] = new
  return new end
-------------------------------------------------------------
local function update(i,cells) 
  local fn= #i.spec==0 and header or data
  return fn(i,cells) end
-------------------------------------------------------------
local function copy(i, from) 
  local j=create()
  header(j, lst.copy(i.spec)) 
  if from=="full" then
    for _,r in pairs(i.rows) do
      data(j, lst.copy(r.cells))  end
  elseif type(from)=='number' then
    lst.shuffle(i.rows)
    for k=1,from do
      data(j, lst.copy(i.rows[k].cells)) end 
  elseif type(from)=='table' then
    for _,r in pairs(from) do
      data(j, lst.copy(r.cells)) end end
  return j 
end
-------------------------------------------------------------
local function dominates(i)
  local cache={}
  for j,r in pairs(i.rows) do 
    io.write(j .. '.')
    cache[r.id] = row.dominate(r,i) end
  return cache end
--  table.sort(i.rows,function (r1,r2) 
--                      return cache[r1.id] > cache[r2.id]  end) end
-------------------------------------------------------------
local function lookup(x,breaks,    r)
  if x==the.ignore then return x end
  for _,b in pairs(breaks) do
    r = b.label
    if x<=b.most then break end end
  return r end
-------------------------------------------------------------
local function firstNumericGoal(i,r)
  return r.cells [ i.y.nums[1].pos ] end 
-------------------------------------------------------------
local function discretize(i, y,   ys)
  y = y or firstNumericGoal -- y has 2 args: table and row
  ---- local convenience functions
  local function discretizeHeader(z)  
    return string.gsub(z , "%$","") end
  --
  local function allYvalues(ys)
    for _,r in pairs(i.rows) do 
      ys[r.id] = y(i,r) end 
    return ys end
  ----- main sequence
  local j= create()
  header(j, lst.collect(i.spec, discretizeHeader))
  -- keep list of columns we are changing
  local todo = lst.collect(i.x.nums, function (_) return _.pos end )
  -- cache all the y values (important for slow inference)
  local ys = ys or allYvalues({}) --XXX get rid of this an go for rawy
  -- find all the bins we need
  for _,k in pairs(todo) do
    local cooked = j.all.cols[k]
    cooked.bins = super(i.rows, 
           function (_) return _.cells[cooked.pos] end,
           function (_) return ys[_.id]  end) end
  -- apply that bin knowledge to the data
  for k,row in pairs(i.rows) do
    local tmp=lst.copy(row.cells)
    -- print(tmp)
    for _,k in pairs(todo) do
      local cooked    = j.all.cols[k]
      local new       = sym.discretize(cooked, tmp[cooked.pos])  
      tmp[cooked.pos] = new end
    data(j,tmp) 
  end 
  -- all done
  return j end
-------------------------------------------------------------
local function fromCsv(f)
  local out = create()
  csv(f, function (cells) update(out,cells) end)
  return out end
-------------------------------------------------------------
return {copy=copy, dominates=dominates,header=header,update=update,
        create=fromCsv,  dominates=dominates,
        discretize=discretize,lookup=lookup}
