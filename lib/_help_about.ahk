#Requires Autohotkey v2

/*
  ╭────────────────────────────────────────────────────────────────────╮
  │ About...Dialog Box                                                 │
  │ The dialog box the appears when you select "About FLOW Effortless" │
  ├────────────────────────────────────────────────────────────────────┤
  │                                                                    │
  ╰────────────────────────────────────────────────────────────────────╯

  TODO:
  [] Give credit to icons8.com for the icons
  [] Give credit for WiseGui.ahk
  [] Give credit to AutoHotkey GUI for generating this dialog box
  [] List the version number of the current release
  [] A link to a YouTube channel that demos
*/
ShowHelpAbout(*) {
    dlgWidth := 740
    dlgHeight := 540
    aboutDlg := ShowAboutDialog()

    aboutDlg.Show("w" dlgWidth " h" dlgHeight)
    aboutDlg.OnEvent("Escape", (*) => aboutDlg.Hide())
    aboutDlg.OnEvent("Close", (*) => aboutDlg.Hide())
}

ShowAboutDialog(*) {
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
    mainTab := aboutDlg.Add("Tab3", "x8 y40 w724 h480", ["About", "Hotkeys", "Function Keys", "Text Replacements",
        "Chords", "Other Options"])

    ; Tab 1 - About
    mainTab.UseTab(1)
    ; Logo and Title, version number, and license
    aboutDlg.Add("Picture", "x16 y80 w48 h48", A_ScriptDir "\media\icons\mizu-leaf.ico")
    aboutDlg.SetFont("c3e3d32", "Segoe UI")
    aboutDlg.SetFont("Bold s20", "Segoe UI")
    aboutDlg.Add("Text", "x72 y80 w470 h50", "Mizu Keys - Procutivity Shortcuts")
    aboutDlg.SetFont("q5 s10", "Segoe UI")
    aboutDlg.Add("Text", "x72 y120 w400 h23", "Version: " mizu_keys_version)
    aboutDlg.Add("Text", "x72 y140 w400 h23", "Licensed under the MIT License")

    ; Credit Section and Links to other resources
    aboutDlg.SetFont("c000000 Norm q5 s10", "Segoe UI")
    aboutDlg.Add("Link", "x72 y180 w400 h23",
        "AutoHotkey binaries and libraries are available at <a href=`"https://www.autohotkey.com`">autohotkey.com</a>")
    aboutDlg.Add("Link", "x72 y200 w400 h23", "Icons by <a href=`"https://icons8.com`">icons8.com</a>")
    aboutDlg.Add("Link", "x72 y220 w300 h23",
        "<a href=`"https://www.autohotkey.com/boards/viewtopic.php?f=83&t=94044`">WiseGUI.ahk library</a> by <a href=`"https://www.autohotkey.com/boards/memberlist.php?mode=viewprofile&u=54&sid=f3bac845536fc1eace03994a9e73273e`">SKAN</a>"
    )

    mainTab.UseTab(2)
    ; aboutDlg.SetFont("Bold", "Segoe UI")
    ; aboutDlg.Add("Text", "x54 y80 w120 h23", "Text")
    ; aboutDlg.SetFont("Norm q5 s10", "Segoe UI")
    ; Add ListView for Hotkeys
    lv := aboutDlg.Add("ListView", "r10 w600", ["Action", "Hotkey", "Description"])
    lv.Opt("+Report +Sort")
    ; Set the column widths

    ; Example hotkeys - replace/add as needed for your project

    lv.Add(, "Open Help", "[Ctrl] + [H]", "Show the help/about dialog")
    lv.Add(, "Toggle Clipboard Manager", "[Ctrl] + [Shift] + [V]", "Open clipboard manager")
    lv.Add(, "Insert Date", "Alt+D", "Insert current date at cursor")
    lv.Add(, "Expand Text", "⊞ + ", "Replace with your address")
    lv.Add(, "Launch Calculator", "Ctrl+Alt+C", "Open Windows Calculator")
    lv.Add(, "Screenshot", "PrintScreen", "Take a screenshot and copy to clipboard")
    lv.Add(, "Lock Workstation", "Win+L", "Lock the computer")
    lv.Add(, "Mute Volume", "Ctrl+Alt+M", "Mute/unmute system volume")
    lv.Add(, "Open Settings", "Ctrl+Alt+S", "Open Mizu Keys settings window")
    lv.ModifyCol() ; Auto-size the first column
    lv.ModifyCol(2) ; Auto-size the second column
    lv.ModifyCol(3)

    ; mainTab.UseTab()

    ; Close Button
    ; buttonOK := aboutDlg.Add("Button", "x652 y529 w80 h23", "Close")
    ; ButtonOK := myGui.Add("Button", "x489 y373 w80 h22", "&OK")
    ; buttonOK.OnEvent("Click", (*) => aboutDlg.Hide() )
    ; aboutDlg.OnEvent('Close', (*) => aboutDlg.Hide())

    aboutDlg.Title := "Mizu Keys - About"
    return aboutDlg
}
