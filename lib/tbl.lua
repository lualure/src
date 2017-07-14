-- # table : utilities

local the=require "config"
local num=require "num"
local sym=require "sym"
local row=require "row"
local csv=require "csv"
local lst=require "lists"
-------------------------------------------------------------
local function create() return {
  rows={}, 
  spec={}, 
  goals={} , less={}, more={}, 
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
  print("::: ",cells)
  i.spec = cells
  for col,cell in ipairs(cells) do
    local what, weight, wheres = meta(i,cell)
    local one = what.create()
    one.pos   = col
    one.txt   = cell
    one.what  = what
    one.weight= weight
    for _,where in pairs(wheres) do
      where[ #where + 1 ] = one end end end
-------------------------------------------------------------
local function data(i,cells)
  i.rows[#i.rows+1] = row.update(row.create(), cells,i) end
-------------------------------------------------------------
local function update(i,cells) 
  local fn= #i.spec==0 and header or data
  fn(i,cells) end
-------------------------------------------------------------
local function copy(i, mode) 
  local j=create()
  header(j, lst.copy(i.spec)) 
  if mode=="full" then
    for _,row in pairs(i.rows) do
      data(j, lst.copy(row.cells)) end 
  elseif type(mode)=='number' then
    lst.shuffle(i.rows)
    for k=1,mode do
      data(j, lst.copy(i.rows[k].cells)) end end
  return j
end
-------------------------------------------------------------
local function discretizeHeaders(i)
  local function discretizeHeader(z)  
    return string.gsub(z , "%$","") end
  return lst.collect(i.spec, discretizeHeader) end
-------------------------------------------------------------
local function discretize (i,j)
   local ranges=sup
   local j=create()
   header(j, lst.collect(i.spec, discretizeHeader))
   --for _,head in pairs(i.x.nums) do
     --print(ranges(i.rows, function (z) z.cells[head.pos] end ,
       --                   function (z) row.dominate(z,i) end)) end
end
-------------------------------------------------------------
local function dominates(i)
  for _,r in pairs(i.rows) do 
    row.dominate(r,i) end
  table.sort(i.rows,function (r1,r2) 
                      return r1.dom > r2.dom end) end
-------------------------------------------------------------
local function fromCsv(f)
  local out = create()
  csv(f, function (cells) update(out,cells) end)
  return out end
-------------------------------------------------------------
return {copy=copy, t0=create,dominates=dominates,header=header,update=update,
        create=fromCsv,  discretizeHeaders=discretizeHeaders}


        -- discretizeations hould be inside tbl
