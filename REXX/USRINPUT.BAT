/*
  UserInput v1.00 - Hans van Kranenburg 1996 - PC DOS 7 REXX

  Parameters:               Default:
  01 - aantal tekens         1
  02 - string                ''
  03 - cursor                1
  04 - echo                  1
  05 - uppercase             0
  06 - insert                1
  07 - enter nodig           1
  08 - string(2) weghalen    0
       bij eerste wijziging
  09 - teken op lege plek    ' ' (space)
  10 - replace character     ''  (no replace) (e.g. password input)
*/
UserInput:

RxCrStat('off')
Parse Arg a, str, c, e, u, i, ent, w, chr, rchr
If a='' Then a=1
If c='' Then c=1
If e='' Then e=1
If u='' Then u=0
If i='' Then i=1
If ent='' Then ent=1
If w='' Then w=0
If chr='' Then chr=' '

sp=1; l=Length(str) /* string pointer, length of string */
Parse Value RxGetPos() With y x
If e
  Then Do
    If chr<>' ' Then rc=CharOut(,Copies(chr,a))
    RxSetPos(y,x)
    rc=CharOut(,str)
    RxSetPos(y,x)
  End
Do Until t='0D' | l=a & \ent
  If c Then RxCrStat('on')
  ex=0; t=Right(C2X(RxGetKey('noecho')),2,0)
  If t='00'; Then Do; ex=1; t=Right(C2X(RxGetKey('noecho')),2,0); End
  RxCrStat('off')
  Select
    When \ex & t='1B' Then Call Clear                /* escape */
    When \ex & t='08' & (sp>1 | sp=1 & w)            /* backspace */
      Then Do
        If w Then Call Clear       /* zie parameters info */
        Else Do
          sp=sp-1                  /* een positie terug in string */
          str=Delstr(str,sp,1)     /* teken daar verwijderen */
          l=Length(str)            /* lengte vernieuwen */
          If e
            Then Do
              If rchr='' Then rc=CharOut(,'08'x||SubStr(str,sp)||chr)
              Else rc=CharOut(,'08'x||Copies(rchr,l-sp+1)||chr)
                                   /* non-destructive backspace op scherm */
                                   /* resterende stuk en overschrijven
                                      oude letter */
              RxSetPos(y,x+sp-1)   /* cursor goedzetten */
            End
        End
      End
    When ex & t='52' Then i=\i                      /* insert */
    When ex & t='53'                                /* delete */
      Then Do
        If w Then Call Clear       /* zie parameters info */
        Else Do
          str=Delstr(str,sp,1)     /* teken in string verwijderen */
          l=Length(str)            /* lengte vernieuwen */
          If e
            Then Do
              If rchr='' Then rc=CharOut(,SubStr(str,sp)||chr)
              Else rc=CharOut(,Copies(rchr,l-sp+1)||chr)
                                   /* resterende stuk en overschrijven
                                      oude letter */
              RxSetPos(y,x+sp-1)   /* cursor goedzetten */
            End
        End
      End
    When ex & Left(t,1)='4' & e
      Then Do
        Select
          When t='4B' & sp>1  Then sp=sp-1           /* left */
          When t='4D' & sp<=l Then sp=sp+1           /* right */
          When t='47'         Then sp=1              /* home */
          When t='4F'         Then sp=Length(str)+1  /* end */
          Otherwise Nop
        End
        RxSetPos(y,x+sp-1)         /* cursor positie aanpassen */
      End
    When \ex & t>='20'                               /* valid characters */
      Then Do
        If w Then Call Clear       /* zie parameters info */
        If i & l<a                       /* insert character */
          Then Do
            str=Insert(X2C(t),str,sp-1)
                                   /* op current pos in string teken invoegen */
            sp=sp+1                /* string pointer aanpassen */
            l=Length(str)          /* lengte vernieuwen */
            If e
              Then Do
                RxSetPos(y,x+sp-2) /* cursor aanpassen voor output */
                If rchr='' Then rc=CharOut(,SubStr(str,sp-1))
                Else rc=CharOut(,Copies(rchr,l-sp+2))
                                   /* ingevoegde teken en resterende stuk
                                      afbeelden */
              End
          End
        Else If \i & sp<=a
          Then Do                        /* overlay character */
            str=Overlay(X2C(t),str,sp)
                                   /* op current pos in string teken over-
                                      schrijven */
            sp=sp+1                /* string pointer aanpassen */
            If e
              Then
                If rchr='' Then rc=CharOut(,X2C(t))
                Else rc=CharOut(,rchr)
                                   /* teken afbeelden op scherm */
          End
        If e Then RxSetPos(y,x+sp-1)
                                   /* cursor positie aanpassen */
      End
    Otherwise Nop
  End
  w=0
End
If c Then RxCrStat('on')
If u Then str=Translate(str)

Return str

Clear:
If e
  Then Do
    RxSetPos(y,x)
    rc=CharOut(,Copies(chr,l))
    RxSetPos(y,x)
  End
sp=1; str=''; l=Length(str)
Return

/* Einde UserInput */
