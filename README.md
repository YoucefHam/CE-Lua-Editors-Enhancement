# CE-Lua-Editors-Enhancement

	Author:  YoucefHam
	Email:   youcefham20@gmail.com
	Discord: YoucefHam
	GitHub:  https://github.com/YoucefHam

# Lua Editors Enhancement:

	- Add Button "Lua Engine" To Ce Main Form.(Next to Memory View Button).
	- Add Shortcut "Ctrl+L" to open Lua Engine from Ce Main Form.
	- Add Checkbox "Clear" To Lua Engine, To Clear Output Before Execute.(On Top Of Execute Button)
	- Add Popup Item "Clear Output" To Lua Engine, To Clear Output.
	- Add Inside "Lua Engine" And "Lua Editor" And "Autoassemble Editor":
		Use "Ctrl + Mouse Wheel" to Zoom Font Size And Save It To Restore Later.
		Use "Auto Close Brackets" With Selected Code "str" 'txt' (code) [] {}. See "Autoclose.List"
		Use "Ctrl + Q" To Comment Code In Line  --Code.
		Use "Ctrl + W" To Comment Code In Block --[=[Code]=].
		Use "Ctrl + Shift + Q" To Uncomment (Selected) Code In Line --Code.
		Use "Ctrl + Shift + W" To Uncomment (Selected) Code In Block --[=[Code]=].
		Use "Tab Only" For Indents. (Space At The Start Of The Line)
		Use "Keep Spaces" To Stop Editor from removing spaces.
		Add Popup Item "Browse This Memory Region" To Editor Popup. (for Selected Text)
		Add Popup Item "Disassemble This Memory Region" To Editor Popup. (for Selected Text)
		Use "Auto Backup Script" to save Editor code to file:
			"OnOpen" : Save After Editor Opened.
			"OnClose" : Save Before Editor Closed.
			"OnExecute" : Save Before Editor Execute Code.
			"OnTime" : Save opened Editors Code every x amount of time.
		Add Menu Item "Selection Mode": (Some Of Them Works Without This Extension)
			"Hold Alt + Select" : Select Text In Column Mode.
			"Hold Ctrl + Shift + Click" : Type In Multiple Places.
			"Ctrl + Shift + N" : Toggle Normal Selection Mode.
			"Ctrl + Shift + C" : Toggle Column Selection Mode.
			"Ctrl + Shift + L" : Toggle Line Selection Mode.