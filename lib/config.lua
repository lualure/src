-- # Global settings
-- Used by many files

return {ignore= "?",
        sep=    ",",
        here=   os.getenv("Lure"),
        sample= { most=256},
        bpo=    { pop0=20,
                  score=64,
                  max=1,
                  min=1},
        tree=   { ish=1.00,
                  min=2, 
                  maxDepth=10},
        chop=   { m=0.5,
                  cohen=0.2}
      }
