﻿'###############################################################################
'#  BitmapType.bi                                                                  #
'#  This file is part of MyFBFramework                                           #
'#  Version 1.0.0                                                              #
'###############################################################################

#Include Once "Object.bi"
#Include Once "Graphics.bi"

Namespace My.Sys.Drawing
    #DEFINE QBitmapType(__Ptr__) *Cast(BitmapType Ptr,__Ptr__)

    Type BitmapType Extends My.Sys.Object
        Private:
            FWidth       As Integer
            FHeight      As Integer
            FDevice      As HDC 
            FTransparent As Boolean
            FLoadFlag(2) As Integer
            Declare Sub Create
        Public:
            Graphic      As Any Ptr  
            Handle       As HBITMAP
            Brush        As My.Sys.Drawing.Brush
            Pen          As My.Sys.Drawing.Pen
            Tag          As Any Ptr
            Declare Property Width As Integer
            Declare Property Width(Value As Integer)
            Declare Property Height As Integer
            Declare Property Height(Value As Integer)
            Declare Property Transparency As Boolean
            Declare Property Transparency(Value As Boolean)
            Declare Sub LoadFromFile(File As String)
            Declare Sub SaveToFile(File As String)
            Declare Sub LoadFromResourceName(ResName As String, ModuleHandle As HInstance = GetModuleHandle(NULL))
            Declare Sub LoadFromResourceID(ResID As Integer)
            Declare Static Function FromResourceName(ResName As String) As BitmapType Ptr
            Declare Sub Clear
            Declare Sub Free
            Declare Operator Cast As Any Ptr
            Declare Operator Let(ByRef Value As WString)
            Declare Operator Let(Value As HBITMAP)
            Declare Constructor
            Declare Destructor
            Changed As Sub(BYREF Sender As BitmapType)
    End Type

    Property BitmapType.Width As Integer
        Return FWidth
    End Property

    Property BitmapType.Width(Value As Integer)
        FWidth = Value
        If Changed Then Changed(This)
    End Property

    Property BitmapType.Height As Integer
        Return FHeight
    End Property

    Property BitmapType.Height(Value As Integer)
        FHeight = Value
        If Changed Then Changed(This)
    End Property

    Property BitmapType.Transparency As Boolean
        Return FTransparent
    End Property

    Property BitmapType.Transparency(Value As Boolean)
        FTransparent = Value
    End Property

    Sub BitmapType.LoadFromFile(File As String)
        Dim As BITMAP BMP
        Dim As HDC MemDC
        If Handle Then DeleteObject Handle
        Handle = LoadImage(0,File,IMAGE_BITMAP,0,0,LR_LOADFROMFILE OR LR_LOADMAP3DCOLORS OR FLoadFlag(Abs_(FTransparent)))
        GetObject(Handle,SizeOF(BMP),@BMP)
        FWidth  = BMP.bmWidth
        FHeight = BMP.bmHeight
        If Changed Then Changed(This)
    End Sub

    Sub BitmapType.SaveToFile(File As String)
        Type RGB3 Field = 1
            G As Byte
            B As Byte
            R As Byte
        End Type
        Type BitmapStruct Field = 1
             Identifier      As Word
             FileSize        As Dword
             Reserved0       As Dword
             bmpDataOffset   As Dword
             bmpHeaderSize   As Dword
             bmpWidth        As Dword
             bmpHeight       As Dword
             Planes          As Word
             BitsPerPixel    As Word
             Compression     As Dword
             bmpDataSize     As Dword 
             HResolution     As Dword
             VResolution     As Dword
             Colors          As Dword
             ImportantColors As Dword
        End Type
        Static As BitmapStruct BM
        Dim As Integer F,x,y,Clr,Count = 0
        F = FreeFile
        Redim PixelData(FWidth * FHeight - 1) As RGB3
        For y = FHeight-1 To 0 Step -1
            For x = 0 To FWidth - 1
                 Clr = GetPixel(FDevice,x,y)
                 PixelData(Count).G = GetGreen(Clr)
                 PixelData(Count).R = GetRed(Clr)
                 PixelData(Count).B = GetBlue(Clr)
                 Count += 1
            Next x
        Next y
        BM.Identifier      = 66 + 77 * 256
        BM.Reserved0       = 0
        BM.bmpDataOffset   = 54
        BM.bmpHeaderSize   = 40
        BM.Planes          = 1
        BM.BitsPerPixel    = 24
        BM.Compression     = 0
        BM.HResolution     = 0
        BM.VResolution     = 0
        BM.Colors          = 0
        BM.ImportantColors = 0
        BM.bmpWidth        = FWidth
        BM.bmpHeight       = FHeight
        BM.bmpDataSize     = FWidth * FHeight * 3
        BM.FileSize        = BM.bmpDataOffset + BM.bmpDataSize
        Open File For Binary Access Write As #F
        Put #F,,BM
        Put #F,,PixelData()
        Close #F
    End Sub

    Sub BitmapType.LoadFromResourceName(ResName As String, ModuleHandle As HInstance = GetModuleHandle(NULL))
        Dim As BITMAP BMP
        Handle = LoadImage(ModuleHandle,ResName,IMAGE_BITMAP,0,0,LR_COPYFROMRESOURCE OR FLoadFlag(Abs_(FTransparent)))
        GetObject(Handle,SizeOF(BMP),@BMP)
        FWidth  = BMP.bmWidth
        FHeight = BMP.bmHeight
        If Changed Then Changed(This)
    End Sub

    Function BitmapType.FromResourceName(ResName As String) As BitmapType Ptr
        Dim As BitmapType bm
        bm.LoadFromResourceName(ResName)
        Return @bm
    End Function

    Sub BitmapType.LoadFromResourceID(ResID As Integer)
        Dim As BITMAP BMP
        Handle = LoadImage(GetModuleHandle(NULL),MAKEINTRESOURCE(ResID),IMAGE_BITMAP,0,0,LR_COPYFROMRESOURCE OR FLoadFlag(Abs_(FTransparent)))
        GetObject(Handle,SizeOF(BMP),@BMP)
        FWidth  = BMP.bmWidth
        FHeight = BMP.bmHeight
        If Changed Then Changed(This)
    End Sub

    Sub BitmapType.Create
        Dim rc As Rect
        Dim As HDC Dc
        If Handle Then DeleteObject Handle
        Dc = GetDC(0)
        FDevice = CreateCompatibleDC(Dc)
        ReleaseDC 0,Dc
        rc.Left = 0
        rc.Top = 0
        rc.Right = FWidth
        rc.Bottom = FHeight
        Handle = CreateCompatibleBitmap(FDevice,FWidth,FHeight)
        SelectObject FDevice,Handle
        FillRect(FDevice, @rc, Brush.Handle)
        If Changed Then Changed(This)
    End Sub

    Sub BitmapType.Clear
        Dim rc As RECT
        rc.Left = 0
        rc.Top = 0
        rc.Right = FWidth
        rc.Bottom = FHeight
        FillRect FDevice, @rc, Brush.Handle
        If Changed Then Changed(This)
    End Sub

    Sub BitmapType.Free
        If Handle Then DeleteObject Handle
        Handle = 0
        If Changed Then Changed(This)
    End Sub

    Operator BitmapType.Cast As Any Ptr
        Return @This
    End Operator

    Operator BitmapType.Let(ByRef Value As WString)
        If FindResource(GetModuleHandle(NULL),Value,RT_BITMAP) Then
           LoadFromResourceName(Value) 
        Else
           LoadFromFile(Value)
        End If
    End Operator

    Operator BitmapType.Let(Value As HBITMAP)
        Handle = Value
    End Operator

    Constructor BitmapType
        FLoadFlag(0) = 0
        FLoadFlag(1) = LR_LOADTRANSPARENT
        FWidth       = 16
        FHeight      = 16
        FTransparent = False
        Create
    End Constructor

    Destructor BitmapType
        Free
        DeleteObject FDevice
    End Destructor
End namespace
