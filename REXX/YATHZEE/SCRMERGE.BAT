/*
  SCRMERGE.BAT - Yathzee-Top-11 Merge  Hans van Kranenburg 1996
                 Onderdeel van Yathzee v2.41

  Leest 1 of meerdere Yathzee-Top-11 files in en schijft ‚‚n file weg met
  daarin de 11 hoogste scores

  SCRMERGE.BAT werkt alleen met Yathzee-Top-11 files van het formaat v2.20
  Yathzee-Top-1x Files van het formaat voor v2.20 kunnen na ze geconverteerd
  te hebben met SCRCONV.BAT ook meegemerged worden

  Parameters:
    - filenames van Yathzee-Top-11 files
    - laatste parameter is de naam van de file die als outputfile gebruikt moet
      worden, als deze al bestaat, wordt de inhoud overschreven
    > als een filename wordt opgegeven zonder extensie wordt .SCR toegevoegd
      type om dit te voorkomen wel een punt, maar geen extensie

  Bij gelijke scores gaan de scores van de latergenoemde files voor

  bv. "SCRMERGE.BAT \YATHZEE\YATHZEE.SCR SCORES.SCR SCORES.SCR"
*/

/* Main */
versie='2.41'
Say Sourceline(2)
If GetParams(Arg(1)) /* set variables: scr. nfiles */
  Then Do
    Say
    Do n=1 To nfiles-1
      If Top11File(scr.n)
        Then Do
          rc=CharOut(,'  Reading 'scr.n' ')
          rc=Stream(scr.n,'c','open read')
          rc=Stream(scr.n,'c','seek =6')
          Do a=1 To 11
            rc=CharOut(,'.')
            b=((n-1)*11)+a
            top.b=(CharIn(scr.n,,20))(Right(C2D(CharIn(scr.n,,2)),3,0))
          End
          Say
          rc=Stream(scr.n,'c','close')
        End
      Else Do
        rc=CharOut(,'    Using default SCRMERGE values ')
        Do a=1 to 11
          rc=CharOut(,'.')
          b=((n-1)*11)+a
          top.b=(Left('SCRMERGE v'versie,20))(000)
        End
        Say
      End
    End

    Say '  BubbleSorting scores ...'
    Call BubbleSort

    Say '  Preparing outputfile ...'
    rc=RxCreate(scr.nfiles)
    If Top11File(scr.nfiles)
      Then Do
        rc=Stream(scr.nfiles,'c','open write')
        rc=CharOut(scr.nfiles,'YT11F')

        rc=CharOut(,'  Writing 'scr.nfiles' ')
        rc=Stream(scr.nfiles,'c','seek =6')
        Do n=(nfiles-1)*11 To (nfiles-1)*11-10 By -1
          rc=CharOut(,'.')
          rc=CharOut(scr.nfiles,(Left(top.n,20))(D2C(Right(top.n,3),2)))
        End
        Say
        rc=Stream(scr.nfiles,'c','close')
        Say '  Files merged.'
      End
  End

Exit
/* End Main */

/* Subs */
GetParams: Procedure Expose scr. nfiles
Arg poc; rc=1
If poc=''
  Then Do; rc=0
    Do a=3 to 19; Say SourceLine(a); End
  End
nfiles=Words(poc)
If nfiles<2
  Then Do; rc=0
    Say; Say '  Er moeten minstens twee filenames opgegeven worden.'
  End
Do n=1 To nfiles
  scr.n=Word(poc,n)
  If Pos('.',scr.n)=0 Then scr.n=scr.n||'.SCR'
End
Return rc

/* Yathzee-Top-11 file initialisatie */
Top11File: Procedure

Arg scr
ok=0
Select
  When Stream(scr,'c','open read')<>'READY'
    Then Say '  Error opening 'scr
  When \(CharIn(scr,1,5)<>'YT11F' & Stream(scr,'c','query size')=0,
    & Stream(scr,'c','query size')<>247 | CharIn(scr,1,5)='YT11F',
    & Stream(scr,'c','query size')<>0 & Stream(scr,'c','query size')=247)
    Then Say '  'scr' is not a Yathzee-Top-11 file.'
  Otherwise
    ok=1
End
rc=Stream(scr,'c','close')

Return ok
/* Einde Top11File */

BubbleSort: Procedure Expose nfiles top.
Do grens=((nfiles-1)*11)-1 To 1 By -1 Until ok; ok=1
  Do n=1 To grens; m=n+1
    If Right(top.n,3)>Right(top.m,3)
      Then Do; ok=0; h=top.n; top.n=top.m; top.m=h; End
  End n
End grens
Return
