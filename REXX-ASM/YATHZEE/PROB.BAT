/* PROB */
IScreen()
IVersion('3.00','1997')
IT11View('YATHZEE.SCR'||'00'x)
Do Forever
  p=D2C(RxGetKey('noecho'))
  ChVPage(p)
End
