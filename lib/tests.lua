------------------------------------------------------
local pass,fail = 0,0
local builtin = { 
  math=true, package=true, 
  table=true, coroutine=true, os=true, 
  io=true, bit32=true, string=true, 
  arg=true, debug=true, _VERSION=true, _G=true,
  load=true, xpcall=true, type=true, print=true,
  pcall=true, require=true, tonumber=true,
  getmetatable=true, setmetatable=true, ipairs=true,
  tostring=true, loadfile=true, collectgarbage=true,
  next=true, rawequal=true, rawget=true, rawlen=true,
  pairs=true, error=true, dofile=true, unpack=true,
  select=true, loadstring=true, module=true, assert=true,
  rawset=true, gcinfo=true, setfenv=true, jit=true,
  bit=true, newproxy=true, getfenv=true}
-------------------------------------------------------
local function report() 
  print(string.format(
        ":pass %s :fail %s :percentPass %.0f%%",
         pass, fail, 100*pass/(0.001+pass+fail))) end
-------------------------------------------------------
local function globals()
  for k,v in pairs( _G ) do
    --if type(v) ~= 'function' then  
       if not builtin[k] then 
         print("-- Global: " .. k) end end end --end
------------------------------------------------------
local function tests(t)
  for s,x in pairs(t) do  
    print("# test:", s) 
    pass = pass + 1
    local t1= os.clock()
    local passed,err = pcall(x) 
    local t2= os.clock()
    print((t2-t1) .. " secs")
    if not passed then   
       fail = fail + 1
       print("Failure: ".. err) end end end
------------------------------------------------------
local function nstr(x,n)
  return  string.format("%.".. n .."f",x) end
------------------------------------------------------
local function main(t) 
  if next(t) ~= nil then tests(t) end 
  report()
  globals()  end
------------------------------------------------------
return {k=main,nstr=nstr}
