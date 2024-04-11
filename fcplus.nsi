!include nsDialogs.nsh
!include ReplaceInFile3.nsh
!include StrContains.nsh

Name "Fightcade+ Post"
OutFile "fcplus.exe"
Icon "fcplus.ico"

InstallDir "$DOCUMENTS\Fightcade"
BrandingText " "

RequestExecutionLevel user
Unicode True

Var /GLOBAL FLYCAST_TAG

SpaceTexts none
DirText "Select your existing Fightcade installation folder."

Page directory
Page custom nsDialogsPage nsDialogsPageLeave
Page instfiles

!pragma warning disable 8000 ; "Page instfiles not used, no sections will be executed!"

Var CHECKBOX
Var CHECKBOX1
Var CHECKBOX2
Var CHECKBOX3
Var CHECKBOX4
Var EDIT
Var EDIT_LABEL

Var CustomZip

Function .onInit
	StrCpy $CHECKBOX ${BST_CHECKED}
	GetFunctionAddress $0 OnJoyCheckbox
	StrCpy $CHECKBOX1 ${BST_CHECKED}
	GetFunctionAddress $0 OnDojoCheckbox
	StrCpy $CHECKBOX2 ${BST_CHECKED}
	GetFunctionAddress $0 OnGrouflonCheckbox
	StrCpy $CHECKBOX3 ${BST_CHECKED}
	GetFunctionAddress $0 OnNailokCheckbox
FunctionEnd

Function nsDialogsPage
	nsDialogs::Create 1018
	Pop $0

	${NSD_CreateCheckbox} 0 20 100% 8u "Fightcade Joystick/Keyboard Controls"
		Pop $CHECKBOX
		${NSD_SetState} $CHECKBOX $CHECKBOX
		GetFunctionAddress $0 OnJoyCheckbox
		nsDialogs::OnClick $CHECKBOX $0

	${NSD_CreateCheckbox} 0 40 100% 8u "Latest Flycast Dojo Prerelease"
		Pop $CHECKBOX1
		${NSD_SetState} $CHECKBOX1 $CHECKBOX1
		GetFunctionAddress $0 OnDojoCheckbox
		nsDialogs::OnClick $CHECKBOX1 $0

	${NSD_CreateCheckbox} 0 80 100% 8u "Street Fighter III: 3rd Strike Lua Scripts by Grouflon"
		Pop $CHECKBOX2
		${NSD_SetState} $CHECKBOX2 $CHECKBOX2
		GetFunctionAddress $0 OnGrouflonCheckbox
		nsDialogs::OnClick $CHECKBOX2 $0

	${NSD_CreateCheckbox} 0 100 100% 8u "Virtua Fighter 4: Final Tuned Lua Scripts by Nailok"
		Pop $CHECKBOX3
		${NSD_SetState} $CHECKBOX3 $CHECKBOX3
		GetFunctionAddress $0 OnNailokCheckbox
		nsDialogs::OnClick $CHECKBOX3 $0

	${NSD_CreateCheckbox} 0 140 100% 8u "Download custom ZIP archive and extract to emulator folder"
		Pop $CHECKBOX4
		GetFunctionAddress $0 OnZipCheckbox
		nsDialogs::OnClick $CHECKBOX4 $0

	${NSD_CreateLabel} 0 160 100% 8u "Zip URL"
		Pop $EDIT_LABEL
		ShowWindow $EDIT_LABEL ${SW_HIDE}

	${NSD_CreateText} 0 180 100% 12u ""
		Pop $EDIT
		ShowWindow $EDIT ${SW_HIDE}

	Pop $0

	nsDialogs::Show
FunctionEnd

Function nsDialogsPageLeave
	${NSD_GetText} $EDIT $0
	StrCpy $CustomZip $0
FunctionEnd

Section "Joystick/Keyboard Controls" joykb
	DetailPrint "Downloading Fightcade Joystick/Keyboard Controls"
	inetc::get /POPUP "" /CAPTION "Fightcade Joystick/Keyboard Controls" "https://raw.githubusercontent.com/blueminder/fightcade-joystick-kb-controls/main/inject.js" "$INSTDIR\fc2-electron\resources\app\inject\inject.js"
    Pop $0 # return value = exit code, "OK" if OK
    DetailPrint "Download Status: $0"
	DetailPrint "Fightcade Joystick/Keyboard Controls Installed"
SectionEnd

Function OnJoyCheckbox
	Pop $0 # HWND
	${If} $0 == 1
		SectionGetFlags ${joykb} $0
		IntOp $0 $0 & ${SECTION_OFF}
		SectionSetFlags ${joykb} $0
	${Else}
		SectionGetFlags ${joykb} $R0
		IntOp $0 $0 & ${SF_SELECTED}
		SectionSetFlags ${joykb} $0
	${EndIf}
FunctionEnd

Section "Flycast Dojo" fcdojo
	DetailPrint "Looking Up Latest Flycast Dojo Prerelease"
	inetc::get /silent "https://api.github.com/repos/blueminder/flycast-dojo/releases" $TempFile
	nsJSON::Set /file $TempFile
	nsJSON::Get /index 0 "tag_name" /end
	Pop $R0
	StrCpy "$FLYCAST_TAG" "$R0"
	${StrContains} $0 "403" "$FLYCAST_TAG"
		StrCpy "$FLYCAST_TAG" "dojo-6.12"
		Goto done
	done:

	SetOutPath "$INSTDIR"

	FileOpen $9 "$INSTDIR\emulator\flycast\VERSION.txt" w
	FileWrite $9 "dojo-0.5.8"
	FileClose $9

	StrCpy $OLD_STR "rend.FixedFrequency = 1"
	StrCpy $FST_OCC all
	StrCpy $FST_OCC 2
	StrCpy $NR_OCC all
	StrCpy $NR_OCC 3
	StrCpy $REPLACEMENT_STR "rend.FixedFrequency = 1$\r$\nrend.FixedFrequencyThreadSleep = no"
	StrCpy $FILE_TO_MODIFIED "$INSTDIR\emulator\flycast\emu.default.cfg"

	!insertmacro ReplaceInFile $OLD_STR $FST_OCC $NR_OCC $REPLACEMENT_STR $FILE_TO_MODIFIED ;job done

	Push "rend.FixedFrequency = 1" #text to be replaced
	Push "rend.FixedFrequency = 1$\r$\nrend.FixedFrequencyThreadSleep = no" #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push "$INSTDIR\emulator\flycast\emu.default.cfg" #file to replace in
		Call AdvReplaceInFile

	IfFileExists "$INSTDIR\emulator\flycast\emu.cfg" file_found file_not_found
	file_found:
	Push "rend.FixedFrequencyThreadSleep = yes" #text to be replaced
	Push "rend.FixedFrequencyThreadSleep = no" #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push "$INSTDIR\emulator\flycast\emu.cfg" #file to replace in
		Call AdvReplaceInFile
	goto end_of_test
	file_not_found:
	CopyFiles "$INSTDIR\emulator\flycast\emu.default.cfg" "$INSTDIR\emulator\flycast\emu.cfg"
	end_of_test:

	Rename "$INSTDIR\emulator\flycast" "$INSTDIR\emulator\flycast_previous"

	DetailPrint "Downloading flycast-$FLYCAST_TAG"
    inetc::get /POPUP "" /CAPTION "flycast-$FLYCAST_TAG" "https://github.com/blueminder/flycast-dojo/releases/download/$FLYCAST_TAG/flycast-$FLYCAST_TAG.zip" "$INSTDIR\emulator\flycast-$FLYCAST_TAG.zip"
    Pop $0 # return value = exit code, "OK" if OK
    DetailPrint "Download Status: $0"

	InitPluginsDir
	nsisunz::UnzipToLog "$INSTDIR\emulator\flycast-$FLYCAST_TAG.zip" "$INSTDIR\emulator"
	Pop $0
	DetailPrint "Extract Status: $0" ;print error message to log
	StrCmp $0 "success" ok
	ok:
	Rename "$INSTDIR\emulator\flycast-$FLYCAST_TAG" "$INSTDIR\emulator\flycast"
	DetailPrint "Copying existing ROMs"
	CopyFiles "$INSTDIR\emulator\flycast_previous\ROMs" "$INSTDIR\emulator\flycast\ROMs"
	DetailPrint "Copying existing NAOMI BIOS"
	CopyFiles "$INSTDIR\emulator\flycast_previous\data\naomi.zip" "$INSTDIR\emulator\flycast\ROMs"
	DetailPrint "Copying existing NAOMI 2 BIOS"
	CopyFiles "$INSTDIR\emulator\flycast_previous\data\naomi2.zip" "$INSTDIR\emulator\flycast\ROMs"
	DetailPrint "Copying existing Atomiswave BIOS"
	CopyFiles "$INSTDIR\emulator\flycast_previous\data\awbios.zip" "$INSTDIR\emulator\flycast\ROMs"

	FileOpen $9 "$INSTDIR\emulator\flycast\VERSION.txt" w
	FileWrite $9 $FLYCAST_TAG
	FileClose $9

	FileOpen $9 "$INSTDIR\fc2-electron\resources\app\inject\inject.js" a
	FileSeek $9 0 END
	FileWrite $9 'const appendFlycastTitle = function (fcWindow) {$\n'
	FileWrite $9 '  const fcDoc = fcWindow.document$\n'
	FileWrite $9 '  fcDoc.title += " (Flycast Version: $FLYCAST_TAG, Prerelease)"$\n'
	FileWrite $9 '}$\n$\n'
	FileWrite $9 'appendFlycastTitle(window)$\n'
	FileClose $9

	DetailPrint "Downloading Switch Fightcade Flycast Version Script"
	inetc::get /POPUP "" /CAPTION "Switch Fightcade Flycast Version Utility" "https://github.com/blueminder/switch-fightcade-flycast/releases/download/0.2/switch-fightcade-flycast-0.2.zip" "$INSTDIR\emulator\switch-fightcade-flycast.zip"
    Pop $0 # return value = exit code, "OK" if OK
    DetailPrint "Download Status: $0"

	nsisunz::UnzipToLog "$INSTDIR\emulator\switch-fightcade-flycast.zip" "$INSTDIR\emulator"
	Pop $0
	DetailPrint "Extract Status: $0" ;print error message to log
	Delete "$INSTDIR\emulator\switch-fightcade-flycast.zip"

	DetailPrint "Creating Fightcade Start Menu Folder"
	CreateDirectory "$STARTMENU\Fightcade"
	Rename "$STARTMENU\Fightcade2.lnk" "$STARTMENU\Fightcade\Fightcade2.lnk"

    DetailPrint "Creating Flycast Dojo Shortcuts"
	SetOutPath "$INSTDIR\emulator"
	CreateShortCut "$STARTMENU\Fightcade\Switch Fightcade Flycast Version.lnk" "$INSTDIR\emulator\switch-fightcade-flycast.exe" "" ""

	SetOutPath "$INSTDIR\emulator\flycast"
	CreateShortCut "$STARTMENU\Fightcade\Flycast Dojo (Active).lnk" "$INSTDIR\emulator\flycast\flycast.exe" "" ""

	SetOutPath "$INSTDIR\emulator\flycast"
	CreateShortCut "$STARTMENU\Fightcade\Flycast Dojo (Alternate).lnk" "$INSTDIR\emulator\flycast_previous\flycast.exe" "" ""

    DetailPrint "Creating Fightcade FBNeo Shortcut"
	SetOutPath "$INSTDIR\emulator\fbneo"
	CreateShortCut "$STARTMENU\Fightcade\Fightcade FBNeo.lnk" "$INSTDIR\emulator\fbneo\fcadefbneo.exe" "" ""
	SetOutPath "$INSTDIR"

SectionEnd

Function OnDojoCheckbox
	Pop $0 # HWND
	${If} $0 == 1
		SectionGetFlags ${fcdojo} $0
		IntOp $0 $0 & ${SECTION_OFF}
		SectionSetFlags ${fcdojo} $0
	${Else}
		SectionGetFlags ${fcdojo} $R0
		IntOp $0 $0 & ${SF_SELECTED}
		SectionSetFlags ${fcdojo} $0
	${EndIf}
FunctionEnd

Section "Street Fighter III: 3rd Strike Lua Scripts by Grouflon" grouflon
    DetailPrint "Downloading Street Fighter III: 3rd Strike Lua Scripts by Grouflon"
	inetc::get /POPUP "" /CAPTION "Street Fighter III: 3rd Strike Lua Scripts by Grouflon" "https://github.com/Grouflon/3rd_training_lua/archive/refs/heads/master.zip" "$INSTDIR\3rd_training_lua.zip"
    Pop $0 # return value = exit code, "OK" if OK
    DetailPrint "Download Status: $0"
	InitPluginsDir
	CreateDirectory "$INSTDIR\emulator\fbneo\lua"
	nsisunz::UnzipToLog "$INSTDIR\3rd_training_lua.zip" "$INSTDIR\emulator\fbneo\lua"
	Delete "$INSTDIR\3rd_training_lua.zip"
	DetailPrint "Street Fighter III: 3rd Strike Lua Scripts by Grouflon Installed"
SectionEnd

Function OnGrouflonCheckbox
	Pop $0 # HWND
	${If} $0 == 1
		SectionGetFlags ${grouflon} $0
		IntOp $0 $0 & ${SECTION_OFF}
		SectionSetFlags ${grouflon} $0
	${Else}
		SectionGetFlags ${grouflon} $R0
		IntOp $0 $0 & ${SF_SELECTED}
		SectionSetFlags ${grouflon} $0
	${EndIf}
FunctionEnd

Section "Virtua Fighter 4: Final Tuned Lua Scripts by Nailok" nailok
    DetailPrint "Downloading Virtua Fighter 4: Final Tuned Lua Scripts by Nailok"
	inetc::get /POPUP "" /CAPTION "Virtua Fighter 4: Final Tuned Lua Scripts by Nailok" "https://github.com/Nailok/VF4-Training/archive/refs/heads/master.zip" "$INSTDIR\VF4-Training.zip"
    Pop $0 # return value = exit code, "OK" if OK
    DetailPrint "Download Status: $0"
	InitPluginsDir
	nsisunz::UnzipToLog "$INSTDIR\VF4-Training.zip" "$INSTDIR\emulator\flycast"
	Rename "$INSTDIR\emulator\flycast\VF4-Training-master\vf4_training.lua" "$INSTDIR\emulator\flycast\training\vf4tuned.lua"
	CopyFiles "$INSTDIR\emulator\flycast\VF4-Training-master\cheats" "$INSTDIR\emulator\flycast\cheats"
	CopyFiles "$INSTDIR\emulator\flycast\VF4-Training-master\vf4_training" "$INSTDIR\emulator\flycast\vf4_training"
	RMDir /r "$INSTDIR\emulator\flycast\VF4-Training-master"
	Delete "$INSTDIR\VF4-Training.zip"
	DetailPrint "Virtua Fighter 4: Final Tuned Lua Scripts by Nailok Installed"
SectionEnd

Function OnNailokCheckbox
	Pop $0 # HWND
	${If} $0 == 1
		SectionGetFlags ${nailok} $0
		IntOp $0 $0 & ${SECTION_OFF}
		SectionSetFlags ${nailok} $0
	${Else}
		SectionGetFlags ${nailok} $R0
		IntOp $0 $0 & ${SF_SELECTED}
		SectionSetFlags ${nailok} $0
	${EndIf}
FunctionEnd

Section "Custom Zip Extract" customzip
	${If} $CustomZip != ""
		DetailPrint "Downloading Custom Zip Archive"
		inetc::get /POPUP "" /CAPTION "Custom Zip Archive" $CustomZip "$INSTDIR\custom.zip"
		Pop $0 # return value = exit code, "OK" if OK
		DetailPrint "Download Status: $0"

		InitPluginsDir
		DetailPrint "Extracting Custom Zip Archive to emulator"
		nsisunz::UnzipToLog "$INSTDIR\custom.zip" "$INSTDIR\emulator"
		Pop $0
		StrCmp $0 "success" ok
			DetailPrint "Extraction: $0" ;print error message to log
		ok:
		Delete "$INSTDIR\custom.zip"
	${EndIf}
SectionEnd

Function OnZipCheckbox
	Pop $0 # HWND
	${NSD_GetState} $0 $0
	${If} $0 == 1
		ShowWindow $EDIT_LABEL ${SW_SHOW}
		ShowWindow $EDIT ${SW_SHOW}

		SectionGetFlags ${customzip} $0
		IntOp $0 $0 & ${SF_SELECTED}
		SectionSetFlags ${customzip} $0
	${Else}
		ShowWindow $EDIT_LABEL ${SW_HIDE}
		ShowWindow $EDIT ${SW_HIDE}
		
		SectionGetFlags ${customzip} $0
		IntOp $0 $0 & ${SECTION_OFF}
		SectionSetFlags ${customzip} $0
	${EndIf}
FunctionEnd
