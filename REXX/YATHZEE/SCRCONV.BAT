/*
  SCRCONV.BAT - Yathzee-Top-1x Convertor - Hans van Kranenburg 1997
                Onderdeel van Yathzee v2.40

  Leest oude Yathzee-Top-1x file (v2.10 Top-10 en vanaf v2.11 Top-11) en
  converteert 'm naar nieuwe formaat (v2.20)

  Parameters:
    - filename van Yathzee-Top-1x file
    > als een filename wordt opgegeven zonder extensie wordt .SCR toegevoegd
      type om dit te voorkomen wel een punt, maar geen extensie

  bv. "SCRCONV.BAT \YATHZEE\YATHZEE.SCR"
*/

/* Main */
versie='2.40'; top.=''
Say SourceLine(2); Say SourceLine(3); Say

/* Controleren of inputfile wel een oude Yathzee-Top-11 file is */
If Top11File(Arg(1))
  Then Do
    /* Inputfile inlezen */
    rc=CharOut(,'  Reading ')
    rc=Stream(scr,'c','open read')
    Do n=1 To 11
      rc=CharOut(,'.')
      top.n=Left(CharIn(scr,,23)Left('SCRCONV v'versie,20)(000),23)
    End
    rc=Stream(scr,'c','close')

    /* Outputfile aanmaken en openen */
    Say; Say '  Preparing outputfile...'
    rc=RxCreate(scr)
    rc=Stream(scr,'c','open write')
    rc=CharOut(scr,'YT11F')

    /* Yathzee-Top-11 wegschrijven */
    rc=CharOut(,'  Writing ')
    rc=Stream(scr,'c','seek =6')
    Do n=1 To 11
      rc=CharOut(,'.')
      rc=CharOut(scr,Left(top.n,20)D2C(Right(top.n,3),2))
    End

    /* Outputfile sluiten en berichten dat file geconverteerd is */
    rc=Stream(scr,'c','close')
    Say; Say '  File converted.'
  End

Exit
/* End Main */

/* Yathzee-Top-11 file initialisatie */
Top11File: Procedure Expose scr

Arg scr, .
If scr='' Then Do a=3 to 11; Say SourceLine(a); End
Else Do
  If Pos('.',scr)=0 Then scr=scr||'.SCR'

  ok=0; opened=0
  If scr<>''
    Then Do
      /* controle file */
      Select
        When RxIsDir(scr)=''
          Then Say '  'scr' does not exist.'
        When Stream(scr,'c','open')<>'READY'
          Then Say '  Error opening 'scr
        When \(Stream(scr,'c','query size')=230,
             | Stream(scr,'c','query size')=253)
          Then Do
            Say '  'scr' is not a Yathzee-Top-11 file.'
            opened=1
          End
        Otherwise
          ok=1; opened=1
      End
      If opened Then rc=Stream(scr,'c','close')
    End
End

Return ok
/* Einde Top11File */
