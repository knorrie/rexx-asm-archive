/* UserInput v2.00 example */
RxCls()
RxSetPos(20,0)
RxCrStat('off')
p=UsrInput('301B1A2E'x,'hallo')
/*p=UsrInput('307F1A2E050A'x,'hallo')*/
Say p Length(p)
RxCrStat('on')
Exit
