--[====[
	Author:  YoucefHam
	Email:   youcefham20@gmail.com
	Discord: YoucefHam
	GitHub:  https://github.com/YoucefHam

	Lua Editors Enhancement:

	- Add Lua Engine Button To Ce Main Form With Shortcut Ctrl+L
	- Add Checkbox To Lua Engine, To Clear Output Befor Execute.(On Top Of Execute Button)
	- Add Clear Popup Item To Lua Engine, To Clear Output Befor Execute.
	- Inside "Lua Engine" And "Lua Editor" And "Autoassemble Editor"
		Ctrl + Mouse Wheel : Zoom Font Size And Save It To Restore Later.
		Auto Close Brackets With Selected Code "" '' () [] {}. See "Autoclose.List"
		Ctrl+Q To Comment (Selected) Code In Lua (Block) --[=[Code]=].
		Ctrl+Shift+Q To Uncomment (Selected) Code In Lua (Block).
		Make Indents Use Tabs Only. (Space At The Start Of The Line)
		Keep Spaces At End Of The Lines.
		Backup Script On Open Or Close Or Execute, Or On Timer
		Add Menu "Browse This Memory Region" To Lua Editor Popup
		Add Menu "Disassemble This Memory Region" To Lua Editor Popup
		Selection Mode: (Some Of Them Works Without This Extension)
			* Hold Alt And Select : Select Text In Column Mode.
			* Hold Ctrl + Shift + Click : Type In Multiple Places.
			* Ctrl + Shift + N : Toggle Normal Selection Mode.
			* Ctrl + Shift + C : Toggle Column Selection Mode.
			* Ctrl + Shift + L : Toggle Line Selection Mode.


	MIT License

	Copyright (c) 2023 YoucefHam

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
]====] --
-- TODO List
-- ;
local Disable_Extension = false
if Disable_Extension then
	return
end

local ExtensionName = 'Lua Editors Enhancement'

-- ! Main
local this = {}

-- ! ########################
-- ? ENABLE/DISABLE FEATURES
-- ! ########################
this.Features = {
	-- ? ADD LUA ENGINE BUTTON TO CE MAIN FORM WITH SHORTCUT CTRL + L.
	AddLuaEngineButton = {
		Name = 'AddLuaEngineButton',
		Enabled = true
	},
	-- ? AUTO CLOSE BRACKETS WITH SELECTED CODE "" '' () [] {}.
	AutoClose = {
		Name = 'AutoClose',
		Enabled = true,
		Title = '&Auto Close Brackets'
	},
	-- ? COMMENT / UNCOMMENT CTRL + (SHIFT) + Q.
	Comments = {
		Name = 'Comments',
		Enabled = true,
		Title = '&Ctrl+(Shift)+Q to (Un)/Comments'
	},
	-- ? MAKE INDENTS USE TABS ONLY.
	TabIndent = {
		Name = 'TabIndent',
		Enabled = true,
		Title = '&Tab for Indent'
	},
	-- ? CTRL + MOUSE WHEEL : ZOOM FONT SIZE AND SAVE IT TO RESTORE LATER.
	Zoom = {
		Name = 'Zoom',
		Enabled = true,
		Title = '&Zoom With Mouse Wheel'
	},
	-- ? KEEP SPACES AT END OF THE LINES
	KeepSpace = {
		Name = 'KeepSpace',
		Enabled = true,
		Title = '&Keep Spaces at EOL'
	},
	-- ? AUTO BACKUP OPENED SCRIPT
	AutoBackup = {
		Name = 'AutoBackup',
		Enabled = true,
		Title = '&Auto Backup'
	}
}

-- ! #################################
-- ? Save/Restore Enhancement Settings
-- ! #################################
this.Settings = getSettings( ExtensionName )

-- ! SAVE ENHANCEMENT SETTINGS
this.setSettings = function( Name, value )
	if value == true then
		this.Settings.Value[Name] = tostring( true )
	elseif value == false then
		this.Settings.Value[Name] = tostring( false )
	elseif value ~= '' and value ~= nil then
		this.Settings.Value[Name] = tostring( value )
	end
	return value
end

-- ! GET SAVED ENHANCEMENT SETTINGS
this.getSettings = function( Name )
	if this.Settings.Value[Name]:match( '(false)' ) ~= nil then
		return false
	elseif this.Settings.Value[Name]:match( '(true)' ) ~= nil then
		return true
	elseif this.Settings.Value[Name] ~= '' then
		return this.Settings.Value[Name]
	else
		return this.setSettings( Name, true )
	end
end

-- ! PREP SETTINGS FOR FIRST TIME RUN
this.setSettings( this.Features.AddLuaEngineButton.Name, this.Features.AddLuaEngineButton.Enabled )
for _Feature, _ in pairs( this.Features ) do
	if this.Features[_Feature].Enabled == true then
		if this.getSettings( this.Features[_Feature].Name ) == '' then
			this.setSettings( this.Features[_Feature].Name, true )
		end
		this.Features[_Feature].Enabled = this.getSettings( this.Features[_Feature].Name )
	elseif this.Features[_Feature].Enabled == false then
		this.setSettings( this.Features[_Feature].Name, false )
	end
end

-- ! ##########################
-- ? RUN A FUNCTION AFTER DELAY
-- ! ##########################
this.runTimer = function( func, delay )
	local timer = createTimer( nil, false );
	timer.Interval = delay
	function timer.OnTimer()
		timer.destroy()
		timer = nil
		local s, e = pcall( func )
		if s == false then
			print( ('%s'):format( e ) )
			return error( e, 2 )
		end
	end

	timer.Enabled = true
end

-- ! #####################
-- ? FUNCTION TO ADD MENUS
-- ! #####################
this.addMenuItem = function( MenuItem, Caption, Name, onClick, RadioItem, Checked, Image )
	if not MenuItem then
		return error( 'MAIN MENU EMPTY !!!' )
	end
	local newMenuItem = createMenuItem( MenuItem )
	newMenuItem.Caption = Caption or 'Menu'
	newMenuItem.Name = Name or ''
	newMenuItem.OnClick = onClick or nil
	newMenuItem.Checked = Checked or false
	newMenuItem.RadioItem = RadioItem or false
	newMenuItem.ImageIndex = Image or -1
	MenuItem.add( newMenuItem )
	return newMenuItem
end

-- ! ##########################
-- ? CREATE MENU ITEMS PICTURES
-- ! ##########################
-- ! CONSTRUCT PICTURES
this.Pictures = {
	data = {
		-- ! PICTURE FOR ENABLED
		ON = '42 4D F6 00 00 00 00 00 00 00 76 00 00 00 28 00 00 00 10 00 00 00 10 00 00 00 01 00 04 00 00 00 00 00 80 00 00 00 C3 0E 00 00 C3 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 80 00 00 80 00 00 00 80 80 00 80 00 00 00 80 00 80 00 80 80 00 00 80 80 80 00 C0 C0 C0 00 00 00 FF 00 00 FF 00 00 00 FF FF 00 FF 00 00 00 FF 00 FF 00 FF FF 00 00 FF FF FF 00 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 87 77 77 77 77 78 FF FF 70 00 00 00 00 07 FF FF 70 00 0A 00 00 07 FF FF 70 0F AA AF F0 07 FF FF 70 0A AA A7 F0 07 FF FF 70 AA AA AA 80 07 FF FF 7A AA 7F AA A0 07 FF FF 70 A8 FF FA AA 07 FF FF 70 0F FF F8 AA A7 FF FF 70 00 00 00 AA AA FF FF 70 00 00 00 0A AA 7F FF 87 77 77 77 77 AA A8 FF FF FF FF FF FF FA AA FF FF FF FF FF FF F8 7F',
		-- ! PICTURE FOR DISABLED
		OFF = '42 4D F6 00 00 00 00 00 00 00 76 00 00 00 28 00 00 00 10 00 00 00 10 00 00 00 01 00 04 00 00 00 00 00 80 00 00 00 C3 0E 00 00 C3 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 80 00 00 80 00 00 00 80 80 00 80 00 00 00 80 00 80 00 80 80 00 00 80 80 80 00 C0 C0 C0 00 00 00 FF 00 00 FF 00 00 00 FF FF 00 FF 00 00 00 FF 00 FF 00 FF FF 00 00 FF FF FF 00 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 87 77 77 77 77 78 FF FF 70 00 00 00 00 07 FF FF 70 00 00 00 00 07 FF FF 70 0F FF FF F0 07 FF FF 70 0F FF FF F0 07 FF FF 70 0F FF FF F0 07 FF FF 70 0F FF FF F0 07 FF FF 70 0F FF FF F0 07 FF FF 70 0F FF FF F0 07 FF FF 70 00 00 00 00 07 FF FF 70 00 00 00 00 07 FF FF 87 77 77 77 77 78 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF',
		-- ! PICTURE FOR SETTINGS
		SETTING = '42 4D 36 03 00 00 00 00 00 00 36 00 00 00 28 00 00 00 10 00 00 00 10 00 00 00 01 00 18 00 00 00 00 00 00 03 00 00 9C 10 00 00 9C 10 00 00 00 00 00 00 00 00 00 00 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF F4 CA AF DF B1 92 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FC FC FC 8F 8F 8F FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FE E4 D5 E8 76 2B D9 52 00 B8 69 35 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF BC BC BC 61 61 61 9B 9B 9B FF FF FF FF FF FF FF FF FF FF FF FF F7 D2 B8 FB A6 6E EC 8A 4A DD 5A 01 B7 68 32 FF FF FF FF FF FF FF FF FF DC DC DC 97 97 97 C8 C8 C8 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF E8 9A 66 FC AC 76 EC 8A 4A DD 5A 01 B7 69 34 FF FF FF D0 D1 D1 B2 B2 B2 EB EB EB FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF E9 9A 66 FC AC 76 EC 8A 4A DE 5B 02 AF 62 2D B8 C7 D1 E1 E1 E1 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF E9 9A 66 FE AD 78 EC 8A 4A DF 5B 03 B6 68 34 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF DA 8C 58 FF AF 79 EC 8A 4A E4 5C 00 BF 6A 32 C6 CD D2 BC BC BC FE FE FE FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 93 93 CB 83 83 C5 C2 D1 CC E2 94 60 FF AF 76 B5 6F 3F 86 8E 93 CA CA CB CA CA CA 7C 7C 7C C2 C2 C2 FF FF FF FF FF FF FF FF FF FF FF FF 41 41 A0 00 00 91 00 00 BB 9E 9E E6 FF FF FF EC 9E 69 84 8E 94 FF FF FF FE FF FF F9 F9 F9 FB FB FB 83 83 83 EF EF EF FF FF FF FF FF FF 43 43 A1 00 00 96 00 00 C0 0D 0D E2 DC DC FF FF FF FF C2 C9 CE CA C9 CA FF FF FF FC FC FC 99 99 99 75 75 75 D4 D4 D4 A9 A9 A9 FF FF FF 41 41 A0 00 00 96 00 00 C0 11 11 E2 BB BB FF FF FF FF FF FF FF BC BC BC CA CA CA F8 F8 F8 99 99 99 EA EA EA FF FF FF 56 56 56 ED ED ED 9C 9C CE 00 00 92 00 00 C0 11 11 E2 BB BB FF FF FF FF FF FF FF FF FF FF FD FD FD 7C 7C 7C FB FB FB 76 76 76 FF FF FF FF FF FF FF FF FF FF FF FF A5 A5 DE 00 00 B7 0D 0D E2 BB BB FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF C1 C1 C1 84 84 84 D5 D5 D5 56 56 56 FF FF FF FF FF FF FF FF FF FF FF FF AD AD F4 DC DC FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF EA EA EA 9E 9E 9E E9 E9 E9 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF'
	},
	Create = function( picture_data )
		local _stream = createStringStream()
		for x in picture_data:gmatch( '(%x%x)%s-' ) do
			_stream.writeByte( ('%d'):format( '0x' .. x ) )
		end
		_stream.Position = 0
		local _bmp = createBitmap()
		_bmp.loadFromStream( _stream )
		_bmp.Transparent = true
		_bmp.TransparentColor = 0xFFFFFF
		return _bmp
	end
}
for _Pic, _Data in pairs( this.Pictures.data ) do
	this.Pictures[_Pic] = this.Pictures.Create( _Data )
end

-- ! ###########################################################
-- ? ADD "AUTO CLOSE BRACKETS" AND "COMMENT / UNCOMMENT" TO EDITOR
-- ! ###########################################################
this.EditorOnKeyPress = function( LuaEditor )

	-- ! ###############################
	-- ? FUNCTION TO COMMENT / UNCOMMENT
	-- ! ###############################
	this.Comment = function( LuaEditor )

		local EmptyText = LuaEditor.SelText == ''
		local SelStart = math.min( LuaEditor.SelStart, LuaEditor.SelEnd )
		local SelEnd = math.max( LuaEditor.SelStart, LuaEditor.SelEnd )

		if isKeyPressed( VK_SHIFT ) then -- ! VK_Q & VK_CONTROL & VK_SHIFT to Uncomment
			if EmptyText then
				LuaEditor.SelectionMode = 'smNormal'
				LuaEditor.SelStart = SelStart
				LuaEditor.SelectionMode = 'smLine'
				LuaEditor.SelEnd = SelEnd + 2
				if LuaEditor.SelText:match( '%-%-%[(=*)%[' ) == nil then
					if LuaEditor.SelText:match( '%s*%-%-(.*)$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^%s*(%-%-)', '', 1 )
						LuaEditor.SelStart = SelStart - 2
						return
					end
					LuaEditor.SelStart = SelStart
					return
				end
				local commentEq = (LuaEditor.SelText:match( '%-%-%[(=*)%[' ) or '')
				if (LuaEditor.SelText:match( '%]' .. commentEq .. '%]' ) == nil) then
					LuaEditor.SelStart = SelStart
					return showMessage( 'Select All The Comment Block !!!' )
				end
			else
				LuaEditor.SelectionMode = 'smNormal'
				LuaEditor.SelStart = SelStart
				LuaEditor.SelEnd = SelStart
				LuaEditor.SelectionMode = 'smLine'
				LuaEditor.SelEnd = SelEnd
				local commentEq = (LuaEditor.SelText:match( '%-%-%[(=*)%[' ) or '')
				if not (commentEq == '') then
					if (LuaEditor.SelText:match( '%]' .. commentEq .. '%]' ) == nil) then
						return showMessage( 'Select All The Comment Block !!!' )
					end
					LuaEditor.SelText = LuaEditor.SelText:gsub( '%-%-%[' .. commentEq .. '%[(.*)%]' .. commentEq .. '%]%-*', '%1' )
					return
				end
				LuaEditor.SelStart = SelStart
				LuaEditor.SelEnd = SelEnd
			end
		else -- ! VK_Q & VK_CONTROL to Comment
			local LineBreak = LuaEditor.Lines.LineBreak -- ! '\r\n'
			if EmptyText then
				LuaEditor.SelectionMode = 'smNormal'
				LuaEditor.SelStart = SelStart
				LuaEditor.SelectionMode = 'smLine'
				LuaEditor.SelEnd = SelEnd + 2
				local _, LineBreak_Count = LuaEditor.SelText:gsub( '(' .. LineBreak .. ')', '%1' )
				if LineBreak_Count == 0 then
					LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.-)$', '--%1' )
				elseif LineBreak_Count == 1 then
					if LuaEditor.SelText:match( '^.+' .. LineBreak .. '.+$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.+)(' .. LineBreak .. ')(.+)$', '--%1%2%3' )
						LuaEditor.SelStart = SelStart + 4
					elseif LuaEditor.SelText:match( '^.+' .. LineBreak .. '.-$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.+)(' .. LineBreak .. ')(.-)$', '--%1%2%3' )
					elseif LuaEditor.SelText:match( '^' .. LineBreak .. '.+$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(' .. LineBreak .. ')(.+)$', '--%1%2' )
						LuaEditor.SelStart = SelStart + 4
					end
				elseif LineBreak_Count == 2 then
					if LuaEditor.SelText:match( '^.+' .. LineBreak .. '.+' .. LineBreak .. '$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.+' .. LineBreak .. ')(.+' .. LineBreak .. ')$', '--%1%2' )

					elseif LuaEditor.SelText:match( '^.+' .. LineBreak .. '.-' .. LineBreak .. '$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.+' .. LineBreak .. ')(.-' .. LineBreak .. ')$', '--%1%2' )

					elseif LuaEditor.SelText:match( '^' .. LineBreak .. '.+' .. LineBreak .. '$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.-' .. LineBreak .. ')(.+' .. LineBreak .. ')$', '--%1%2' )

					elseif LuaEditor.SelText:match( '^' .. LineBreak .. '.-' .. LineBreak .. '$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.-' .. LineBreak .. ')(.-' .. LineBreak .. ')$', '--%1%2' )

					end
					LuaEditor.SelStart = SelStart + 4
				end
			else
				LuaEditor.SelectionMode = 'smNormal'
				LuaEditor.SelStart = SelStart
				LuaEditor.SelEnd = SelStart
				LuaEditor.SelectionMode = 'smLine'
				LuaEditor.SelEnd = SelEnd
				local _, LineBreak_Count = LuaEditor.SelText:gsub( '(' .. LineBreak .. ')', '%1' )
				local commentEq = (LuaEditor.SelText:match( '%-%-%[(=*)%[' ) or '')
				if not (commentEq == '') then
					if (LuaEditor.SelText:match( '%]' .. commentEq .. '%]' ) == nil) then
						return showMessage( 'Unfinished comment block detected in the Selection !!!' )
					end
				end
				commentEq = '=' .. commentEq
				if LineBreak_Count == 0 then
					LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.-)$', '--[' .. commentEq .. '[%1]' .. commentEq .. ']' )
				elseif LineBreak_Count == 1 then
					if LuaEditor.SelText:match( '^.+' .. LineBreak .. '$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.+)(' .. LineBreak .. ')$', '--[' .. commentEq .. '[%1]' .. commentEq .. ']%2' )

					elseif LuaEditor.SelText:match( '^.+' .. LineBreak .. '.+$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.+' .. LineBreak .. ')(.+)$', '--[' .. commentEq .. '[%1%2]' .. commentEq .. ']' )

					elseif LuaEditor.SelText:match( '^.+' .. LineBreak .. '.-$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.+' .. LineBreak .. ')(.-)$', '--[' .. commentEq .. '[%1%2]' .. commentEq .. ']' )

					elseif LuaEditor.SelText:match( '^.-' .. LineBreak .. '.+$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.-' .. LineBreak .. ')(.+)$', '--[' .. commentEq .. '[%1%2]' .. commentEq .. ']' )
					end
				elseif LineBreak_Count == 2 then
					if LuaEditor.SelText:match( '^.+' .. LineBreak .. '.+' .. LineBreak .. '.+$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.+' .. LineBreak .. ')(.+' .. LineBreak .. ')(.+)$', '--[' .. commentEq .. '[%1%2%3]' .. commentEq .. ']' )

					elseif LuaEditor.SelText:match( '^.+' .. LineBreak .. '.-' .. LineBreak .. '.+$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.+' .. LineBreak .. ')(.-' .. LineBreak .. ')(.+)$', '--[' .. commentEq .. '[%1%2%3]' .. commentEq .. ']' )

					elseif LuaEditor.SelText:match( '^.-' .. LineBreak .. '.+' .. LineBreak .. '.+$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.-' .. LineBreak .. ')(.+' .. LineBreak .. ')(.+)$', '--[' .. commentEq .. '[%1%2%3]' .. commentEq .. ']' )

					elseif LuaEditor.SelText:match( '^.-' .. LineBreak .. '.-' .. LineBreak .. '.+$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.-' .. LineBreak .. ')(.-' .. LineBreak .. ')(.+)$', '--[' .. commentEq .. '[%1%2%3]' .. commentEq .. ']' )

					elseif LuaEditor.SelText:match( '^.+' .. LineBreak .. '.+' .. LineBreak .. '$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.+' .. LineBreak .. ')(.+)(' .. LineBreak .. ')$', '--[' .. commentEq .. '[%1%2]' .. commentEq .. ']%3' )

					elseif LuaEditor.SelText:match( '^.+' .. LineBreak .. '.-' .. LineBreak .. '$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.+' .. LineBreak .. ')(.-)(' .. LineBreak .. ')$', '--[' .. commentEq .. '[%1%2]' .. commentEq .. ']%3' )

					elseif LuaEditor.SelText:match( '^.-' .. LineBreak .. '.+' .. LineBreak .. '$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.-' .. LineBreak .. ')(.+)(' .. LineBreak .. ')$', '--[' .. commentEq .. '[%1%2]' .. commentEq .. ']%3' )

					elseif LuaEditor.SelText:match( '^.-' .. LineBreak .. '.-' .. LineBreak .. '$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.-' .. LineBreak .. ')(.-)(' .. LineBreak .. ')$', '--[' .. commentEq .. '[%1%2]' .. commentEq .. ']%3' )

					end
				elseif LineBreak_Count >= 3 then
					if LuaEditor.SelText:match( LineBreak .. '$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.+)(' .. LineBreak .. ')$', '--[' .. commentEq .. '[%1]' .. commentEq .. ']%2' )

					elseif LuaEditor.SelText:match( LineBreak .. '.+$' ) then
						LuaEditor.SelText = LuaEditor.SelText:gsub( '^(.+)$', '--[' .. commentEq .. '[%1]' .. commentEq .. ']' )

					end
				end
			end
		end
	end

	-- ! ###############################
	-- ? FUNCTION TO AUTO CLOSE BRACKETS
	-- ! ###############################
	-- ? AUTO CLOSE BRACKETS LIST (Select: is to restore selection after auto close brackets)
	this.AutoClose = {
		List = {
			{
				key = '()',
				Select = false
			},
			{
				key = '[]',
				Select = true
			},
			{
				key = '{}',
				Select = false
			},
			{
				key = '""',
				Select = false
			},
			{
				key = "''",
				Select = false
			}
		}
	}

	-- ? AUTO CLOSE BRACKETS PATTERN
	this.AutoClose.Pattern = '^['
	for _, v in pairs( this.AutoClose.List ) do
		this.AutoClose.Pattern = this.AutoClose.Pattern .. v.key:match( '^.' )
	end
	this.AutoClose.Pattern = this.AutoClose.Pattern .. ']'

	-- ? AUTO CLOSE BRACKETS FUNCTION
	this.AutoClose.Do = function( LuaEditor, key )
		local AutoCloseKey = {}
		for _, _Key in pairs( this.AutoClose.List ) do
			if tostring( key ) == _Key.key:match( '^.' ) then
				AutoCloseKey = _Key
				break
			end
		end
		local SelStart = LuaEditor.SelStart
		local SelEnd = LuaEditor.SelEnd
		LuaEditor.SelText = (AutoCloseKey.key:match( '^.' ) .. '%s' .. AutoCloseKey.key:match( '.$' )):format( LuaEditor.SelText )
		LuaEditor.SelStart = SelStart + 1
		if AutoCloseKey.Select then -- restore the selection
			LuaEditor.SelEnd = SelEnd + 1
		else
			LuaEditor.SelStart = SelEnd + 1
		end
	end

	-- ? FUNCTION FOR "AUTO CLOSE BRACKETS" AND "COMMENT / UNCOMMENT"
	local old_OnKeyPress = LuaEditor.OnKeyPress
	LuaEditor.OnKeyPress = function( sender, key )
		if key == '' and this.getSettings( this.Features.Comments.Name ) then -- ! VK_CONTROL & VK_Q
			this.Comment( LuaEditor )
		elseif tostring( key ):match( this.AutoClose.Pattern ) and this.getSettings( this.Features.AutoClose.Name ) then
			this.AutoClose.Do( LuaEditor, key )
		elseif old_OnKeyPress then
			return old_OnKeyPress( sender, key )
		else
			return key
		end
	end
end

-- ! ##########################
-- ? FUNCTION TO ZOOM FONT SIZE
-- ! ##########################
this.Font = {
	-- ! SAVE FONT SIZE
	Save = function( LuaEditor, Settings )
		Settings.Value[(LuaEditor.owner.Name:match( 'frmAutoInject' ) and '' or LuaEditor.Name .. '.') .. 'Font.size'] = LuaEditor.Font.Size
	end,
	-- ! LOAD FONT SIZE
	Load = function( LuaEditor, Settings )
		LuaEditor.Font.Size = Settings.Value[(LuaEditor.owner.Name:match( 'frmAutoInject' ) and '' or LuaEditor.Name .. '.') .. 'Font.size']
	end
}
-- ! ADD ZOOM FUNCTION TO EDITOR
this.Font.addZoom = function( LuaEditor, Settings )
	-- ? INCREASE FONT SIZE
	local old_OnMouseWheelUp = LuaEditor.OnMouseWheelUp
	LuaEditor.OnMouseWheelUp = function( sender, x, y )
		if this.getSettings( this.Features.Zoom.Name ) then
			if isKeyPressed( VK_CONTROL ) then
				if sender.Font.Size < 50 then
					sender.Font.Size = sender.Font.Size + 1
					this.Font.Save( LuaEditor, Settings )
				end
			end
		end
		if old_OnMouseWheelUp then
			return old_OnMouseWheelUp( sender, x, y )
		end
	end

	-- ? DECREASE FONT SIZE
	local old_OnMouseWheelDown = LuaEditor.OnMouseWheelDown
	LuaEditor.OnMouseWheelDown = function( sender, x, y )
		if this.getSettings( this.Features.Zoom.Name ) then
			if isKeyPressed( VK_CONTROL ) then
				if sender.Font.Size > 1 then
					sender.Font.Size = sender.Font.Size - 1
					this.Font.Save( LuaEditor, Settings )
				end
			end
		end
		if old_OnMouseWheelDown then
			return old_OnMouseWheelDown( sender, x, y )
		end
	end
end

-- ! ##########################
-- ? FUNCTION TO USE TAB INDENT
-- ! ##########################
this.TabIndent = function( LuaEditor )
	if this.getSettings( this.Features.TabIndent.Name ) then
		LuaEditor.TabWidth = 4
		LuaEditor.BlockTabIndent = 1
		LuaEditor.BlockIndent = 0
		LuaEditor.Beautifier.IndentType = 'sbitConvertToTabOnly'
		LuaEditor.Options = LuaEditor.Options:gsub( 'eoSmartTabs', '' ):gsub( 'eoTabsToSpaces', '' ):gsub( ',,', ',' )
	else
		LuaEditor.TabWidth = 8
		LuaEditor.BlockTabIndent = 0
		LuaEditor.BlockIndent = 2
		LuaEditor.Beautifier.IndentType = 'sbitSpace'
		LuaEditor.Options = '[' .. LuaEditor.Options:match( '%[(.*)%]' ) .. ',eoSmartTabs,eoTabsToSpaces]'
	end
end

-- ! #############################################
-- ? FUNCTION TO KEEP SPACE AT THE END OF THE LINE
-- ! #############################################
this.KeepSpace = function( LuaEditor )
	if this.getSettings( this.Features.KeepSpace.Name ) then
		LuaEditor.Options = LuaEditor.Options:gsub( 'eoTrimTrailingSpaces', '' ):gsub( ',,', ',' )
	else
		LuaEditor.Options = '[' .. LuaEditor.Options:match( '%[(.*)%]' ) .. ',eoTrimTrailingSpaces]'
	end
end

-- ! #############################
-- ? FUNCTION TO ADD EXTRA OPTIONS
-- ! #############################
this.EditorOptions = function( LuaEditor )
	-- ? HIGHLIGHT GROUPS WITH RED BOX BRACKETS AND BLOCKS
	LuaEditor.BracketMatchColor.FrameColor = clRed

	-- ? ADD THESE OPTIONS TO LUA EDITOR
	-- * eoScrollPastEof : scroll more at the end of the last line
	-- * eoEnhanceHomeKey : make Home button stop at the indent
	-- * eoAltSetsColumnMode : Only for compatibility, moved to TSynEditorMouseOptions, keep in one block, Allows to activate "column" selection mode, if <Alt> key is pressed and text is being selected with mouse
	-- * eoDragDropEditing : Allows to drag-and-drop text blocks within the control
	LuaEditor.Options = '[' .. LuaEditor.Options:match( '%[(.*)%]' ) .. ',eoScrollPastEof,eoEnhanceHomeKey,eoAltSetsColumnMode,eoBracketHighlight,eoDragDropEditing]'
end

-- ! #####################
-- ? CHANGE SELECTION MODE
-- ! #####################
-- ? WITH KEY SHORTCUTS CTRL+SHIFT+ (N: FOR NORMAL | C: FOR COLUMN | L: FOR LINE)
this.SelectionMode = function( SelectionMode )
	local SelectionMode = SelectionMode or VK_N
	keyDown( VK_CONTROL )
	keyDown( VK_SHIFT )
	doKeyPress( SelectionMode ) -- VK_C=67 VK_N=78 VK_L=76
	keyUp( VK_SHIFT )
	keyUp( VK_CONTROL )
end

-- ! ##################
-- ? AUTO BACKUP SCRIPT
-- ! ##################
this.AutoBackup = {
	form = [[local a=createForm(getForm(0))a.Name='AutoBackupForm'a.Caption='Script Auto Backup Settings:'a.AutoSize=true;a.Constraints.MinWidth=675;
	a.Constraints.MinHeight=280;a.Width=675;a.BorderStyle=bsSizeable;a.BorderIcons='[biSystemMenu]'a.FormStyle='fsSystemStayOnTop'a.ShowInTaskBar='stAlways'
	a.Position='poDesktopCenter'a.Scaled=false;a.DoNotSaveInTable=true;a.UseDockManager=false;a.HorzScrollBar.Visible=false;a.VertScrollBar.Visible=false;
	local b=createGroupBox(a)b.Caption='Auto backup directory :'b.Name='gbDir'b.Align=alTop;b.AutoSize=true;b.BorderSpacing.Around=10;local c=createEdit(b)
	c.Name='eDir'c.Text=''c.AutoSize=false;c.Align=alClient;c.BorderSpacing.Around=5;c.Constraints.MinHeight=30;c.Constraints.MaxHeight=30;local d=createButton(b)
	d.Name='bBrows'd.Caption='BROWS'd.AutoSize=false;d.Align=alRight;d.BorderSpacing.Around=5;d.Constraints.MinHeight=30;d.Constraints.MaxHeight=30;
	d.Constraints.MaxWidth=120;d.Constraints.MinWidth=120;local e=createSelectDirectoryDialog(a)e.Name='cSelectDir'
	e.Options='[ofHideReadOnly,ofPathMustExist,ofEnableSizing,ofDontAddToRecent,ofViewDetail]'local f=createGroupBox(a)f.Caption='Time & conditions :'f.Name='gbTime'
	f.AutoSize=true;f.Align=alTop;f.Top=b.Top+b.Height;f.BorderSpacing.Around=10;local g=createCheckBox(f)g.Caption='Backup On Open'g.Name='cbSaveOnOpen'g.AutoSize=true;
	g.BorderSpacing.Around=10;g.Constraints.MaxHeight=25;g.AnchorSideTop.Control=f;g.AnchorSideLeft.Control=f;local h=createCheckBox(f)h.Caption='Backup On Close'
	h.Name='cbSaveOnClose'h.AutoSize=true;h.BorderSpacing.Around=10;h.Constraints.MaxHeight=25;h.AnchorSideTop.Control=g;h.AnchorSideTop.Side=asrBottom;
	h.AnchorSideLeft.Control=f;local i=createCheckBox(f)i.Caption='Backup Befor Execute'i.Name='cbSaveOnExecute'i.AutoSize=true;i.BorderSpacing.Around=10;
	i.Constraints.MaxHeight=25;i.AnchorSideTop.Control=h;i.AnchorSideTop.Side=asrBottom;i.AnchorSideLeft.Control=f;local j=createGroupBox(f)j.Name='gbTiming'
	j.Caption='Backup Script every :'j.AutoSize=true;j.Align=alRight;j.Top=g.Top;j.BorderSpacing.Around=5;j.BorderSpacing.Top=-10;j.Anchors='[akLeft]'
	j.AnchorSideLeft.Control=i;j.AnchorSideLeft.Side=asrRight;local k=createEdit(j)k.Name='eTime'k.Text=20;k.Alignment='taCenter'k.AutoSize=false;k.BorderSpacing.Around=10;
	k.Constraints.MinHeight=30;k.Constraints.MaxHeight=30;k.Constraints.MaxWidth=100;k.Constraints.MinWidth=100;k.NumbersOnly=true;k.MaxLength=2;k.Anchors='[akTop,akLeft]'
	k.AnchorSideTop.Control=j;k.AnchorSideTop.Side=asrCenter;k.AnchorSideLeft.Control=j;k.AnchorSideLeft.Side=asrLeft;local l=createComponentClass('TRadioButton',j)
	l.Parent=j;l.Caption='Min'l.Name='rbMin'l.AutoSize=false;l.Constraints.MaxWidth=60;l.Constraints.MinWidth=60;l.Constraints.MaxHeight=25;l.BorderSpacing.Around=10;
	l.Anchors='[akTop,akRight]'l.AnchorSideTop.Control=j;l.AnchorSideTop.Side=asrCenter;l.AnchorSideRight.Control=j;l.AnchorSideRight.Side=asrRight;local m=createComponentClass('TRadioButton',j)
	m.Parent=j;m.Caption='Sec'm.Name='rbSec'm.AutoSize=false;m.Constraints.MaxWidth=60;m.Constraints.MinWidth=60;m.Constraints.MaxHeight=25;m.BorderSpacing.Around=10;m.Checked=true;
	m.Anchors='[akTop,akRight]'m.AnchorSideTop.Control=j;m.AnchorSideTop.Side=asrCenter;m.AnchorSideRight.Control=l;m.AnchorSideRight.Side=asrLeft;local n=createTrackBar(j)
	n.BorderSpacing.Around=10;n.Name='cTimeBar'n.Min=0;n.Max=60;n.Position=k.Text;n.Anchors='[akTop,akRight,akLeft]'n.AnchorSideTop.Control=j;n.AnchorSideTop.Side=asrCenter;
	n.AnchorSideLeft.Control=k;n.AnchorSideLeft.Side=asrRight;n.AnchorSideRight.Control=m;n.AnchorSideRight.Side=asrLeft;local o=createCheckBox(a)o.Caption='Enabled / Disable Auto Backup'
	o.Name='cbAutoBackup'o.Checked=true;o.Align=alLeft;o.BorderSpacing.Around=10;o.Constraints.MaxHeight=25;local p=createButton(a)p.Caption='Close'p.Name='bClose'p.Align=alRight;
	p.BorderSpacing.Around=10;p.Constraints.MaxHeight=30;p.Constraints.MinWidth=150;p.Constraints.MaxWidth=150;local q=createButton(a)q.Caption='Open Backup Directory'q.Name='bOpenDir'
	q.Align=alRight;q.BorderSpacing.Around=10;q.Constraints.MinWidth=200;q.Constraints.MaxHeight=30;q.Anchors='[akTop,akRight,akLeft]'q.AnchorSideLeft.Control=o;q.AnchorSideLeft.Side=asrRight;
	a.Constraints.MaxHeight=a.Height;a.Constraints.MinHeight=a.Height;return a]],
	FormOpen = this.setSettings( this.Features.AutoBackup.Name .. 'FormOpen', false ),
	Save = {
		OnOpen = this.getSettings( this.Features.AutoBackup.Name .. 'OnOpen' ),
		OnClose = this.getSettings( this.Features.AutoBackup.Name .. 'OnClose' ),
		OnExecute = this.getSettings( this.Features.AutoBackup.Name .. 'OnExecute' ),
		Time = this.getSettings( this.Features.AutoBackup.Name .. 'Time' ) == true and this.setSettings( this.Features.AutoBackup.Name .. 'Time', 0 ) or this.getSettings( this.Features.AutoBackup.Name .. 'Time' ),
		TimeU = this.getSettings( this.Features.AutoBackup.Name .. 'TimeU' ) == true and this.setSettings( this.Features.AutoBackup.Name .. 'TimeU', 1 ) or this.getSettings( this.Features.AutoBackup.Name .. 'TimeU' ),
		OnTime = this.setSettings( this.Features.AutoBackup.Name .. 'OnTime', this.getSettings( this.Features.AutoBackup.Name .. 'Time' ) ~= '0' and true or false ),
		Directory = this.getSettings( this.Features.AutoBackup.Name .. 'Directory' ) == true and this.setSettings( this.Features.AutoBackup.Name .. 'Directory', os.getenv( 'temp' ) ) or this.getSettings( this.Features.AutoBackup.Name .. 'Directory' )
	},
	Backup = function( LuaEditor, type )
		if this.getSettings( this.Features.AutoBackup.Name ) and this.getSettings( this.Features.AutoBackup.Name .. type ) then
			if not fileExists( this.getSettings( this.Features.AutoBackup.Name .. 'Directory' ) .. '\\' .. LuaEditor.Parent.Owner.Caption:gsub( '*', '' ):gsub( ':', '' ):gsub( '?', '' ):gsub( '/', '' ):gsub( '\\', '' ):gsub( '|', '' ):gsub( '"', '' ):gsub( '<', '' ):gsub( '>', '' ) .. '-' .. stringToMD5String( LuaEditor.Lines.getText() ) .. '.txt' ) then
				if (LuaEditor.Lines.getText()):gsub( '\n', '' ):gsub( '\r', '' ):gsub( '\t', '' ):gsub( '%s*', '' ) ~= '' then
					LuaEditor.Lines.saveToFile( this.getSettings( this.Features.AutoBackup.Name .. 'Directory' ) .. '\\' .. LuaEditor.Parent.Owner.Caption:gsub( '*', '' ):gsub( ':', '' ):gsub( '?', '' ):gsub( '/', '' ):gsub( '\\', '' ):gsub( '|', '' ):gsub( '"', '' ):gsub( '<', '' ):gsub( '>', '' ) .. '-' .. stringToMD5String( LuaEditor.Lines.getText() ) .. '.txt' )
				end
			end
		end
	end,
	BackupTimer = createTimer( nil, false )
}
this.AutoBackup.BackupTimer.OnTimer = function()
	local Editor = nil
	if not (getForm( 0 ).Name:match( 'frmLuaEngine' ) == nil) then
		Editor = getForm( 0 ).ComponentByName['mScript']
	elseif not (getForm( 0 ).Name:match( 'frmAutoInject' ) == nil) then
		Editor = getForm( 0 ).ComponentByName['Assemblescreen']
	end
	if Editor and Editor.focused() then
		this.AutoBackup.Backup( Editor, 'OnTime' )
	end
end
this.AutoBackup.BackupTimer.Enabled = this.getSettings( this.Features.AutoBackup.Name .. 'OnTime' )
this.AutoBackup.BackupTimer.Interval = tonumber( this.getSettings( this.Features.AutoBackup.Name .. 'Time' ) ) * tonumber( this.getSettings( this.Features.AutoBackup.Name .. 'TimeU' ) ) * 1000

-- ! #######################
-- ? CREATE ENHANCEMENT MENU
-- ! #######################
this.CreateMenu = function( LuaEditor )

	this.ToggleMenuItem = function( sender, Feature )
		this.Features[Feature.Name].Enabled = not Feature.Enabled
		this.setSettings( Feature.Name, this.Features[Feature.Name].Enabled )
		sender.Bitmap = this.Features[Feature.Name].Enabled and this.Pictures.ON or this.Pictures.OFF
	end

	local miEnhancement = this.addMenuItem( LuaEditor.Menu.Items, '&Enhancement', 'miEnhancement', function( sender )
		for item = 0, sender.Count - 1 do
			if sender.Item[item].name:match( 'miEnhancement' ) then
				sender.Item[item].Bitmap = this.getSettings( sender.Item[item].name:match( 'miEnhancement(.+)$' ) ) and this.Pictures.ON or this.Pictures.OFF
			end
		end
	end )

	local miSelectionMode = this.addMenuItem( miEnhancement, 'Selection Mode', 'miSelectionMode' )
	this.addMenuItem( miSelectionMode, 'NORMAL        (Ctrl+Shift+N)', 'miSelectionModeNormal', function( sender )
		local Editor = nil
		if not (getForm( 0 ).Name:match( 'frmLuaEngine' ) == nil) then
			Editor = getForm( 0 ).ComponentByName['mScript']
		elseif not (getForm( 0 ).Name:match( 'frmAutoInject' ) == nil) then
			Editor = getForm( 0 ).ComponentByName['Assemblescreen']
		end
		if Editor and Editor.focused() then
			createThread( this.SelectionMode( VK_N ) )
		end
	end )
	this.addMenuItem( miSelectionMode, 'COLUMN       (Ctrl+Shift+N)', 'miSelectionModeColumn', function( sender )
		local Editor = nil
		if not (getForm( 0 ).Name:match( 'frmLuaEngine' ) == nil) then
			Editor = getForm( 0 ).ComponentByName['mScript']
		elseif not (getForm( 0 ).Name:match( 'frmAutoInject' ) == nil) then
			Editor = getForm( 0 ).ComponentByName['Assemblescreen']
		end
		if Editor and Editor.focused() then
			createThread( this.SelectionMode( VK_C ) )
		end
	end )
	this.addMenuItem( miSelectionMode, 'LINE               (Ctrl+Shift+N)', 'miSelectionModeLine', function( sender )
		local Editor = nil
		if not (getForm( 0 ).Name:match( 'frmLuaEngine' ) == nil) then
			Editor = getForm( 0 ).ComponentByName['mScript']
		elseif not (getForm( 0 ).Name:match( 'frmAutoInject' ) == nil) then
			Editor = getForm( 0 ).ComponentByName['Assemblescreen']
		end
		if Editor and Editor.focused() then
			createThread( this.SelectionMode( VK_L ) )
		end
	end )
	local miSelectionMultiType = this.addMenuItem( miSelectionMode, 'Multi Type      (Ctrl+Shift+Click)', 'miSelectionMultiType' )
	miSelectionMultiType.Enabled = false
	local miSelectionColumn = this.addMenuItem( miSelectionMode, 'Column Select      (Alt+Select)', 'miSelectionColumn' )
	miSelectionColumn.Enabled = false
	this.addMenuItem( miEnhancement, '-' )

	local _Feature = this.Features.Zoom
	this.addMenuItem( miEnhancement, _Feature.Title, 'miEnhancement' .. _Feature.Name, function( sender )
		this.ToggleMenuItem( sender, _Feature )
	end )
	this.addMenuItem( miEnhancement, '-' )

	local _Feature = this.Features.AutoClose
	this.addMenuItem( miEnhancement, _Feature.Title, 'miEnhancement' .. _Feature.Name, function( sender )
		this.ToggleMenuItem( sender, _Feature )
	end )
	this.addMenuItem( miEnhancement, '-' )

	local _Feature = this.Features.Comments
	this.addMenuItem( miEnhancement, _Feature.Title, 'miEnhancement' .. _Feature.Name, function( sender )
		this.ToggleMenuItem( sender, _Feature )
	end )
	this.addMenuItem( miEnhancement, '-' )

	local _Feature = this.Features.TabIndent
	this.addMenuItem( miEnhancement, _Feature.Title, 'miEnhancement' .. _Feature.Name, function( sender )
		this.ToggleMenuItem( sender, _Feature )
		for i = 0, getFormCount() - 1 do
			if getForm( i ).Name:match( 'frmLuaEngine' ) then
				this.TabIndent( getForm( i ).ComponentByName['mScript'] )
			elseif getForm( i ).Name:match( 'frmAutoInject' ) then
				this.TabIndent( getForm( i ).ComponentByName['Assemblescreen'] )
			end
		end
	end )
	this.addMenuItem( miEnhancement, '-' )

	local _Feature = this.Features.KeepSpace
	this.addMenuItem( miEnhancement, _Feature.Title, 'miEnhancement' .. _Feature.Name, function( sender )
		this.ToggleMenuItem( sender, _Feature )
		for i = 0, getFormCount() - 1 do
			if not (getForm( i ).Name:match( 'frmLuaEngine' ) == nil) then
				this.KeepSpace( getForm( i ).ComponentByName['mScript'] )
			elseif not (getForm( i ).Name:match( 'frmAutoInject' ) == nil) then
				this.KeepSpace( getForm( i ).ComponentByName['Assemblescreen'] )
			end
		end
	end )
	this.addMenuItem( miEnhancement, '-' )

	local _Feature = this.Features.AutoBackup
	local miAutoBackup = this.addMenuItem( miEnhancement, _Feature.Title, 'miEnhance_' .. _Feature.Name, function( sender )
		if not this.getSettings( this.Features.AutoBackup.Name .. 'FormOpen' ) then
			local frm = load( this.AutoBackup.form )()
			this.setSettings( this.Features.AutoBackup.Name .. 'FormOpen', true )

			-- ! FORM ON CLOSE
			frm.OnClose = function( sender )
				this.setSettings( this.Features.AutoBackup.Name .. 'FormOpen', false )
				return caFree
			end
			frm.bClose.OnClick = frm.Close

			-- ! BROWS BUTTON
			frm.gbDir.bBrows.OnClick = function( sender )
				if frm.cSelectDir.execute() then
					frm.gbDir.eDir.Text = frm.cSelectDir.FileName
					frm.gbDir.eDir.Text = this.setSettings( this.Features.AutoBackup.Name .. 'Directory', frm.cSelectDir.FileName )
				end
			end

			-- ! OPEN SAVE DIRECTORY BUTTON
			frm.bOpenDir.OnClick = function( sender )
				shellExecute( frm.gbDir.eDir.Text )
			end

			-- ! AUTOBACKUP CHECK BOX
			frm.cbAutoBackup.OnChange = function( sender )
				frm.gbDir.Enabled = sender.Checked
				frm.gbTime.Enabled = sender.Checked
				frm.cbAutoBackup.Checked = this.setSettings( this.Features.AutoBackup.Name, sender.Checked )
			end

			-- ! SAVE ON OPEN CHECK BOX
			frm.gbTime.cbSaveOnOpen.OnChange = function( sender )
				this.setSettings( this.Features.AutoBackup.Name .. 'OnOpen', sender.Checked )
			end
			-- ! SAVE ON CLOSE CHECK BOX
			frm.gbTime.cbSaveOnClose.OnChange = function( sender )
				this.setSettings( this.Features.AutoBackup.Name .. 'OnClose', sender.Checked )
			end
			-- ! SAVE ON EXECUTE CHECK BOX
			frm.gbTime.cbSaveOnExecute.OnChange = function( sender )
				this.setSettings( this.Features.AutoBackup.Name .. 'OnExecute', sender.Checked )
			end

			-- ! CHANGE TIME UNIT
			frm.gbTime.gbTiming.rbSec.OnChange = function( sender )
				if frm.gbTime.gbTiming.rbSec.State == 1 then
					this.setSettings( this.Features.AutoBackup.Name .. 'TimeU', 1 )
				else
					this.setSettings( this.Features.AutoBackup.Name .. 'TimeU', 60 )
				end
				this.AutoBackup.BackupTimer.Interval = tonumber( this.getSettings( this.Features.AutoBackup.Name .. 'Time' ) ) * tonumber( this.getSettings( this.Features.AutoBackup.Name .. 'TimeU' ) ) * 1000
			end

			-- ! TIME BAR
			frm.gbTime.gbTiming.cTimeBar.OnChange = function( sender )
				frm.gbTime.gbTiming.eTime.Text = frm.gbTime.gbTiming.cTimeBar.Position > 0 and frm.gbTime.gbTiming.cTimeBar.Position or 'NA'
				this.setSettings( this.Features.AutoBackup.Name .. 'Time', frm.gbTime.gbTiming.cTimeBar.Position )
				this.AutoBackup.BackupTimer.Enabled = this.setSettings( this.Features.AutoBackup.Name .. 'OnTime', this.getSettings( this.Features.AutoBackup.Name .. 'Time' ) ~= '0' and true or false )
				this.AutoBackup.BackupTimer.Interval = tonumber( this.getSettings( this.Features.AutoBackup.Name .. 'Time' ) ) * tonumber( this.getSettings( this.Features.AutoBackup.Name .. 'TimeU' ) ) * 1000
			end

			-- ! TIME BOX
			frm.gbTime.gbTiming.eTime.OnChange = function( sender )
				if frm.gbTime.gbTiming.eTime.Text:match( '%d+' ) then
					if tonumber( frm.gbTime.gbTiming.eTime.Text ) < 1 then
						frm.gbTime.gbTiming.eTime.Text = 'NA'
						frm.gbTime.gbTiming.cTimeBar.Position = 0
					elseif tonumber( frm.gbTime.gbTiming.eTime.Text ) > 60 then
						frm.gbTime.gbTiming.eTime.Text = 60
						frm.gbTime.gbTiming.cTimeBar.Position = 60
					else
						frm.gbTime.gbTiming.cTimeBar.Position = frm.gbTime.gbTiming.eTime.Text
					end
				end
			end

			frm.cbAutoBackup.Checked = this.getSettings( this.Features.AutoBackup.Name )
			frm.gbTime.gbTiming.rbSec.State = this.getSettings( this.Features.AutoBackup.Name .. 'TimeU' ) == '1' and 1 or 0
			frm.gbTime.gbTiming.rbMin.State = this.getSettings( this.Features.AutoBackup.Name .. 'TimeU' ) == '60' and 1 or 0
			frm.gbDir.eDir.Text = this.getSettings( this.Features.AutoBackup.Name .. 'Directory' )
			frm.gbTime.gbTiming.cTimeBar.Position = this.getSettings( this.Features.AutoBackup.Name .. 'Time' )
			frm.gbTime.cbSaveOnOpen.Checked = this.getSettings( this.Features.AutoBackup.Name .. 'OnOpen' )
			frm.gbTime.cbSaveOnClose.Checked = this.getSettings( this.Features.AutoBackup.Name .. 'OnClose' )
			frm.gbTime.cbSaveOnExecute.Checked = this.getSettings( this.Features.AutoBackup.Name .. 'OnExecute' )

		end
	end )
	miAutoBackup.Bitmap = this.Pictures.SETTING
	this.addMenuItem( miEnhancement, '-' )

end

-- ! ###############
-- ? SEARCH FOR FORM
-- ! ###############
this.findForm = function( FormName )
	local Form = nil
	for i = 0, getFormCount() - 1 do
		if not (getForm( i ).Name:match( FormName ) == nil) and getForm( i ).Menu and not getForm( i ).Menu.Items.miEnhancement then
			Form = getForm( i )
			break
		end
	end
	return Form
end

-- ! ########################
-- ? CREATE MEMORY POPUP MENU
-- ! ########################
this.MemoryPopup = function( LuaEditor )
	-- ? GET LUA EDITOR POPUP MENU
	local pmLuaEditor = LuaEditor.getPopupMenu().Items

	this.addMenuItem( pmLuaEditor, '-' )
	-- ? ADD MENU BROWSE THIS MEMORY REGION LUA EDITOR
	this.addMenuItem( pmLuaEditor, 'Browse this memory region', 'miBrowseMemory', function( sender )
		if LuaEditor.SelText ~= '' then
			local Address = getAddressSafe( LuaEditor.SelText )
			if Address ~= nil then
				local MemoryView = getMemoryViewForm()
				MemoryView.HexadecimalView.TopAddress = Address
				MemoryView.HexadecimalView.SelectionStart = Address
				MemoryView.HexadecimalView.SelectionStop = Address
				MemoryView.bringToFront()
			end
		end
	end )
	-- ? ADD MENU DISASSEMBLE THIS MEMORY REGION LUA EDITOR
	this.addMenuItem( pmLuaEditor, 'Disassemble this memory region', 'miDisassembleMemory', function( sender )
		if LuaEditor.SelText ~= '' then
			local Address = getAddressSafe( LuaEditor.SelText )
			if Address ~= nil then
				local MemoryView = getMemoryViewForm()
				MemoryView.DisassemblerView.TopAddress = Address
				MemoryView.DisassemblerView.SelectionStart = Address
				MemoryView.DisassemblerView.SelectionStop = Address
				MemoryView.bringToFront()
			end
		end
	end )

	local old_OnContextPopup = LuaEditor.OnContextPopup
	LuaEditor.OnContextPopup = function( sender )
		local state = false
		if sender.SelText ~= '' then
			state = getAddressSafe( sender.SelText ) ~= nil and true or false
		end
		local pmLuaEditor = sender.getPopupMenu().Items
		pmLuaEditor.miBrowseMemory.Visible = state
		pmLuaEditor.miDisassembleMemory.Visible = state
		if old_OnContextPopup then
			old_OnContextPopup()
		end
	end
end

-- ! ####################################
-- ? ADD ENHANCEMENT TO LUA ENGINE EDITOR
-- ! ####################################
this.LuaEngine_Enhancement = function()

	-- ? GET LUA ENGINE EDITOR
	local LuaEngine = nil
	if not (getLuaEngine().Menu.Items.miEnhancement) then
		LuaEngine = getLuaEngine()
	else
		LuaEngine = this.findForm( 'frmLuaEngine' )
		if not LuaEngine then
			return
		end
	end

	-- ? ADD ENHANCEMENT MENU TO LUA ENGINE
	this.CreateMenu( LuaEngine )

	-- ? GET SAVE PATH
	local CE_Settings = getSettings( 'Lua Engine' )

	-- ? GET CONTROLS
	local mnLuaScript = LuaEngine.ComponentByName['mScript']
	local mnLuaOutput = LuaEngine.ComponentByName['mOutput']

	-- ? ADD ENHANCEMENT TO NEW LUA ENGINE EDITOR
	local old_MenuItem11 = LuaEngine.ComponentByName['MenuItem11'].OnClick
	LuaEngine.ComponentByName['MenuItem11'].OnClick = function( sender )
		old_MenuItem11( sender )
		this.runTimer( this.LuaEngine_Enhancement, 800 )
	end

	-- ? SET SAVED FONT SIZE WHEN LUA ENGINE SHOW
	local old_OnShow = LuaEngine.OnShow
	LuaEngine.OnShow = function( sender )
		old_OnShow( sender )
		this.Font.Load( mnLuaScript, CE_Settings )
		this.Font.Load( mnLuaOutput, CE_Settings )
		this.AutoBackup.Backup( mnLuaScript, 'OnOpen' )
	end

	-- ? BACKUP WHEN LUA ENGINE CLOSE
	local old_OnClose = LuaEngine.OnClose
	LuaEngine.OnClose = function( sender, option )
		this.AutoBackup.Backup( mnLuaScript, 'OnClose' )
		if old_OnClose then
			return old_OnClose( sender )
		else
			return option
		end
	end

	-- ! ADD CLEAR CHECK BOX TO CLEAR OUTPUT BEFOR EXECUTE
	local clearCheckBox = createCheckBox( LuaEngine )
	clearCheckBox.Caption = 'Clear'
	clearCheckBox.Name = 'clearCheckBox'
	clearCheckBox.Constraints.MaxHeight = 25
	clearCheckBox.Parent = LuaEngine.btnExecute.Parent
	clearCheckBox.Anchors = '[akTop,akLeft]'
	clearCheckBox.AnchorSideTop.Control = LuaEngine.btnExecute.Parent
	clearCheckBox.AnchorSideTop.Side = asrTop
	clearCheckBox.AnchorSideLeft.Control = LuaEngine.btnExecute
	clearCheckBox.AnchorSideLeft.Side = asrLeft
	LuaEngine.AnchorSideTop.Control = clearCheckBox
	LuaEngine.AnchorSideTop.Side = asrBottom

	-- ? BACKUP WHEN LUA ENGINE EXECUTE SCRIPT
	local old_btnExecute = LuaEngine.ComponentByName['btnExecute'].OnClick
	LuaEngine.ComponentByName['btnExecute'].OnClick = function( sender )
		this.AutoBackup.Backup( mnLuaScript, 'OnExecute' )
		if clearCheckBox.Checked then
			mnLuaOutput.Lines.setText( '' )
		end
		if old_btnExecute then
			old_btnExecute( sender )
		end
	end

	-- ? ADD "AUTO CLOSE BRACKETS" AND "COMMENT / UNCOMMENT"
	this.EditorOnKeyPress( mnLuaScript )
	-- ? SCRIPT INCREASE/DECREASE FONT SIZE
	this.Font.addZoom( mnLuaScript, CE_Settings )
	-- ? OUTPUT INCREASE/DECREASE FONT SIZE
	this.Font.addZoom( mnLuaOutput, CE_Settings )

	-- ? SET INITIAL TEXT
	mnLuaScript.Lines.setText( (mnLuaScript.Lines.LineBreak):rep( 2 ) )
	-- ? LOAD SAVED FONT SIZE
	this.Font.Load( mnLuaScript, CE_Settings )
	this.Font.Load( mnLuaOutput, CE_Settings )

	-- ? MAKE INDENT USE TAB NOT SPACES
	this.TabIndent( mnLuaScript )

	-- ? KEEP SPACES AT END OF THE LINES
	this.KeepSpace( mnLuaScript )

	-- ? ADD EXTRA OPTIONS
	this.EditorOptions( mnLuaScript )

	-- ? ADD MEMORY POPUP MENU
	this.MemoryPopup( mnLuaScript )

	-- ? MAKE VIEW MENU VISIBLE IN NEW LUA ENGINE
	LuaEngine.miView.Visible = true

	-- ? CLEAR LUA ENGINE EDITOR OUTPUT
	local function LuaEngineClearOutput()
		mnLuaOutput.Lines.setText( '' )
	end

	-- ? GET LUA ENGINE POPUP MENU
	local pmluaEngine = LuaEngine.ComponentByName['pmEditor'].Items

	this.addMenuItem( pmluaEngine, '-' )
	-- ? ADD MENU CLEAR LUA ENGINE OUTPUT
	this.addMenuItem( pmluaEngine, 'Clear Output', 'miClearOutput', LuaEngineClearOutput, nil, nil, LuaEngine.ComponentByName['MenuItem5'].ImageIndex )

	-- ? RIGHT CLICK EXECUTE BUTTON SAVE SCRIPT THEN EXECUTE
	local oldbtnExecuteOnClick = LuaEngine.ComponentByName['btnExecute'].onContextPopup
	LuaEngine.ComponentByName['btnExecute'].onContextPopup = function( sender )
		if LuaEngine.ClassName == 'TfrmLuaEngine' and LuaEngine.isForegroundWindow( LuaEngine ) then
			LuaEngine.ComponentByName['MenuItem3'].DoClick()
			LuaEngine.ComponentByName['btnExecute'].DoClick()
			if oldbtnExecuteOnClick then
				return oldbtnExecuteOnClick( sender )
			end
		end
	end

end

-- ! ########################################
-- ? ADD ENHANCEMENT TO AUTO ASSEMBLER EDITOR
-- ! ########################################
this.AutoInject_Enhancement = function()

	-- ? GET AUTO ASSEMBLER EDITOR
	local AutoInject = nil

	AutoInject = this.findForm( 'frmAutoInject' )
	if not AutoInject then
		return
	end

	-- ? ADD ENHANCEMENT MENU TO LUA ENGINE
	this.CreateMenu( AutoInject )

	-- ? GET SAVE PATH
	local CE_Settings = getSettings( 'Auto Assembler' )

	-- ? GET CONTROLS
	local mnAssemblescreen = AutoInject.ComponentByName['Assemblescreen']

	-- ? ADD ENHANCEMENT TO NEW SCRIPT
	local old_miNewWindow = AutoInject.miNewWindow.OnClick
	AutoInject.miNewWindow.OnClick = function( sender )
		this.runTimer( this.AutoInject_Enhancement, 800 )
		return old_miNewWindow( sender )
	end

	-- ? SET SAVED FONT SIZE WHEN ASSEMBLER EDITOR SHOW
	local old_OnShow = AutoInject.OnShow
	AutoInject.OnShow = function( sender )
		old_OnShow( sender )
		this.Font.Load( mnAssemblescreen, CE_Settings )
		this.AutoBackup.Backup( mnAssemblescreen, 'OnOpen' )
	end
	this.AutoBackup.Backup( mnAssemblescreen, 'OnOpen' )

	-- ? BACKUP WHEN ASSEMBLER EDITOR CLOSE
	local old_OnClose = AutoInject.OnClose
	AutoInject.OnClose = function( sender, option )
		this.AutoBackup.Backup( mnAssemblescreen, 'OnClose' )
		if old_OnClose then
			return old_OnClose( sender )
		else
			return option
		end
	end

	-- ? BACKUP WHEN ASSEMBLER EDITOR EXECUTE SCRIPT
	local old_btnExecute = AutoInject.ComponentByName['btnExecute'].OnClick
	AutoInject.ComponentByName['btnExecute'].OnClick = function( sender )
		this.AutoBackup.Backup( mnAssemblescreen, 'OnExecute' )
		if old_btnExecute then
			old_btnExecute( sender )
		end
	end

	-- ? ADD "AUTO CLOSE BRACKETS" AND "COMMENT / UNCOMMENT"
	this.EditorOnKeyPress( mnAssemblescreen )

	-- ? SCRIPT INCREASE/DECREASE FONT SIZE
	this.Font.addZoom( mnAssemblescreen, CE_Settings )

	-- ? SET SAVED FONT SIZE
	this.Font.Load( mnAssemblescreen, CE_Settings )

	-- ? MAKE INDENT USE TAB NOT SPACES
	this.TabIndent( mnAssemblescreen )

	-- ? KEEP SPACES AT END OF THE LINES
	this.KeepSpace( mnAssemblescreen )

	-- ? ADD EXTRA OPTIONS
	this.EditorOptions( mnAssemblescreen )

	-- ? ADD MEMORY POPUP MENU
	this.MemoryPopup( mnAssemblescreen )
end

-- ! ###############################################
-- ? ADD ENHANCEMENT TO MEMORY VIEWER TO OPEN EDITOR
-- ! ###############################################
this.MemoryView_Enhancement = function()
	-- ? FIND MEMORY VIEWER
	local MemoryView = nil
	if not getMemoryViewForm().Menu.Items.miEnhancement then
		MemoryView = getMemoryViewForm()
	else
		MemoryView = this.findForm( 'MemoryBrowser' )
		if not MemoryView then
			return
		end
	end

	-- ? ADD AUTOINJECT ENHANCEMENT AFTER CLICK ON AUTO ASSEMBLE MENU IN MEMORY VIEW
	local old_AutoInject1 = MemoryView.AutoInject1.OnClick
	MemoryView.AutoInject1.OnClick = function( sender )
		old_AutoInject1( sender )
		this.runTimer( this.AutoInject_Enhancement, 800 )
	end

	-- ? ADD AUTOINJECT ENHANCEMENT TO AUTO ASSEMBLE MENU IN NEW MEMORY VIEW
	local Old_Newwindow1 = MemoryView.Newwindow1.OnClick
	MemoryView.Newwindow1.OnClick = function( sender )
		Old_Newwindow1( sender )
		this.runTimer( this.MemoryView_Enhancement, 800 )
	end

	-- ? CREATE ENHANCEMENT MENU HIDDEN JUST FOR CHECK
	local miEnhancement = this.addMenuItem( MemoryView.Menu.Items, '&Enhancement', 'miEnhancement' )
	miEnhancement.Visible = false

end

-- ! ###########################################
-- ? ADD ENHANCEMENT TO MAIN FORM TO OPEN EDITOR
-- ! ###########################################
this.MainForm_Enhancement = function()

	-- ! GET MAINFORM FORM
	local MainForm = MainForm or getMainForm()
	-- ! GET ADDRESSLIST CONTROL
	local AddressList = AddressList or getAddressList()

	-- ? ADD AUTOINJECT ENHANCEMENT AFTER CLICK ON POPUP MENU CHANGE SCRIPT IN ADDRESSLIST
	local old_Changescript1 = MainForm.ComponentByName['Changescript1'].OnClick
	MainForm.ComponentByName['Changescript1'].OnClick = function( sender )
		if AddressList.SelectedRecord and AddressList.SelectedRecord.Type == vtAutoAssembler then
			this.runTimer( this.AutoInject_Enhancement, 800 )
		end
		if old_Changescript1 then
			old_Changescript1( sender )
		end
	end

	-- ? ADD AUTOINJECT ENHANCEMENT AFTER DOUBLE CLICK ON SCRIPT IN ADDRESSLIST
	local old_OnDblClick = AddressList.List.OnDblClick
	AddressList.List.OnDblClick = function( sender )
		if AddressList.SelectedRecord and AddressList.SelectedRecord.Type == vtAutoAssembler then
			this.runTimer( this.AutoInject_Enhancement, 800 )
		end
		if old_OnDblClick then
			old_OnDblClick( sender )
		end
	end

	-- ? ADD AUTOINJECT ENHANCEMENT AFTER PRESSING ENTER ON SCRIPT IN ADDRESSLIST
	local old_OnKeyDown = AddressList.List.OnKeyDown
	AddressList.List.OnKeyDown = function( sender, key )
		if AddressList.SelectedRecord and AddressList.SelectedRecord.Type == vtAutoAssembler and key == VK_RETURN and not isKeyPressed( VK_CONTROL ) then
			this.runTimer( this.AutoInject_Enhancement, 800 )
		end
		if old_OnKeyDown then
			old_OnKeyDown( sender, key )
		end
	end

	-- ! ################################################
	-- ? ADD LUA ENGINE BUTTON NEXT TO MEMORY VIEW BUTTON
	-- ! ################################################
	if this.getSettings( this.Features.AddLuaEngineButton.Name ) then
		local btnLuaEngine = createButton( MainForm.btnMemoryView.Parent )
		if not MainForm.btnLuaEngine then
			btnLuaEngine.Name = 'btnLuaEngine'
			btnLuaEngine.Parent = MainForm.btnMemoryView.Parent
			btnLuaEngine.AnchorSideLeft.Control = MainForm.btnMemoryView
			btnLuaEngine.AnchorSideLeft.Side = asrRight
			btnLuaEngine.AnchorSideTop.Control = MainForm.btnMemoryView
			btnLuaEngine.AnchorSideTop.Side = asrTop
			btnLuaEngine.BorderSpacing.Left = 5
			btnLuaEngine.caption = "LUA Engine"
			btnLuaEngine.Height = MainForm.btnMemoryView.Height
			btnLuaEngine.Width = MainForm.btnMemoryView.Width
			btnLuaEngine.OnClick = function()
				if getLuaEngine().GetVisible() then
					if getLuaEngine().WindowState == 'wsMinimized' then
						getLuaEngine().WindowState = 'wsNormal'
					end
					getLuaEngine().BringToFront()
				else
					getLuaEngine().show()
				end
			end
		end
	end

	-- ! ###################################
	-- ? ADD LUA ENGINE SHORTCUT CONTROL + L
	-- ! ###################################
	local pmAddressList = AddressList.PopupMenu.Items
	local miLuaEngine = this.addMenuItem( pmAddressList, 'Lua Engine', 'miLuaEngine', function()
		if getLuaEngine().GetVisible() then
			if getLuaEngine().WindowState == 'wsMinimized' then
				getLuaEngine().WindowState = 'wsNormal'
			end
			getLuaEngine().BringToFront()
		else
			getLuaEngine().show()
		end
	end )
	miLuaEngine.ShortCut = textToShortCut( "Ctrl+L" )
	miLuaEngine.Visible = false

end

-- ! ###################################################
-- ? LOAD THE EXTENSION ONLY IF THE MAIN FORM IS VISIBLE
-- ! ###################################################
local MainForm = MainForm or getMainForm()
local s = os.clock()
local TimeOut = false
local timer = createTimer( nil, false );
timer.Interval = 500
function timer.OnTimer()
	MainForm = getMainForm()
	if MainForm.Visible then
		this.MainForm_Enhancement()
		this.MemoryView_Enhancement()
		this.LuaEngine_Enhancement()
		this.AutoInject_Enhancement()
		timer.destroy()
		timer = nil
		return
	end
	if (os.clock() - s) > (2 * 60) then
		print( ExtensionName .. ' Timed Out' )
		timer.destroy()
		timer = nil
		return
	end
end
timer.Enabled = true
