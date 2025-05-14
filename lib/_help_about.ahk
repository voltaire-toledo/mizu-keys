#Requires Autohotkey v2

if A_LineFile = A_ScriptFullPath && !A_IsCompiled
{
	dlgWidth := 740
	dlgHeight := 560
	aboutDlg := ShowAboutDialog()

	aboutDlg.Show("w" dlgWidth " h" dlgHeight)
}
ShowAboutDialog()
{
	; Dialog Construction	
	aboutDlg := Gui()
    aboutDlg.SetFont("q5 s10", "Segoe UI")
	aboutDlg.Opt("-MinimizeBox -MaximizeBox +AlwaysOnTop")

	; First Line with link to docs
	aboutDlg.Add("Link", "x9 y8 h23", "All items below are common examples. Visit the <a href=`"https://github.com/voltaire-toledo/mizu-keys/tree/main/docs`">Official Documentation</a> for a more comprehensive list.")

	; Tab Control
	mainTab := aboutDlg.Add("Tab3", "x8 y40 w724 h480", ["About", "Shortcuts", "Function Keys", "Text Replacements", "Chords", "Other Options"])

  ; Tab 1 - About
	mainTab.UseTab(1)
	aboutDlg.Add("Link", "x56 y51 w120 h23", "<a href=`"https://autohotkey.com`">autohotkey.com</a>")
  aboutDlg.Add("Text", "x55 y270 w120 h23", "Text")
	aboutDlg.Add("ListBox", "x55 y98 w120 h160", ["ListBox"])
	
	mainTab.UseTab(2)
	aboutDlg.Add("Text", "x54 y51 w120 h22 +0x200", "Text")
	TreeView := aboutDlg.Add("TreeView", "x51 y92 w160 h160")
	aboutDlg.Add("ListBox", "x271 y97 w120 h160", ["ListBox"])
	
	mainTab.UseTab()
    
	; Close Button
	buttonOK := aboutDlg.Add("Button", "x652 y529 w80 h23", "Close")
	; ButtonOK := myGui.Add("Button", "x489 y373 w80 h22", "&OK")
	; buttonOK.OnEvent("Click", ExitApp())
    
    aboutDlg.OnEvent('Close', (*) => ExitApp())
	aboutDlg.Title :=  "Mizu Keys - About"
	return aboutDlg
}