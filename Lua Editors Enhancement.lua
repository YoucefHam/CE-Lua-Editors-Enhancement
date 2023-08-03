--[====[ return
	Author:  YoucefHam
	Email:   youcefham20@gmail.com
	Discord: YoucefHam
	GitHub:  https://github.com/YoucefHam

	Lua Editors Enhancement:

	- Add Lua Engine Button to CE Main Form with shortcut CTRL+L
	- inside "Lua Engine" and "Lua Editor" and "AutoAssemble Editor"
		Ctrl + Mouse Wheel : Zoom Font Size and save it to restore later.
		Auto close brackets with selected code "" '' () [] {}. see "AutoClose.List"
		Ctrl+Q to comment (selected) code in lua (block) --[=[Code]=].
		Ctrl+Shift+Q to uncomment (selected) code in lua (block).
		Make indents use TABs only. (Space at the start of the line)
		Keep spaces at end of the lines
		Selection mode: (some of them works without this Extension)
			* Hold ALT and Select : Select text in column mode.
			* Hold CTRL + SHIFT + Click : type in multiple places.
			* CTRL + SHIFT + N : toggle normal selection mode.
			* CTRL + SHIFT + C : toggle column selection mode.
			* CTRL + SHIFT + L : toggle line selection mode.


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
-- add auto backup
-- add popup menu to go to memory address
-- add clear befor execute in lua engine;
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
	}
}

-- ! #################################
-- ? Save/Restore Enhancement Settings
-- ! #################################
this.Settings = getSettings( ExtensionName )

-- ! SAVE ENHANCEMENT SETTINGS
this.setSettings = function( Name, value )
	this.Settings.Value[Name] = tostring( (value == true) and true or false )
end

-- ! GET SAVED ENHANCEMENT SETTINGS
this.getSettings = function( Name )
	return this.Settings.Value[Name]:match( '(false)' ) == nil and (this.Settings.Value[Name]:match( '(true)' ) == nil and this.setSettings( Name, true ) or true) or false
end

-- ! PREP SETTINGS FOR FIRST TIME RUN
this.setSettings( this.Features.AddLuaEngineButton.Name, this.Features.AddLuaEngineButton.Enabled )
for _Feature, _ in pairs( this.Features ) do
	if this.Features[_Feature].Enabled == true then
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
		ON = '42 4D F6 00 00 00 00 00 00 00 76 00 00 00 28 00 00 00 10 00 00 00 10 00 00 00 01 00 04 00 00 00 00 00 80 00 00 00 C3 0E 00 00 C3 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 80 00 00 80 00 00 00 80 80 00 80 00 00 00 80 00 80 00 80 80 00 00 80 80 80 00 C0 C0 C0 00 00 00 FF 00 00 FF 00 00 00 FF FF 00 FF 00 00 00 FF 00 FF 00 FF FF 00 00 FF FF FF 00 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 87 77 77 77 77 78 FF FF 70 00 00 00 00 07 FF FF 70 00 0A 00 00 07 FF FF 70 0F AA AF F0 07 FF FF 70 0A AA A7 F0 07 FF FF 70 AA AA AA 80 07 FF FF 7A AA 7F AA A0 07 FF FF 70 A8 FF FA AA 07 FF FF 70 0F FF F8 AA A7 FF FF 70 00 00 00 AA AA FF FF 70 00 00 00 0A AA 7F FF 87 77 77 77 77 AA A8 FF FF FF FF FF FF FA AA FF FF FF FF FF FF F8 7F',
		OFF = '42 4D F6 00 00 00 00 00 00 00 76 00 00 00 28 00 00 00 10 00 00 00 10 00 00 00 01 00 04 00 00 00 00 00 80 00 00 00 C3 0E 00 00 C3 0E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 80 00 00 80 00 00 00 80 80 00 80 00 00 00 80 00 80 00 80 80 00 00 80 80 80 00 C0 C0 C0 00 00 00 FF 00 00 FF 00 00 00 FF FF 00 FF 00 00 00 FF 00 FF 00 FF FF 00 00 FF FF FF 00 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 87 77 77 77 77 78 FF FF 70 00 00 00 00 07 FF FF 70 00 00 00 00 07 FF FF 70 0F FF FF F0 07 FF FF 70 0F FF FF F0 07 FF FF 70 0F FF FF F0 07 FF FF 70 0F FF FF F0 07 FF FF 70 0F FF FF F0 07 FF FF 70 0F FF FF F0 07 FF FF 70 00 00 00 00 07 FF FF 70 00 00 00 00 07 FF FF 87 77 77 77 77 78 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF'
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
-- ! PICTURE FOR ENABLED FEATURE
this.Pictures.ON = this.Pictures.Create( this.Pictures.data.ON )
-- ! PICTURE FOR DISABLED FEATURE
this.Pictures.OFF = this.Pictures.Create( this.Pictures.data.OFF )

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
		for item = 0, sender.Count do
			if sender.Item[item].name:match( 'miEnhancement' ) then
				sender.Item[item].Bitmap = this.getSettings( sender.Item[item].name:match( 'miEnhancement(.+)$' ) ) and this.Pictures.ON or this.Pictures.OFF
			end
		end
	end )

	local miSelectionMode = this.addMenuItem( miEnhancement, 'Selection Mode', 'miSelectionMode' )
	this.addMenuItem( miSelectionMode, 'NORMAL        (Ctrl+Shift+N)', 'miSelectionModeNormal', function( sender )
		local Editor = nil
		if not (getForm( 0 ).Name:match( 'frmLuaEngine' ) == nil) then
			Editor = LuaEditor.ComponentByName['mScript']
		elseif not (getForm( 0 ).Name:match( 'frmAutoInject' ) == nil) then
			Editor = LuaEditor.ComponentByName['Assemblescreen']
		end
		if Editor and Editor.focused() then
			createThread( this.SelectionMode( VK_N ) )
		end
	end )
	this.addMenuItem( miSelectionMode, 'COLUMN       (Ctrl+Shift+N)', 'miSelectionModeColumn', function( sender )
		local Editor = nil
		if not (getForm( 0 ).Name:match( 'frmLuaEngine' ) == nil) then
			Editor = LuaEditor.ComponentByName['mScript']
		elseif not (getForm( 0 ).Name:match( 'frmAutoInject' ) == nil) then
			Editor = LuaEditor.ComponentByName['Assemblescreen']
		end
		if Editor and Editor.focused() then
			createThread( this.SelectionMode( VK_C ) )
		end
	end )
	this.addMenuItem( miSelectionMode, 'LINE               (Ctrl+Shift+N)', 'miSelectionModeLine', function( sender )
		local Editor = nil
		if not (getForm( 0 ).Name:match( 'frmLuaEngine' ) == nil) then
			Editor = LuaEditor.ComponentByName['mScript']
		elseif not (getForm( 0 ).Name:match( 'frmAutoInject' ) == nil) then
			Editor = LuaEditor.ComponentByName['Assemblescreen']
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
		this.runTimer( this.LuaEngine_Enhancement, 1500 )
	end

	-- ? SET SAVED FONT SIZE WHEN LUA ENGINE SHOW
	local old_OnShow = LuaEngine.OnShow
	LuaEngine.OnShow = function( sender )
		old_OnShow( sender )
		this.Font.Load( mnLuaScript, CE_Settings )
		this.Font.Load( mnLuaOutput, CE_Settings )
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
		this.runTimer( this.AutoInject_Enhancement, 1500 )
		return old_miNewWindow( sender )
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
		this.runTimer( this.AutoInject_Enhancement, 1500 )
	end

	-- ? ADD AUTOINJECT ENHANCEMENT TO AUTO ASSEMBLE MENU IN NEW MEMORY VIEW
	local Old_Newwindow1 = MemoryView.Newwindow1.OnClick
	MemoryView.Newwindow1.OnClick = function( sender )
		Old_Newwindow1( sender )
		this.runTimer( this.MemoryView_Enhancement, 1500 )
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
			this.runTimer( this.AutoInject_Enhancement, 1500 )
		end
		if old_Changescript1 then
			old_Changescript1( sender )
		end
	end

	-- ? ADD AUTOINJECT ENHANCEMENT AFTER DOUBLE CLICK ON SCRIPT IN ADDRESSLIST
	local old_OnDblClick = AddressList.List.OnDblClick
	AddressList.List.OnDblClick = function( sender )
		if AddressList.SelectedRecord and AddressList.SelectedRecord.Type == vtAutoAssembler then
			this.runTimer( this.AutoInject_Enhancement, 1500 )
		end
		if old_OnDblClick then
			old_OnDblClick( sender )
		end
	end

	-- ? ADD AUTOINJECT ENHANCEMENT AFTER PRESSING ENTER ON SCRIPT IN ADDRESSLIST
	local old_OnKeyDown = AddressList.List.OnKeyDown
	AddressList.List.OnKeyDown = function( sender, key )
		if AddressList.SelectedRecord and AddressList.SelectedRecord.Type == vtAutoAssembler and key == VK_RETURN and not isKeyPressed( VK_CONTROL ) then
			this.runTimer( this.AutoInject_Enhancement, 1500 )
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

-- ! #############################################
-- ? LOAD THE EXTENSION ONLY IF THE MAI IS VISIBLE
-- ! #############################################
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
