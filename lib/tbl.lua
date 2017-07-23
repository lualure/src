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
  name={},
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
    i.name[one.txt] = one
    for _,where in pairs(wheres) do
      where[ #where + 1 ] = one end end 
  return i end
-------------------------------------------------------------
local function data(i,cells,old)
  local new = row.update(row.create(),cells,i)
  i.rows[#i.rows+1] = new
  if old then
    new.id=old.id end
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
      data(j, lst.copy(r.cells),r) end end
  return j 
end
-------------------------------------------------------------
local function discretizeCells(i,cells) 
  out=lst.copy(cells)
  for _,head in pairs(i.x.cols) do
     out[head.pos] = sym.discretize(head,cells[head.pos]) end
  return out
end
-------------------------------------------------------------
local function goallast(t,n) 
  return function(r) 
           return lst.last(r.cells )  end  end

local function goaln(t,n) 
  return function(r) 
           return r.cells [ t.y.nums[n].pos ] end  end

local function goal1(t) 
  return goaln(t,1) end 

local function dom(t)
  local b4={}
  return function (r)   
           if not b4[r.id] then 
             io.write('.');b4[r.id]=row.dominate(r,t) end
           return b4[r.id] end end

local funs={goaln=goaln, goal1=goal1,dom=dom,goallast=goallast}
-------------------------------------------------------------
local function discretizeHeaders(spec)
  return lst.collect(spec, 
           function(txt) 
             return string.gsub(txt,"%$","") end) end
-------------------------------------------------------------
local function discretizeRows(i, y)
  -- 'j' is a table where all the numerics and symbols
  local j = header(create(), 
             discretizeHeaders(i.spec))
  -- each header in 'j' gets 'bins': a list saying how to
  -- change num into a sym
  local yfun = funs[y](i)
  for _,head in pairs(i.x.nums) do
    local cooked = j.all.cols[head.pos]
    local function x(r) return r.cells[cooked.pos] end
    cooked.bins = super(i.rows,x, yfun) 
  end
  -- each row in 'i' gets transformed, according to 'bins'
  for _,r in pairs(i.rows) do
    local tmp=lst.copy(r.cells)
    for _,head in pairs(i.x.nums) do
      local cooked    = j.all.cols[head.pos]
      local old       = tmp[cooked.pos]
      local new       = sym.discretize(cooked, old)
      tmp[cooked.pos] = new  end
    data(j,tmp,r) end 
  return j end
-------------------------------------------------------------
local function fromCsv(f)
  local out = create()
  csv(f, function (cells) update(out,cells) end)
  return out end
-------------------------------------------------------------
return {copy=copy, header=header,update=update,
        create=fromCsv,goal1=goal1,dom=dom,goaln=goaln,goallast=goallast,
        discretize=discretizeRows,discretize1=discretizeCells}
