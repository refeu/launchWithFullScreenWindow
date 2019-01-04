#include <WinAPIProc.au3>
#include <WinAPIShPath.au3>
#include <WinAPISys.au3>
#include <WinAPISysWin.au3>
#include <WindowsConstants.au3>

Global $newStyle = BitOR($WS_CHILD, $WS_VISIBLE)
Global $waitTime = 250
Global $cmdLineIdx = 1

While ($cmdLineIdx <= $CmdLine[0]) And (StringMid($CmdLine[$cmdLineIdx], 1, 1) = "/")
	if $CmdLine[$cmdLineIdx] = "/withmenu" Then
		$newStyle = BitOR($WS_POPUP, $WS_VISIBLE)
		$cmdLineIdx += 1
	ElseIf $CmdLine[$cmdLineIdx] = "/waittime" Then
		$waitTime = Int($CmdLine[$cmdLineIdx + 1])
		$cmdLineIdx += 2
	Else
		ExitWithWrongParameters()
	EndIf
WEnd

If $cmdLineIdx >= $CmdLine[0] Then
	ExitWithWrongParameters()
EndIf

Global $windowName = $CmdLine[$cmdLineIdx]
$cmdLineIdx += 1
Global $strToRun = ""

While $cmdLineIdx <= $CmdLine[0]
	If (StringInStr($CmdLine[$cmdLineIdx], " ") <> 0) And (StringMid($CmdLine[$cmdLineIdx], 1, 1) <> '"') Then
		$strToRun &= '"' & $CmdLine[$cmdLineIdx] & '" '
	Else
		$strToRun &= $CmdLine[$cmdLineIdx] & " "
	EndIf

	$cmdLineIdx += 1
WEnd

global $process = Run($strToRun, "")

if $process = 0 then
	ExitWithError('Cannot run "' & $strToRun & '".')
endif

AdlibRegister("ResetFull", $waitTime)
ProcessWaitClose($process)

Func SetFullScreen($windowHandle)
	if _WinAPI_GetWindowLong($windowHandle, $GWL_STYLE) = $newStyle Then
		Return
	EndIf

	_WinAPI_SetWindowLong($windowHandle, $GWL_STYLE, $newStyle)
	_WinAPI_SetWindowLong($windowHandle, $GWL_EXSTYLE, BitOR(_WinAPI_GetWindowLong($windowHandle, $GWL_EXSTYLE), $WS_EX_TOPMOST))
	Local $screenSizeX = _WinAPI_GetSystemMetrics($SM_CXSCREEN)
	Local $screenSizeY = _WinAPI_GetSystemMetrics($SM_CYSCREEN)
	WinMove($windowHandle, "", 0, 0, $screenSizeX, $screenSizeY)
EndFunc

Func ExitWithWrongParameters()
	ExitWithError("Error parsing the parameters. Usage " & _WinAPI_PathRemoveExtension(@ScriptName) & " [/withmenu] [/waittime] <windowName> <commandToExecute> [<arg1>...<argN>]")
EndFunc

Func ExitWithError($message)
	MsgBox($MB_ICONERROR, "Error", $message)
	Exit -1
EndFunc

Func ResetFull()
	Local $window = WinActive($windowName)

	If $window = 0 Then
		Return
	EndIf

	Local $windowProcess = WinGetProcess($window)

	if ($windowProcess <> $process) And (_WinAPI_GetParentProcess($windowProcess) <> $process) Then
		Return
	EndIf

	if _WinAPI_GetWindowLong($window, $GWL_STYLE) <> $newStyle Then
		Return
	EndIf

	_WinAPI_SetWindowLong($window, $GWL_STYLE, $newStyle)
	_WinAPI_SetWindowLong($window, $GWL_EXSTYLE, BitOR(_WinAPI_GetWindowLong($window, $GWL_EXSTYLE), $WS_EX_TOPMOST))
	Local $screenSizeX = _WinAPI_GetSystemMetrics($SM_CXSCREEN)
	Local $screenSizeY = _WinAPI_GetSystemMetrics($SM_CYSCREEN)
	WinMove($window, "", 0, 0, $screenSizeX, $screenSizeY)
EndFunc