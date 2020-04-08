import win32print
from sys import argv
import win32ui
from PIL import ImageWin
import treepoem


nombre = argv[1]
def main():
    printer_name = win32print.GetDefaultPrinter()              # How to reach printer on LPT1 port?
    hDC = win32ui.CreateDC()
    hDC.CreatePrinterDC(printer_name)

    qr = treepoem.generate_barcode(barcode_type='qrcode', data=nombre,)  
    #qr2 = treepoem.generate_barcode(barcode_type='qrcode', data=nombre, )
    #barra = treepoem.generate_barcode(barcode_type='code39', data='12312371289379812',)
    #barra2 = treepoem.generate_barcode(barcode_type='code39', data='12312371289379812',)

    hDC.StartDoc("Codigos")
    hDC.StartPage()
    qr3 = ImageWin.Dib(qr)
    qr3.draw(hDC.GetHandleOutput(),(500,2000,1000,2500))
    #qr4 = ImageWin.Dib(qr2)
    #qr4.draw(hDC.GetHandleOutput(),(500,2500,1000,3000))
    #barra5 = ImageWin.Dib(barra)
    #barra5.draw(hDC.GetHandleOutput(),(100, 1000,200,1100))
    #barra4 = ImageWin.Dib(barra2)
    #barra4.draw(hDC.GetHandleOutput(),(100,2000, 200, 2100))

    hDC.EndPage()
    hDC.EndDoc()
main()
