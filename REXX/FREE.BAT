/* Displays a report of the free space on a drive. */

Arg poc; w=Words(poc) /* parameters on command line, words */
drive=0; all=0; pause=0; help=0; error=0; freedrv=RxGetDrv()
Do n=1 to w; p.n=Word(poc,n) /* parameter */; If p.n='/?' Then help=1; End n

If help Then Call help

Do n=1 to w While \error
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
  Do n=start to finish
    Queue InfoLine(n)
  End n
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
Say '  [/A]      Display information from All drives starting at drive C:.'
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
  pfree=Right(Pfree(free,total),7) /* percentage free */
  free=Right(Comma(free),21)
  total=Right(Comma(total),21)
  vl=SubStr(vl,1,11)
  infoline=' 'dl' 'vl' 'free' 'total' 'pfree' %'
  /*
   C: VOLUMELABEL 0.000.000.000.000.000 0.000.000.000.000.000    100 %
                  123456789012345678901
                                        123456789012345678901
                                                              123456
  */
End

Return infoline
/* End InfoLine */

/* Percentage Free */
Pfree: Procedure

Arg free, total
p1=(free/total)*100
p2=Trunc(p1,1)
If p1-p2>=0.05 Then p2=p2+0.1

Return p2
/* End Pfree */

/* Place commas in number */
Comma: Procedure

Arg on       /* old number */
nn=''        /* new number (with commas) */
l=Length(on) /* length */
i=l%3        /* integer */
r=l//3       /* remainder */
If r<>0 Then Do; nn=SubStr(on,1,r); on=DelStr(on,1,r); End
If i>=1 Then Do i
  nn=(nn)(',')(SubStr(on,1,3))
  on=DelStr(on,1,3)
End
If r=0 Then nn=DelStr(nn,1,1)

Return nn
/* End Comma */
