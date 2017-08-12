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
  nk=0,
  klass={} } end

local function thisKlass(i, cells)
  local k = TBL.klass(i.all, cells)
  if not i.klass[k] then
    i.nk = i.nk + 1
    i.klass[k] = TBL.copy(i.all) end
  return i.klass[k] end
  
local function update(i,cells) 
  if not i.eden then
    TBL.update( thisKlass(i, cells), cells)
  end
  i.eden = false 
  TBL.update(i.all, cells) end

local function like(i, cells)
  guess,best= nil, -1*10^64
  for this, t in pairs(i.klass) do
    guess = guess or this
    local like = (#t.rows + the.nb.k) / 
                 (#i.all.rows + the.nb.k*i.nk)
    local prior= like
    for _,head in pairs(t.x.cols) do
      x = cells[head.pos]
      if x ~= the.ignore then 
        like = like * head.what.like(head, x, prior)
      end  end
    if like > best then
      guess,best = this,like end 
  end
  return guess
end
local y,n=0,0 -- horrid hack 
----------------------------------------------
local function incNB(i, cells, log)
  if #i.all.rows > 0 then 
    if like(i,cells) ==  TBL.klass(i.all,cells)  then
      y = y+1 
    else
      n = n+1 
    end  
    io.write(" " .. math.floor(100*y/(y+n)))
  end
  update(i, cells)  
end
-------------------------------
local function fromCsv(f)
  local out = create()
  CSV(f, function (cells)  update(out,cells) end)
  return out end

-------------------------------
local function fromCsv(f,g)
  g = g or update
  local out = create()
  CSV(f, function (cells) g(out,cells) end)
  return out end

return {create=fromCsv, update=update,incNB=incNB}
