-- ### Reading classified data
-- 
-- _tim@menzies.us_   
-- _August'17_   
--
--
local TBL=require "tbl"
local CSV=require "csv"

local function create() return {
  all=TBL.createPrim(),
  eden=true,
  klass={} } end

local function thisKlass(i, cells)
  local k = TBL.klass(i.all, cells)
  if not i.klass[k] then
    i.klass[k] = TBL.copy(i.all) end
  return i.klass[k] end
  
local function update(i,cells) 
  if not i.eden then
    TBL.update( thisKlass(i, cells), cells)
  end
  i.eden = false 
  TBL.update(i.all, cells) end

local function classify(i, cells)

end
local function fromCsv(f)
  local out = create()
  CSV(f, function (cells)  update(out,cells) end)
  return out end

return {create=fromCsv, update=update}
