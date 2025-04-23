#Requires AutoHotkey v2.0
CoordMode "Mouse", "Screen"

SetTimer WinMoveMsgBox, 20
MsgBox "This is a test MsgBox()", "Spike!"
ExitApp

WinMoveMsgBox()
{
    ; Get Mouse Position
    MouseGetPos &xpos, &ypos
    SetTimer WinMoveMsgBox, 0
    WinMove xpos, ypos, , , "Spike!"
}
 
