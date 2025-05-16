#Requires AutoHotkey v2.0
^!i::
{
    rtext := GetIP("https://www.netikus.net/show_ip.html")
    sleep 500
    MsgBox(rtext, "Response from website")
}

GetIP(URL)
{
    http := ComObject("WinHttp.WinHttpRequest.5.1")
    http.Open("GET", URL, 1)
    http.Send()
    http.WaitForResponse
    return http.ResponseText
}