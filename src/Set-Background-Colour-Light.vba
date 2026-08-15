'==============================================================================
' Background - Light
'
' Sets the SOLIDWORKS graphics area background to plain white
' (R:255 G:255 B:255).
'
' This is a system option rather than a document property. It applies to every
' document you open and persists between sessions until it is changed again, and
' nothing is saved into any part, assembly or drawing.
'
' Only the graphics area changes. The surrounding interface - CommandManager,
' FeatureManager, menus and task pane - is controlled separately by the
' "UI - Dark" and "UI - Light" macros, so the two can be combined freely.
'
' The background colour is stored per colour scheme, so this sets it for
' whichever scheme is active in Tools > Options > System Options > Colors.
'
' To use, run the macro. A document does not need to be open.
'
'   Version   0.1.0
'   Date      2026-08-09
'   Author    James Debono
'   Licence   MIT - full text below
'   Source    https://github.com/james-debono/solidworks-themes
'
'------------------------------------------------------------------------------
' CHANGELOG (summary - see CHANGELOG.md for the full history)
'
'   0.1.0   First numbered release.'
'------------------------------------------------------------------------------
' MIT Licence
' SPDX-License-Identifier: MIT
'
' Copyright (c) 2026 James Debono
'
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
'
' The above copyright notice and this permission notice shall be included in all
' copies or substantial portions of the Software.
'
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
' SOFTWARE.
'==============================================================================

Option Explicit

Const BG_RED As Long = 255
Const BG_GREEN As Long = 255
Const BG_BLUE As Long = 255

Sub main()

    Dim swApp As SldWorks.SldWorks

try_:
    On Error GoTo catch_

    Set swApp = Application.SldWorks

    'Background appearance -> Plain (viewport background color above)
    swApp.SetUserPreferenceIntegerValue _
        swUserPreferenceIntegerValue_e.swColorsBackgroundAppearance, _
        swColorsBackgroundAppearance_e.swColorsBackgroundAppearance_Plain

    'Viewport Background colour. SOLIDWORKS expects a COLORREF (&H00BBGGRR),
    'which is exactly what the VBA RGB() function returns.
    swApp.SetUserPreferenceIntegerValue _
        swUserPreferenceIntegerValue_e.swSystemColorsViewportBackground, _
        RGB(BG_RED, BG_GREEN, BG_BLUE)

    RedrawActiveDoc swApp

    GoTo finally_

catch_:
    Debug.Print "Background - Light error: " & Err.Number & " - " & Err.Description
    If Not swApp Is Nothing Then
        swApp.SendMsgToUser2 "Background - Light failed: " & Err.Description, _
            swMessageBoxIcon_e.swMbWarning, swMessageBoxBtn_e.swMbOk
    End If

finally_:

End Sub

'Nudges the graphics area so the new colour is visible straight away.
'Silently does nothing when no document is open.
Private Sub RedrawActiveDoc(swApp As SldWorks.SldWorks)

    On Error Resume Next

    Dim swModel As SldWorks.ModelDoc2
    Set swModel = swApp.ActiveDoc

    If Not swModel Is Nothing Then swModel.GraphicsRedraw2

End Sub
