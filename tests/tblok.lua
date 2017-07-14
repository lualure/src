-- # tableok : unit tests for table

require "show"	
local rand=  require "random"
local the=  require "config"
local o=    require "tests"	
local tbl=  require "tbl"
local row=  require "row"
local super=require "superrange"
local lst=require "lists"
----------------------------------------------------------
-- process 14 rows
 local function _test1()
   local t=tbl.create(the.here .. "/data/weather.csv")
  print(t.spec)
   assert(#t.rows==14)
   assert(t.rows[14].cells[1]=="rainy")
   assert(o.nstr(t.all.nums[1].mu,4) == o.nstr(73.5714,4))
   assert(o.nstr(t.all.nums[1].sd,4) ==  o.nstr(6.5717,4))
   assert(t.x.syms[1].counts["overcast"] == 4)
   assert(t.x.syms[2].counts["TRUE"]==6)
end
----------------------------------------------------------
-- process 400 rows
local function _test3()
  local function someShow(i,j) 
    local r=i.rows[j]
    local tmp={j,r.dom}
    for _,c in pairs(i.goals)  do
      tmp[#tmp+1] = r.cells[c.pos] end
    print(tmp)
  end
  local t=tbl.create(the.here .. "/data/auto.csv")
  tbl.dominates(t)
  for j=1,5 do someShow(t,j) end
  print(t.spec)
  print("...")
  for j=#t.rows-5,#t.rows do someShow(t,j) end
  --for i=1,250 do row.dominates(t.rows[i],t) print(t.rows[i].dom) end
end 
----------------------------------------------------------
local function lookup(x,ran)
  if x==the.ignore then return x end
  local r
  for j=1,#ran do
    r=ran[j].label
    if x<=ran[j].most then return r end end
  return r end
----------------------------------------------------------
local function _test4()
   local t1=tbl.create(the.here .. "/data/auto.csv")
   local t2=tbl.t0()
   tbl.header(t2, tbl.discretizeHeaders(t2))
   print(22)
   local bins={}
   for _,head in pairs(t1.x.nums) do
     bins[head.pos] =  super(t1.rows, 
                        function (_) return _.cells[head.pos] end,
                        function (_) return row.dominate(_,t1) end) end

    for k=1,#t1.rows do
       local tmp=lst.copy(t1.rows[k].cells)
       for pos,ran in pairs(bins) do
         --print(pos,ran)
         tmp[pos] = lookup(tmp[pos],ran) end
       print(k,tmp)
       --print(t2.x.cols[2])
       tbl.update(t2,tmp) end end 
---------------------------------------------
rand.r(1)

-- o.k{_test1,_test2,_test3,test4}
_test4()


