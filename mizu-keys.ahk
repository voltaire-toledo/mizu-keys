#Requires AutoHotkey v2.0

; Ensure single mutex. Use [Prompt] switch to prompt for options
#SingleInstance Force

; Use default Windows response to built-in responses to keyboard shortcutsm, e.g. [Alt]+[<-]
SendMode "Input"

; Default matching behavior for searches using WinTitle, e.g. WinWait
SetTitleMatchMode 2
InstallKeybdHook
; InstallMouseHook

; Include the following libraries
#Include ".\lib\_about.ahk"
#Include ".\lib\_traymenu.mzk"
#Include ".\lib\_hotkeys.mzk"
#Include ".\lib\_hotstrings.mzk"
#Include ".\lib\_alerts.mzk"
#Include ".\lib\_mizuclick.mzk"
#include ".\lib\_modes.mzk"
#Include ".\lib\WiseGui.ahk"

; Get Launch/Reload Time
LaunchTime := FormatTime()

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


DisplayTrayMenu()


ReloadAndReturn(*)
{
  Reload
  Return
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


LaunchCalculator(*)
{
  ; Single Instance condition. Do not create a new process and used the last one created
  If WinExist("Calculator", "Calculator")
  {
    WinActivate
    WinShow
    Return
  }
  Else
  {
    Run "calc.exe"
    WinWait "Calculator"
    WinActivate
  }
}

LaunchTerminal(*)
{
  If WinExist("ahk_exe WindowsTerminal.exe")
  {
    WinActivate
    WinShow
    Return
  }
  Else
  {
    Run "wt.exe -w 0 new-tab --title (ツ)_/¯{Terminal} --suppressApplicationTitle", , , &wt_pid
    Sleep 1000
    If WinExist("ahk_exe WindowsTerminal.exe") or WinExist("ahk_title Terminal")
    {
      WinActivate
      WinShow
    }
    Return
  }
}

LaunchNotion(*) {
  ; Path to Notion.exe
  static notionIconPath := RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\661f0cc6-343a-59cb-a5e8-8f6324cc6998", "DisplayIcon")
  static notionPath := SubStr(notionIconPath, 1, InStr(notionIconPath, ",") - 1)
  If WinExist("ahk_exe Notion.exe")
  {
    WinActivate
    SoundPlay sound_file_start
    WinShow
    Return
  }
  Else
  {
    If FileExist(notionPath)
    {
      Run notionPath
      ; SoundPlay "*48"
      Return
    }
    Else
    {
      SoundPlay sound_file_stop
      Return
    }
  }
}


/*
╔══════════════════════════════════════════════════════════════╗
║       KEY HOTKEY DEFINITIONS: CORE FUNCTIONALITY             ║
║   Not affected by ToggleAuxHotkeys and ToggleAuxHotstrings   ║
╚══════════════════════════════════════════════════════════════╝
*/

; ┌─────────────────────────────┐
; │ [RCtrl]x2 to run Calculator │
; └─────────────────────────────┘
; Detects when a key has been double-pressed (similar to double-click). KeyWait is used to
; stop the keyboard's auto-repeat feature from creating an unwanted double-press when you
; hold down the RControl key to modify another key. It does this by keeping the hotkey's
; thread running, which blocks the auto-repeats by relying upon #MaxThreadsPerHotkey being
; at its default setting of 1. For a more elaborate script that distinguishes between
; single, double and triple-presses, see SetTimer example #3.
~RControl::
{
  if (A_PriorHotkey != "~RControl" or A_TimeSincePriorHotkey > 400)
  {
    ; Too much time between presses, so this isn't a double-press.
    KeyWait "RControl"
    return
  }

  ; A double-press of the RControl key has occurred.
  LaunchCalculator()
}


;╭───────────────────────────────────────────────────────╮
;│  [Ctrl]+[Alt]+[T] for Terminal                        │
;│  [Ctrl]+[Alt]+[Shift]+[T] for Terminal in Admin Mode  │
;╰───────────────────────────────────────────────────────╯

LAlt & t::
{
  ; [Ctrl]+[Alt]+[T] to run Terminal
  If GetKeyState("LShift", "P") && GetKeyState("Alt", "P") && GetKeyState("LCtrl", "P")
  {
    ; MsgBox "Run wt.exe as Admin"  ; DEBUG
    Run "*RunAs wt.exe -w 0 new-tab --title Terminal(Admin) --suppressApplicationTitle"
    exit ; return will only exit the current condition
  }

  If GetKeyState("LCtrl", "P") && GetKeyState("LAlt", "P")
  {
    LaunchTerminal()
  }
  Else
  {
    Send "T" ; This is to respond to [RShift}+[T]; otherwise, nothing will be sent
  }
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

;================================================================================================
; Hot keys with CapsLock modifier. See https://autohotkey.com/docs/Hotkeys.htm#combo
;================================================================================================
; Get DEFINITION of selected word.
; CapsLock & d:: {
;   ClipboardGet()
;   Run, http: // www.google.com / search ? q = define + %clipboard% ; Launch with contents of clipboard
;     ClipboardRestore()
;     Return
;       }

;   ; GOOGLE the selected text.
;   CapsLock & g:: {
;     ClipboardGet()
;     Run, http: // www.google.com / search ? q = %clipboard% ; Launch with contents of clipboard
;       ClipboardRestore()
;       Return
;         }

;     ; Do THESAURUS of selected word
;     CapsLock & t:: {
;       ClipboardGet()
;       Run http: // www.thesaurus.com / browse / %Clipboard% ; Launch with contents of clipboard
;       ClipboardRestore()
;       Return
;     }

;     ; Do WIKIPEDIA of selected word
;     CapsLock & w:: {
;       ClipboardGet()
;       Run, https: // en.wikipedia.org / wiki / %clipboard% ; Launch with contents of clipboard
;       ClipboardRestore()
;       Return
;     }


;     ClipboardGet()
;     {
;       OldClipboard := ClipboardAll ;Save existing clipboard.
;       Clipboard := ""
;       Send, ^ c ;Copy selected test to clipboard
;       ClipWait 0
;       If ErrorLevel
;       {
;         MsgBox, No Text Selected !
;           Return
;       }
;     }

;     ClipboardRestore()
;     {
;       Clipboard := OldClipboard
;     }

; ╭────────────────────────────╮
; │  QWIK KEYS (CapsLock)      │
; │  [Ctrl]+[Alt]+[Win] + [?]  │
; ├────────────────────────────┴───────────────────────╮
; │  [CapsLock]+[K]    Toggle Aux Hotkeys              │
; │  [CapsLock]+[S]    Toggle Aux Hotsrings            │
; │  [CapsLock]+[R]    Reload this app                 │
; │  [CapsLock]+[E]    Edit this AHK (default editor)  │
; │  [CapsLock]+[F2]   AutoHotKey Help File            │
; ╰────────────────────────────────────────────────────╯

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

; [Ctrl]+[Alt]+[Win]+[F12] to go to sleep mode
^!#F12:: {
  Run "rundll32.exe powrprof.dll,SetSuspendState 0,1,0"
}

; ╭─────────────────────────────────────────────────────────╮
; │  Mizu Key modes & chords                                │
; │  1. Hit the [CapsLock]+[?] To enter the MODE            │
; │  2. Hit the other [key] to complete the CHORD           │
; ├─────────────────────────────────────────────────────────┤
; │  MODES:                                                 │
; │  [b] BROWSE WEB     Qwik access to fav sites            │
; │  [o] OPEN APP       Qwik access to apps                 │
; │  [p] POWERTOYS      Shortcuts to PowerToys utils        │
; │  [c] CLIP UTILs     Qwik utils on the selected text     │
; │  [u] UTILITIES      Qwik access to utilities            │
; ├─────────────────────────────────────────────────────────┤
; │  [CapsLock]+[o], [b]   OPEN APP:                 (none) │
; │  [CapsLock]+[o], [c]   OPEN APP: VS Code            [x] │
; │  [CapsLock]+[o], [d]   OPEN APP: Dev Tools              │
; │  [CapsLock]+[o], [h]   OPEN APP: Dev Home               │
; │  [CapsLock]+[o], [n]   OPEN APP: Notepad            [x] │
; │  [CapsLock]+[o], [p]   OPEN APP: Epic Pen           [x] │
; │  [CapsLock]+[o], [w]   OPEN APP: Wezterm                │
; │                                                         │
; │  [CapsLock]+[b], [c]   BROWSE: chat.openai.com          │
; │  [CapsLock]+[b], [d]   BROWSE: dev.azure.com            │
; │  [CapsLock]+[b], [g]   BROWSE: github.com               │
; │  [CapsLock]+[b], [i]   BROWSE: icons8.com               │
; │  [CapsLock]+[b], [p]   BROWSE: portal.azure.com         │
; │  [CapsLock]+[b], [y]   BROWSE: youtube.com              │
; │                                                         │
; ╰─────────────────────────────────────────────────────────╯


; ╭─────────────────────────────────╮
; │  [CapsLock]+[o]. OPEN App Mode  │
; ╰─────────────────────────────────╯
KeyWaitAny(*)
{
  ih := InputHook("B L1 T4 M", "abcdefghijklmnopqrstuvwxyz12345678900")
  ih.KeyOpt("{All}", "E")  ; End
  ih.Start()
  ih.Wait()

  return ih.EndKey  ; Return the key name
}

SplashGUI(message, timeout) {
  WiseGui("MizuKeySplash"
  , "Margins:       3,3,0,4"
  ; , "Theme:,,," . LoadPicture(A_AhkPath, "Icon1", &ImageType)
  , "Theme:,,,"  LoadPicture(app_ico, "Icon1", &ImageType)
  , "FontMain:     S14, Arial"
  , "MainText:     " message
  ; , "FontSub:      S14, Consolas"
  ; , "SubText:" . A_AhkVersion
  , "SubAlign:     +1"
  ; , "Show:         Fade@400ms"
  , "Hide:         Fade@1000ms"
  , "Timer:        2000"
  )
}
CapsLock & o::
{
  ; If GetKeyState("CapsLock", "P")
  ; {
  ;   ; Open App Mode, then follow it with another key to complete the CHORD
  KeyWait "CapsLock"
  retKeyHook := KeyWaitAny()
  ; MsgBox "You pressed " retKeyHook, "Mizu Keys", "T2 4096"
  ; random_string := "LaunchNotion"
  ; action_array := (retKeyHook = "b") ? (["Bitwarden", "run", "bitwarden"]) 
  ;              :  (retKeyHook = "c") ? (["VS Code", "run", "code.cmd"])
  ;              :  (retKeyHook = "n") ? (["Notion", "function", "LaunchNotion()"])
  ;              :  (["Defaul", "doNothing", ""])

  If (retKeyHook = "c") {
      SplashGUI("Starting VS Code...", 2000)
      Run "code.cmd"
  }
  Else If (retKeyHook = "e") {
    SplashGUI("Starting Epic Pen...", 2000)
    Run EnvGet("ProgramFiles(x86)") "\Epic Pen\EpicPen.exe"
  }
  Else If (retKeyHook = "n") {
    SplashGUI("Starting Notion...", 2000)
    LaunchNotion()
  }
  Else If (retKeyHook = "o") {
    SplashGUI("Starting MS Outlook...", 2000)
    Send "^!+#o"
  }
  Else If (retKeyHook = "p") {
    SplashGUI("Starting MS PowerPoint...", 2000)
    Send "^!+#p"
  }
  Else If (retKeyHook = "w") {
      SplashGUI("Starting MS Word...", 2000)
      Send "^!+#w"
  }
  Else If (retKeyHook = "x") {
    SplashGUI("Starting MS Excel...", 2000)
    Send "^!+#x"
  }
  Else {
    Send "O" ; This is to respond to [LShift}+[o]; otherwise, nothing will be sent
  }
}

; [Win]+[F] to open the File Explorer in the user's Documents folder
#f:: {
  Run "explorer.exe ~"
}

CapsLock & p:: PrintScreen

CapsLock & F1:: F23
CapsLock & F2:: F24
CapsLock & F3:: F13
CapsLock & F4:: F14
CapsLock & F5:: F15
CapsLock & F6:: F16
CapsLock & F7:: F17
CapsLock & F8:: F18
CapsLock & F9:: F19
CapsLock & F10:: F20
CapsLock & F11:: F21
CapsLock & F12:: F22