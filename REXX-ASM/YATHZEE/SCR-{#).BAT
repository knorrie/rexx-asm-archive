/* SCR-{#}.BAT - Voegt SCR-TXT.TXT en SCR-ATT.TXT samen tot input file
   voor schermopbouwroutine YATHZEE */

text   = 'SCR-TXT.TXT'
attrib = 'SCR-ATT.TXT'
screen = 'ISCREEN.DAT'

color.0 = '07'x  /* wit op zwart   */
color.1 = '17'x  /* wit op blauw   */
color.2 = '12'x  /* groen op blauw */
color.3 = '09'x  /* blauw op zwart */

rc=Stream(text,'c','open read')
rc=Stream(attrib,'c','open read')
rc=Stream(screen,'c','open write')

Do 75
  txtline = Left(LineIn(text),80)
  attline = LineIn(attrib)
  Do n=1 To 80
    rc=CharOut(screen,SubStr(txtline,n,1))
      q=SubStr(attline,n,1)
    rc=CharOut(screen,color.q)
  End n
End

rc=Stream(text,'c','close')
rc=Stream(attrib,'c','close')
rc=Stream(screen,'c','close')

Exit
