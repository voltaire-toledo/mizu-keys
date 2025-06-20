#Requires Autohotkey v2

/*
  ╭────────────────────────────────────────────────────────────────────╮
  │ About...Dialog Box                                                 │
  │ The dialog box the appears when you select "About FLOW Effortless" │
  ├────────────────────────────────────────────────────────────────────┤
  │                                                                    │
  ╰────────────────────────────────────────────────────────────────────╯

  TODO:
  [x] Add a link to the official documentation
  [x] Add a link to the GitHub repository
  [x] Add credit to the third-party library developers
  [x] add links to their profile and project
  [x] Credit icons8 for icons and add link to icons8
  [] Add a link to the YouTube channel that demos the features
  [] Add a link to the GitHub Sponsors page for donations
  [] Add a link to the Ko-fi page for donations
*/
ShowHelpAbout(*) {
  static aboutDlg := ""
  dlgWidth := 740
  dlgHeight := 540

  ; If dialog exists and is visible, bring it to front and return
  try {
    ; aboutDlg.Show("w" dlgWidth " h" dlgHeight)
    aboutDlg.Restore()
    return
  } catch Any {
    ; If dialog does not exist, create it
    aboutDlg := ShowAboutDialog()
    aboutDlg.Show("w" dlgWidth " h" dlgHeight)
  }

  aboutDlg.OnEvent("Escape", (*) => aboutDlg.Destroy())
  aboutDlg.OnEvent("Close", (*) => aboutDlg.Destroy())
}

ShowAboutDialog(*) {
  ; Detect the active private working memory usage of this process
  pid := DllCall("GetCurrentProcessId")
  ; Open process with query info rights
  hProcess := DllCall("OpenProcess", "UInt", 0x1000, "Int", false, "UInt", pid, "Ptr")
  if hProcess {
    PROCESS_MEMORY_COUNTERS := Buffer(40, 0)
    NumPut("UInt", 40, PROCESS_MEMORY_COUNTERS, 0) ; cb
    if DllCall("psapi\GetProcessMemoryInfo", "Ptr", hProcess, "Ptr", PROCESS_MEMORY_COUNTERS.Ptr, "UInt", 40) {
      ; For 32-bit AHK, PROCESS_MEMORY_COUNTERS.PrivateWorkingSetSize is at offset 32 (DWORD)
      ; This is
      workingSetSize := NumGet(PROCESS_MEMORY_COUNTERS, 32, "UInt")
      memMB := Round(workingSetSize / 1024 / 1024, 2)
    } else {
      memMB := "??"
    }
    DllCall("CloseHandle", "Ptr", hProcess)
  } else {
    memMB := "?"
  }

  ; Calculate Uptime
  __Uptime := A_TickCount - __StartTime
  __days := Floor(__Uptime / 86400000)
  __hours := Floor(Mod(__Uptime, 86400000) / 3600000)
  __minutes := Floor(Mod(__Uptime, 3600000) / 60000)
  __seconds := Floor(Mod(__Uptime, 60000) / 1000)
  UptimeString := __days " Days " __hours " Hrs " __minutes " Mins " __seconds " Secs"

  ; Dialog Construction
  aboutDlg := Gui()
  aboutDlg.SetFont("q5 s10", "Segoe UI")
  aboutDlg.Opt("-MinimizeBox -MaximizeBox +AlwaysOnTop")

  ; First Line with link to docs
  aboutDlg.Add("Link", "x9 y8 h23",
    "All items below are frequently used features. Visit the <a href=`"https://github.com/voltaire-toledo/mizu-keys/tree/main/docs`">Official Documentation</a> for a more comprehensive list."
  )

  ; Status Bar
  aboutDlg.Add("StatusBar", "x0 y530 w740 h30", "  Hit the [Esc] key to close this window.")

  ; Tab Control
  mainTab := aboutDlg.Add("Tab3", "x8 y40 w724 h480",
    ["About      ",
      "Hotkeys         ",
      "Hotstrings      ",
      "Arpeggios       ",
      "Higher F-Keys   ",
      "Other Options   "])

  ; Tab 1 - About
  mainTab.UseTab(1)
  ; Logo and Title, version number, and license
  aboutDlg.Add("Picture", "x16 y80 w48 h48", A_ScriptDir "\media\icons\mizu-leaf.ico")
  aboutDlg.SetFont("c3e3d32", "Segoe UI")
  aboutDlg.SetFont("Bold s20", "Segoe UI")
  aboutDlg.Add("Text", "x72 y80 w470 h50", "Mizu Keys - Productivity Shortcuts")
  aboutDlg.SetFont("q5 s10", "Segoe UI")
  aboutDlg.Add("Text", "x72 y120 w300 h23", "Version: " thisapp_version)
  aboutDlg.Add("Text", "x372 y120 w300 h23", "Private Memory Usage: " memMB " MB")
  aboutDlg.Add("Text", "x72 y140 w600 h23", "Licensed under the MIT License")
  aboutDlg.Add("Text", "x372 y140 w600 h23", "Uptime: " UptimeString)

  ; Credit Section and Links to other resources
  aboutDlg.SetFont("Bold s12", "Segoe UI")
  aboutDlg.Add("Text", "x72 y180 w600 h23", "Credits and Resources")
  aboutDlg.SetFont("c000000 Norm q5 s10", "Segoe UI")
  aboutDlg.Add("Link", "x72 y210 w600 h23",
    "AutoHotkey (version " A_AhkVersion ") is available at <a href=`"https://www.autohotkey.com`">autohotkey.com</a>")
  aboutDlg.Add("Link", "x72 y230 w600 h23", "Icons by <a href=`"https://icons8.com`">icons8.com</a>")
  aboutDlg.Add("Link", "x72 y250 w600 h23",
    "<a href=`"https://www.autohotkey.com/boards/viewtopic.php?f=83&t=94044`">WiseGUI.ahk library</a> by <a href=`"https://www.autohotkey.com/boards/memberlist.php?mode=viewprofile&u=54&sid=f3bac845536fc1eace03994a9e73273e`">SKAN</a>")
  aboutDlg.Add("Link", "x72 y270 w300 h23",
    "<a href=`"https://github.com/FuPeiJiang/VD.ahk/tree/v2_port`">VD.ahk library</a> by <a href=`"https://github.com/FuPeiJiang`">FuPeiJiang</a>")
  ; aboutDlg.Add("Link", "x72 y270 w300 h23",
  ; "<a href=`"https://github.com/Ciantic/VirtualDesktopAccessor`">VirtualDesktopAccessor</a> by <a href=`"https://github.com/Ciantic`">Ciantic</a>")

  ; Tab 2 - Hotkeys
  mainTab.UseTab(2)
  aboutDlg.SetFont("Bold s12", "Segoe UI")
  aboutDlg.Add("Text", "x16 y70 w690 h26", "Hotkeys")
  aboutDlg.SetFont("c000000 Norm q5 s10", "Segoe UI")
  aboutDlg.Add("Text", "x16 y95 w705 h23", "Hotkeys are synonymous to keyboard shortcuts. Go ahead and try them out!")
  ; aboutDlg.Add("Text", "x16 y120 w720 h23", "You can also add your own hotkeys in the script file, or use the auxiliary hotkeys feature to create custom hotkeys on the fly.")
  ; Add ListView for Hotkeys
  lv_corehkeys := aboutDlg.Add("ListView", "r14 w705", ["Action", "Hotkey", "Description"])
  lv_corehkeys.Opt("+Report +Sort")
  ; Set the column widths

  ; Example hotkeys - replace/add as needed for your project
  lv_corehkeys.Opt("-Redraw")
  lv_corehkeys.Add(, "Toggle Aux Keys", "[Ctrl] + [⊞] + [Alt] + [K] ", "Toggle the auxiliary keys on/off")
  lv_corehkeys.Add(, "Toggle Aux Hotstrings", "[Ctrl] + [⊞] + [Alt] + [S] ", "Toggle the auxiliary hotstrings on/off")
  lv_corehkeys.Add(, "Reload and Restart " thisapp_name, "[Ctrl] + [⊞] + [Alt] + [R] ", "Reload and restart " thisapp_name)
  lv_corehkeys.Add(, "AutoHotkey Help", "[Ctrl] + [⊞] + [Alt] + [F2]`t", "Open the AutoHotkey help docs")
  lv_corehkeys.Add(, thisapp_name " Help", "[Ctrl] + [⊞] + [Alt] + [F1]`t", "Display this dialog")
  lv_corehkeys.Add(, "Sleep", "[Ctrl] + [⊞] + [Alt] + [F12]`t", "Put this system to sleep")
  lv_corehkeys.Add(, "Open the user's folder", "[⊞] + [F]`t", "Open the user's directory in File Explorer")
  lv_corehkeys.Add(, "Edit this script", "[Ctrl] + [⊞] + [Alt] + [E]`t", "Open the main " thisapp_name " script in the default editor")
  lv_corehkeys.Add(, "Open the " thisapp_name " folder", "[Ctrl] + [⊞] + [Alt] + [F]`t", "Open the " thisapp_name " folder in File Explorer")
  lv_corehkeys.Add(, "Windows Terminal", "[Ctrl] + [Alt] + [T]`t", "Open or focus the Windows Terminal window")
  lv_corehkeys.Add(, "Windows Terminal (Elevated)", "[Ctrl] + [Shift] + [Alt] + [T]`t", "Open an elevated Windows Terminal instance")
  lv_corehkeys.Add(, "Open Calculator", "2 × [Right_Ctrl]`t", "Open or focus the Calculator app")
  lv_corehkeys.ModifyCol() ; Auto-size the first column
  lv_corehkeys.ModifyCol(2) ; Auto-size the second column
  lv_corehkeys.ModifyCol(3)
  lv_corehkeys.Opt("+Redraw")

  ; Tab 3 - Hotstrings
  mainTab.UseTab(3)
  aboutDlg.SetFont("Bold s12", "Segoe UI")
  aboutDlg.Add("Text", "x16 y70 w690 h30", "Hotstrings")
  aboutDlg.SetFont("c000000 Norm q5 s10", "Segoe UI")
  aboutDlg.Add("Text", "x16 y95 w705 h54", "Hotstrings are basically aliases or string replacements. Just type the hotsring followed by a trigger key (like [Space] or [Enter]) and it will be replaced with the corresponding text.")

  ; --- Radio Buttons and Dynamic ListViews ---
  ; GroupBox for visual clarity (optional)
  aboutDlg.Add("GroupBox", "x16 y135 w705 h50", "Hotstring Groups")

  ; Radio Buttons (horizontal)
  hs_rb_core := aboutDlg.Add("Radio", "x32 y155 w120 h23 vhs_rb_core", "Core")
  hs_rb_aux := aboutDlg.Add("Radio", "x172 y155 w120 h23 vhs_rb_aux", "Aux Hotstrings")
  hs_rb_custom := aboutDlg.Add("Radio", "x312 y155 w120 h23 vhs_rb_custom", "Custom")

  hs_rb_core.Value := true ; Default selection
  aboutDlg.Add("Text", "x16 y190 w705 h54 vhs_rb_text", "The Core Hotstrings are the ones that come with " thisapp_name ".")

  ; ListViews for each category (stacked, only one visible at a time)
  hs_lv_core := aboutDlg.Add("ListView", "x16 y220 w705 r10 vhs_lv_core", ["Hotstring", "Replacement", "Comments"])
  hs_lv_core.Opt("+Report +Sort")
  hs_lv_core.Opt("-Redraw")
  hs_lv_core.Add(, "A1", "B1")
  hs_lv_core.Add(, "A2", "B2")
  hs_lv_core.Add(, "A3", "B3")
  hs_lv_core.ModifyCol() ; Auto-size the first column
  hs_lv_core.ModifyCol(2) ; Auto-size the second column
  hs_lv_core.ModifyCol(3)
  hs_lv_core.Opt("+Redraw")

  hs_lv_aux := aboutDlg.Add("ListView", "x16 y220 w705 r10 vhs_lv_aux", ["Hotstring", "Replacement", "Comments"])
  hs_lv_aux.Opt("+Report +Sort")
  hs_lv_aux.Opt("-Redraw")
  hs_lv_aux.Add(, "X1", "Y1")
  hs_lv_aux.Add(, "X2", "Y2")
  hs_lv_aux.ModifyCol() ; Auto-size the first column
  hs_lv_aux.ModifyCol(2) ; Auto-size the second column
  hs_lv_aux.ModifyCol(3)
  hs_lv_aux.Opt("+Redraw")
  hs_lv_aux.Visible := false
  
  hs_lv_custom := aboutDlg.Add("ListView", "x16 y220 w705 r10 vhs_lv_custom.", ["Hotstring", "Example Replacement", "Comments"])
  hs_lv_aux.Opt("+Report +Sort")
  hs_lv_aux.Opt("-Redraw")
  hs_lv_custom.Add(, "!me", "[Your Name]")
  hs_lv_custom.Add(, "!nickname", "[Your Nickname]")
  hs_lv_custom.Add(, "!sig", "Name`{ENTER`}Email`{ENTER`}Phone#`{ENTER`}")
  hs_lv_custom.Add(, "!myphone", "[Your Phone Number]")
  hs_lv_custom.Add(, "!email", "[Your E-mail address]")
  hs_lv_custom.ModifyCol() ; Auto-size the first column
  hs_lv_custom.ModifyCol(2) ; Auto-size the second column
  hs_lv_custom.ModifyCol(3)
  hs_lv_custom.Opt("+Redraw")
  hs_lv_custom.Visible := false

  hs_lv_custom.Visible := false

  ; Handler to switch ListViews
  hs_switchListView(*) {
    hs_lv_core.Visible := hs_rb_core.Value
    hs_lv_aux.Visible := hs_rb_aux.Value
    hs_lv_custom.Visible := hs_rb_custom.Value
    if (hs_rb_core.Value)
      aboutDlg["hs_rb_text"].Value := "The Core Hotstrings are the ones that come with " thisapp_name "."
    else if (hs_rb_aux.Value)
      aboutDlg["hs_rb_text"].Value := "Aux Hotstrings include optional expansions and modifiers for advanced use."
    else if (hs_rb_custom.Value)
      aboutDlg["hs_rb_text"].Value := "Add your Custom Hotstrings at the end of the LIB\_HOTSTRINGS.MZK file. Here are some examples below:"
  }
  hs_rb_core.OnEvent("Click", hs_switchListView)
  hs_rb_aux.OnEvent("Click", hs_switchListView)
  hs_rb_custom.OnEvent("Click", hs_switchListView)

  ; Tab 4 - Arpeggios
  mainTab.UseTab(4)
  aboutDlg.SetFont("Bold s12", "Segoe UI")
  aboutDlg.Add("Text", "x16 y70 w690 h30", "Arpeggios2")
  aboutDlg.SetFont("c000000 Norm q5 s10", "Segoe UI")
  aboutDlg.Add("Text", "x16 y95 w705 h54", "Arpeggios trigger automations, but instead of using a hotkey or hotstring, an Arpeggio is made up of a sequence of keys/hotkeys. Think of it like playing musical notes: press [Caps Lock] + [O] to set the Mood, then tap [N] and  voilà — Notion launches like you meant business!")

  ; --- Radio Buttons and Dynamic ListViews ---
  ; GroupBox for visual clarity (optional)
  aboutDlg.Add("GroupBox", "x16 y160 w705 h60", "Mood")

  ; Radio Buttons (horizontal)
  a_rb_apps := aboutDlg.Add("Radio", "x32 y185 w120 h23 ", "Applications")
  a_rb_clip := aboutDlg.Add("Radio", "x172 y185 w120 h23 ", "Selected Text")
  a_rb_nav := aboutDlg.Add("Radio", "x312 y185 w120 h23 ", "Navigation")

  a_rb_apps.Value := true ; Default selection

  ; ListViews for each category (stacked, only one visible at a time)
  a_lv_apps := aboutDlg.Add("ListView", "x16 y220 w705 r10 va_lvapps", ["Arpgeggio", "Action", "Description"])
  a_lv_apps.Opt("+Report +Sort")
  a_lv_apps.Opt("-Redraw")
  a_lv_apps.Add(, "A1", "B1")
  a_lv_apps.Add(, "A2", "B2")
  a_lv_apps.Add(, "A3", "B3")
  a_lv_apps.Opt("+Redraw")

  a_lv_clip := aboutDlg.Add("ListView", "x16 y220 w705 r10 va_lv_clip", ["Arpgeggio", "Action", "Description"])
  a_lv_clip.Add(, "X1", "Y1")
  a_lv_clip.Add(, "X2", "Y2")
  a_lv_clip.Visible := false

  a_lv_nav := aboutDlg.Add("ListView", "x16 y220 w705 r10 va_lv_nav", ["Arpgeggio", "Action", "Description"])
  a_lv_nav.Add(, "F1", "B1")
  a_lv_nav.Add(, "F2", "B2")
  a_lv_nav.Visible := false

  ; Handler to switch ListViews
  a_switchListView(*) {
    a_lv_apps.Visible := a_rb_apps.Value
    a_lv_clip.Visible := a_rb_clip.Value
    a_lv_nav.Visible := a_rb_nav.Value
  }
  a_rb_apps.OnEvent("Click", a_switchListView)
  a_rb_clip.OnEvent("Click", a_switchListView)
  a_rb_nav.OnEvent("Click", a_switchListView)


  aboutDlg.Title := "Mizu Keys - About"
  return aboutDlg
}