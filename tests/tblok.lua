-- # tableok : unit tests for table

require "show"	
local the=  require "config"
local o=    require "tests"	
local tbl=  require "tbl"
local row=  require "row"
local super=require "superrange"
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
   local t=tbl.create(the.here .. "/data/auto.csv")
   for _,head in pairs(t.x.nums) do
     print("")
     for j,ran in pairs(super(t.rows, 
                        function (z) return z.cells[head.pos] end,
                        function (z) return row.dominate(z,t) end)) do
        print(head.pos,j,ran)
    end end  end

----------------------------------------------------------
local function _test5(    t1)
   local t=tbl.create(the.here .. "/data/weather.csv")
   t1=tbl.copy(t,"full")
  print(t)
  print("==")
  print(t1)
 end
---------------------------------------------------------
-- o.k{_test1,_test2,_test3,test4}
_test5()


