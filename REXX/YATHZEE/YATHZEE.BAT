/* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ */
/* ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป */
/* บ YATHZEE REXX Versie 1.00 door Hans van Kranenburg 1995    บ */
/* ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ */

trace off

/* begin einde-loop: als de speler wil stoppen dan krijgt einde waarde 1,
   anders begint het spel weer opnieuw */
Do Until einde=1

/* HOOFDPROGRAMMA */
/* initialisatie: variabelen beginwaarden geven etc, deel 1 */
Call initialisatie.1

/* het openingsscherm op het scherm zetten */
Call scr.opening

/* informatie over de spelers opvragen: hoeveel + naam + initialen */
Call infosp

/* initialisatie: variabelen beginwaarden geven etc, deel 2 */
Call initialisatie.2

/* speelscherm opbouwen */
Call scr.spelscherm

/* Spelen */
Do spelteller=1 to 13                  /* 13 vakjes moeten punten in komen */
  Do sp=1 to splrs                    /* alle spelers om de beurt */
    Call scr.hoofdprogramma.sp.init.naam
    Call gv                            /* gooien en vasthouden */
    Call bubble                        /* sorteren gegooide stenen */
    Call keuze                         /* kiezen in welk vakje de punten
                                          moeten komen */
    If einde=1                         /* als keuze is einde spel op gegeven */
      Then Leave
      Else Nop
    Call punten                        /* na iedere beurt wordt de totaal-
                                          score berekend */
  End
If einde=1
  Then Leave
  Else Nop
End

Call einde                             /* punten definitief, nog een keer? */

End /* einde einde-loop voor toelichting zie begin programma */

/* einde Yathzee */
rxcls()
Exit
/* EINDE HOOFDPROGRAMMA */

/* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ */
/* SUBROUTINES PROGRAMMAONDERDELEN */

/* Initialisatie-1 */
initialisatie.1:

/* variabelen beginwaarden geven */
c=0                                    /* controle, krijgt waarde 1 of 0 */
n=0                                    /* gebruikt voor allerlei dingen,
                                          hoofdzakelijk als teller in een
                                          loopje oid */
m=0                                    /* zie toel. bij n */
l=0                                    /* zie toel. bij n */
k=0                                    /* zie toel. bij n */
j=0                                    /* zie toel. bij n */
h=0                                    /* hulp bij omwisselen van variabelen */
w=0                                    /* worp, krijgt waarde 1,2,3 */
true=0                                 /* als het waar is krijgt true de
                                          waarde 1, wordt verschillend
                                          gebruikt */
og=0                                   /* opgegeven getal voor enen,tweeen,
                                          etcetera-routine, krijgt waarde
                                          1,2,3,4,5,6 */
spelteller=0                           /* krijgt waarde 1 tot 13, 13 vakjes
                                          waar punten in moeten komen */
sp=0                                   /* welke speler aan de beurt is */
splrs=0                                /* aantal spelers */
nogkeer=''                             /* krijgt waarde J,N bij vraag aan
                                          einde spel of men nog een keer wil */
toets='toets'                          /* invoer vanaf toetsenbord */
grens=0                                /* gebruikt in bubblesort */
keuze=''                               /* keuze gemaakt in subroutine keuze */
lines=''                               /* wordt gebruikt in subroutine
                                          scr.opening bij het instellen van
                                          het 80x25 scherm */
hpos=0                                 /* horizontale positie cursor */
vpos=0                                 /* verticale positie cursor
                                          gebruikt bij schermopbouw */
scthoogste=0                           /* hierin komt de hoogste totaalscore */
scthoogstespeler=0                    /* en hierin wie de hoogste score heeft */
einde=0                                /* als men wil stoppen met het spel
                                          krijgt einde waarde 1, wordt
                                          verder alles overgeslagen en komt
                                          het programma direct in de subroutine
                                          einde terecht */

/* array's beginwaarden geven */
  /* de array's naam en init worden in de subroutine infosp ingesteld */
Do n=1 to 5
  st.n=0                               /* dobbelstenen 5x */
  v.n=0                                /* vasthouden na worp voor volgende */
End

/* einde subroutine initialisatie.1 */
Return

/* Informatie spelers opvragen */
infosp:

Call scr.infosp.spelers

/* aantal spelers */
Do Until c=0
  c=0
    rxsetpos(14,27)
    toets=rxgetkey(noecho)
    rxwrscr(toets,23)
  Select
    When toets=1
      Then splrs=1
    When toets=2
      Then splrs=2
    When toets=3
      Then splrs=3
    When toets=4
      Then splrs=4
    When toets=5
      Then splrs=5
    Otherwise
      Do
        c=1
        Call scr.infosp.foutspelers
      End
  End
End

Call scr.infosp.cleanfoutspelers

/* namen en initialen van spelers */
vpos=15
Do sp=1 to splrs
  Call scr.infosp.naam
  Parse Pull string
  naam.sp=substr(string,1,20)
  vpos=vpos+1
End

vpos=15
Do sp=1 to splrs
  Call scr.infosp.init
  Parse Pull string
  init.sp=substr(string,1,4)
  vpos=vpos+1
End

/* einde subroutine infosp */
Return

/* Initialisatie-2 */
initialisatie.2:

/* variabelen beginwaarden geven */

/* array's beginwaarden geven */
Do sp=1 to splrs
  /* score per vakje */
  Do n=1 to 6
    ete.sp.n=-1                        /* enen, tweeen, etcetera per speler */
  End
  driedz.sp=-1                         /* drie dezelfde per speler */
  vierdz.sp=-1                         /* vier dezelfde per speler */
  vb.sp=-1                             /* volle bak per speler */
  ks.sp=-1                             /* kleine straat per speler */
  gs.sp=-1                             /* grote straat per speler */
  yathzee.sp=-1                        /* yathzee per speler */
  vk.sp=-1                             /* vrije keuze per speler */
  /* score totaal */
  scl.sp=0                             /* score linkerhelft */
  sclb.sp=0                            /* score linkerhelft met evt bonus */
  scr.sp=0                             /* score rechterhelft */
  sct.sp=0                             /* score links+rechts */
End

/* einde subroutine initialisatie.2 */
Return

/* Gooien en vasthouden */
gv:

/* array vasthouden leegmaken */
Do n=1 to 5
  v.n=0
End

/* initialisatie */
w=0

/* gooien 3x en vasthouden 2x */
Do 3                                   /* 3x werpen */
  w=w+1                                /* volgende worp */
  Call scr.gv.worp
  n=0                                  /* 5x dobbelsteen gooien */
  Do n=1 to 5                          /*        -              */
    If v.n=1                           /*        -              */
      Then Nop                         /*        -              */
      Else st.n=random(1,6)            /*        -              */
  End                                  /*        -              */
  Call scr.gv.stenen.afbeelden
  If w=3                               /* 3e worp geweest? */
    Then Nop                           /* dan niet meer vasthouden */
    Else                               /* anders wel */
      Do                               /* vasthouden */
        Call scr.gv.vasthouden
        toets=rxgetkey(echo)           /* welke steen vasthouden? */
        Do Until toets='G' | toets='g' | c2d(toets)=13
                                       /* zolang niet stop met vasthouden */
          Select
            When toets=1               /* steen 1 vasthouden */
              Then
                Do                     /*        -           */
                  If v.1=1             /*        -           */
                    Then v.1=0         /*        -           */
                    Else v.1=1         /*        -           */
                  Call scr.gv.steenvasthouden
                End                    /*        -           */
            When toets=2               /* steen 2 vasthouden */
              Then
                Do                     /*        -           */
                  If v.2=1             /*        -           */
                    Then v.2=0         /*        -           */
                    Else v.2=1         /*        -           */
                  Call scr.gv.steenvasthouden
                  End                  /*        -           */
            When toets=3               /* steen 3 vasthouden */
              Then
                Do                     /*        -           */
                  If v.3=1             /*        -           */
                    Then v.3=0         /*        -           */
                    Else v.3=1         /*        -           */
                  Call scr.gv.steenvasthouden
                End                    /*        -           */
            When toets=4               /* steen 4 vasthouden */
              Then
                Do                     /*        -           */
                  If v.4=1             /*        -           */
                    Then v.4=0         /*        -           */
                    Else v.4=1         /*        -           */
                  Call scr.gv.steenvasthouden
                End                    /*        -           */
            When toets=5               /* steen 5 vasthouden */
              Then
                Do                     /*        -           */
                  If v.5=1             /*        -           */
                    Then v.5=0         /*        -           */
                    Else v.5=1         /*        -           */
                  Call scr.gv.steenvasthouden
                End                    /*        -           */
            When toets='R' | toets='r' /* reset vasthouden */
              Then                     /*        -         */
                Do                     /*        -         */
                  Do n=1 to 5          /*        -         */
                    v.n=0              /*        -         */
                  End                  /*        -         */
                  Call scr.stenenlos   /*        -         */
                End                    /*        -         */
            When toets='G' | toets='g' | c2d(toets)=13
              Then Nop
            Otherwise                  /* ingevoerde toets niet van */
              Call scr.gv.verkeerdeinvoer  /* toepassing                */
          End
        If toets='G' | toets='g' | c2d(toets)=13
          Then Nop
          Else
            Do
              toets=rxgetkey(echo)
              Call scr.cleanstatusregel
            End
        End
      End
End

/* einde gooien-vasthouden subroutine */
Return

/* Bubblesort routine voor YATHZEE */
bubble:

/* initialisatie */
grens=5

/* sorteren */
Do Until c=0
  n=0
  c=0
  grens=grens-1
  If grens=0
    Then Nop
    Else
      Do Until n=grens
        n=n+1
        m=n+1
        If st.n > st.m
          Then
            Do
            c=1
            h=st.n
            st.n=st.m
            st.m=h
            End
          Else Nop
      End
End

/* einde bubblesort subroutine */
Return

/* Keuze + Afhandeling punten etc... */
keuze:

/* initialisatie */
n=0

/* Keuze: 01. enen
          02. tweeen
          03. drieen
          04. vieren
          05. vijven
          06. zessen
          07. driedz,drie dezelfde
          08. vierdz,vier dezelfde
          09. vb,volle bak
          10. ks,kleine straat
          11. gs,grote straat
          12. yathzee
          13. vk,vrije keuze
          14. einde spel */
Call scr.stenenlos
Call scr.keuze.keuze
rxcls(,15,15,15,79)
Pull keuze

Do Until c=0
c=0
  Select
    When keuze>0 & keuze<7
      Then
        Do
          og=keuze
          If ete.sp.og=-1
            Then Call ete
            Else Call scr.keuze.keuzealgemaakt
        End
    When keuze=7
      Then
        Do
          If driedz.sp=-1
            Then Call driedz
            Else Call scr.keuze.keuzealgemaakt
        End
    When keuze=8
      Then
        Do
          If vierdz.sp=-1
            Then Call vierdz
            Else Call scr.keuze.keuzealgemaakt
        End
    When keuze=9
      Then
        Do
          If vb.sp=-1
            Then Call vb
            Else Call scr.keuze.keuzealgemaakt
        End
    When keuze=10
      Then
        Do
          If ks.sp=-1
            Then Call ks
            Else Call scr.keuze.keuzealgemaakt
        End
    When keuze=11
      Then
        Do
          If gs.sp=-1
            Then Call gs
            Else Call scr.keuze.keuzealgemaakt
        End
    When keuze=12
      Then
        Do
          If yathzee.sp=-1
            Then Call yathzee
            Else Call scr.keuze.keuzealgemaakt
        End
    When keuze=13
      Then
        Do
          If vk.sp=-1
            Then Call vk
            Else Call scr.keuze.keuzealgemaakt
        End
    When keuze=14
      Then einde=1
    Otherwise
      Do
        Call scr.keuze.foutekeuze
        rxcls(,15,15,15,79)
        Pull keuze
        Call scr.cleanstatusregel
      End
  End
End

/* Einde subroutine keuze */
Return


/* Check enen, tweeen, etcetera */
ete:

/* initialisatie */
true=0

/* check */
Do n=1 to 5
 If st.n=og
   Then true=true+1
   Else nop
End

/* punten */
ete.sp.og=true * og
Call scr.punten.ete

/* einde subroutine */
Return

/* Drie dezelfde */
driedz:

/* initialisatie */
n=0
true=0
driedz.sp=0

/* check */
Do Until true=1 | n=3
  n=n+1
  m=n+1
  l=m+1
  If st.n=st.m & st.m=st.l
    Then true=1
    Else Nop
End

/* punten */
If true=1
  Then
    Do n=1 to 5
    driedz.sp=driedz.sp+st.n
    End
  Else Nop
Call scr.punten.driedz

/* einde subrountine driedz */
Return

/* Vier dezelfde */
vierdz:

/* initialisatie */
n=0
true=0
vierdz.sp=0

/* check */
Do Until true=1 | n=2
  n=n+1
  m=n+1
  l=m+1
  k=l+1
  If st.n=st.m & st.m=st.l & st.l=st.k
    Then true=1
    Else Nop
End

/* punten */
If true=1
  Then
    Do n=1 to 5
    vierdz.sp=vierdz.sp+st.n
    End
  Else Nop
Call scr.punten.vierdz

/* einde subrountine vierdz */
Return

/* Volle bak */
vb:

/* initialisatie */
vb.sp=0
n=1
m=n+1
l=m+1
k=l+1
j=k+1

/* check & punten */
If st.n=st.m & st.m=st.l & st.l<>st.k & st.k=st.j
  Then vb.sp=25
  Else
    Do
      If st.n=st.m & st.m<>st.l & st.l=st.k & st.k=st.j;
        Then vb.sp=25
        Else Nop
    End
Call scr.punten.vb

/* einde subroutine vb */
Return

/* Kleine straat */
ks:

/* initialisatie */
n=0
true=0
ks.sp=0

/* check */
Do Until true=1 | n=2
  n=n+1
  m=n+1
  l=m+1
  k=l+1
  If st.n+3=st.m+2 & st.m+2=st.l+1 & st.l+1=st.k
    Then true=1
    Else nop
End

/* punten */
If true=1
  Then ks.sp=30
  Else nop
Call scr.punten.ks

/* einde subroutine ks */
Return

/* Grote straat */
gs:

/* initialisatie */
n=1
m=n+1
l=m+1
k=l+1
j=k+1
true=0
gs.sp=0

/* check */
If st.n+4=st.m+3 & st.m+3=st.l+2 & st.l+2=st.k+1 & st.k+1=st.j
  Then true=1
  Else nop

/* punten */
If true=1
  Then gs.sp=40
  Else Nop
Call scr.punten.gs

/* einde subroutine gs*/
Return

/* Yathzee */
yathzee:

/* check & punten */
If st.1=st.2 & st.2=st.3 & st.3=st.4 & st.4=st.5
  Then yathzee.sp=50
  Else yathzee.sp=0
Call scr.punten.yathzee

/* einde subroutine yathzee */
Return

/* Vrije keuze */
vk:

/* initialisatie */
vk.sp=0

/* punten */
Do n=1 to 5
  vk.sp=vk.sp+st.n
End
Call scr.punten.vk

/* einde subroutine vk */
Return

/* punten opnieuw optellen */
punten:

/* totaalscores op 0 zetten */
scl.sp=0
sclb.sp=0
scr.sp=0
sct.sp=0

/* punten optellen */
Do n=1 to 6
  If ete.sp.n=-1
    Then Nop
    Else scl.sp=scl.sp+ete.sp.n
End
If scl.sp > 63
  Then sclb.sp=scl.sp+35
  Else sclb.sp=scl.sp
If driedz.sp=-1
  Then Nop
  Else scr.sp=scr.sp+driedz.sp
If vierdz.sp=-1
  Then Nop
  Else scr.sp=scr.sp+vierdz.sp
If vb.sp=-1
  Then Nop
  Else scr.sp=scr.sp+vb.sp
If ks.sp=-1
  Then Nop
  Else scr.sp=scr.sp+ks.sp
If gs.sp=-1
  Then Nop
  Else scr.sp=scr.sp+gs.sp
If yathzee.sp=-1
  Then Nop
  Else scr.sp=scr.sp+yathzee.sp
If vk.sp=-1
  Then Nop
  Else scr.sp=scr.sp+vk.sp
sct.sp=sclb.sp+scr.sp

/* punten afbeelden */
Call scr.punten

/* einde subroutine punten */
Return

/* Einde */
einde:

/* wie heeft er het meeste punten? */
scthoogste=sct.1
scthoogstespeler=1
If splrs > 1
  Then
    Do sp=2 to splrs
      If sct.sp > scthoogste
        Then
          Do
            scthoogste=sct.sp
            scthoogstespeler=sp
          End
        Else Nop
    End
  Else Nop

Call scr.einde.wiegewonnen

/* opvragen of men nog een keer wil spelen */
Do Until c=0
  c=0
  Call scr.cleanstatusregel
  Call scr.einde.nogkeer
  nogkeer=rxgetkey(noecho)
  rxwrscr(nogkeer,7)
  Select
    When nogkeer='J' | nogkeer='j'
      Then true=1
    When nogkeer='N' | nogkeer='n'
      Then true=0
    Otherwise c=1
  End
End

If true=1
  Then einde=0
  Else
    Do
      einde=1
      Call scr.cleanstatusregel
      Call scr.einde.totziens
    End

/* Einde subroutine einde */
Return



/* EINDE SUBROUTINES PROGRAMMAONDERDELEN */

/* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ */
/* SUBROUTINES SCHERMOPBOUW */

/* Openingsscherm afbeelden */
scr.opening:

trace off

lines=rxscrsiz()
/*If lines='25 80'
  Then Nop
  Else 'mode con lines=25'*/

rxcrstat('off')
rxcls(16)
rxsetpos(2,10)
rxwrscr('Û     Û  Û฿฿฿฿฿Û  ฿฿฿Û฿฿฿  Û     Û  ฿฿฿฿฿฿Û  Û฿฿฿฿฿฿  Û฿฿฿฿฿฿',18)
rxsetpos(3,10)
rxwrscr('Û     Û  Û     Û     Û     Û     Û        Û  Û        Û      ',18)
rxsetpos(4,10)
rxwrscr('฿฿฿Û฿฿฿  Û฿฿฿฿฿Û     Û     Û฿฿฿฿฿Û   ÜÜÜ฿฿฿  Û฿฿฿฿฿   Û฿฿฿฿฿ ',18)
rxsetpos(5,10)
rxwrscr('   Û     Û     Û     Û     Û     Û  Û        Û        Û      ',18)
rxsetpos(6,10)
rxwrscr('   Û     Û     Û     Û     Û     Û  ÛÜÜÜÜÜÜ  ÛÜÜÜÜÜÜ  ÛÜÜÜÜÜÜ',18)
rxsetpos(8,10)
rxwrscr('              Û฿฿฿฿฿Û  Û฿฿฿฿฿฿  Û     Û  Û     Û             ',18)
rxsetpos(9,10)
rxwrscr('              Û     Û  Û         Û   Û    Û   Û              ',18)
rxsetpos(10,10)
rxwrscr('              Û฿฿฿Û฿฿  Û฿฿฿฿฿     ÛÛÛ      ÛÛÛ               ',18)
rxsetpos(11,10)
rxwrscr('              Û    Û   Û         Û   Û    Û   Û              ',18)
rxsetpos(12,10)
rxwrscr('              Û     Û  ÛÜÜÜÜÜÜ  Û     Û  Û     Û             ',18)
rxsetpos(24,22)
rxwrscr('Hans van Kranenburg 1995  REXX freeware',23)
rxsleep(3)
rxcrstat('on')

/* einde subroutine scherm.opening */
Return

/* Speelscherm opbouwen */
scr.spelscherm:

trace off

rxcrstat('off')
rxcls()
rxsetpos(0,0)
rxwrscr('                               YATHZEE REXX v1.00            Hans van Kranenburg',23)
rxsetpos(2,0)
Say'ษอออออออออออออหออออัออออัออออัออออัออออหออออออออออออออหออออัออออัออออัออออัออออป'
rxsetpos(3,0)
Say'บEnen         บ    ณ    ณ    ณ    ณ    บDrie dezelfde บ    ณ    ณ    ณ    ณ    บ'
rxsetpos(4,0)
Say'บTween       บ    ณ    ณ    ณ    ณ    บVier dezelfde บ    ณ    ณ    ณ    ณ    บ'
rxsetpos(5,0)
Say'บDrien       บ    ณ    ณ    ณ    ณ    บVolle bak     บ    ณ    ณ    ณ    ณ    บ'
rxsetpos(6,0)
Say'บVieren       บ    ณ    ณ    ณ    ณ    บKleine straat บ    ณ    ณ    ณ    ณ    บ'
rxsetpos(7,0)
Say'บVijven       บ    ณ    ณ    ณ    ณ    บGrote straat  บ    ณ    ณ    ณ    ณ    บ'
rxsetpos(8,0)
Say'บZessen       บ    ณ    ณ    ณ    ณ    บYathzee       บ    ณ    ณ    ณ    ณ    บ'
rxsetpos(9,0)
Say'วฤฤฤฤฤฤฤฤฤฤฤฤฤืฤฤฤฤลฤฤฤฤลฤฤฤฤลฤฤฤฤลฤฤฤฤถVrije keuze   บ    ณ    ณ    ณ    ณ    บ'
rxsetpos(10,0)
Say'บTotaal puntenบ    ณ    ณ    ณ    ณ    วฤฤฤฤฤฤฤฤฤฤฤฤฤฤืฤฤฤฤลฤฤฤฤลฤฤฤฤลฤฤฤฤลฤฤฤฤถ'
rxsetpos(11,0)
Say'บExtra bonus  บ    ณ    ณ    ณ    ณ    บTotaal rechts บ    ณ    ณ    ณ    ณ    บ'
rxsetpos(12,0)
Say'บTotaal links บ    ณ    ณ    ณ    ณ    บTotaal links  บ    ณ    ณ    ณ    ณ    บ'
rxsetpos(13,0)
Say'ศอออออออออออออสออออฯออออฯออออฯออออฯออออนTotaal ฤฤฤฤฤฤ>บ    ณ    ณ    ณ    ณ    บ'
rxsetpos(14,0)
Say'                                       ศออออออออออออออสออออฯออออฯออออฯออออฯออออผ'
rxsetpos(14,0)
rxwrscr('Speler',9)
rxsetpos(21,23)
Say'ษอออป  ษอออป  ษอออป  ษอออป  ษอออป'
rxsetpos(22,23)
Say'บ   บ  บ   บ  บ   บ  บ   บ  บ   บ'
rxsetpos(23,23)
Say'ศอออผ  ศอออผ  ศอออผ  ศอออผ  ศอออผ'
Call scr.cleanstatusregel

hpos=15
Do sp=1 to splrs
  rxsetpos(1,hpos)
  rxwrscr(init.sp,7)
  hpos=hpos+40
  rxsetpos(1,hpos)
  rxwrscr(init.sp,7)
  hpos=hpos-35
End

Do vpos=10 to 12
  Do sp=1 to splrs
    rxsetpos(vpos,13+5*sp)
    Say '0'
  End
End
Do vpos=11 to 13
  Do sp=1 to splrs
    rxsetpos(vpos,53+5*sp)
    Say '0'
  End
End

rxcrstat('on')

/* einde subroutine spelscherm opbouwen */
Return

scr.cleanstatusregel:
    rxcls(16,24,6,24,79)
   Return

scr.infosp.cleanfoutspelers:
    rxcls(16,23,0,23,79)
   Return

scr.infosp.spelers:
    rxsetpos(14,5)
    rxwrscr('Aantal spelers? (1-5)',23)
   Return

scr.infosp.foutspelers:
    rxsetpos(23,5)
    rxwrscr('Verkeerde invoer -- Aantal spelers 1, 2, 3, 4 of 5',23)
   Return

scr.infosp.naam:
    rxsetpos(vpos,5)
    rxwrscr('Naam speler 'sp':',23)
    rxcls(,vpos,20,vpos,40)
    rxsetpos(vpos,20)
   Return

scr.infosp.init:
    rxsetpos(vpos,44)
    rxwrscr('Initialen speler 'sp':',23)
    rxcls(,vpos,64,vpos,68)
    rxsetpos(vpos,64)
   Return

scr.hoofdprogramma.sp.init.naam:
    rxcls(,14,20,14,38)
    rxsetpos(14,7)
    rxwrscr(sp,9)
    rxsetpos(14,12)
    rxwrscr(init.sp,9)
    rxsetpos(14,19)
    rxwrscr(naam.sp,9)
   Return

scr.gv.stenen.afbeelden:
    hpos=25
    Do n=1 to 5
      rxsetpos(22,hpos)
      Say st.n
      hpos=hpos+7
    End
   Return

scr.gv.vasthouden:
    rxcls(,15,0,19,79)
    rxsetpos(15,0)
    Say'Welke stenen moeten vastgehouden worden bij de volgende worp?'
    rxsetpos(16,2)
    Say'1. Steen 1  5. Steen 5'
    rxsetpos(17,2)
    Say'2. Steen 2  R. Alle stenen los'
    rxsetpos(18,2)
    Say'3. Steen 3  G. Volgende worp'
    rxsetpos(19,2)
    Say'4. Steen 4'
    rxsetpos(15,62)
   Return

scr.gv.worp:
    rxsetpos(24,0)
    rxwrscr('Worp 'w,23)
   Return

scr.gv.steenvasthouden:
    If v.toets=1
      Then
        Do
          rxsetpos(21,16+7*toets)
          rxwrscr('ษอออป',10)
          rxsetpos(22,16+7*toets)
          rxwrscr('บ',10)
          rxsetpos(22,20+7*toets)
          rxwrscr('บ',10)
          rxsetpos(23,16+7*toets)
          rxwrscr('ศอออผ',10)
        End
      Else
        Do
          rxsetpos(21,16+7*toets)
          Say'ษอออป'
          rxsetpos(22,16+7*toets)
          Say'บ 'st.toets' บ'
          rxsetpos(23,16+7*toets)
          Say'ศอออผ'
        End
    rxsetpos(15,62)
   Return

scr.stenenlos:
    Do n=1 to 5
      rxsetpos(21,16+7*n)
      Say'ษอออป'
      rxsetpos(22,16+7*n)
      Say'บ '
      rxsetpos(22,20+7*n)
      Say'บ'
      rxsetpos(23,16+7*n)
      Say'ศอออผ'
    End
    rxsetpos(15,62)
   Return

scr.gv.verkeerdeinvoer:
    rxcls(16,24,6,24,79)
    rxsetpos(24,17)
    rxwrscr('Verkeerde keuze -- Toets 1, 2, 3, 4, 5, R of G',23)
    rxsetpos(15,62)
   Return

scr.keuze.keuze:
    rxcls(,15,0,19,79)
    rxsetpos(15,0)
    Say'Maak uw keuze: '
    rxsetpos(16,2)
    Say'1. Enen    5. Vijven          9. Volle bak      13. Vrije keuze'
    rxsetpos(17,2)
    Say'2. Tween  6. Zessen         10. Kleine straat  14. Einde spel'
    rxsetpos(18,2)
    Say'3. Drien  7. Drie dezelfde  11. Grote straat'
    rxsetpos(19,2)
    Say'4. Vieren  8. Vier dezelfde  12. Yathzee'
    rxsetpos(15,15)
   Return

scr.keuze.keuzealgemaakt:
    rxcls(16,24,6,24,79)
    rxsetpos(24,24)
    rxwrscr('Deze keuze is al eerder gemaakt.',23)
    rxsetpos(15,15)
      /* programmaonderldeel dat eigenlijk boven had moeten staan */
      c=1
      rxcls(,15,15,15,79)
      Pull keuze
      Call scr.cleanstatusregel
      /* einde */
   Return

scr.keuze.foutekeuze:
    rxcls(16,24,6,24,79)
    rxsetpos(24,28)
    rxwrscr('Verkeerde keuze gemaakt.',23)
    rxsetpos(15,15)
    c=1
   Return

scr.punten.ete:
/* punten ete afbeelden */
    vpos=3
    Do n=1 to 6
      If ete.sp.n=-1
        Then Nop
        Else
          Do
            h=right(ete.sp.n,2)
            rxsetpos(vpos,12+5*sp)
            Say h
          End
        vpos=vpos+1
    End
   Return

scr.punten.driedz:
/* punten driedz afbeelden */
    h=right(driedz.sp,2)
    rxsetpos(3,52+5*sp)
    Say h
   Return

scr.punten.vierdz:
/* punten vierdz afbeelden */
    h=right(vierdz.sp,2)
    rxsetpos(4,52+5*sp)
    Say h
   Return

scr.punten.vb:
/* punten vb afbeelden */
    h=right(vb.sp,2)
    rxsetpos(5,52+5*sp)
    Say h
   Return

scr.punten.ks:
/* punten ks afbeelden */
    h=right(ks.sp,2)
    rxsetpos(6,52+5*sp)
    Say h
   Return

scr.punten.gs:
/* punten gs afbeelden */
    h=right(gs.sp,2)
    rxsetpos(7,52+5*sp)
    Say h
   Return

scr.punten.yathzee:
/* punten yathzee afbeelden */
    h=right(yathzee.sp,2)
    rxsetpos(8,52+5*sp)
    Say h
   Return

scr.punten.vk:
/* punten vk afbeelden */
    h=right(vk.sp,2)
    rxsetpos(9,52+5*sp)
    Say h
   Return

scr.punten:
/* totaalscores afbeelden */
      /* score links */
      h=right(scl.sp,3)
      rxsetpos(10,11+5*sp)
      Say h

      /* evt bonus */
      If scl.sp > 63
        Then
          Do
            rxsetpos(11,12+5*sp)
            Say '35'
          End
        Else Nop

      /* score links met evt bonus */
      h=right(sclb.sp,3)
      rxsetpos(12,11+5*sp)
      Say h
      rxsetpos(12,51+5*sp)
      Say h

      /* score rechts */
      h=right(scr.sp,3)
      rxsetpos(11,51+5*sp)
      Say h

      /* totaalscore */
      h=right(sct.sp,3)
      rxsetpos(13,51+5*sp)
      Say h
   Return

scr.einde.nogkeer:
    rxsetpos(24,23)
    rxwrscr('Wilt u nog een keer spelen? (J,N)',23)
    rxsetpos(24,57)
   Return

scr.einde.totziens:
    rxsetpos(24,35)
    rxwrscr('Tot ziens!!!',23)
    rxsleep(2)
   Return

scr.einde.wiegewonnen:
    rxcls(,15,0,19,79)
    rxsetpos(16,0)
    naam.scthoogstespeler=strip(naam.scthoogstespeler,'t')
    rxwrscr(naam.scthoogstespeler' heeft de meeste punten.',7)
    rxsetpos(17,0)
    rxwrscr('Deze speler heeft dus gewonnen!!!',7)
   Return

/* ษออออออออออออออออออออป */
/* บ EINDE YATHZEE REXX บ */
/* ศออออออออออออออออออออผ */
