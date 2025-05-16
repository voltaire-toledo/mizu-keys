#Requires AutoHotkey v2.0-
#Warn
#SingleInstance
#Include "WiseGUI-2.0-beta1.ahk"

/*
Try it out: https://www.autohotkey.com/boards/viewtopic.php?f=83&t=94044

  Valid types:
    - Fade
    - Zoom
    - SlideEast
    - SlideNorthEast
    - SlideNorth
    - SlideNorthWest
    - SlideWest
    - SlideSouthWest
    - SlideSouth
    - SlideSouthEast
    - RollEast
    - RollNorthEast
    - RollNorth
    - RollNorthWest
    - RollWest
    - RollSouthWest
    - RollSouth
    - RollSouthEast
*/

; WiseGui("Test"
;     , "MainText:     UTC"
;     , "SubText:" . FormatTime(A_NowUTC, "hh:mm tt")
;     ;    , "Show:         SlideWest@400ms"
;     , "Show:         SlideNorth@400ms" ; delete this line to slide west
;     , "Hide:         SlideSouth@400ms"
;     , "Move:         -1,-1"
;     , "Timer:        2000"
; )

; Sleep 3000

; WiseGui("Test", "Theme: Warning")
; Sleep(2000)
; WiseGui("Test") ; Kill

WiseGui("Test"
    , "Margins:       3,3,0,4"
    ; , "Theme:,,," . LoadPicture(A_AhkPath, "Icon1", &ImageType)
    , "Theme:,,,"  LoadPicture(".\myleaf.ico", "Icon1", &ImageType)
    , "FontMain:     S14, Arial"
    , "MainText:     TetraKey"
    ; , "FontSub:      S14, Consolas"
    ; , "SubText:" . A_AhkVersion
    , "SubAlign:     +1"
    ; , "Show:         Fade@400ms"
    , "Hide:         Fade@1000ms"
    , "Timer:        2000"
)

; WiseGui("Test"
;     , "MainText:     UTC"
;     , "SubText:" . FormatTime(A_NowUTC, "hh:mm tt")
;     ;    , "Show:         SlideWest@400ms"
;     , "Show:         SlideNorth@400ms" ; delete this line to slide west
;     , "Hide:         SlideSouth@400ms"
;     , "Move:         -1,-1"
;     , "Timer:        2000"
; )

F3:: ExitApp