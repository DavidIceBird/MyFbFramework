﻿'################################################################################
'#  PageScroller.bi                                                             #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
	#DEFINE QPageScroller(__Ptr__) *Cast(PageScroller Ptr, __Ptr__)
	
	Type PageScroller Extends Control
	Private:
		#IfNDef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Sub ProcessMessage(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#EndIf
	Public:
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#IfNDef __USE_MAKE__
	#Include Once "PageScroller.bas"
#EndIf
