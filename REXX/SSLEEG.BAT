/* Rexx procedure om het scherm leeg te maken en vervolgens te
   wachten tot er een toets ingedrukt wordt om dan weer met de prompt
   en de cursor tevoorschijn te komen */

Trace Off; Rxcrstat(off); Rxcls(); rc=Rxgetkey(noecho); Rxcrstat(on); Exit
