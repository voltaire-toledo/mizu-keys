
#Requires Autohotkey v2
;AutoGUI creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;EasyAutoGUI-AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

if A_LineFile = A_ScriptFullPath && !A_IsCompiled
{
	myGui := Constructor()
	myGui.Show("w474 h536")
}

Constructor()
{	
	myGui := Gui()
	myGui.Opt("+Resize")
	ButtonOK := myGui.Add("Button", "x360 y480 w96 h40", "&OK")
	Tab := myGui.Add("Tab3", "x8 y0 w457 h472", ["About", "Credits", "Reference"])
	Tab.UseTab()
	ButtonOK.OnEvent("Click", OnEventHandler)
	myGui.OnEvent('Close', (*) => ExitApp())
	myGui.Title := "Tetrakey v1.0.0_beta (Clone)"
	
	OnEventHandler(*)
	{
		ToolTip("Click! This is a sample action.`n"
		. "Active GUI element values include:`n"  
		. "ButtonOK => " ButtonOK.Text "`n", 77, 277)
		SetTimer () => ToolTip(), -3000 ; tooltip timer
	}
	
	return myGui
}