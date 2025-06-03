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
InstallKeybdHook  ; Install the keyboard hook to capture key events
; InstallMouseHook

/*
╭────────────────────────╮
│ GLOBAL SCOPE VARIABLES │
╰────────────────────────╯
*/
global thisapp_name := "Mizu Keys"
global thisapp_version := "0.9.0_alpha (2024-06-01)"
global process_theme := ""
global app_ico := ".\media\icons\mizu-leaf.ico"
global toggle_sound_file_startrun := A_Windir "\Media\Windows Unlock.wav"
global toggle_sound_file_enabled := ".\media\sounds\01_enable.wav"
global toggle_sound_file_disabled := ".\media\sounds\01_disable.wav"
global sound_file_start := ".\media\sounds\start-13691.wav"
global sound_file_stop := ".\media\sounds\stop-13692.wav"
global regkey_sticky_keys := "HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys"

; --- Splash Screen Modal ---
global app_splashGUI := Gui("+AlwaysOnTop +ToolWindow -Caption", "Mizu Keys Splash")
app_splashGUI.BackColor := "White"
app_splashGUI.SetFont("s14", "Segoe UI")
app_splashGUI.AddPicture("x20 y20 w48 h48 Icon1", app_ico)
app_splashGUI.SetFont("s16 bold", "Segoe UI")
app_splashGUI.AddText("x80 y20", "Mizu Keys")
app_splashGUI.SetFont("s9 norm", "Segoe UI")
app_splashGUI.AddText("x80 y50", "Version " thisapp_version)
app_splashGUI.Show("w300 h90 Center")
; --- End Splash Screen ---

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
#include ".\lib\_virtual_desktops.mzk"
; #Include ".\lib\_time_functions.ahk"
; #Include ".\lib\_screen_notifications.ahk"

/*
╭────────────────────────╮
│ INITIALIZATION         │
╰────────────────────────╯
*/
LaunchTime := FormatTime()
SetWorkingDir(A_ScriptDir)
DisplayTrayMenu()

; Hide splash after tray menu is ready
app_splashGUI.Destroy()

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

; [Ctrl]+[Alt]+[Win]+[F1] to open this App's Help -> About dialog
^!#F1:: {
  ShowHelpAbout()
}

; [Ctrl]+[Alt]+[Win]+[F12] to go to sleep mode
^!#F12:: {
  Run "rundll32.exe powrprof.dll,SetSuspendState 0,1,0"
}

; [Ctrl]+[Alt]+[Win]+[F] to open this script's folder in File Explorer
^!#f:: {
  Run "explorer.exe " A_ScriptDir
}

; [Win]+[F] to open the File Explorer in the user's Documents folder
#f:: {
  Run "explorer.exe ~"
}
; CapsLock & p:: Send "^+x"

CapsLock & F3::F23
CapsLock & F4::F24
CapsLock & F5::F15
CapsLock & F6::F16
CapsLock & F7::F17
CapsLock & F8::F18
CapsLock & F9::F19
CapsLock & F10::F20
CapsLock & F11::F21
CapsLock & F12::F22

; #SuspendExempt
;   ^!s:: Suspend  ; Ctrl+Alt+S
; #SuspendExempt False

/* ╭───────────────------------╮
   │ Dynamic Tray Menu updates │  
   ╰------------───────────────╯ */
; #HotIf !WinActive("ahk_exe vmware.exe") or !WinActive("ahk_class VMUIFrame")
;   TraySetIcon tray_icon_normal
; #HotIf

; #HotIf WinActive("ahk_exe vmware.exe") and WinActive("ahk_class VMUIFrame")
;   TraySetIcon tray_icon_suspend
; #HotIf