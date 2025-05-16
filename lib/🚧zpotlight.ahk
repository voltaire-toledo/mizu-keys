#Requires AutoHotkey v2.0

VirtualScreenWidth := SysGet(78)
VirtualScreenHeight := SysGet(79)
MsgBox A_ScreenWidth " x " A_ScreenHeight, "Full resolution (x by y) of primary monitor"
MsgBox VirtualScreenWidth " x " VirtualScreenHeight, "Virtual resolution (x by y) of all monitors"
MsgBox SysGet(80), "Number of monitors"

; Gui.OnEvent("Close", GuiEscape)
; Gui := Gui("+Owner +AlwaysOnTop -Disabled -SysMenu -Caption")

; Gui.BackColor := "000000"

; Picture := Gui.Add("Picture", "X-1920 Y0 W" A_ScreenWidth " H" A_ScreenHeight " gCLICK")

; Gui.Show("NoActivate X-1920 Y0 W" A_ScreenWidth " H" A_ScreenHeight, "WINDOW")

; WinSetTransparent("255", "WINDOW")

; Loop {
;     Sleep(100)
;     WinGetActiveStats(wint, winw, winh, winx, winy)
;     winw += winx
;     winh += winy

;     if (winx < -1920)
;         winx := -1920

;     if (winy < 0)
;         winy := 0

;     if (wint = "") {
;         winx := -1920
;         winy := 1080
;         winw := A_ScreenWidth
;         winh := A_ScreenHeight
;     }

;     WinSetRegion("0-0 " A_ScreenWidth "-1920 " A_ScreenWidth "-" A_ScreenHeight " 1080-" A_ScreenHeight " 0-0 " winx "-" winy " " winw "-" winy " " winw "-" winh " " winx "-" winh " " winx "-" winy, "WINDOW")
;     WinSetTop("WINDOW") ; Rem this line to keep the task bar visible
; }

; Gui.OnEvent("Click", "CLICK")

; CLICK() {
;     WinSetBottom("WINDOW")
;     CoordMode("Mouse", "Screen")
;     MouseGetPos(&mousex, &mousey, &mousewin)
;     MouseClick("Left", mousex, mousey)
;     MouseClick("Left", mousex, mousey)
;     WinSetAlwaysOnTop("On", "WINDOW")
; }