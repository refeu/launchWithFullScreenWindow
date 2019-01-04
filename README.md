# launchWithFullScreenWindow

Usage: launchWithFullScreenWindow [/withmenu] [/waittime \<timeInSeconds>] \<windowName> \<commandToExecute> [\<arg1>...\<argN>]
  
* /withmenu: Optionally maintains the window menu. If not set, the menu is hidden too.
* /waittime \<timeInSeconds>: Only checks the state of the windows every **timeInSeconds** seconds. If not set, the state of the windows are checked every 250ms.
* \<windowName>: The name of the window to make full-screen.
* \<commandToExecute>: The command to execute
* \<arg1>...\<argN>: The arguments to pass to the command.
  
Compile with [AutoIt](https://www.autoitscript.com).
