/* woorden invoeren */
say 'Typ drie of meer woorden in.'
parse pull een twee drie rest
/* eerste woord */
if een="" then do
  say 'er zijn geen woorden ingetypt!'; exit
 end
say 'Het eerste woord was :' een
/* tweede woord */
if twee="" then do
 say 'er is geen tweede woord ingetypt'; exit
 end
say 'Het tweede woord was :' twee
/* derde woord */
if drie="" then do
 say 'er is geen derde woord ingetypt'; exit
 end
say 'Het derde woord was :' drie
/* de rest */
if rest="" then do
 say 'er waren maar drie woorden ingetypt'; exit
 end
say 'De rest was :' rest
/* afsluiten */
exit
