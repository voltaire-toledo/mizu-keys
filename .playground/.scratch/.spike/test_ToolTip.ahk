#Requires AutoHotkey v2.0

; Ref: https://www.autohotkey.com/docs/v2/lib/ToolTip.htm    
; ToolTip "Timed ToolTip`nThis will be displayed for 5 seconds."
; ; SetTimer () => ToolTip(), -5000

; MsgBox "To the next section!"

; Ref: https://www.autohotkey.com/docs/v2/lib/MouseGetPos.htm
SetTimer WatchCursor, 100  
; Positive timer will re-run the function every 100ms, creating 
; (1) a polling interval and 
; (2) a moving ToolTip that follows the mouse cursor.

WatchCursor()
{
    ; MouseGetPos(): https://www.autohotkey.com/docs/v2/lib/MouseGetPos.htm
    MouseGetPos &xpos, &ypos, &id, &control
    ToolTip
    (
        "ahk_id: `t`t" id 
        "`nahk_class: `t" WinGetClass(id) 
        "`nahk_title: `t" WinGetTitle(id) 
        "`nControl: `t`t" control
        "`nX Pos: `t`t" xpos
        "`nY Pos: `t`t" ypos
        
    )
}

^z::ExitApp