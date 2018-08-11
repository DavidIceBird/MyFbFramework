﻿#Include Once "Object.bi"

Namespace My.Sys.Drawing
    Enum BrushStyle
        bsSolid   = BS_SOLID
        bsClear   = BS_NULL
        bsHatch   = BS_HATCHED
        bsPattern = BS_PATTERN
    End Enum

    Enum HatchStyle
        hsHorizontal = HS_HORIZONTAL
        hsVertical   = HS_VERTICAL
        hsFDiagonal  = HS_FDIAGONAL
        hsDiagonal   = HS_BDIAGONAL
        hsCross      = HS_CROSS
        hsDiagCross  = HS_DIAGCROSS
    End Enum

    Type Brush Extends My.Sys.Object
        private:
        FColor       As Integer
        FStyle       As BrushStyle
        FHatchStyle  As HatchStyle
        Declare Sub Create
        public:
        Handle       As HBRUSH
        Declare Property Color As Integer
        Declare Property Color(Value As Integer)
        Declare Property Style As Integer
        Declare Property Style(Value As Integer)
        Declare Property HatchStyle As Integer
        Declare Property HatchStyle(Value As Integer)
        Declare Operator Cast As Any Ptr
        Declare Constructor
        Declare Destructor
    End Type

    Property Brush.Color As Integer
        Return FColor
    End Property

    Property Brush.Color(Value As Integer)
        FColor = Value
        Create
    End Property

    Property Brush.Style As Integer
       Return FStyle
    End Property

    Property Brush.Style(Value As Integer)
        FStyle = Value
        Create
    End Property

    Property Brush.HatchStyle As Integer
        Return FHatchStyle
    End Property

    Property Brush.HatchStyle(Value As Integer)
        FHatchStyle = Value
        Create
    End Property

    Sub Brush.Create
        Dim As LOGBRUSH LB
        LB.lbColor = FColor
        LB.lbHatch = FHatchStyle
        If Handle Then DeleteObject Handle
        Select Case FStyle
        Case bsClear
            LB.lbStyle = BS_NULL
        Case bsSolid
            LB.lbStyle = BS_SOLID
        Case bsHatch
            LB.lbStyle = BS_HATCHED
            LB.lbHatch = FHatchStyle
        End Select
        Handle = CreateBrushIndirect(@LB)
    End Sub

    Operator Brush.Cast As Any Ptr
        Return @This
    End Operator

    Constructor Brush
        FColor = &HFFFFFF
        FStyle = bsSolid
        Create
    End Constructor

    Destructor Brush
        If Handle Then DeleteObject Handle
    End Destructor
End namespace