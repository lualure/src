-- # Global settings
-- Used by many files

return {ignore= "?",
        sep=    ",",
        here=   os.getenv("Lure"),
        sample= { most=256},
        bdo=    { pop0=20,
                  max=1,
                  min=1},
        tree=   { ish=1.00,
                  min=10, 
                  maxDepth=10},
        chop=   { m=0.5,
                  cohen=0.2}
      }
