/* Encrypt - Decrypt v1.02 by Hans van Kranenburg */

Trace Off; Parse Arg file.1 file.2 key.1
Say; Say 'Encrypt - Decrypt v1.02'
Say; Say "Ensure that disks you want to use aren't write-protected"; Say
wipeinfo=1 /* only if wipeinfo is available */
Call info
Call crypt
Call end

Exit
/* end main */

/* Get information from user */
info: Procedure Expose file. key.1 iio

If file.1='' Then Do
  Do Until ok; ok=1
    rc=Charout(,'Enter filename of inputfile  : '); Pull file.1
    If Rxisdir(file.1)<>0 Then Do
      ok=0; Say "File doesn't exist"
      rc=Charout(,X2c(7)) /* Beep */
    End
  End
  Do Until ok; ok=1
    rc=Charout(,'Enter filename of outputfile : '); Pull file.2
    If Rxisdir(file.2)<>'' & file.2<>file.1 Then Do
      ok=0; Say 'File already exists'; End
    Else If file.2='' Then Do
      ok=0; Say 'Invalid input, try again...'
      rc=Charout(,X2c(7)) /* Beep */
    End
  End
  If file.1=file.2 Then Do; iio=1 /* inputfile is outputfile */; file.2=''
    Do Until Rxisdir(file.2)=''
      Do 8
        file.2=(file.2)(D2c(Random(65,90)))
      End
    End
  End; Else iio=0
  Do Until key.1=key.2
    Say
    Do n=1 to 2
      key.n=''; rc=Charout(,'Enter Encryption key : ')
      Do Until c2d(q)=13
        q=Rxgetkey('noecho')
        If c2d(q)<>13 Then key.n=(key.n)(q)
      End
      If n=1 Then Do
        Say; Say 'Please re-enter encryption key for verification'; End
    End n
    If key.1<>key.2 Then Do
      Say; Say "Keys doesn't match -- try again..."
      rc=Charout(,X2c(7)) /* Beep */
    End
  End
End

Return
/* end info */

/* Encrypt/Decrypt file */
crypt: Procedure Expose file. key.

rc=Stream(file.1,'c','open read')
rc=Stream(file.2,'c','open write')
lof=Stream(file.1,'c','query size')
Say; Say; Say 'Length of inputfile : 'lof' bytes'; Say 'Encrypting file...'; Say
l=Length(key.1)
blocks=Trunc(lof/l)
If blocks>0 Then Do block=1 to blocks
  rc=Charout(file.2,Bitxor(Charin(file.1,,l),key.1))
End
remain=lof//l
If remain>0 Then Do
  l=remain; key.1=Substr(key.1,1,l)
  rc=Charout(file.2,Bitxor(Charin(file.1,,l),key.1))
End
rc=Stream(file.1,'c','close')
rc=Stream(file.2,'c','close')

Return
/* end crypt */

/* End of program, some questions etc. */
end: Procedure Expose file. iio wipeinfo

error=0; rc=Charout(,'(D)elete, (W)ipe input file or do (N)othing ? ')
Do Until q='D' | q='W' | q='N'
  q=Translate(Rxgetkey('echo'))
End
Say
If q<>'N' Then Do; error=1
  attrib=Subword(Rxfinfo(file.1),5)
  If Substr(attrib,3,1)<>'-' Then Say "Can't delete/wipe hidden files"
  Else If Substr(attrib,5,1)<>'-' Then Say "Can't delete/wipe system files"
  Else If Substr(attrib,4,1)<>'-' Then Say 'File is readonly'
  Else Do; error=0
    Select
      When q='D' Then rc=Rxdelete(file.1)
      When q='W' Then Do
        If wipeinfo Then 'wipeinfo 'file.1' /batch'
        Else Do
          rc=Stream(file.1,'c','open write')
          Do Stream(file.1,'c','query size'); rc=Charout(file.1,'X'); End
          rc=Stream(file.1,'c','close')
          rc=Rxdelete(file.1)
        End
      End
    End
    If iio Then 'ren 'file.2 file.1
  End
End
If q='N' & iio | error Then Say 'Name of encrypted file : 'file.2

Return
/* end end */
