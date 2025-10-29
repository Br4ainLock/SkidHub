Set WshShell = WScript.CreateObject("WScript.Shell")

' Open Run dialog (Win + R)
WshShell.SendKeys "^{ESC}"  ' This sends Ctrl+Esc to open Start menu, but better to use Win+R:
WshShell.SendKeys "^{ESC}"  ' Actually, VBScript can’t directly send Win key, so workaround needed.

' Instead, use this to open Run dialog:
WshShell.Run "RunDll32.exe Shell32.dll,ShellExec_RunDLL shell:::{2559a1f3-21d7-11d4-bdaf-00c04f60b9f0}"
WScript.Sleep 500

' Type 'cmd'
WshShell.SendKeys "cmd"
WScript.Sleep 200

' Press Enter
WshShell.SendKeys "{ENTER}"


WshShell.SendKeys "shutdown /l"
WScript.Sleep 200
WshShell.SendKeys "{ENTER}"