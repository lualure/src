-- # Global settings
-- Used by many files

function defaults() return {
  ignore= "?",
  sep=    ",",
  here=   os.getenv("Lure"),
  sample= { b=200,
            most=512,
            epsilon=1.01,
            fmtstr="%20s",
            fmtnum="%5.3f",
            cliffsDelta=0.147 -- small
            --cliffsDelta=0.33 -- small
            --cliffsDelta=0.474 -- small
            },
  tree=   { ish=1.00,
            min=2, 
            maxDepth=10},
  chop=   { m=0.5,
            cohen=0.2},
  num=    { conf=95,
            small=0.38,
            first=3, 
            last=96,
            criticals = {
              [95] = {[ 3]=3.182,[ 6]=2.447,[12]=2.179,
                      [24]=2.064,[48]=2.011,[96]=1.985},
              [99] = {[ 3]=5.841,[ 6]=3.707,[12]=3.055,
                      [24]=2.797,[48]=2.682,[96]=2.625}}}
          } end

the= defaults()
return the
