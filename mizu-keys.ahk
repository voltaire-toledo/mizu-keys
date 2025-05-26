#Requires AutoHotkey v2.0

/*
╭──────────────────────────────────────────────────────────────╮
│ Mizu Keys - AutoHotkey Script                                │
│ Automations leveraging AutoHotkey for enhanced productivity  │
╰──────────────────────────────────────────────────────────────╯
*/

#SingleInstance Force
SendMode "Input"    ; Use default Windows response to built-in responses to keyboard shortcutsm, e.g. [Alt]+[<-]
SetTitleMatchMode 2 ; Default matching behavior for searches using WinTitle, e.g. WinWait
InstallKeybdHook
; InstallMouseHook

/*
╭────────────────────────╮
│ GLOBAL SCOPE VARIABLES │
╰────────────────────────╯
*/
global process_theme := ""
global app_ico := ".\media\icons\mizu-leaf.ico"
global toggle_sound_file_startrun := A_Windir "\Media\Windows Unlock.wav"
global toggle_sound_file_enabled := ".\media\sounds\01_enable.wav"
global toggle_sound_file_disabled := ".\media\sounds\01_disable.wav"
global sound_file_start := ".\media\sounds\start-13691.wav"
global sound_file_stop := ".\media\sounds\stop-13692.wav"
global regkey_sticky_keys := "HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys"

/*
╭────────────────────────╮
│ LIBRARY INCLUDES       │
╰────────────────────────╯
*/
#Include ".\lib\_apps_automations.mzk"
#Include ".\lib\_traymenu.mzk"
#Include ".\lib\_help_about.ahk"
; #Include ".\lib\_about.ahk"
#Include ".\lib\_hotkeys.mzk"
#Include ".\lib\_hotstrings.mzk"
#Include ".\lib\_alerts.mzk"
#Include ".\lib\_mizuclick.mzk"
#include ".\lib\_arpeggios.mzk"
#Include ".\lib\WiseGui.ahk"
; #Include ".\lib\_time_functions.ahk"
; #Include ".\lib\_screen_notifications.ahk"

/*
╭────────────────────────╮
│ INITIALIZATION         │
╰────────────────────────╯
*/
LaunchTime := FormatTime()
DisplayTrayMenu()

/*
╭────────────────────────╮
│ FUNCTIONS              │
╰────────────────────────╯
*/
ReloadAndReturn(*)
{
  Reload
}

EditAndReturn(*)
{
  Edit
  Return
}

EndScript(*)
{
  ExitApp
}


/*
╭───────────────────────────────────────────────────────────────╮
│ CAPS LOCK Genius!                                             │
│
│ Double tap to toggle the Caps Lock feature.                   │
│ Hold down the Caps Lock key as a modifier to trigger hotkeys. │
│                                                               │
╰───────────────────────────────────────────────────────────────╯
*/
; CapsLock:: {
;   KeyWait "CapsLock" ; Wait forever until Capslock is released.
;   KeyWait "CapsLock", "D T0.2" ; ErrorLevel = 1 if CapsLock not down within 0.2 seconds.

;   if (A_PriorKey = "CapsLock") ; Is a double tap on CapsLock?
;   {
;     SetCapsLockState !GetKeyState("CapsLock", "T")
;   }
;   return
; }



; ╭─────────────────────────────────────────────────────────────╮
; │       KEY HOTKEY DEFINITIONS: CORE FUNCTIONALITY            │
; │   Not affected by ToggleAuxHotkeys and ToggleAuxHotstrings  │
; ├─────────────────────────────────────────────────────────────┤
; │  [Ctrl]+[Win]+[Alt]+[K]    Toggle Aux Hotkeys               │
; │  [Ctrl]+[Win]+[Alt]+[S]    Toggle Aux Hotsrings             │
; │  [Ctrl]+[Win]+[Alt]+[R]    Reload this app                  │
; │  [Ctrl]+[Win]+[Alt]+[E]    Edit this AHK (default editor)   │
; │  [Ctrl]+[Win]+[Alt]+[F2]   AutoHotKey Help File             │
; │  [Ctrl]+[Win]+[Alt]+[F12]  Put system to Sleep              │
; │  [Win]+[F]                 Open the user's Documents folder │
; ╰─────────────────────────────────────────────────────────────╯

; [Ctrl]+[Alt]+[Win]+[K]: Toggle Aux Hotkeys
^#!k:: {
  ToggleAuxHotkeys()
}

; [Ctrl]+[Alt]+[Win]+[S]: Toggle Aux Hotstrings
^#!s:: {
  ToggleAuxHotstrings()
}

; [Ctrl]+[Alt]+[Win]+[R] to Reload this script
^#!r:: {
  ReloadAndReturn()
}

; [Ctrl]+[Alt]+[Win]+[E] to edit this script
^!#e:: {
  EditAndReturn()
}

; [Ctrl]+[Alt]+[Win]+[F2] to open the AutoHotkey Help File
^!#F2:: {
  ShowHelp()
}

; [Ctrl]+[Alt]+[Win]+[F1] to open the AutoHotkey Help File
^!#F1:: {
  ShowHelpAbout()
}

; [Ctrl]+[Alt]+[Win]+[F12] to go to sleep mode
^!#F12:: {
  Run "rundll32.exe powrprof.dll,SetSuspendState 0,1,0"
}

; [Win]+[F] to open the File Explorer in the user's Documents folder
#f:: {
  Run "explorer.exe ~"
}
CapsLock & p:: Send "^+x"

CapsLock & F3:: F23
CapsLock & F4:: F24
CapsLock & F5:: F15
CapsLock & F6:: F16
CapsLock & F7:: F17
CapsLock & F8:: F18
CapsLock & F9:: F19
CapsLock & F10:: F20
CapsLock & F11:: F21
CapsLock & F12:: F22