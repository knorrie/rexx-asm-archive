/* Clock v1.00  Hans van Kranenburg 1996 PC DOS 7 REXX */

/* Main */
RxCrStat('off')

/* digits info */
d.0 = 1 ; d.0.1 = '1,2:7,7'
d.1 = 1 ; d.1.1 = '0,0:8,7'
d.2 = 2 ; d.2.1 = '1,0:3,7' ; d.2.2 = '5,2:7,9'
d.3 = 2 ; d.3.1 = '1,0:3,7' ; d.3.2 = '5,0:7,7'
d.4 = 2 ; d.4.1 = '0,2:3,7' ; d.4.2 = '5,0:8,7'
d.5 = 2 ; d.5.1 = '1,2:3,9' ; d.5.2 = '5,0:7,7'
d.6 = 2 ; d.6.1 = '1,2:3,9' ; d.6.2 = '5,2:7,7'
d.7 = 1 ; d.7.1 = '1,0:8,7'
d.8 = 2 ; d.8.1 = '1,2:3,7' ; d.8.2 = '5,2:7,7'
d.9 = 2 ; d.9.1 = '1,2:3,7' ; d.9.2 = '5,0:7,7'

/* colors */
black = 0
blue = 16
green = 32
cyan = 48
red = 64
magenta = 80
brown = 96
white = 112

/* background */ bgr = blue
/* foreground */ fgr = green
RxCls(bgr)

/* begin vertical position   */ by = 8
/* begin horizontal position */ bx = 13
/* space between digits (interdigit) */ id = 3

timeh=''
timem=''
Do While Chars()=0
  time=Time()
  rc=Time('r')
  If timeh<>Time('h')
    Then Do
      timeh=Right(Time('h'),2,0)
      Clock('h',timeh)
    End
  If totalmin<>Time('m')
    Then Do
      Parse Value Time() With . ':' timem ':' .
      totalmin=Time('m')
      Clock('m',timem)
    End
  Do While Chars()=0 & Time('e')<0.5; End
  Period('off')
  Do While Chars()=0 & time=Time(); End
  Period('on')
End

Do While Chars()<>0; rc=RxGetKey('noecho'); End
RxCls()
Say 'Clock v1.00  IBM PC DOS 7 REXX'
RxCrStat('on')
Exit

/* End Main */

/* Subroutines */

Clock: Procedure Expose bgr fgr by bx d. id

Arg s, n
Select
  When s='H' Then x=bx
  When s='M' Then x=bx+20+3*id+2
End
Digit(Left(n,1))
x=x+10+id
Digit(SubStr(n,2,1))

Return ''

Digit: Procedure Expose bgr fgr by bx x d.

Arg n
If \(n=0 & x=bx)
  Then Do
    RxCls(fgr,by,x,by+8,x+9)
    Do g=1 To d.n                              /* number of gaps */
      Parse Var d.n.g y1 ',' x1 ':' y2 ',' x2  /* gap data       */
      RxCls(bgr,by+y1,x+x1,by+y2,x+x2)         /* make gap       */
    End g
  End

Return ''

Period: Procedure Expose bgr fgr by bx id

Arg state
Select
  When state='OFF' Then color=bgr
  When state='ON'  Then color=fgr
End
RxCls(color,by+2,bx+2*id+20,by+2,bx+2*id+20+1)
RxCls(color,by+6,bx+2*id+20,by+6,bx+2*id+20+1)

Return ''

/* EOF Clock v.100 */
