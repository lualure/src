require "show"
local THE = require "config"
local LST= require "lists"
-----------------------------
local function tiles(i,p, jump)
  local p    = p or 10
  local jump = jump or 1
  table.sort(i)
  local inc = #i / p
  local q,out = inc, {}
  while q < #i do
    out[#out+1] = i[ math.floor( q ) ]
    q = q + jump*inc end
  return out end
-------------------------------------
local function hows(t) 
  table.sort(t)
  return {
  width=50,
  lo = t[1],
  hi = t[#t],
  chops={{0.1,"-"},
         {0.3," "},
         {0.5," "},
         {0.7,"-"},
         {0.9," "}},
  bar="|",
  star="*",
  show= THE.sample.fmtnum or "%5.3f"} end
-------------------------------------------------
local function show(t, how)
  how = how or hows(t)
  local function fl(x)    return 1+ math.floor(x) end
  local function pos(p)   return t[ fl(p * #t) ] end
  local function place(x) return fl( how.width*(x- how.lo)/(how.hi - how.lo) ) end
  local function whats(chops)
          return  LST.collect(chops, function (_) return 
                              pos(_[1]) end ) end
  local function wheres(what) 
          return LST.collect(what, function (_) return 
                             place(_)  end ) end
  how.lo = math.min(how.lo, t[1])
  how.hi = math.max(how.hi, t[#t])
  local what   = whats(how.chops)
  local where  = wheres(what)
  local out={}
  for i=1,how.width + 1 do out[i] = " " end
  local b4=1
  for k,now in pairs(where) do
    if k> 1 then
      for i = b4,now  do
        out[i] = how.chops[k-1][2] end  end
    b4= now  end
  out[math.floor(how.width/2)] = how.bar
  out[place(pos(0.5))]    = how.star
  local suffix = LST.collect(what,  function (_) return
                     string.format(how.show,_) end) 
  return "(" .. table.concat(out,"") .. ")" .. 
                table.concat(suffix,", ") end
------------------------------------------------
local function shows(ts) 
  local lo,hi,out = 10^64, -10^64, {}
  for _,t in pairs(ts) do
    for _,v in pairs(t) do
      lo = math.min(lo, v)
      hi = math.max(hi, v) end
    table.sort(t)
    out[#out+1] = t  end
  table.sort(out, function(a,b) return 
                  a[math.floor(#a/2)] < b[math.floor(#b/2)] end )
  return LST.collect(out, function (t) 
                          local how = hows(t)
                          how.lo = lo
                          how.hi = hi
                          return show(t,how) end) end

return {tiles=tiles, show=show, shows=shows,how=hows}
