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
local function _test4()
   local t1=tbl.create(the.here .. "/data/auto.csv")
   local t2=tbl.discretize(t1)
   print("rows ",#t1.rows, #t2.rows)
   local function order(t,x,y) return row.dominate(x,t) < row.dominate(y,t) end 
   table.sort(t1.rows,function(x,y) return order(t1,x,y) end)
   table.sort(t2.rows,function(x,y) return order(t2,x,y) end)
   lst.maprint(t1.rows,5,-5) 
   print("--")
   lst.maprint(t2.rows,5,-5) end
---------------------------------------------
rand.r(1)
-- o.k{_test1,_test2,_test3,test4}
_test4()


