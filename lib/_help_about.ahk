#Requires Autohotkey v2

/*
  ╭────────────────────────────────────────────────────────────────────╮
  │ About...Dialog Box                                                 │
  │ The dialog box the appears when you select "About FLOW Effortless" │
  ├────────────────────────────────────────────────────────────────────┤
  │                                                                    │
  ╰────────────────────────────────────────────────────────────────────╯

  TODO:
  [] Add a link to the official documentation
  [] Add a link to the GitHub repository
  [] Add a link to the YouTube channel that demos the features
  [] Add a link to the GitHub Sponsors page for donations
  [] Add a link to the Ko-fi page for donations
  [] A link to a YouTube channel that demos
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
    if DllCall("psapi\GetProcessMemoryInfo", "Ptr", hProcess, "Ptr", PROCESS_MEMORY_COUNTERS, "UInt", 40) {
      privateUsage := NumGet(PROCESS_MEMORY_COUNTERS, 16, "UPtr") ; WorkingSetSize is Offset 16
      memMB := Round(privateUsage / 1024, 2)
    } else {
      memMB := "?"
    }
    DllCall("CloseHandle", "Ptr", hProcess)
  } else {
    memMB := "?"
  }

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
    ["About",
      "Hotkeys",
      "Text Replacements",
      "Function Keys",
      "Chords",
      "Other Options"])

  ; Tab 1 - About
  mainTab.UseTab(1)
  ; Logo and Title, version number, and license
  aboutDlg.Add("Picture", "x16 y80 w48 h48", A_ScriptDir "\media\icons\mizu-leaf.ico")
  aboutDlg.SetFont("c3e3d32", "Segoe UI")
  aboutDlg.SetFont("Bold s20", "Segoe UI")
  aboutDlg.Add("Text", "x72 y80 w470 h50", "Mizu Keys - Procutivity Shortcuts")
  aboutDlg.SetFont("q5 s10", "Segoe UI")
  aboutDlg.Add("Text", "x72 y120 w300 h23", "Version: " thisapp_version)
  aboutDlg.Add("Text", "x372 y120 w300 h23", "Memory Usage: " memMB " KB")
  aboutDlg.Add("Text", "x72 y140 w600 h23", "Licensed under the MIT License")

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
  aboutDlg.Add("Text", "x16 y70 w690 h23", "Core Hotkeys")
  aboutDlg.SetFont("c000000 Norm q5 s10", "Segoe UI")
  aboutDlg.Add("Text", "x16 y90 w720 h23", "The following hotkeys are available by default in this script. Go ahead and try them out!")
  ; aboutDlg.Add("Text", "x16 y120 w720 h23", "You can also add your own hotkeys in the script file, or use the auxiliary hotkeys feature to create custom hotkeys on the fly.")
  ; Add ListView for Hotkeys
  lv_corehkeys := aboutDlg.Add("ListView", "r14 w710", ["Action", "Hotkey", "Description"])
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

  ; mainTab.UseTab()

  ; Close Button
  ; buttonOK := aboutDlg.Add("Button", "x652 y529 w80 h23", "Close")
  ; ButtonOK := myGui.Add("Button", "x489 y373 w80 h22", "&OK")
  ; buttonOK.OnEvent("Click", (*) => aboutDlg.Hide() )
  ; aboutDlg.OnEvent('Close', (*) => aboutDlg.Hide())

  aboutDlg.Title := "Mizu Keys - About"
  return aboutDlg
}