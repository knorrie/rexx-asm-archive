/* Displays a report of the free space on a drive. */

Arg poc; w=Words(poc) /* parameters on command line, words */
drive=0; all=0; pause=0; help=0; error=0; freedrv=RxGetDrv()
Do n=1 To w; p.n=Word(poc,n) /* parameter */; If p.n='/?' Then help=1; End n

If help Then Call help

Do n=1 To w While \error
  Select
    When Length(p.n)<>2 Then InvSw(p.n)
    When SubStr(p.n,2,1)=':' & C2D(SubStr(p.n,1,1))>=65,
         & C2D(SubStr(p.n,1,1))<=90 & drive=0 Then Do; drive=1; freedrv=p.n; End
    When SubStr(p.n,2,1)=':' & C2D(SubStr(p.n,1,1))>=65,
         & C2D(SubStr(p.n,1,1))<=90 & drive<>0 Then TooMan(p.n)
    When p.n='/A' Then all=1
    When p.n='/P' Then pause=1
    Otherwise InvSw(p.n)
  End
End n

If \error & \all Then Do
  If RxIsDir(freedrv||'\')='' Then Do
    error=1; Say 'Invalid drive specification'
  End
End

If \error Then Do
  If all Then Do; start=67; finish=90; End
  Else Do; start=C2D(SubStr(freedrv,1,1)); finish=start; End
  Do n=start To finish; Queue InfoLine(n); End n
  lines=0; maxlines=Word(RxScrSiz(),1)-4
  Say 'Drive               Free Space (bytes)   Total Space (bytes)   % Free'
  Do finish-start+1
    If lines=maxlines & pause Then Do
      Say 'Press any key to continue...'
      Do Until Chars()=0; rc=RxGetKey('noecho'); End
    End
    Parse Pull line; If line<>'' Then Do; Say line; lines=lines+1; End
  End
End

Exit
/* End Main */

/* Invalid switch */
InvSw:
Say 'Invalid switch - 'Arg(1)
error=1; help=0
Return ''
/* End InvSw */

/* Too many parameters */
TooMan:
Say 'Too many parameters - 'Arg(1)
error=1; help=0
Return ''
/* End TooMan */

/* Display help info */
help:
Say 'Displays a report of the free space on a drive.'; Say
Say 'FREE [drive:] [/A] [/P]'; Say
Say '  [drive:]  Specifies the drive you want to see information from.'
Say '  [/A]      Displays information from All drives starting at drive C:.'
Say '  [/P]      Pauses when screen fills up.'; Say
Say 'Type FREE without parameters to display information from the current',
    'drive.'
error=1
Return
/* End help */

/* Create line with information of drive */
InfoLine: Procedure

Arg n /* ASCII number of drive letter */
Parse Value RxDInfo(D2C(n)':') With dl free total vl
/* drive letter, free space, total space, volume label */
infoline=''
If dl<>'' Then Do
  pfree=Right(Format((free/total)*100,,1),7) /* percentage free */
  free=Right(InsChar(free),21)
  total=Right(InsChar(total),21)
  vl=Left(vl,11)
  infoline=' 'dl' 'vl' 'free' 'total' 'pfree' %'
  /*
   C: VOLUMELABEL 0,000,000,000,000,000 0,000,000,000,000,000    000.0 %
                  123456789012345678901
                                        123456789012345678901
                                                               1234567
  */
End

Return infoline
/* End InfoLine */

/* Insert characters in string */
InsChar: Procedure

Arg str, chr, n
If n='' Then n=3
If chr='' Then chr=','
l=Length(str) /* length */
i=l%n         /* integer */
r=l//n        /* remainder */
If i>=1 Then Do
  If r=0 Then Do; cp=n; i=i-1; End /* current position in string */; Else cp=r
  Do i; str=Insert(chr,str,cp); cp=cp+n+1; End
End

Return str
/* End InsChar */
