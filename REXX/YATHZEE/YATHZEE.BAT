/*ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
  º YATHZEE REXX Versie 2.10  Hans van Kranenburg 1995-1996                  º
  ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
Versie 1.00 In produktie gegaan: -

Versie 2.00 In produktie gegaan: -
Wijzigingen:
  Alles, het programma is totaal herschreven

Versie 2.01 In produktie gegaan: -
Wijzigingen:
  Bij verkeerde keuze is '--' in 'ÄÄ' veranderd
  Type-foutje bij 'Is scl.sp>63 Then bonus=35' verbeterd

Versie 2.02 In produktie gegaan: -
Wijzigingen:
  Gooien.stenen routine aangepast, nu ook voor stenen vasthouden
  Extra keuze bij gooien: Alle stenen vast
  Bonus-bug opgelost
  Veranderde manier opbouw openingsscherm; nu m.b.v. internal data queue
  Aanpassing routine scherm opbouwen, programmacode past nu op scherm

Versie 2.10 In produktie gegaan: 20 april 1996
Wijzigingen:
  Er wordt nu een Yathzee-Top-10 bijgehouden
  Veel kleine dingen aangepast */

/* Hoofdprogramma */
Trace Off; Rxcrstat('off')
versie='2.10'; jaar='1996'
Call top10file
Do Until sp=-1
  Call opening
  Call schermopbouwen
  Do 13 Until sp=-1
    Do sp=1 to splrs Until sp=-1
      Call gooien
      Call bubble
      Call keuzepunten
    End sp
  End
  Call einde
End
Call top10zien
Rxcls()

exit:
Rxcrstat('on')
Exit
/* einde hoofdprogramma */

/* Naam van Yathzee-Top-10-file wordt gecre‰erd, er wordt gecontroleerd of de
   file wel bestaat. Zo niet, dan wordt een nieuwe aangemaakt */
top10file: Procedure Expose scr versie

Parse Source . . execfile
scr=Substr(execfile,1,Lastpos('\',execfile))||'YATHZEE.SCR'
say 'Yathzee-Top-10: 'scr

If Rxisdir(scr)<>0 Then Do
  rc=Stream(scr,'c','open')
  Do 10; rc=Charout(scr,'Yathzee v'versie'       000'); End
  rc=Stream(scr,'c','close')
End

Return
/* einde top10file */

/* Opening */
opening: Procedure Expose splrs naam. init. punten scl. scr. scr versie jaar

/* Controleren schermgrootte */
If Subword(Rxscrsiz(),2,1)<80 Then Do
  Say 'Het scherm moet een breedte van minstens80 kolommen hebben'
  Signal exit
End

opening2:
/* Openingsscherm afbeelden */
Rxcls(16)
Queue 'Û     Û  ÛßßßßßÛ  ßßßÛßßß  Û     Û  ßßßßßßÛ  Ûßßßßßß  Ûßßßßßß'
Queue 'Û     Û  Û     Û     Û     Û     Û        Û  Û        Û      '
Queue 'ßßßÛßßß  ÛßßßßßÛ     Û     ÛßßßßßÛ   ÜÜÜßßß  Ûßßßßß   Ûßßßßß '
Queue '   Û     Û     Û     Û     Û     Û  Û        Û        Û      '
Queue '   Û     Û     Û     Û     Û     Û  ÛÜÜÜÜÜÜ  ÛÜÜÜÜÜÜ  ÛÜÜÜÜÜÜ'
Queue ''
Queue 'ÛßßßßßÛ  Ûßßßßßß  Û     Û  Û     Û'
Queue 'Û     Û  Û         Û   Û    Û   Û '
Queue 'ÛßßßÛßß  Ûßßßßß     ÛÛÛ      ÛÛÛ  '
Queue 'Û    Û   Û         Û   Û    Û   Û '
Queue 'Û     Û  ÛÜÜÜÜÜÜ  Û     Û  Û     Û'
Rxsetpos(2,0)
Do 11; Pull q; rc=Rxwrscr(Centre(q,80),18); End
Rxsetpos(24,0)
rc=Rxwrscr(Centre('Versie 'versie'  Hans van Kranenburg 'jaar' IBM PC DOS '||,
  '7.0 REXX',80),23)
If splrs<>'nowait' Then rc=Rxsleep(3)

/* Informatie spelers opvragen */
splrs=0
Rxsetpos(14,5)
rc=Rxwrscr("Aantal spelers [1-5] of 'T' voor Yathzee-Top-10 ?",23)
Rxcls(,14,55,14,55)
Do Until splrs>=1 & splrs<=5
  Do While Chars()<>0; rc=Rxgetkey('noecho'); End
  Rxsetpos(14,55)
  Rxcrstat('on'); splrs=Translate(Rxgetkey('echo')); Rxcrstat('off')
  Rxcls(16,22,0,22,79)
  Select
    When splrs='T' Then Do; Call top10zien; Signal opening2; End
    When splrs>=1 & splrs<=5 Then Nop
    Otherwise
      Rxsetpos(22,0)
      rc=Rxwrscr(Centre("Aantal spelers tussen 1 en 5 of 'T' voor Yathzee-To"||,
        'p-10',80),23)
  End
End
Do n=1 to splrs; v=15+n
  Rxsetpos(v,5); rc=Rxwrscr('Naam speler 'n':',23)
  Rxcls(,v,20,v,39); Rxsetpos(v,20)
  Rxcrstat('on'); Parse Pull naam.n; Rxcrstat('off')
  Rxcls(16,v,40,v,79);Rxcls(16,v+1,0,v+1,66)
  naam.n=Strip(Substr(naam.n,1,20))
  Rxsetpos(v,44); rc=Rxwrscr('Initialen speler 'n':',23)
  Rxcls(,v,64,v,67); Rxsetpos(v,64)
  Rxcrstat('on'); Parse Pull init.n; Rxcrstat('off')
  Rxcls(16,v,68,v,79); Rxcls(16,v+1,0,v+1,79); Rxcls(16,v+2,0,v+2,30)
  init.n=Strip(Substr(init.n,1,4))
End n

/* Variabelen voor puntentelling beginwaarden geven */
punten=Copies('0',splrs*13)
Do n=1 to splrs; scl.n=0; scr.n=0; End n

Return
/* einde opening */

/* Scherm opbouwen */
schermopbouwen: Procedure Expose splrs naam. init. versie

Rxcls(); Rxcls(16,0,0,0,79); Rxcls(16,24,0,24,79)
Rxsetpos(0,0); rc=Rxwrscr(Centre('YATHZEE REXX v'versie,80),23)
Rxsetpos(0,61); rc=Rxwrscr('Hans van Kranenburg',23)
Rxsetpos(2,0)
rc=Charout(,'ÉÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÑÍÍÍÍÑÍÍÍÍÑÍÍÍÍÑÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÑÍÍÍ'||,
  'ÍÑÍÍÍÍÑÍÍÍÍÑÍÍÍÍ»')
rc=Charout(,'ºEnen         º    ³    ³    ³    ³    ºDrie dezelfde º    ³   '||,
  ' ³    ³    ³    º')
rc=Charout(,'ºTwee‰n       º    ³    ³    ³    ³    ºVier dezelfde º    ³   '||,
  ' ³    ³    ³    º')
rc=Charout(,'ºDrie‰n       º    ³    ³    ³    ³    ºVolle bak     º    ³   '||,
  ' ³    ³    ³    º')
rc=Charout(,'ºVieren       º    ³    ³    ³    ³    ºKleine straat º    ³   '||,
  ' ³    ³    ³    º')
rc=Charout(,'ºVijven       º    ³    ³    ³    ³    ºGrote straat  º    ³   '||,
  ' ³    ³    ³    º')
rc=Charout(,'ºZessen       º    ³    ³    ³    ³    ºYathzee       º    ³   '||,
  ' ³    ³    ³    º')
rc=Charout(,'ÇÄÄÄÄÄÄÄÄÄÄÄÄÄ×ÄÄÄÄÅÄÄÄÄÅÄÄÄÄÅÄÄÄÄÅÄÄÄÄ¶Vrije keuze   º    ³   '||,
  ' ³    ³    ³    º')
rc=Charout(,'ºTotaal puntenº    ³    ³    ³    ³    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄ×ÄÄÄÄÅÄÄÄ'||,
  'ÄÅÄÄÄÄÅÄÄÄÄÅÄÄÄÄ¶')
rc=Charout(,'ºExtra bonus  º    ³    ³    ³    ³    ºTotaal rechts º    ³   '||,
  ' ³    ³    ³    º')
rc=Charout(,'ºTotaal links º    ³    ³    ³    ³    ºTotaal links  º    ³   '||,
  ' ³    ³    ³    º')
rc=Charout(,'ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÏÍÍÍÍÏÍÍÍÍÏÍÍÍÍÏÍÍÍÍ¹Totaal ÄÄÄÄÄÄ>º    ³   '||,
  ' ³    ³    ³    º')
Rxsetpos(14,39); rc=Charout(,'ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÏÍÍÍÍÏÍÍÍÍÏÍÍÍÍÏÍÍÍÍ¼')
Rxsetpos(14,0); rc=Rxwrscr('Speler',9)
Call gooien.stenen 1 5 7
Do n=1 to splrs
  Rxsetpos(1,5*(n+2)); rc=Rxwrscr(init.n,7)
  Rxsetpos(1,5*(n+10)); rc=Rxwrscr(init.n,7)
End n
Do n=10 to 12; Do q=1 to splrs; Rxsetpos(n,13+5*q); Say 0; End q; End n
Do n=11 to 13; Do q=1 to splrs; Rxsetpos(n,53+5*q); Say 0; End q; End n

Return
/* einde schermopbouwen */

/* Gooien */
gooien: Procedure Expose sp naam.sp init.sp st.

/* v(asthouden) heeft waarde 7=los, 10=vast (kleur stenen) */
Do n=1 to 5; v.n=7; End n
Rxcls(,14,20,14,38)
Rxsetpos(14,7); rc=Rxwrscr(sp,9)
Rxsetpos(14,19); rc=Rxwrscr(naam.sp,9)
Rxsetpos(24,0); rc=Rxwrscr('Worp',23)
Do worp=1 to 3
  Rxsetpos(24,5); rc=Rxwrscr(worp,23)
  Do n=1 to 5; If v.n=7 Then st.n=Random(1,6); End n
  Do n=1 to 5; Rxsetpos(22,n*7+18); Say st.n; End n
  If worp<3 Then Do
    Rxcls(,15,0,19,79); Rxsetpos(15,0)
    Say 'Welke stenen moeten vastgehouden worden bij de volgende worp?'
    Say '  1. Steen 1    5. Steen 5'
    Say '  2. Steen 2    V. Alle stenen vasthouden'
    Say '  3. Steen 3    L. Alle stenen los'
    Say '  4. Steen 4    G. Volgende worp'
    Do Until n=g | c2d(n)=13
      Do While Chars()<>0; rc=Rxgetkey('noecho'); End
      Rxsetpos(15,62)
      Rxcrstat('on'); n=Translate(Rxgetkey('echo')); Rxcrstat('off')
      Rxcls(16,24,6,24,79)
      Select
        When n>=1 & n<=5 Then
          If v.n=10 Then Call gooien.stenen n n 7
          Else Call gooien.stenen n n 10
        When n='V' Then Call gooien.stenen 1 5 10
        When n='L' Then Call gooien.stenen 1 5 7
        When n='G' | c2d(n)=13 Then Nop
        Otherwise
          Rxsetpos(24,6)
          rc=Rxwrscr(Centre('Verkeerde keuze ÄÄ Toets 1, 2, 3, 4, 5, V, L of'||,
          ' G',68),23)
      End
    End
  End
End worp
Call gooien.stenen 1 5 7; Rxcls(16,24,0,24,5)

Return
/* einde gooien */

/* Bepaald aantal stenen los/vast
   Aanroepen: gooien.stenenlos [van steen] [tot steen] [los/vast -> 7/10] */
gooien.stenen: Procedure Expose v.

Arg st1 st2 lv
Do n=st1 to st2
  v.n=lv
  Rxsetpos(21,16+7*n); rc=Rxwrscr('ÉÍÍÍ»',lv)
  Rxsetpos(22,16+7*n); rc=Rxwrscr('º',lv)
  Rxsetpos(22,20+7*n); rc=Rxwrscr('º',lv)
  Rxsetpos(23,16+7*n); rc=Rxwrscr('ÈÍÍÍ¼',lv)
End n

Return
/* einde gooien.stenen */

/* Stenen sorteren m.b.v. Bubblesort */
bubble: Procedure Expose st.

grens=5
Do Until ok | grens=1; n=0; ok=0; grens=grens-1
  Do Until n=grens; n=n+1; m=n+1
    If st.n>st.m Then Do; ok=0; h=st.n; st.n=st.m; st.m=h; End
  End
End

Return
/* einde bubble */

/* Keuze + Punten */
keuzepunten: Procedure Expose punten sp scl. scr. st.

Rxcls(,15,0,19,79); Rxsetpos(15,0)
Say 'Maak uw keuze:'
Say '  1. Enen     5. Vijven           9. Volle bak       13. Vrije keuze'
Say '  2. Twee‰n   6. Zessen          10. Kleine straat   14. Einde spel'
Say '  3. Drie‰n   7. Drie dezelfde   11. Grote straat'
Say '  4. Vieren   8. Vier dezelfde   12. Yathzee'
c=0; Do Until k>=1 & k<=13 & c=1 | k=14
  Rxcls(,15,15,15,79); Rxsetpos(15,15)
  Do While Chars()<>0; rc=Rxgetkey('noecho'); End
  Rxcrstat('on'); Pull k; Rxcrstat('off'); Rxcls(16,24,6,24,79); Rxsetpos(24,0)
  Select
    When k>=1 & k<=13 Then
      If Substr(punten,13*(sp-1)+k,1)=0 Then Do
        c=1; Call keuzepunten.punten
        punten=Overlay(1,punten,13*(sp-1)+k)
      End
      Else rc=Rxwrscr(Centre('Deze keuze is al eerder gemaakt',80),23)
    When k=14 Then sp=-1
    Otherwise rc=Rxwrscr(Centre('Verkeerde keuze gemaakt',80),23)
  End
End

Return
/* einde keuzepunten */

/* Punten berekenen en weergeven */
keuzepunten.punten: Procedure Expose sp scl. scr. k st.

punten=0; bonus=0
Select
  When k>=1 & k<=6 Then
    Do n=1 to 5; If st.n=k Then punten=punten+st.n; End n
  When k=7 Then
    If st.1=st.2 & st.2=st.3 | st.2=st.3 & st.3=st.4 | st.3=st.4 & st.4=st.5
      Then Do n=1 to 5; punten=punten+st.n; End n
  When k=8 Then
    If st.1=st.2 & st.2=st.3 & st.3=st.4 | st.2=st.3 & st.3=st.4 & st.4=st.5
      Then Do n=1 to 5; punten=punten+st.n; End n
  When k=9 Then
    If st.1=st.2 & st.2=st.3 & st.3<>st.4 & st.4=st.5 | st.1=st.2 & st.2<>st.3,
      & st.3=st.4 & st.4=st.5 Then punten=25
  When k=10 Then Do
    s=st.1; Do n=2 to 5; s=(s)(st.n); End n
    Do n=1 to 4; m=n+1
      If Substr(s,n,1)=Substr(s,m,1) Then s=Delstr(s,m,1)
    End n
    If Length(s)<>5 Then s=Substr(s,1,5,'0')
    Do n=1 to 5; st.n=Substr(s,n,1); End n
    If st.1=st.2-1 & st.2=st.3-1 & st.3=st.4-1 | st.2=st.3-1 & st.3=st.4-1,
      & st.4=st.5-1 Then punten=30
  End
  When k=11 Then
    If st.1=st.2-1 & st.2=st.3-1 & st.3=st.4-1 & st.4=st.5-1 Then punten=40
  When k=12 Then If st.1=st.2 & st.2=st.3 & st.3=st.4 & st.4=st.5 Then punten=50
  When k=13 Then Do n=1 to 5; punten=punten+st.n; End n
End

If k<=6 Then Do
  scl.sp=scl.sp+punten
  If scl.sp>63 Then bonus=35
  Rxsetpos(10,11+5*sp); Say Right(scl.sp,3)
  Rxsetpos(11,12+5*sp); Say Right(bonus,2)
  Rxsetpos(12,11+5*sp); Say Right(scl.sp+bonus,3)
  Rxsetpos(12,51+5*sp); Say Right(scl.sp+bonus,3)
  Rxsetpos(k+2,12+5*sp)
End
Else Do
  If scl.sp>63 Then bonus=35
  scr.sp=scr.sp+punten; Rxsetpos(11,51+5*sp); Say Right(scr.sp,3)
  Rxsetpos(k-4,52+5*sp)
End
Say Right(punten,2)
Rxsetpos(13,51+5*sp); Say Right(scl.sp+bonus+scr.sp,3)

Return
/* einde keuzepunten.punten */

/* Einde */
einde: Procedure Expose splrs sp scl. scr. naam. scr versie

Call einde.winnaar
Call einde.top10bijw

Rxcls(16,24,0,24,79); rc=Rxwrscr(Centre('Opnieuw beginnen [J/N] ?',80),23)
Do Until n='J' | n='N'
  Do While Chars()<>0; rc=Rxgetkey('noecho'); End
  Rxsetpos(24,53); n=Translate(Rxgetkey('noecho')); rc=Rxwrscr(n,23)
  If n='J' Then sp=0
  If n='N' Then Do
    Rxcls(16,24,0,24,79); rc=Rxwrscr(Centre('Tot ziens!',80),23)
    sp=-1; rc=Rxsleep(2)
  End
End

Return
/* einde einde */

/* Na(a)m(en) winnaar(s) afbeelden */
einde.winnaar: Procedure Expose splrs scl. scr. naam.

Do n=1 to splrs; sct.n=scl.n+scr.n; If scl.n>63 Then sct.n=sct.n+35; End n
sct=sct.1
If splrs>1 Then Do; Do n=2 to splrs; If sct.n>sct Then sct=sct.n; End n; End
w=0; Do n=1 to splrs
  If sct.n=sct Then Do; w=w+1
    If naam.n='' Then naamx.w='Speler 'n
    Else naamx.w=naam.n
  End
End n
Rxcls(,15,0,19,79); Rxsetpos(16,0)
If w=1 Then Say naamx.1' heeft gewonnen met 'sct' punten!'
Else Do
  Say 'Deze spelers hebben gewonnen met 'sct' punten:'
  Do n=1 to w
    If n//2=0 Then x=25; Else x=0
    Rxsetpos(16+Trunc(Abs(n/2+1/2),0),x); Say naamx.n
  End n
End

Return
/* einde einde.winnaar */

/* Yathzee-Top-10 bijwerken */
einde.top10bijw: Procedure Expose splrs scl. scr. naam. scr versie

/* totaalscores spelers + namen controleren */
Do n=splrs to 1 by -1
  If naam.n='' Then naam.n=Substr('Yathzee v'versie,1,20)
  Else naam.n=Substr(naam.n,1,20)
  If scl.n>63 Then scl.n=scl.n+35
  sc.n=naam.n||Right(scl.n+scr.n,3,'0')
End n

/* file openen + oude Yathzee-Top-10 inlezen */
rc=Stream(scr,'c','open')
Do n=10+splrs to splrs+1 by -1; sc.n=Charin(scr,,23); End n

/* alle scores sorteren m.b.v. Bubblesort */
grens=splrs+10
Do splrs Until stop; grens=grens-1; n=0; stop=0
  Do Until ok | n=grens; n=n+1; m=n+1; ok=0
    If Substr(sc.n,21,3)>Substr(sc.m,21,3) Then Do
      h=sc.n; sc.n=sc.m; sc.m=h; End
    Else If n>splrs Then ok=1
    Else If n=splrs Then Do; ok=1; stop=1; End
  End
End

/* nieuwe Yathzee-Top-10 wegschrijven + file sluiten */
rc=Stream(scr,'c','seek =1')
Do n=10+splrs to splrs+1 by -1; rc=Charout(scr,sc.n); End n
rc=Stream(scr,'c','close')

Return
/* einde einde.top10bijw */

/* Speler wil Yathzee-Top-10 zien */
top10zien: Procedure Expose scr splrs versie

splrs='nowait'
Rxcls(); Rxsetpos(2,0)
rc=Charout(,Centre('Yathzee-Top-10  Yathzee v'versie,80)); Say; Say
Queue 'ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»'
Queue 'º Speler                           ³ Score             º'
Queue 'ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶'
Queue 'ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼'
Do 3; Parse Pull q; rc=Charout(,Centre(q,80)); End
rc=Stream(scr,'c','open read')
Do n=8 to 17
  rc=Charout(,Centre('º 'Right(n-7,2,'0')'. 'Charin(scr,,20)'         ³ '||,
  Charin(scr,,3)'               º',80))
End
rc=Stream(scr,'c','close')
Parse Pull q; rc=Charout(,Centre(q,80)); Say; Say; Say
Do While Chars()<>0; rc=Rxgetkey('noecho'); End
rc=Charout(,Centre('Druk op een toets om verder te gaan ...',80))
rc=Rxgetkey('noecho')

Return
/* einde top10zien */
