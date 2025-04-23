; AHK Startup
; Fanatic Guru
;
; Version: 2023 09 26
;
; #Requires AutoHotkey v2
;
; Startup Script for Startup Folder to Run on Bootup.
;{-----------------------------------------------
; Runs the Scripts Defined in the Files Array
; Removes the Scripts' Tray Icons leaving only AHK Startup
; Creates a ToolTip for the One Tray Icon Showing the Startup Scripts
; If AHK Startup is Exited All Startup Scripts are Exited
; Includes a 'Load' menu for a list of scripts that are not currently loaded
; Includes flags to allow for running of both v1 and v2 scripts
;}

; INITIALIZATION - ENVIROMENT
;{-----------------------------------------------
;
#Requires AutoHotkey v2
#SingleInstance force  ; ensures that only the last executed instance of script is running
DetectHiddenWindows true ; scripts base window is generally hidden
;}

; INITIALIZATION - VARIABLES
;{-----------------------------------------------
; Folder: all files in that folder and subfolders
; Relative Paths: .\ at beginning is the folder of the script, each additional . steps back one folder
; Wildcards: * and ? can be used
; Flags to the right are used to indicate additional instructions, can use tabs for readability
; '/noload' indicates to not load the script initially but add to Load submenu
; '/v1' indicates to run with AutoHotkey v1 exe
; '/v2' or no version flag indicates to run with AutoHotkey v2 exe
Files := [	; Additional Startup Files and Folders Can Be Added Between the ( Continuations  ) Below
	(Join,
	"C:\Users\Guru\Documents\AutoHotkey\Startup\"
	"C:\Users\Guru\Documents\AutoHotkey\Compiled Scripts\*.exe"
	A_MyDocuments "\AutoHotkey\My Scripts\Hotstring Helper.ahk"
	"C:\Users\Guru\Documents\AutoHotkey\My Scripts\Calculator.ahk"	"/v2"
	".\Web\Google Search.ahk"	"/v1"
	"..\Dictionary.ahk"
	"Hotkey Help.ahk"
	"MediaMonkey.ahk"		"/noload"
	)]
	
; Define Path to AutoHotkey.exe for v1 and v2
; If ExtV1 and ExtV2 are different then the extension will be used to determine version
RunPathV1 := A_ProgramFiles '\AutoHotkey\AutoHotkey.exe'
ExtV1 := 'ahk'	; v1 extension
RunPathV2 := A_ProgramFiles '\AutoHotkey\v2\AutoHotkey.exe'
ExtV2 := 'ahk'	; v2 extension (personal use .ah2 for v2 scripts)
;}

; AUTO-EXECUTE
;{-----------------------------------------------
;
If FileExist(RegExReplace(A_ScriptName, '(.*)\..*', '$1.txt')) ; Look for text file with same name as script
	Loop Read RegExReplace(A_ScriptName, '(.*)\..*', '$1.txt')
		If A_LoopReadLine
			Files.Insert(A_LoopReadLine)

Scripts := Map()
For index, FileItem in Files
{
	(FileItem ~= '/noload' ? Status := false : Status := true)
	(FileItem ~= '/v1' ? RunPath := RunPathV1 : RunPath := RunPathV2)
	FileItem := Trim(RegExReplace(FileItem, '/noload|/v1|/v2'))
	If RegExMatch(FileItem, '^(\.*)\\', &Match)
		R := StrLen(Match[1]) ; Look for relative pathing
	Else
		R := false
	If (R = 1)
		FileItem := A_ScriptDir SubStr(FileItem, R + 1)
	Else If (R > 1)
		FileItem := SubStr(A_ScriptDir, 1, InStr(A_ScriptDir, '\', , , -(R - 1))) SubStr(FileItem, R + 2)
	If RegExMatch(FileItem, '\\$') ; If File ends in \ assume it is a folder
	{
		Loop Files FileItem '*.*', 'R' ; Get full path of all files in folder and subfolders
			Scripts_Push(A_LoopFileFullPath)
	}
	Else
		If RegExMatch(FileItem, '\*|\?') ; If File contains wildcard
		{
			Loop Files FileItem, 'R' ; Get full path of all matching files in folder and subfolders
				Scripts_Push(A_LoopFileFullPath)
		}
		Else
			Scripts_Push(FileItem)
}
Scripts_Push(Path)
{
	global RunPath
	SplitPath(Path, &Script_Name)
	If ExtV1 != ExtV2
		If (Script_Name ~= '\.' ExtV1 '$')
			RunPath := RunPathV1
		Else If (Script_Name ~= '\.' ExtV2 '$')
			RunPath := RunPathV2
	Scripts[Script_Name] := { Path: Path, Status: Status, RunPath: RunPath }
}

; Run All the Scripts with Status true, Keep Their Pid
For Script_Name, Script in Scripts
{
	If !Script.Status
		Continue
	; Use specific AutoHotkey version to run scripts
	; Required to deal with 'launcher' that was introduced when Autohotkey v2 is installed
	; Requires literal quotes around variables to handle spaces in file paths/names
	Run('"' Script.RunPath '" "' Script.Path '"', , , &Pid) ; specify Autohotkey version
	Scripts[Script_Name].DefineProp('PID', { Value: Pid })
}

OnExit(ExitFunc) ; Call ExitFunc when this Script Exits
TrayTipBuild(), MenuBuild()	; Build Menu and TrayTip
OnMessage(0x404, AHK_NOTIFYICON) ; Hook Events for Tray Icon (used for Tray Icon cleanup on mouseover)
OnMessage(0x7E, AHK_DISPLAYCHANGE) ; Hook Events for Display Change (used for Tray Icon cleanup on resolution change)
TrayIconRemove(10)	; Remove Tray Icons
;
;}-----------------------------------------------
; END OF AUTO-EXECUTE

; HOTKEYS
;{-----------------------------------------------
;
~#^!Escape:: ExitApp ; <-- Terminate Script
;}

; FUNCTIONS - GUI
;{-----------------------------------------------
;
MenuBuild()
{
	Menu_Load := Menu(), A_TrayMenu.Delete()
	For Script_Name, Script in Scripts
	{
		If Script.Status
		{
			Menu_Sub := Menu(), Menu_Sub.Pid := Script.Pid, Menu_Sub.Parent := Script_Name
			Menu_Sub.Add('View Lines', ScriptCommand)
			Menu_Sub.Add('View Variables', ScriptCommand)
			Menu_Sub.Add('View Hotkeys', ScriptCommand)
			Menu_Sub.Add('View Key History', ScriptCommand)
			Menu_Sub.Add('View Key History', ScriptCommand)
			Menu_Sub.Add()
			Menu_Sub.Add('Open', ScriptCommand)
			Menu_Sub.Add('Edit', ScriptCommand)
			Menu_Sub.Add('Pause', ScriptCommand)
			Menu_Sub.Add('Suspend', ScriptCommand)
			Menu_Sub.Add('Reload', ScriptCommand)
			Menu_Sub.Add('Exit', ScriptCommand)
			A_TrayMenu.Add(Script_Name, Menu_Sub)
		}
		Else
			Menu_Load.Add(Script_Name, ScriptCommand_Load)
	}
	A_TrayMenu.Add()
	A_TrayMenu.Add('Load', Menu_Load), A_TrayMenu.Default := 'Load'
	A_TrayMenu.AddStandard()
	Return
}

ScriptCommand(ItemName, ItemPos, MyMenu)
{
	Static Cmd := Map('Open', 65300, 'Reload', 65400, 'Edit', 65401, 'Pause', 65403, 'Suspend', 65404, 'Exit', 65405, 'View Lines', 65406, 'View Variables', 65407, 'View Hotkeys', 65408, 'View Key History', 65409)
	If (ItemName = 'Reload')	; if Reload, simulate by exiting and running again with captured Pid
	{
		try PostMessage(0x111, Cmd['Exit'], , , 'ahk_pid ' MyMenu.Pid)
		hWnds := WinGetList('ahk_pid ' MyMenu.Pid)
		For hWnd in hWnds
			Try WinKill('ahk_id ' hWnd)
		Run('"' Scripts[MyMenu.Parent].RunPath '" "' Scripts[MyMenu.Parent].Path '"', , , &Pid) ; specify Autohotkey version
		Scripts[MyMenu.Parent].Pid := Pid, MyMenu.Pid := Pid
		TrayIconRemove(6) ; need to remove new icon
	}
	Else
	{
		If (ItemName = 'Pause' or ItemName = 'Suspend')
			MyMenu.ToggleCheck(ItemName)
		try PostMessage(0x111, Cmd[ItemName], , , 'ahk_pid ' MyMenu.Pid)
	}
	If (ItemName = 'Exit')
	{
		hWnds := WinGetList('ahk_pid ' MyMenu.Pid)
		For hWnd in hWnds
			Try WinKill('ahk_id ' hWnd)
		Scripts[MyMenu.Parent].Status := false
		MenuBuild(), TrayTipBuild()	; Rebuild Menu and TrayTip
	}
}

ScriptCommand_Load(ItemName, ItemPos, MyMenu)
{
	Run('"' Scripts[ItemName].RunPath '" "' Scripts[ItemName].Path '"', , , &Pid) ; specify Autohotkey version
	Scripts[ItemName].Pid := Pid, Scripts[ItemName].Status := true	; keep new info

	MenuBuild(), TrayTipBuild()	; bebuild Menu and TrayTip
	TrayIconRemove(6) ; need to remove new icon
}
;}

; FUNCTIONS
;{-----------------------------------------------
;
TrayTipBuild()
{
	Tip_Text := ''
	For Script_Name, Script in Scripts
		If Script.Status
			Tip_Text .= Script_Name '`n'
	Tip_Text := Sort(Tip_Text)
	Tip_Text := TrimAtDelim(Trim(Tip_Text, ' `n'))
	A_IconTip := Tip_Text ; Tooltip is limited to first 127 characters
	Return
}

TrayIconRemove(Attempts)
{
	Global Scripts
	Loop Attempts	; try to remove over time because icons may lag especially during bootup
	{
		For Script_Name, Script in Scripts
			If Script.Status
			{
				hWnds := WinGetList('ahk_pid ' Script.Pid)
				For hWnd in hWnds
					KillTrayIcon(hWnd)
			}
		Sleep A_Index ** 2 * 200
	}
	Return
}

KillTrayIcon(scriptHwnd)	; converted from v1 code by Lexikos
{
	Static NIM_DELETE := 2, AHK_NOTIFYICON := 1028
	nic := Buffer(936 + 4 * A_PtrSize, 0)
	NumPut('UPtr', scriptHwnd, nic, A_PtrSize)
	NumPut('UInt', AHK_NOTIFYICON, nic, A_PtrSize * 2)
	Return DllCall('Shell32\Shell_NotifyIcon', 'UInt', NIM_DELETE, 'Ptr', nic)
}

TrimAtDelim(String, Length := 124, Delim := '`n', Tail := '...')
{
	If (StrLen(String) > Length)
		RegExMatch(SubStr(String, 1, Length + 1), 's)(.*)' Delim, &Match), Result := Match[] Tail
	Else
		Result := String
	Return Result
}

AHK_NOTIFYICON(wParam, lParam, uMsg, hWnd) ; OnMessage(0x404, AHK_NOTIFYICON) to cleanup tray icons on mouseover
{
	If (lParam = 0x200) ; WM_MOUSEMOVE := 0x200
		TrayIconRemove(1)
}

AHK_DISPLAYCHANGE(wParam, lParam, uMsg, hWnd) ; OnMessage(0x7E, AHK_DISPLAYCHANGE) to cleanup tray icons on resolution change
{
	TrayIconRemove(8) ; resolution change can take a moment so try over time
}

; Stop All the Scripts with Status true (Called When this Script Exits)
ExitFunc(ExitReason, ExitCode)
{
	For Script_Name, Script in Scripts
		If Script.Status
		{
			hWnds := WinGetList('ahk_pid ' Script.Pid)
			For hWnd in hWnds
				Try WinKill('ahk_id ' hWnd)
		}
	ExitApp
}
;}
