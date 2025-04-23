
#Requires Autohotkey v2
;AutoGUI creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;EasyAutoGUI-AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

if A_LineFile = A_ScriptFullPath &! A_IsCompiled
{
	myGui := Constructor()
	myGui.Show("w620 h420")
}

Constructor()
{	
	myGui := Gui()
	myGui.OnEvent("Size", GuiSize)
	myGui.Opt("+Resize")
	myGui.Add("Text", "x8 y6 w363 h23 +0x200", "Text")
	myGui.SetFont("s15 q5", "Segoe UI")
	SB := myGui.Add("StatusBar", , "Status Bar")
	myGui.Add("Text", "x195 y160 w0 h0 +0x200", "Text")
	Tab := myGui.Add("Tab3", "x8 y40 w603 h337", ["Tab 1", "Tab 2", "Tab3"])
	Tab.UseTab(1)
	ButtonOK := myGui.Add("Button", "x445 y312 w55 h22", "&OK")
	Tab.UseTab(2)
	myGui.Add("Text", "x23 y76 w120 h23 +0x200", "Text")
	Tab.UseTab()
	ButtonOK.OnEvent("Click", OnEventHandler)
	myGui.OnEvent('Close', (*) => ExitApp())
	myGui.Title := "Window"
	GuiSize(thisGui, MinMax, A_GuiWidth, A_GuiHeight)
	    If (A_EventInfo == 1) {
	        Return
	    }
	    AutoXYWH("*", )
	
	OnEventHandler(*)
	{
		ToolTip("Click! This is a sample action.`n"
		. "Active GUI element values include:`n"  
		. "ButtonOK => " ButtonOK.Text "`n", 77, 277)
		SetTimer () => ToolTip(), -3000 ; tooltip timer
	}
	
	return myGui
}