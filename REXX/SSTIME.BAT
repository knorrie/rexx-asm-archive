/* Time-screensaver v1.03 door Hans van Kranenburg */
/* Eventuele parameter: interval, probeer 1 eens */

RxCls(); RxCrStat('off')
Arg int .; If int<>'' Then int=int+1
sec=Time('s')
Do While Chars()=0
  vpos=Random(0,24); hpos=Random(0,72)
  If int='' Then int=Random(10,20)
  sec=Time('s')-1
  Do int While Chars()=0
    Do While Chars()=0 & Time('s')=sec; End
    Rxsetpos(vpos,hpos); rc=Rxwrscr(Time())
    sec=Time('s')
  End
  RxCls(,vpos,hpos,vpos,hpos+7)
End
Do While Chars()<>0; rc=RxGetKey('noecho'); End
RxCls(); RxCrStat('on')
Exit
