> {-# LANGUAGE NoMonomorphismRestriction #-}
> 
> import Diagrams.Prelude
> import Diagrams.Backend.SVG.CmdLine
> 
> main = defaultMain (example)

> circle1 = circle 1 # fc blue
>                    # lw 0.05
>                    # lc purple
>                    # dashing [0.2,0.05] 0
> example = position (zip (map mkPoint [-3, -2.90 .. 3]) (repeat dot))
>   where dot       = circle 0.05 # fc black
>         mkPoint x = p2 (x,cos sin x)
