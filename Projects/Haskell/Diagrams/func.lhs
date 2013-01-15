>example = position (zip (map mkPoint [-3, -2.8 .. 3]) (repeat dot))
>   where dot       = circle 0.2 # fc black
>         mkPoint x = p2 (x,x^2)
