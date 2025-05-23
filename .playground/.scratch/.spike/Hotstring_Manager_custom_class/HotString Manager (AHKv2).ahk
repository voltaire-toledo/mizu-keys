; Hotstring Manager (https://www.autohotkey.com/boards/viewtopic.php?t=115835)
; Fanatic Guru
;
; Version 2023 04 06
;
; #Requires AutoHotkey v2
;
; Manager for Hotstrings
;
;{-----------------------------------------------
;
; Hotstring Manager allows you to create, edit, delete, and manage many hotstrings in an easy to use interface.
;
;}

;; INITIALIZATION - ENVIROMENT
;{-----------------------------------------------
;
#Requires AutoHotkey v2.0
#Warn All, Off
#SingleInstance force ; Ensures that only the last executed instance of script is running
;}

;; DEFAULT SETTING - VARIABLES
;{-----------------------------------------------
;
Settings := { Save: {}, File: {}, Font: {} }
Settings.Save.HS := true
Settings.Save.INI := true
Settings.File.HS := "Hotstring Manager.sav"
Settings.File.INI := "Hotstring Manager.ini"
Settings.Font.Size := 12
Settings.GuiPositions := { guiList: { X: A_ScreenWidth / 3.5, Y: A_ScreenHeight / 5, Width: A_ScreenWidth / 5, Height: A_ScreenHeight / 5 },
guiInput: { X: A_ScreenWidth / 3.25, Y: A_ScreenWidth / 6, Width: A_ScreenWidth / 6, Height: A_ScreenHeight / 6 },
guiSettings: { X: A_ScreenWidth / 3.25, Y: A_ScreenWidth / 6, Width: A_ScreenWidth / 6, Height: A_ScreenHeight / 10 } }
; load INI and overwrite default settings
If Settings.Save.INI
	Load_Settings()
;}

;; INITIALIZATION - VARIABLES
;{-----------------------------------------------
;
Hotstrings := Map(), Hotstrings.Default := ""
OptionFlags := { NoEndChar: "*", CaseSensitive: "C", TriggerInside: "?", NoConformCase: "C1", NoAutoBack: "B0", OmitEndChar: "O", SendRaw: "R", TextRaw: "T" }
Toggle_Active := true
;}

;; INITIALIZATION - GUI
;{-----------------------------------------------
;
;{ guiList
guiList := Gui(, "Hotstring Manager - List"), guiList.Opt("+AlwaysOnTop +Resize +MinSize650x300")
guiList.OnEvent("Size", GuiReSizer)
guiList.OnEvent("Escape", gui_Hide)
guiList.SetFont("s" Settings.Font.Size)
guiList.Button := {}
guiList.Button.Add := guiList.Add("Button", "Default", "&Add")
guiList.Button.Add.OnEvent("Click", guiList_Button_Add_Click)
GuiButtonIcon(guiList.Button.Add.Hwnd, A_WinDir '\system32\wmploc.dll', 12, "a1 r10 s" Settings.Font.Size * 2)
guiList.Button.Edit := guiList.Add("Button", "yp", "&Edit")
guiList.Button.Edit.OnEvent("Click", guiList_Button_Edit_Click)
GuiButtonIcon(guiList.Button.Edit.Hwnd, A_WinDir '\system32\wmploc.dll', 133, "a1 r10 s" Settings.Font.Size * 2)
guiList.Button.Delete := guiList.Add("Button", "yp", "&Delete")
guiList.Button.Delete.OnEvent("Click", guiList_Button_Delete_Click)
GuiButtonIcon(guiList.Button.Delete.Hwnd, A_WinDir '\system32\shell32.dll', 220, "a1 r10 s" Settings.Font.Size * 2)
guiList.Button.Settings := guiList.Add("Button", "yp", "&Settings")
guiList.Button.Settings.OnEvent("Click", guiList_Button_Settings_Click)
GuiButtonIcon(guiList.Button.Settings.Hwnd, A_WinDir '\system32\shell32.dll', 315, "a1 r10 s" Settings.Font.Size * 2)
guiList.ListView := guiList.Add("ListView", "+Grid -Multi xm r20 w750", ["Options", "Abbreviation", "Replacement"])
guiList.ListView.OnEvent("DoubleClick", guiList_Button_Edit_Click)
guiList.Button.Add.X := 10
guiList.Button.Add.WidthP := 0.20
guiList.Button.Edit.XP := 0.37
guiList.Button.Edit.OriginXP := 0.5
guiList.Button.Edit.WidthP := 0.20
guiList.Button.Delete.XP := 0.62
guiList.Button.Delete.OriginXP := 0.5
guiList.Button.Delete.WidthP := 0.20
guiList.Button.Settings.X := -10
guiList.Button.Settings.OriginXP := 1
guiList.Button.Settings.WidthP := 0.22
guiList.ListView.Width := -10
guiList.ListView.Height := -10
;}
;{ guiInput
guiInput := Gui(, "Hotstring Manager - Add"), guiInput.Opt("+AlwaysOnTop +Resize +MinSize" Settings.Font.Size * 48 "x" Settings.Font.Size * 25)
guiInput.OnEvent("Size", GuiReSizer)
guiInput.OnEvent("Escape", gui_Hide)
guiInput.SetFont("s" Settings.Font.Size)
guiInput.Edit := {}, guiInput.Checkbox := {}, guiInput.Button := {}
guiInput.Add("Text", "Right w" Settings.Font.Size * 8, "Abbreviation:")
guiInput.Edit.Abbr := guiInput.Add("Edit", "w400 yp x" Settings.Font.Size * 11)
guiInput.Add("Text", "Right xm w" Settings.Font.Size * 8, "Replacement:")
guiInput.Edit.Replace := guiInput.Add("Edit", "r4 w400 WantTab yp x" Settings.Font.Size * 11)
guiInput.Line := guiInput.Add("Text", "x10 h1 w400 0x7")
guiInput.Checkbox.NoEndChar := guiInput.Add("Checkbox", , "No ending character (*)")
guiInput.Checkbox.CaseSensitive := guiInput.Add("Checkbox", , "Case sensitive (C)")
guiInput.Checkbox.TriggerInside := guiInput.Add("Checkbox", , "Trigger inside another word (?)")
guiInput.Checkbox.NoConformCase := guiInput.Add("Checkbox", , "Do not conform to typed case (C1)")
guiInput.Checkbox.NoAutoBack := guiInput.Add("Checkbox", , "No automatic backspacing (B0)")
guiInput.Checkbox.OmitEndChar := guiInput.Add("Checkbox", , "Omit ending character (O)")
guiInput.Checkbox.SendRaw := guiInput.Add("Checkbox", , "Send raw (R)")
guiInput.Checkbox.TextRaw := guiInput.Add("Checkbox", , "Send text raw (T)")
guiInput.Edit.Abbr.Width := -10
guiInput.Edit.Replace.Width := -10
guiInput.Edit.Replace.Height := -Settings.Font.Size * 15
guiInput.Line.X := 10
guiInput.Line.Y := -Settings.Font.Size * 14
guiInput.Line.Width := -10
For FlagName, Val in OptionFlags.OwnProps()	; Position Checkboxes
{
	Mod(A_Index, 2) ? guiInput.Checkbox.%FlagName%.XP := 0.05 : guiInput.Checkbox.%FlagName%.XP := 0.55
	guiInput.Checkbox.%FlagName%.Y := -Settings.Font.Size * 14.5 + (Ceil(A_Index / 2) * Settings.Font.Size * 2)
	guiInput.Checkbox.%FlagName%.Cleanup := true
}
guiInput.Button.Confirm := guiInput.Add("Button", "Default", "&Confirm")
guiInput.Button.Confirm.OnEvent("Click", guiInput_Button_Confirm_Click)
guiInput.Button.Cancel := guiInput.Add("Button", , "&Cancel")
guiInput.Button.Cancel.OnEvent("Click", guiInput_Button_Cancel_Click)
guiInput.Button.Confirm.XP := 0.20
guiInput.Button.Confirm.Y := -Settings.Font.Size
guiInput.Button.Confirm.OriginYP := 1
guiInput.Button.Confirm.WidthP := 0.25
guiInput.Button.Cancel.XP := 0.60
guiInput.Button.Cancel.Y := -Settings.Font.Size
guiInput.Button.Cancel.OriginYP := 1
guiInput.Button.Cancel.WidthP := 0.25
;}
;{ guiSettings
guiSettings := Gui(, "Hotstring Manager - Settings"), guiSettings.Opt("+AlwaysOnTop +Resize +MinSize" Settings.Font.Size * 35 "x" Settings.Font.Size * 18 + 50)
guiSettings.OnEvent("Size", GuiReSizer)
guiSettings.OnEvent("Escape", gui_Hide)
guiSettings.SetFont("s" Settings.Font.Size)
guiSettings.Button := {}, guiSettings.Edit := {}, guiSettings.Checkbox := {}, guiSettings.DropDownList := {}
guiSettings.Button.Load := guiSettings.Add("Button", "Default y10 x10 w150", "&Load`nHotstrings")
guiSettings.Button.Load.OnEvent("Click", guiSettings_Button_Load_Click)
GuiButtonIcon(guiSettings.Button.Load.Hwnd, A_WinDir '\system32\imageres.dll', 280, "a1 r10 s" Settings.Font.Size * 3)
guiSettings.Button.Save := guiSettings.Add("Button", "Default yp x+50 w150", "&Save`nHotstrings")
guiSettings.Button.Save.OnEvent("Click", guiSettings_Button_Save_Click)
GuiButtonIcon(guiSettings.Button.Save.Hwnd, A_WinDir '\system32\wmploc.dll', 132, "a1 r10 s" Settings.Font.Size * 3)
guiSettings.Line := guiSettings.Add("Text", "y+20 x10 w350 h1 0x7")	; horizontal line
guiSettings.Text1 := guiSettings.Add("Text", "y+10 x10", "Auto Save/Load File Name:")
guiSettings.Edit.SaveHS := guiSettings.Add("Edit", "r1 yp-5 x+10 w210", Settings.File.HS)
guiSettings.Checkbox.SaveHS := guiSettings.Add("Checkbox", "y+10 x10", "Auto Save/Load Hotstrings")
guiSettings.Checkbox.SaveHS.Value := Settings.Save.HS
guiSettings.Text2 := guiSettings.Add("Text", "yp+" Settings.Font.Size * 3 " x10", "Font Size [Reload Required]:")
guiSettings.DropDownList.Font := guiSettings.Add("DropDownList", "yp x+10 w50", ["10", "12", "14", "16", "18"])
guiSettings.DropDownList.Font.Text := Settings.Font.Size
guiSettings.Button.Confirm := guiSettings.Add("Button", "Default y+20 x10 w150", "&Confirm")
guiSettings.Button.Confirm.OnEvent("Click", guiSettings_Button_Confirm_Click)
guiSettings.Button.Cancel := guiSettings.Add("Button", "yp x+50 w150", "&Cancel")
guiSettings.Button.Cancel.OnEvent("Click", guiSettings_Button_Cancel_Click)
guiSettings.Button.Load.XP := 0.05
guiSettings.Button.Load.WidthP := 0.4
guiSettings.Button.Save.XP := -0.05
guiSettings.Button.Save.OriginXP := 1
guiSettings.Button.Save.WidthP := 0.4
guiSettings.Line.Width := -10
guiSettings.Edit.SaveHS.Width := -10
guiSettings.Button.Confirm.XP := 0.20
guiSettings.Button.Confirm.Y := -Settings.Font.Size
guiSettings.Button.Confirm.OriginYP := 1
guiSettings.Button.Confirm.WidthP := 0.25
guiSettings.Button.Cancel.XP := 0.60
guiSettings.Button.Cancel.Y := -Settings.Font.Size
guiSettings.Button.Cancel.OriginYP := 1
guiSettings.Button.Cancel.WidthP := 0.25
;}
;}

;; AUTO-EXECUTE
;{-----------------------------------------------
;
; Load Hotstrings
If Settings.Save.HS
	Load_Hotstrings(Settings.File.HS)

; Init positioning of Gui
For GuiName, Pos in Settings.GuiPositions.OwnProps()
{
	%GuiName%.Show("Hide")
	%GuiName%.Move(Pos.X, Pos.Y, Pos.Width, Pos.Height)
	GuiReSizer.Now(%GuiName%)
}

OnExit(OnExit_Save)
;}

;; HOTKEYS
;{-----------------------------------------------
;
#SuspendExempt	; Only Hotstrings affected by Suspend
#h:: guiList.Show	; <-- Hotstring Manager - List

#Space::	; <-- Space without expanding Hotstring
{
	Hotstring("Reset")
	Send "{Space}"
}

^#space::	; <-- Toggle On/Off
{
	Global
	Toggle_Active := !Toggle_Active
	ToolTip "Hotsting Manager`n" (Toggle_Active ? "ON" : "OFF")
	SetTimer () => ToolTip(), -5000
	(Toggle_Active ? Suspend(false) : Suspend(true))
}
#SuspendExempt false
;}

;; CLASSES & FUNCTIONS - GUI
;{-----------------------------------------------
;
;{ All Gui
;; Gui Escape
gui_Hide(GuiObj)
{
	GuiObj.Hide
}
;}
;{ guiList
guiList_Button_Add_Click(GuiCtrlObj, Info)
{
	For PropDesc, Prop in guiInput.Edit.OwnProps()
		Prop.Text := ""
	For PropDesc, Prop in guiInput.Checkbox.OwnProps()
		Prop.Value := 0
	guiInput.Title := "Hotstring Manager - Add"
	guiInput.Edit.Abbr.Focus()
	guiInput.Show
}

guiList_Button_Edit_Click(GuiCtrlObj, RowNumber := 0)	; also List View DoubleClick
{
	Global CurrentHS
	If !RowNumber
		RowNumber := guiList.ListView.GetNext()
	If RowNumber = 0
	{
		MsgBox "Select Hotsting to Edit"
		Return
	}
	Options := guiList.ListView.GetText(RowNumber)
	guiInput.Edit.Abbr.Text := Abbr := guiList.ListView.GetText(RowNumber, 2)
	guiInput.Edit.Replace.Text := StrReplace(Replace := Hotstrings[Options ":" Abbr], "`n", "`r`n")
	For Flag, Value in OptionFlags.OwnProps()
	{
		If RegExMatch(Options, "\Q" Value "\E(?!\d)")
			guiInput.Checkbox.%Flag%.Value := true
		Else
			guiInput.Checkbox.%Flag%.Value := false
	}
	guiInput.Title := "Hotstring Manager - Edit"
	CurrentHS := { RowNumber: RowNumber, Options: Options, Abbr: Abbr, Replace: Replace }
	guiInput.Edit.Abbr.Focus()
	guiInput.Show
}

guiList_Button_Delete_Click(GuiCtrlObj, Info)
{
	RowNumber := guiList.ListView.GetNext()
	If RowNumber = 0
	{
		MsgBox "Select Hotsting to Delete"
		Return
	}
	For Index, Element in ["Options", "Abbr", "Replace"]
		%Element% := guiList.ListView.GetText(RowNumber, Index)
	If MsgBox("Are you sure you want to Delete?`n`n" Abbr "`n" Replace, "Delete Hotstring", 4 + 32 + 256 + 4096) = "Yes"
	{
		guiList.ListView.Delete(RowNumber)
		Hotstrings.Delete(Options ":" Abbr)
		Hotstring(":" Options ":" Abbr, , false)
	}
}

guiList_Button_Settings_Click(GuiCtrlObj, Info)
{
	guiSettings.Show
}
;}
;{ guiInput
guiInput_Button_Confirm_Click(*)
{
	guiInput.Hide
	Options := ""
	For Opt, Flag in OptionFlags.OwnProps()
		If guiInput.Checkbox.%Opt%.Value
			Options .= Flag
	If guiInput.Title ~= "Edit"
	{
		; when editting - delete current Hotstring to recreate
		guiList.ListView.Delete(CurrentHS.RowNumber)
		Hotstrings.Delete(CurrentHS.Options ":" CurrentHS.Abbr)
		Hotstring(":BCO0R0*0:" CurrentHS.Abbr, CurrentHS.Replace, false)	; Disable Exsisting Options Variants (C)
		Hotstring(":BC1O0R0*0:" CurrentHS.Abbr, CurrentHS.Replace, false)	; Disable Exsisting Options Variants (C1)
		Hotstring(":BC0O0R0*0:" CurrentHS.Abbr, CurrentHS.Replace, false)	; Disable Exsisting Options Variants (C0)
	}
	; remove any list View duplicate
	Loop guiList.ListView.GetCount()
		If (guiList.ListView.GetText(A_Index) = Options and guiList.ListView.GetText(A_Index, 2) = guiInput.Edit.Abbr)
			guiList.ListView.Delete(A_Index)
	; create Hotstring
	Hotstrings[Options ":" guiInput.Edit.Abbr.Value] := guiInput.Edit.Replace.Value
	Hotstring(":" Options ":" guiInput.Edit.Abbr.Value, guiInput.Edit.Replace.Value, true)
	guiList.ListView.Add(, Options, guiInput.Edit.Abbr.Value, Escape_CC(guiInput.Edit.Replace.Value))
}

guiInput_Button_Cancel_Click(*)
{
	guiInput.Hide
}
;}
;{ guiSettings
guiSettings_Button_Confirm_Click(Dialog, *)
{
	Global Settings
	guiSettings.Hide
	(Settings.Font.Size != guiSettings.DropDownList.Font.Text) ? DoReload := true : DoReload := false
	Settings.Font.Size := guiSettings.DropDownList.Font.Text
	Settings.Save.HS := guiSettings.Checkbox.SaveHS.Value
	Settings.File.HS := guiSettings.Edit.SaveHS.Value
	If DoReload
		Reload
}

guiSettings_Button_Load_Click(*)
{
	guiSettings.Opt("+OwnDialogs")
	FileName := FileSelect(3, , "Select Hotstring File to Load")
	If FileName
		Load_Hotstrings(FileName)
}

guiSettings_Button_Save_Click(*)
{
	guiSettings.Opt("+OwnDialogs")
	FileName := FileSelect(3, , "Select Hotstring File for Save")
	If FileName
		Save_Hotstrings(FileName)
}

guiSettings_Button_Cancel_Click(*)
{
	guiSettings.Hide
}
;}
;}

;; FUNCTIONS
;{-----------------------------------------------
;
;{ Save/Load/Exit
Save_Hotstrings(FileName)
{
	For Opt_Abbr, Replacement in Hotstrings
		String .= ":" Opt_Abbr "::" Escape_CC(Replacement) "`n"
	Try FileMove(FileName, FileName ".bak", true)
	Try FileAppend(SubStr(String, 1, -1), FileName)
}

Load_Hotstrings(FileName)
{
	Try
		String := FileRead(FileName)
	Catch
		Return
	Loop Parse, String, "`n", "`r"
	{
		If RegExMatch(A_LoopField, "U)^:(?<Options>.*):(?<Abbr>.*)::(?<Replace>.*)$", &Match)
		{
			If Hotstrings[Match.Options ":" Match.Abbr] !== Match.Replace
			{
				guiList.ListView.Add(, Match.Options, Match.Abbr, Match.Replace)
				Match.Replace := Unescape_CC(Match.Replace)
				Hotstrings[Match.Options ":" Match.Abbr] := Match.Replace
				Hotstring(":" Match.Options ":" Match.Abbr, Match.Replace, true)
			}
		}
	}
	Loop 3
		guiList.ListView.ModifyCol(A_Index, "AutoHdr")
	guiList.ListView.ModifyCol(3, "Sort")
}

Save_Settings()
{
	Try FileMove(Settings.File.INI, Settings.File.INI ".bak", true)
	For GuiName, Pos in Settings.GuiPositions.OwnProps()
	{
		%GuiName%.GetPos(&X, &Y, &W, &H)
		Pos.X := X, Pos.Y := Y, Pos.Width := W, Pos.Height := H
	}
	For Section_Name, Section in Settings.OwnProps()
		For Setting_Name, Value in Section.OwnProps()
			If !IsObject(Value)
				IniWrite Value, Settings.File.INI, Section_Name, Setting_Name

	For Section_Name, Section in Settings.GuiPositions.OwnProps()
		For Setting_Name, Value in Section.OwnProps()
			IniWrite Value, Settings.File.INI, Section_Name, Setting_Name
}

Load_Settings()
{
	For Section_Name, Section in Settings.OwnProps()
		For Setting_Name, Value in Section.OwnProps()
			If !IsObject(Value)
				Try Settings.%Section_Name%.%Setting_Name% := IniRead(Settings.File.INI, Section_Name, Setting_Name)
	For Section_Name, Section in Settings.GuiPositions.OwnProps()
		For Setting_Name, Value in Section.OwnProps()
			Try Settings.GuiPositions.%Section_Name%.%Setting_Name% := IniRead(Settings.File.INI, Section_Name, Setting_Name)
}

OnExit_Save(*)
{
	If Settings.Save.HS
		Save_Hotstrings(Settings.File.HS)
	If Settings.Save.INI
		Save_Settings()
}
;}
;{ Escape / Unescape Control Characters
Escape_CC(String)	; Escape Control Characters
{
	String := StrReplace(String, "`n", "``n")
	String := StrReplace(String, "`t", "``t")
	String := StrReplace(String, "`b", "``b")
	Return String
}
Unescape_CC(String)	; Unescape Control Characters
{
	String := StrReplace(String, "``n", "`n")
	String := StrReplace(String, "``t", "`t")
	String := StrReplace(String, "``b", "`b")
	Return String
}
;}
;}

;; Library
;{-----------------------------------------------
;
;{ [Class] GuiReSizer
;{ -------------------
; Fanatic Guru
; Version 2023 03 13
;
; Update 2023 02 15:  Add more Min Max properties and renamed some properties
; Update 2023 03 13:  Major rewrite.  Converted to Class to allow for Methods
; Update 2023 03 17:  Add function InTab3 to allow automatic anchoring of controls in Tab3
;
; #Requires AutoHotkey v2.0.2+
;
; Class to Handle the Resizing of Gui and
; Move and Resize Controls
;
;------------------------------------------------
;
;   Class GuiReSizer
;
;   Call: GuiReSizer(GuiObj, WindowMinMax, Width, Height)
;
;   Parameters:
;	1) {GuiObj} 		Gui Object
;   2) {WindowMinMax}	Window status, 0 = neither minimized nor maximized, 1 = maximized, -1 = minimized
;   3) {Width}			Width of GuiObj
;   4) {Height}			Height of GuiObj
;
;   	Normally parameters are passed by a callback from {gui}.OnEvent("Size", GuiReSizer)
;
;	Properties:		Abbr	Description
; 		X					X positional offset from margins
;		Y					Y positional offset from margins
; 		XP					X positional offset from margins as percentage of Gui width
; 		YP					Y positional offset from margins as percentage of Gui height
;		OriginX		OX		control origin X defaults to 0 or left side of control, this relocates the origin
;		OriginXP	OXP		control origin X as percentage of Gui width defaults to 0 or left side of control, this relocates the origin
;		OriginY		OY		control origin Y defaults to 0 or top side of control, this relocates the origin
;		OriginYP	OYP		control origin Y as percentage of Gui height defaults to 0 or top side of control, this relocates the origin
;		Width		W		width of control
;		WidthP		WP		width of control as percentage of Gui width
;		Height		H		height of control
;		HeightP		HP		height of control as percentage of Gui height
;		MinX				mininum X offset
;		MaxX				maximum X offset
;		MinY				minimum Y offset
;		MaxY				maximum Y offset
;		MinWidth	MinW	minimum control width
;		MaxWidth	MaxW	maximum control width
;		MinHeight	MinH	minimum control height
;		MaxHeight	MaxH	maximum control height
;		Cleanup		C		{true/false} when set to true will redraw this control each time to cleanup artifacts, normally not required and causes flickering
;		Function	F		{function} custom function that will be called for this control
;		Anchor		A       {contol object} anchor control so that size and position commands are in relation to another control
;		AnchorIn	AI		{true/false} controls where the control is restricted to the inside of another control
;
;   Methods:
;       Now(GuiObj)         will force a manual Call now for {GuiObj}
;       Opt({switches})     same as Options method
;       Options({switches}) all options are set as a string with each switch separated by a space "x10 yp50 oCM"
;           Flags:
;           x{number}       X
;           y{number}       Y
;           xp{number}      XP
;           yp{number}      YP
;           wp{number}      WidthP
;           hp{number}      HeightP
;           w{number}       Width
;           h{number}       Height
;           minx{number}    MinX
;           maxx{number}    MaxX
;           miny{number}    MinY
;           maxy{number}    MaxY
;           minw{number}    MinWidth
;           maxw{number}    MaxWidth
;           minh{number}    MinHeight
;           maxh{number}    MaxHeight
;           oxp{number}     OriginXP
;           oyp{number}     OriginYP
;           ox{number}      OriginX
;           oy{number}      OriginY
;           o{letters}      Origin: "L" left, "C" center, "R" right, "T" top, "M" middle, "B" bottom; may use 1 or 2 letters
;
;	Gui Properties:
;		Init		{Gui}.Init := 1, will cause all controls of the Gui to be redrawn on next function call
;                   {Gui}.Init := 2, will also reinitialize abbreviations
;}
Class GuiReSizer
{
    ;{ Call GuiReSizer
    Static Call(GuiObj, WindowMinMax, GuiW, GuiH)
    {
        ;{ GuiObj Checks
        if !GuiObj.HasProp('Init')
			GuiObj.Init := 2 ; Redraw Twice on Initial Call with Redraw (called on initial Show)

        If WindowMinMax = -1 ; Do nothing if window minimized
            Return
;}
        ;{ Loop through all Controls of Gui
        For Hwnd, CtrlObj in GuiObj
        {
            ;{ Initializations Control on First Call
            If GuiObj.Init = 2
            {
                Try CtrlObj.OriginX := CtrlObj.OX
                Try CtrlObj.OriginXP := CtrlObj.OXP
                Try CtrlObj.OriginY := CtrlObj.OY
                Try CtrlObj.OriginYP := CtrlObj.OYP
                Try CtrlObj.Width := CtrlObj.W
                Try CtrlObj.WidthP := CtrlObj.WP
                Try CtrlObj.Height := CtrlObj.H
                Try CtrlObj.HeightP := CtrlObj.HP
                Try CtrlObj.MinWidth := CtrlObj.MinW
                Try CtrlObj.MaxWidth := CtrlObj.MaxW
                Try CtrlObj.MinHeight := CtrlObj.MinH
                Try CtrlObj.MaxHeight := CtrlObj.MaxH
                Try CtrlObj.Function := CtrlObj.F
                Try CtrlObj.Cleanup := CtrlObj.C
                Try CtrlObj.Anchor := CtrlObj.A
                Try CtrlObj.AnchorIn := CtrlObj.AI
                If !CtrlObj.HasProp("AnchorIn")
                	CtrlObj.AnchorIn := true
                if Tab3 := InTab3(CtrlObj)
					CtrlObj.Anchor := Tab3
            }
            ;}
            ;{ Initialize Current Positions and Sizes
            CtrlObj.GetPos(&CtrlX, &CtrlY, &CtrlW, &CtrlH)
            LimitX := AnchorW := GuiW, LimitY := AnchorH := GuiH, OffsetX := OffsetY := 0
            ;}
            ;{ Check for Anchor
            If CtrlObj.HasProp("Anchor")
            {
                If Type(CtrlObj.Anchor) = "Gui.Tab"
                {
                    CtrlObj.Anchor.GetPos(&AnchorX, &AnchorY, &AnchorW, &AnchorH)
                    OffsetTab(CtrlObj, &TabX, &TabY)
                    CtrlX := CtrlX - TabX, CtrlY := CtrlY - TabY
                    AnchorW := AnchorW + AnchorX - TabX, AnchorH := AnchorH + AnchorY - TabY
                }
                Else
                {
                    CtrlObj.Anchor.GetPos(&AnchorX, &AnchorY, &AnchorW, &AnchorH)
                    If CtrlObj.HasProp("X") or CtrlObj.HasProp("XP")
                        OffsetX := AnchorX
                    If CtrlObj.HasProp("Y") or CtrlObj.HasProp("YP")
                        OffsetY := AnchorY
                }
                If CtrlObj.AnchorIn
                    LimitX := AnchorW, LimitY := AnchorH
            }
            ;}
            ;{ OriginX
            If CtrlObj.HasProp("OriginX") and CtrlObj.HasProp("OriginXP")
                OriginX := CtrlObj.OriginX + (CtrlW * CtrlObj.OriginXP)
            Else If CtrlObj.HasProp("OriginX") and !CtrlObj.HasProp("OriginXP")
                OriginX := CtrlObj.OriginX
            Else If !CtrlObj.HasProp("OriginX") and CtrlObj.HasProp("OriginXP")
                OriginX := CtrlW * CtrlObj.OriginXP
            Else
                OriginX := 0
            ;}
            ;{ OriginY
            If CtrlObj.HasProp("OriginY") and CtrlObj.HasProp("OriginYP")
                OriginY := CtrlObj.OriginY + (CtrlH * CtrlObj.OriginYP)
            Else If CtrlObj.HasProp("OriginY") and !CtrlObj.HasProp("OriginYP")
                OriginY := CtrlObj.OriginY
            Else If !CtrlObj.HasProp("OriginY") and CtrlObj.HasProp("OriginYP")
                OriginY := CtrlH * CtrlObj.OriginYP
            Else
                OriginY := 0
            ;}
            ;{ X
            If CtrlObj.HasProp("X") and CtrlObj.HasProp("XP")
                CtrlX := Mod(LimitX + CtrlObj.X + (AnchorW * CtrlObj.XP) - OriginX, LimitX)
            Else If CtrlObj.HasProp("X") and !CtrlObj.HasProp("XP")
                CtrlX := Mod(LimitX + CtrlObj.X - OriginX, LimitX)
            Else If !CtrlObj.HasProp("X") and CtrlObj.HasProp("XP")
                CtrlX := Mod(LimitX + (AnchorW * CtrlObj.XP) - OriginX, LimitX)
            ;}
            ;{ Y
            If CtrlObj.HasProp("Y") and CtrlObj.HasProp("YP")
                CtrlY := Mod(LimitY + CtrlObj.Y + (AnchorH * CtrlObj.YP) - OriginY, LimitY)
            Else If CtrlObj.HasProp("Y") and !CtrlObj.HasProp("YP")
                CtrlY := Mod(LimitY + CtrlObj.Y - OriginY, LimitY)
            Else If !CtrlObj.HasProp("Y") and CtrlObj.HasProp("YP")
                CtrlY := Mod(LimitY + AnchorH * CtrlObj.YP - OriginY, LimitY)
            ;}
            ;{ Width
            If CtrlObj.HasProp("Width") and CtrlObj.HasProp("WidthP")
                (CtrlObj.Width > 0 and CtrlObj.WidthP > 0 ? CtrlW := CtrlObj.Width + AnchorW * CtrlObj.WidthP : CtrlW := CtrlObj.Width + AnchorW + AnchorW * CtrlObj.WidthP - CtrlX)
            Else If CtrlObj.HasProp("Width") and !CtrlObj.HasProp("WidthP")
                (CtrlObj.Width > 0 ? CtrlW := CtrlObj.Width : CtrlW := AnchorW + CtrlObj.Width - CtrlX)
            Else If !CtrlObj.HasProp("Width") and CtrlObj.HasProp("WidthP")
                (CtrlObj.WidthP > 0 ? CtrlW := AnchorW * CtrlObj.WidthP : CtrlW := AnchorW + AnchorW * CtrlObj.WidthP - CtrlX)
            ;}
            ;{ Height
            If CtrlObj.HasProp("Height") and CtrlObj.HasProp("HeightP")
                (CtrlObj.Height > 0 and CtrlObj.HeightP > 0 ? CtrlH := CtrlObj.Height + AnchorH * CtrlObj.HeightP : CtrlH := CtrlObj.Height + AnchorH + AnchorH * CtrlObj.HeightP - CtrlY)
            Else If CtrlObj.HasProp("Height") and !CtrlObj.HasProp("HeightP")
                (CtrlObj.Height > 0 ? CtrlH := CtrlObj.Height : CtrlH := AnchorH + CtrlObj.Height - CtrlY)
            Else If !CtrlObj.HasProp("Height") and CtrlObj.HasProp("HeightP")
                (CtrlObj.HeightP > 0 ? CtrlH := AnchorH * CtrlObj.HeightP : CtrlH := AnchorH + AnchorH * CtrlObj.HeightP - CtrlY)
            ;}
            ;{ Min Max
            (CtrlObj.HasProp("MinX") ? MinX := CtrlObj.MinX : MinX := -999999)
            (CtrlObj.HasProp("MaxX") ? MaxX := CtrlObj.MaxX : MaxX := 999999)
            (CtrlObj.HasProp("MinY") ? MinY := CtrlObj.MinY : MinY := -999999)
            (CtrlObj.HasProp("MaxY") ? MaxY := CtrlObj.MaxY : MaxY := 999999)
            (CtrlObj.HasProp("MinWidth") ? MinW := CtrlObj.MinWidth : MinW := 0)
            (CtrlObj.HasProp("MaxWidth") ? MaxW := CtrlObj.MaxWidth : MaxW := 999999)
            (CtrlObj.HasProp("MinHeight") ? MinH := CtrlObj.MinHeight : MinH := 0)
            (CtrlObj.HasProp("MaxHeight") ? MaxH := CtrlObj.MaxHeight : MaxH := 999999)
            CtrlX := MinMax(CtrlX, MinX, MaxX)
            CtrlY := MinMax(CtrlY, MinY, MaxY)
            CtrlW := MinMax(CtrlW, MinW, MaxW)
            CtrlH := MinMax(CtrlH, MinH, MaxH)
            ;}
            ;{ Move and Size
            CtrlObj.Move(CtrlX + OffsetX, CtrlY + OffsetY, CtrlW, CtrlH)
            ;}
            ;{ Redraw on Cleanup or GuiObj.Init
            If GuiObj.Init or (CtrlObj.HasProp("Cleanup") and CtrlObj.Cleanup = true)
                CtrlObj.Redraw()
            ;}
            ;{ Custom Function Call
            If CtrlObj.HasProp("Function")
                CtrlObj.Function(GuiObj) ; CtrlObj is hidden 'this' first parameter
            ;}
        }
        ;}
        ;{ Reduce GuiObj.Init Counter and Check for Call again
        If (GuiObj.Init := Max(GuiObj.Init - 1, 0))
        {
            GuiObj.GetClientPos(, , &AnchorW, &AnchorH)
            GuiReSizer(GuiObj, WindowMinMax, AnchorW, AnchorH)
        }
        ;}
        ;{ Functions: Helpers
        MinMax(Num, MinNum, MaxNum) => Min(Max(Num, MinNum), MaxNum)
        OffsetTab(CtrlObj, &OffsetX, &OffsetY)
        {
            hParentWnd := DllCall("GetParent", "Ptr", CtrlObj.Hwnd, "Ptr")
            RECT := Buffer(16, 0)
            DllCall("GetWindowRect", "Ptr", hParentWnd, "Ptr", RECT)
            DllCall("MapWindowPoints", "Ptr", 0, "Ptr", DllCall("GetParent", "Ptr", hParentWnd, "Ptr"), "Ptr", RECT, "UInt", 1)
            OffsetX := NumGet(RECT, 0, "Int"), OffsetY := NumGet(RECT, 4, "Int")
        }
		InTab3(CtrlObj)
		{
			Try
				Tab3Obj := GuiCtrlFromHwnd(DllCall('GetWindow', 'Ptr', DllCall('GetParent', 'Ptr', CtrlObj.Hwnd, 'Ptr'), 'UInt', 3, 'Ptr'))
			Catch
				Tab3Obj := false
			Return Tab3Obj
		}
        ;}
    }
    ;}
    ;{ Methods:
    ;{ Options
    Static Opt(CtrlObj, Options) => GuiReSizer.Options(CtrlObj, Options)
    Static Options(CtrlObj, Options)
    {
        For Option in StrSplit(Options, " ")
        {
            For Abbr, Cmd in Map(
                "xp", "XP", "yp", "YP", "x", "X", "y", "Y",
                "wp", "WidthP", "hp", "HeightP", "w", "Width", "h", "Height",
                "minx", "MinX", "maxx", "MaxX", "miny", "MinY", "maxy", "MaxY",
                "minw", "MinWidth", "maxw", "MaxWidth", "minh", "MinHeight", "maxh", "MaxHeight",
                "oxp", "OriginXP", "oyp", "OriginYP", "ox", "OriginX", "oy", "OriginY")
                If RegExMatch(Option, "i)^" Abbr "([\d.-]*$)", &Match)
                {
                    CtrlObj.%Cmd% := Match.1
                    Break
                }
            ; Origin letters
            If SubStr(Option, 1, 1) = "o"
            {
                Flags := SubStr(Option, 2)
                If Flags ~= "i)l"           ; left
                    CtrlObj.OriginXP := 0
                If Flags ~= "i)c"           ; center (left to right)
                    CtrlObj.OriginXP := 0.5
                If Flags ~= "i)r"           ; right
                    CtrlObj.OriginXP := 1
                If Flags ~= "i)t"           ; top
                    CtrlObj.OriginYP := 0
                If Flags ~= "i)m"           ; middle (top to bottom)
                    CtrlObj.OriginYP := 0.5
                If Flags ~= "i)b"           ; bottom
                    CtrlObj.OriginYP := 1
            }
        }
    }
    ;}
    ;{ Now
    Static Now(GuiObj, Redraw := true, Init := 2)
    {
        If Redraw
            GuiObj.Init := Init
        GuiObj.GetClientPos(, , &Width, &Height)
        GuiReSizer(GuiObj, WindowMinMax := 1, Width, Height)
    }
    ;}
    ;}
}
;}
;{ [Function] GuiButtonIcon
;{
; Fanatic Guru
; Version 2019 03 26
;
; #Requires AutoHotkey v2.0.2+
;
; FUNCTION to Assign an Icon to a Gui Button
;
;------------------------------------------------
;
; Method:
;   GuiButtonIcon(Handle, File, Index, Options)
;
;   Parameters:
;   1) {Handle} 	HWND handle of Gui button
;   2) {File} 		File containing icon image
;   3) {Index} 		Index of icon in file
;						Optional: Default = 1
;   4) {Options}	Single letter flag followed by a number with multiple options delimited by a space
;						W = Width of Icon (default = 16)
;						H = Height of Icon (default = 16)
;						S = Size of Icon, Makes Width and Height both equal to Size
;						L = Left Margin
;						T = Top Margin
;						R = Right Margin
;						B = Botton Margin
;						A = Alignment (0 = left, 1 = right, 2 = top, 3 = bottom, 4 = center; default = 4)
;
; Return:
;   1 = icon found, 0 = icon not found
;
; Example:
; Gui := GuiCreate()
; Button := Gui.Add("Button", "w70 h38", "Save")
; GuiButtonIcon(Button.Hwnd, "shell32.dll", 259, "s32 a1 r2")
; Gui.Show
;}
GuiButtonIcon(Handle, File, Index := 1, Options := "")
{
	RegExMatch(Options, "i)w\K\d+", &W) ? W := W.0 : W := 16
	RegExMatch(Options, "i)h\K\d+", &H) ? H := H.0 : H := 16
	RegExMatch(Options, "i)s\K\d+", &S) ? W := H := S.0 : ""
	RegExMatch(Options, "i)l\K\d+", &L) ? L := L.0 : L := 0
	RegExMatch(Options, "i)t\K\d+", &T) ? T := T.0 : T := 0
	RegExMatch(Options, "i)r\K\d+", &R) ? R := R.0 : R := 0
	RegExMatch(Options, "i)b\K\d+", &B) ? B := B.0 : B := 0
	RegExMatch(Options, "i)a\K\d+", &A) ? A := A.0 : A := 4
	W := W * (A_ScreenDPI / 96), H := H * (A_ScreenDPI / 96)
	Psz := (A_PtrSize = "" ? 4 : A_PtrSize), DW := "UInt", Ptr := (A_PtrSize = "" ? DW : "Ptr")
	button_il := Buffer(20 + Psz)
	normal_il := DllCall("ImageList_Create", DW, W, DW, H, DW, 0x21, DW, 1, DW, 1)
	NumPut(Ptr, normal_il, button_il, 0)	; Width & Height
	NumPut(DW, L, button_il, 0 + Psz)	; Left Margin
	NumPut(DW, T, button_il, 4 + Psz)	; Top Margin
	NumPut(DW, R, button_il, 8 + Psz)	; Right Margin
	NumPut(DW, B, button_il, 12 + Psz)	; Bottom Margin
	NumPut(DW, A, button_il, 16 + Psz)	; Alignment
	SendMessage(BCM_SETIMAGELIST := 5634, 0, button_il, , "AHK_ID " Handle)
	Return IL_Add(normal_il, File, Index)
}
;}
;}
