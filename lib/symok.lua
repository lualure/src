
require "show"
local O=require "tests"
local R=require "random"
local SYM=require "sym"
local STR=require "str"

---------------------------------------------------

local words =[[
to be or not to be that is the question 
whether tis nobler in the mind to suffer
the slings and arrows of outrageous fortune
or to take arms against a sea of troubles
and by opposing end them to die to sleep
no more and by a sleep to say we end
the heart ache and the thousand natural shocks
that flesh is heir to  tis a consummation
devoutly to be wishd to die to sleep
to sleep perchance to dream ay theres the rub 
for in that sleep of death what dreams may come
when we have shuffled off this mortal coil
must give us pause theres the respect
that makes calamity of so long life
for who would bear the whips and scorns of time
thoppressors wrong the proud mans contumely
the pangs of disprizd love the laws delay
the insolence of office and the spurns
that patient merit of thunworthy takes
when he himself might his quietus make
with a bare bodkin  who would fardels bear
to grunt and sweat under a weary life
but that the dread of something after death
the undiscovered country from whose bourn
no traveller returns puzzles the will
and makes us rather bear those ills we have
than fly to others that we know not of 
thus conscience does make cowards of us all
and thus the native hue of resolution
is sicklied oer with the pale cast of thought
and enterprises of great pitch and moment
with this regard their currents turn awry
and lose the name of action
]]

words = words:gsub("[\t\r\n]"," ")

local function _ent1()
  local i = SYM.create()
  for word in string.gmatch(words,"([^ ]+)" ) do
     SYM.update(i,word) end
  print(SYM.ent(i)) end

local function _ent2()
  local i,add = SYM.watch()
  for word in string.gmatch(words,"([^ ]+)" ) do
    add(word) end
  print(SYM.ent(i)) end

O.k{_ent1,_ent2}
