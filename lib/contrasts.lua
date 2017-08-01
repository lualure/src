require "show"
local THE=require "config"
local TREE=require "sdtree"
local TREES=require "trees"
local LST=require "lists"
local NUM=require "num"
-----------------------------------------------------
local function has(branch)
  local out = {}
  for i=1,#branch do
    step = branch[i]
    out[#out+1] = {attr=step.attr, val=step.val} end 
  return out end

local function have(branches)
  for _,branch in pairs(branches) do
    branch.has = has(branch) end 
  return branches end
-----------------------------------------------------
local function branches1(tr,out,b)
  if tr.attr then
    b[#b+1] = {attr=tr.attr,val=tr.val,_stats=tr.stats} end
  if #b > 0 then out[#out+1] = b   end
  for _,kid in pairs(tr._kids) do
      branches1(kid,out,LST.copy(b)) end  
  return out end

local function branches(tr)
  return have(branches1(tr,{},{})) end
-----------------------------------------------------
local function member2(twin0,twins) 
  for _,twin1 in pairs(twins) do
    if twin0.attr == twin1.attr and
       twin0.val == twin1.val then
       return true end end
  return false end

local function delta(held1, held2) 
  local out={}
  for _,twin in pairs(held1) do
    if not member2(twin,held2) then
      out[#out+1] = {twin.attr, twin.val} end end
  return out end

------------------------------------------------------
local function plans(branches, better)
  better = better or function(x,y) return x > y end
  for i,branch1 in pairs(branches) do
    local out={}
    for j,branch2 in pairs(branches) do
      if i ~= j then
        local num1=LST.last(branch1)._stats
        local num2=LST.last(branch2)._stats
        if better(num2.mu, num1.mu)  then
          if not NUM.same(num1,num2) then
            local inc = delta(branch2.has,branch1.has)
            if #inc > 0 then
              out[#out+1] = {i=i,j=j,ninc=#inc,muinc=num2.mu - num1.mu,
                             inc=inc, branch1=branch1.has,mu1=num1.mu, 
                             branch2=branch2.has,mu2=num2.mu}
               end end end end end 
    print("")
    table.sort(out, function (x,y) return x.muinc > y.muinc end)
    print(i,"max mu  ",out[1])
    table.sort(out, function (x,y) return x.ninc < y.ninc end)
    print(i,"min inc ",out[1])

    end end

local function monitors(branches)
  return plans(branches, function(x,y)
               return x < y end) end

return {monitors=monitors, plans=plans,branches=branches}

