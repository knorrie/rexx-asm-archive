/* Genereert een getal van opgegeven lengte */
/* lengte >= 1 !! */
Arg l
str=''
Do n=1 to l
  str=(str)(d2c(Random(48,57)))
End
Say str
Exit
