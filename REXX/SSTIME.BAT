/* Time-screensaver v1.02 door Hans van Kranenburg */
/* Eventuele parameter: interval, probeer 1 eens */

Arg interval .; RxCls(); RxCrStat('off')
sec=Time('s')
Do While Chars()=0
  vpos=Random(0,24); hpos=Random(0,72)
  If interval='' Then interval=Random(10,20)
  n=-1; sec=Time('s')-1
  Do While Chars()=0 & n<>interval
    Do While Chars()=0 & Time('s')=sec; End
    If Time('s')<>sec Then Do
      Rxsetpos(vpos,hpos); rc=Rxwrscr(Time())
      sec=Time('s'); n=n+1
    End
  End
  RxCls(,vpos,hpos,vpos,hpos+7)
End
Do While Chars()<>0; rc=RxGetKey('noecho'); End
RxCls(); RxCrStat('on')
Exit
