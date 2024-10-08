require "show"
local R=require "random"

local function NUM() return{1,3,4} end
local function SYM() return{1,3,4} end
local nasa93=[[
?id,prec,flex,resl,team,pmat,rely,data,cplx,ruse,docu,time,stor,pvol,acap,pcap,pcon,apex,plex,ltex,tool,site,sced,$kloc,<effort,<defects,<months
1,h,h,h,vh,h,h,l,h,n,n,n,n,l,n,n,n,n,n,h,n,n,l,25.9,117.6,808,15.3
2,h,h,h,vh,h,h,l,h,n,n,n,n,l,n,n,n,n,n,h,n,n,l,24.6,117.6,767,15.0
3,h,h,h,vh,h,h,l,h,n,n,n,n,l,n,n,n,n,n,h,n,n,l,7.7,31.2,240,10.1
4,h,h,h,vh,h,h,l,h,n,n,n,n,l,n,n,n,n,n,h,n,n,l,8.2,36,256,10.4
5,h,h,h,vh,h,h,l,h,n,n,n,n,l,n,n,n,n,n,h,n,n,l,9.7,25.2,302,11.0
6,h,h,h,vh,h,h,l,h,n,n,n,n,l,n,n,n,n,n,h,n,n,l,2.2,8.4,69,6.6
7,h,h,h,vh,h,h,l,h,n,n,n,n,l,n,n,n,n,n,h,n,n,l,3.5,10.8,109,7.8
8,h,h,h,vh,h,h,l,h,n,n,n,n,l,n,n,n,n,n,h,n,n,l,66.6,352.8,2077,21.0
9,h,h,h,vh,h,h,l,h,n,n,xh,xh,l,h,h,n,h,n,h,h,n,n,7.5,72,226,13.6
10,h,h,h,vh,n,n,l,h,n,n,n,n,l,h,vh,n,vh,n,h,n,n,n,20,72,566,14.4
11,h,h,h,vh,n,n,l,h,n,n,n,n,l,h,h,n,vh,n,h,n,n,n,6,24,188,9.9
12,h,h,h,vh,n,n,l,h,n,n,n,n,l,h,vh,n,vh,n,h,n,n,n,100,360,2832,25.2
13,h,h,h,vh,n,n,l,h,n,n,n,n,l,h,n,n,vh,n,l,n,n,n,11.3,36,456,12.8
14,h,h,h,vh,n,n,l,h,n,n,n,n,h,h,h,n,h,l,vl,n,n,n,100,215,5434,30.1
15,h,h,h,vh,n,n,l,h,n,n,n,n,l,h,h,n,vh,n,h,n,n,n,20,48,626,15.1
16,h,h,h,vh,n,n,l,h,n,n,n,n,l,h,n,n,n,n,vl,n,n,n,100,360,4342,28.0
17,h,h,h,vh,n,n,l,h,n,n,n,xh,l,h,vh,n,vh,n,h,n,n,n,150,324,4868,32.5
18,h,h,h,vh,n,n,l,h,n,n,n,n,l,h,h,n,h,n,h,n,n,n,31.5,60,986,17.6
19,h,h,h,vh,n,n,l,h,n,n,n,n,l,h,h,n,vh,n,h,n,n,n,15,48,470,13.6
20,h,h,h,vh,n,n,l,h,n,n,n,xh,l,h,n,n,h,n,h,n,n,n,32.5,60,1276,20.8
21,h,h,h,vh,h,h,l,h,n,n,n,n,l,n,n,n,n,n,h,n,n,l,19.7,60,614,13.9
22,h,h,h,vh,h,h,l,h,n,n,n,n,l,n,n,n,n,n,h,n,n,l,66.6,300,2077,21.0
23,h,h,h,vh,h,h,l,h,n,n,n,n,l,n,n,n,n,n,h,n,n,l,29.5,120,920,16.0
24,h,h,h,vh,n,h,n,n,n,n,h,n,n,n,h,n,h,n,n,n,n,n,15,90,575,15.2
25,h,h,h,vh,n,h,n,h,n,n,n,n,n,n,h,n,h,n,n,n,n,n,38,210,1553,21.3
26,h,h,h,vh,n,n,n,n,n,n,n,n,n,n,h,n,h,n,n,n,n,n,10,48,427,12.4
27,h,h,h,vh,h,n,vh,h,n,n,vh,vh,l,vh,n,n,h,l,h,n,n,l,15.4,70,765,14.5
28,h,h,h,vh,h,n,vh,h,n,n,vh,vh,l,vh,n,n,h,l,h,n,n,l,48.5,239,2409,21.4
29,h,h,h,vh,h,n,vh,h,n,n,vh,vh,l,vh,n,n,h,l,h,n,n,l,16.3,82,810,14.8
29,h,h,h,vh,h,n,vh,h,n,n,vh,vh,l,vh,n,n,h,l,h,n,n,l,12.8,62,636,13.6
31,h,h,h,vh,h,n,vh,h,n,n,vh,vh,l,vh,n,n,h,l,h,n,n,l,32.6,170,1619,18.7
32,h,h,h,vh,h,n,vh,h,n,n,vh,vh,l,vh,n,n,h,l,h,n,n,l,35.5,192,1763,19.3
33,h,h,h,vh,h,h,l,h,n,n,n,n,l,n,n,n,n,n,h,n,n,l,5.5,18,172,9.1
34,h,h,h,vh,h,h,l,h,n,n,n,n,l,n,n,n,n,n,h,n,n,l,10.4,50,324,11.2
35,h,h,h,vh,h,h,l,h,n,n,n,n,l,n,n,n,n,n,h,n,n,l,14,60,437,12.4
36,h,h,h,vh,n,h,n,h,n,n,n,n,n,n,n,n,n,n,n,n,n,n,6.5,42,290,12.0
37,h,h,h,vh,n,n,n,h,n,n,n,n,n,n,n,n,n,n,n,n,n,n,13,60,683,14.8
38,h,h,h,vh,h,n,n,h,n,n,n,n,n,n,h,n,n,n,h,h,n,n,90,444,3343,26.7
39,h,h,h,vh,n,n,n,h,n,n,n,n,n,n,n,n,n,n,n,n,n,n,8,42,420,12.5
40,h,h,h,vh,n,n,n,h,n,n,h,n,n,n,n,n,n,n,n,n,n,n,16,114,887,16.4
41,h,h,h,vh,h,n,h,h,n,n,vh,h,l,h,h,n,n,l,h,n,n,l,177.9,1248,7998,31.5
42,h,h,h,vh,h,h,l,h,n,n,n,n,l,n,h,n,n,n,n,n,n,n,302,2400,8543,38.4
43,h,h,h,vh,h,n,h,l,n,n,n,n,h,h,n,n,h,n,n,h,n,n,282.1,1368,9820,37.3
44,h,h,h,vh,h,h,h,l,n,n,n,n,n,h,n,n,h,n,n,n,n,n,284.7,973,8518,38.1
45,h,h,h,vh,n,h,h,n,n,n,n,n,l,n,h,n,h,n,h,n,n,n,79,400,2327,26.9
46,h,h,h,vh,l,l,n,n,n,n,n,n,l,h,vh,n,h,n,h,n,n,n,423,2400,18447,41.9
47,h,h,h,vh,h,n,n,n,n,n,n,n,l,h,vh,n,vh,l,h,n,n,n,190,420,5092,30.3
48,h,h,h,vh,h,n,n,h,n,n,n,h,n,h,n,n,h,n,h,n,n,n,47.5,252,2007,22.3
49,h,h,h,vh,l,vh,n,xh,n,n,h,h,l,n,n,n,h,n,n,h,n,n,21,107,1058,21.3
50,h,h,h,vh,l,n,h,h,n,n,vh,n,n,h,h,n,h,n,h,n,n,n,78,571.4,4815,30.5
51,h,h,h,vh,l,n,h,h,n,n,vh,n,n,h,h,n,h,n,h,n,n,n,11.4,98.8,704,15.5
52,h,h,h,vh,l,n,h,h,n,n,vh,n,n,h,h,n,h,n,h,n,n,n,19.3,155,1191,18.6
53,h,h,h,vh,l,h,n,vh,n,n,h,h,l,h,n,n,n,h,h,n,n,n,101,750,4840,32.4
54,h,h,h,vh,l,h,n,h,n,n,h,h,l,n,n,n,h,n,n,n,n,n,219,2120,11761,42.8
55,h,h,h,vh,l,h,n,h,n,n,h,h,l,n,n,n,h,n,n,n,n,n,50,370,2685,25.4
56,h,h,h,vh,h,vh,h,h,n,n,vh,vh,n,vh,vh,n,vh,n,h,h,n,l,227,1181,6293,33.8
57,h,h,h,vh,h,n,h,vh,n,n,n,n,l,h,vh,n,n,l,n,n,n,l,70,278,2950,20.2
58,h,h,h,vh,h,h,l,h,n,n,n,n,l,n,n,n,n,n,h,n,n,l,0.9,8.4,28,4.9
59,h,h,h,vh,l,vh,l,xh,n,n,xh,vh,l,h,h,n,vh,vl,h,n,n,n,980,4560,50961,96.4
60,h,h,h,vh,n,n,l,h,n,n,n,n,l,vh,vh,n,n,h,h,n,n,n,350,720,8547,35.7
61,h,h,h,vh,h,h,n,xh,n,n,h,h,l,h,n,n,n,h,h,h,n,n,70,458,2404,27.5
62,h,h,h,vh,h,h,n,xh,n,n,h,h,l,h,n,n,n,h,h,h,n,n,271,2460,9308,43.4
63,h,h,h,vh,n,n,n,n,n,n,n,n,l,h,h,n,h,n,h,n,n,n,90,162,2743,25.0
64,h,h,h,vh,n,n,n,n,n,n,n,n,l,h,h,n,h,n,h,n,n,n,40,150,1219,18.9
65,h,h,h,vh,n,h,n,h,n,n,h,n,l,h,h,n,h,n,h,n,n,n,137,636,4210,32.2
66,h,h,h,vh,n,h,n,h,n,n,h,n,h,h,h,n,h,n,h,n,n,n,150,882,5848,36.2
67,h,h,h,vh,n,vh,n,h,n,n,h,n,l,h,h,n,h,n,h,n,n,n,339,444,8477,45.9
68,h,h,h,vh,n,l,h,l,n,n,n,n,h,h,h,n,h,n,h,n,n,n,240,192,10313,37.1
69,h,h,h,vh,l,h,n,h,n,n,n,vh,l,h,h,n,h,h,h,n,n,l,144,576,6129,28.8
70,h,h,h,vh,l,n,l,n,n,n,n,vh,l,h,h,n,h,h,h,n,n,l,151,432,6136,26.2
71,h,h,h,vh,l,n,l,h,n,n,n,vh,l,h,h,n,h,h,h,n,n,l,34,72,1555,16.2
72,h,h,h,vh,l,n,n,h,n,n,n,vh,l,h,h,n,h,h,h,n,n,l,98,300,4907,24.4
73,h,h,h,vh,l,n,n,h,n,n,n,vh,l,h,h,n,h,h,h,n,n,l,85,300,4256,23.2
74,h,h,h,vh,l,n,l,n,n,n,n,vh,l,h,h,n,h,h,h,n,n,l,20,240,813,12.8
75,h,h,h,vh,l,n,l,n,n,n,n,vh,l,h,h,n,h,h,h,n,n,l,111,600,4511,23.5
76,h,h,h,vh,l,h,vh,h,n,n,n,vh,l,h,h,n,h,h,h,n,n,l,162,756,7553,32.4
77,h,h,h,vh,l,h,h,vh,n,n,n,vh,l,h,h,n,h,h,h,n,n,l,352,1200,17597,42.9
78,h,h,h,vh,l,h,n,vh,n,n,n,vh,l,h,h,n,h,h,h,n,n,l,165,97,7867,31.5
79,h,h,h,vh,h,h,n,vh,n,n,h,h,l,h,n,n,n,h,h,n,n,n,60,409,2004,24.9
80,h,h,h,vh,h,h,n,vh,n,n,h,h,l,h,n,n,n,h,h,n,n,n,100,703,3340,29.6
81,h,h,h,vh,n,h,vh,vh,n,n,xh,xh,h,n,n,n,n,l,l,n,n,n,32,1350,2984,33.6
82,h,h,h,vh,h,h,h,h,n,n,vh,xh,h,h,h,n,h,h,h,n,n,n,53,480,2227,28.8
83,h,h,h,vh,h,h,l,vh,n,n,vh,xh,l,vh,vh,n,vh,vl,vl,h,n,n,41,599,1594,23.0
84,h,h,h,vh,h,h,l,vh,n,n,vh,xh,l,vh,vh,n,vh,vl,vl,h,n,n,24,430,933,19.2
85,h,h,h,vh,h,vh,h,vh,n,n,xh,xh,n,h,h,n,h,h,h,n,n,n,165,4178.2,6266,47.3
86,h,h,h,vh,h,vh,h,vh,n,n,xh,xh,n,h,h,n,h,h,h,n,n,n,65,1772.5,2468,34.5
87,h,h,h,vh,h,vh,h,vh,n,n,xh,xh,n,h,h,n,h,h,h,n,n,n,70,1645.9,2658,35.4
88,h,h,h,vh,h,vh,h,xh,n,n,xh,xh,n,h,h,n,h,h,h,n,n,n,50,1924.5,2102,34.2
89,h,h,h,vh,l,vh,l,vh,n,n,vh,xh,l,h,n,n,l,vl,l,h,n,n,7.25,648,406,15.6
90,h,h,h,vh,h,vh,h,vh,n,n,xh,xh,n,h,h,n,h,h,h,n,n,n,233,8211,8848,53.1
91,h,h,h,vh,n,h,n,vh,n,n,vh,vh,h,n,n,n,n,l,l,n,n,n,16.3,480,1253,21.5
92,h,h,h,vh,n,h,n,vh,n,n,vh,vh,h,n,n,n,n,l,l,n,n,n,  6.2, 12,477,15.4
93,h,h,h,vh,n,h,n,vh,n,n,vh,vh,h,n,n,n,n,l,l,n,n,n,  3.0, 38,231,12.0
]]

---------------------------------------------
-- ### `Num`eric columns

local function NUM(col) 
  local num = {
      lo=  10^64,
      hi= -10^64,
      col= col}
  local function norm(x)
    return (x - num.lo) / (num.hi - num.lo + 1e-32) 
  end ---------------------------------------------
  local function update(x) 
    if x ~= no then
      if x < num.lo then num.lo = x end
      if x > num.hi then num.hi = x end
    end
    return x 
  end --------------------------------------------
  local function distance(x,y) 
    if x==no and y== no then
      return 0,0 
    elseif x==no then
      y = norm(num,y)
      x = y < 0.5 and 1 or 0 
    elseif y==no then
      x = norm(num,x)
      y = y < 0.5 and 1 or 0
    else
      x = norm(num,x)
      y = norm(num,y)
    end
    return (x-y)^2, 1 
  end -------------------------------------------
  num.update   = update
  num.distance = distance
  return num
end 
---------------------------------------------
-- ### `Sym`bolic columns

local function SYM(col)
  local function distance(x,y) 
    if     x==no and j==no then return 0,0
    elseif x==no           then return 1,1
    elseif y==no           then return 1,1
    elseif x==y            then return 0,1
    else                        return 1,1 end 
  end ------------------------------------------
  return {
    col      = col,
    update   = function (x) return x end,
    distance = distance} 
end 

local function CSV(source)
  local files    = {csv=true, dat=true,txt=true}
  local no       = "?"
  local sep      = ","
  local dull     = "['\"\t\n\r]*" 
  local comments = "#.*"           
  local nonsep   = "([^" .. sep .. "]+)" 
  local padding  = "%s*(.-)%s*"   
  local first,use= true,{}
  local id       = -1
  -- Turn a line of text info a list of cells
  local function cells(txt)
    txt= txt:gsub(padding,"%1")
            :gsub(dull,"")
            :gsub(comments,"")
    if #txt > 0 then
      local out,col={},0
      for word in string.gmatch(txt,nonsep) do
        col=col+1
        if first    then use[col]    = string.find(word,no) == nil end
        if use[col] then out[#out+1] = tonumber(word) or word      end 
      end
      first = false
      id=id+1
      return {id=id, cells=out}  end  end
  -- Iterator fomr lines of text from a string.
  if  files[ string.sub(source,-3,-1) ] then
    io.input(source)
    local line = io.read()
    return function() 
      while line do
        local tmp = cells(line)
        line = io.read()
        return tmp  end end 
  else
    local pos = 0          
    return function ()    
      while pos < #source do
        local s, e = string.find(source, "[^\r\n]+", pos)
        if s then       
          pos = e + 1 
          return cells(string.sub(source, s, e))  end end end end
  -- Iterator fomr lines of text from a file.
end
---------------------------------------------------------------------------
-- csv DATA reader
-- Returns a data table, coilum headers initialized to NUM or SYM
local function DATA(source)
  local data = { rows= {}, spec={}, goals={}, less={}, more={}, klass={}, 
              all = {nums={}, syms={}, cols={}}, -- all columns
              x   = {nums={}, syms={}, cols={}}, -- all independent columns
              y   = {nums={}, syms={}, cols={}}}  -- all depednent   columns
  local cols = data.x.cols
  -- Column headers have magic symbols label them into mutlitple categories.
  local spec =  {
     {when= "%$", what= NUM, weight= 1, where= {data.all.cols, data.x.cols, data.all.nums, data.x.nums}},
     {when= "<",  what= NUM, weight=-1, where= {data.all.cols, data.y.cols, data.all.nums, data.y.nums, data.goals, data.less}},
     {when= ">",  what= NUM, weight= 1, where= {data.all.cols, data.y.cols, data.all.nums, data.y.nums, data.goals, data.more}},
     {when= "!",  what= SYM, weight= 1, where= {data.all.cols, data.y.cols, data.all.syms, data.y.syms, data.klass}},
     {when= "",   what= SYM, weight= 1, where= {data.all.cols, data.x.cols, data.all.syms, data.x.syms}}}
  -- Using `spec`, initial NUM or SYM column headers from column header `txt`.
  local function header(col,txt)
    for _,want in pairs(spec) do
      if string.find(txt,want.when) ~= nil then
        local one = want.what()
        one.pos= col
        one.txt= txt
        one.weight= want.weight
        for _,where in pairs(want.where) do
          where[ #where+1 ] = one end end end
    return one  end
  -- Convert csv text to table, kill white, convert number strings to strings
  -- Main
  local function update(row)
    print(">>",row)
    if #data.spec == 0 then
       data.spec = row.cells
       for col,txt in pairs(row.cells) do -- initialize the column headers
          header(col,txt) end
    else
       for _,header in pairs(data.all.cols) do -- update the column headers
         header.update(row.cells[ header.pos ]) end 
       data.rows[ #data.rows+1 ] = row  end
    return i
  end
  local function updates(rows)
    print("!!!! ",rows)
    for _,row in pairs(rows) do update(row) end 
    return data
  end
  local function distance(row1, row2) 
    local d,n = 0, 10^-64
    for _,col in pairs(cols) do 
      incd, incn = col.distance( row1.cells[col.pos], row2.cells[col.pos] )
      d = d + incd
      n = n + incn end
    return d^0.5/n^0.5 
  end ---------------------
  local function furthest(one)
     local best,out = -1,one
     for j,row in pairs(data.rows) do
        local d= distance(one,two) 
        if d > best then
          best,out=d,two end end
     return out
  end
  data.clone = function () 
    return DATA().updates({cells=data.spec,id=1})  end
  data.update= update
  data.updates= function (rows) return updates(rows) end
  data.distance=distance
  data.furthest=furthest
  if source then
    for row in CSV(source) do
      data.update(row) end end
  return data
end

---------------------------------------------
-- ### Misc utils

local function shuffle( t )
  for i= 1,#t do
    local j = i + math.floor((#t - i) * R.r() + 0.5)
    t[i],t[j] = t[j], t[i] 
  end
  return t 
end -------------------------
local function any(t)
  return t[ math.floor((#t-1) * R.r() + 0.5) ] 
end -------------------------
local function zero1(x)
    if x>1 then return 1 end
    if x<0 then return 0 end end

------------------------------------------
-- ### Tree 

local function showt(t, depth)
  pre = string.repn("|.. ",depth)
  print(pre, g.c, #t.data.rows)
  for _,key in pairs{"nw", "ne", "sw", "se"} do
    if #t[key] >0 then
      print(pre, key, ":")
      showt(t[key], depth+1) end end 
end

local function TREE(data,min, depth,up,key,xy)
  min   = min or (#data.rows)^0.5
  depth = depth or 10
  if #data.rows < min or depth == 0 or 
     up and same(data, up.date) 
  then
    if up then up.deadends.updates(data.rows) end
    return nil  
  end
  local t = { data = data, deadends = data.clone(),   
              show = function () showt(t,0) end }
  up[key] = t 
  local function mid(key,xy) 
    table.sort(data.rows, function (a,b) return 
               xy[a.id][key] < xy[b.id][key] end)
    return data.rows[ math.floor(#data.rows/2) ][key] end
  local function xys(out) 
    for _,row in pairs( data.rows ) do
      local a= data.distance(row, t.left)
      local b= data.distance(row, t.right)
      local x= zero1((a^2 + t.c^2 - b^2) / (2*t.c))  
      local y= zero1(a^2 - x^2)^0.5
      out[row.id] = {x=x, y=y}  end 
    return out end
  t.left  = any( data.rows )
  t.right = data.furthest( t.left ) 
  t.c     = data.distance( t.left, t.right ) 
  xy      = xy or xys{}
  t.xmid  = mid("x",xy)
  t.ymid  = mid("y",xy)
  local kids = {}
  for _,row in pairs(data.rows) do
    if xy[row.id].y <= t.ymid then
      local what = xy[row.id].x < t.xmid and "sw" and "se"
    else
      local what = xy[row.id].x < t.xmid and "nw" and "ne"
    end 
    kids[what][ #kids[what] +1 ] = row  
  end 
  for key,kid in pairs(kids) do
    TREE( data.clone().updates(kid), min, depth-1, t, key, all, xy) end
  return t
end

print(TREE(DATA(nasa93)))
