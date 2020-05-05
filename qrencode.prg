#include "hbzebra.ch"
#include "hbwin.ch"
#include "ct.ch"
REQUEST HB_CODEPAGE_DEWIN
*******************************************************************************************************************
Procedure Main
   parameter numero
   Local import,cant,dec,idcli,cant2,numfac,cantfac,a, id1, id2,import2
   Local tocut := {}
   Local to3 := {}
   Local to2 := {}
   Local qr2 := {}
   Local qr1 := {}
   tocut := hb_ValToStr(numero)
   
   to2 := AllTrim(SubStr(tocut,2,28))
   to3 := AllTrim(SubStr(tocut,31,28))
   id1 := AllTrim(Substr(tocut,1,1))
   id2 := AllTrim(Substr(tocut,30,1))
  
 prn_init()
 
 oPrn:SetFont( "Courier New", 7, { 3, -50 } )
 if id1 == "a" 
   ** Formato
   qr1 := "000201"
  
   mk_qrcode(qr1,755,397)   
   EanBarCode(oPrn,187,50,1,to2,HB_ZEBRA_FLAG_CHECKSUM)      
   oPrn:TextOutAt(500, 1600, "*" +to2+ "*")                    

 endif
   
 prn_exit()
 Return
*******************************************************************************************************************
Function mk_qrcode(ccString, posx, posy)
// ChecoCode for Cooperativa Electrica Colon
local qr_arr := {}
local i
   for i = 1 to 5
      intpos := at(",",ccString)
      t_string := substr(ccString,1,intpos-1)
      aadd(qr_arr,t_string)
      ccString := right(ccString,len(ccString)-intpos)
   next i
   qr_feld01 := ccString            // Service
   qr_feld02 := ""            // Version
 
   qr_string := qr_feld01+chr(10)+qr_feld02+chr(10)
   qr_string := hb_strToUTF8(qr_string,"DEWIN")
   if len(qr_string) >= 330
      alert("QR Code String to long: "+str(len(qr_string)))
   else
      EanQRCode(oPrn,posx,posy,1.5,qr_string,HB_WIN_RGB_BLACK,HB_ZEBRA_FLAG_QR_LEVEL_M)
   endif
RETURN NIL
*******************************************************************************************************************
Function EanQRCode(coPRN, nY, nX, nWidth, nQRCODE, nColor,iFlags)
Local hCODE,nRET
Local nLineWidth:=IIF(nWidth==NIL .OR. nWidth<1,1,nWidth)
Local nLineHeight:=nLineWidth
Local nSCALE:=7.2

hCODE:=hb_zebra_create_qrcode(nQRCODE,iFlags)

nY *= nSCALE
nLineWidth *= nSCALE

IF hCODE != NIL
   IF hb_zebra_geterror( hCODE ) == 0
      IF Empty( nLineHeight )
         nLineHeight := 16
      ENDIF
      IF hb_zebra_geterror( hCODE ) != 0
         RETURN HB_ZEBRA_ERROR_INVALIDZEBRA
      Endif
      nRET:=hb_zebra_draw( hCODE, {|x,y,w,h| coPRN:FillRect(Int( x + .5 ), Int( y + .5 ),;
            Int( x + .5 ) + Int( w ), Int( y + .5 ) + Int( h ) + 1,nColor) },;
            nX*nSCALE, nY, nLineWidth, nLineHeight*nSCALE )
   Endif
   hb_zebra_destroy( hCODE )
Endif
Return nRET
*************************************************************************************************************************
function prn_init
   Public cPrinter := win_printerPortToName("LPT1")
   Public oPrn:= Win32Prn():New(cPrinter)
   
   oPrn:LandScape := .f.
   oPrn:BinNumber := 0
   oPrn:FormType := 9 // A4 form
   oPrn:Copies := 0
   oPrn:hPrinterDc:=0

   if !oPrn:Create()
      Alert("Printer Error! check printer.")
      return
   endif
 
   if !oPrn:StartDoc()
      Alert("Printer Errosr! check printer.")
      oPrn:Destroy()
      return
   endif
Return
*******************************************************************************************************************
Function prn_exit
   
   oPrn:EndDoc() // call endpage() at least one time
   oPrn:Destroy()
   
Return Nil
*******************************************************************************************************************

*******************************************************************************************************************
Function EanBarCode(coPRN, nY, nX, nWidth, cod39,iFlags)
Local hCODE,nRET
Local nLineWidth:=IIF(nWidth==NIL .OR. nWidth<1,1,nWidth)
Local nLineHeight:= 24
Local nSCALE:=7.2

hCODE:=hb_zebra_create_code128(cod39,iFlags)

nY *= nSCALE
nLineWidth *= nSCALE

IF hCODE != NIL
   IF hb_zebra_geterror( hCODE ) == 0
      IF Empty( nLineHeight )
         nLineHeight := 16
      ENDIF
      IF hb_zebra_geterror( hCODE ) != 0
         RETURN HB_ZEBRA_ERROR_INVALIDZEBRA
      Endif
      nRET:=hb_zebra_draw( hCODE, {|x,y,w,h| coPRN:FillRect(Int( x + .5 ), Int( y + .5 ),;
            Int( x + .5 ) + Int( w ), Int( y + .5 ) + Int( h ) + 1) },;
            nX*nSCALE, nY, nLineWidth, nLineHeight*nSCALE )
   Endif
   hb_zebra_destroy( hCODE )
Endif
Return nRET
*************************************************************************************************************************

