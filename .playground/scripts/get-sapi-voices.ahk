#Requires AutoHotkey v2.0

voice := ComObject("SAPI.SpVoice")
voices := voice.GetVoices()

for v in voices {
    voice.Voice := v
    description := v.GetDescription()
    voice.Speak("This is the voice of " description)
    MsgBox "That was " description
}
