struct DN_ControlLayout
(
	Width,
	Height,
	Left,
	Right,
	Top,
	Bottom,
	Dock,
	AnchorStyles,
	Padding,
	MultiLine,
	SizeMode,
	Disabled,
	BackColor,
	ForeColor
)
fn SetControlLayout ctrl Layout =
(
	
	if Layout.Width != undefined then ctrl.width = Layout.Width
	--else ctrl.width = form.Width-15
	if Layout.Height != undefined then ctrl.height = Layout.Height
	--else ctrl.height = 400
	
	if Layout.AnchorStyles != undefined and Layout.AnchorStyles.count > 0 then
	(
		anchorStyle = -1
		for style in Layout.AnchorStyles do
		(
			actualStyle = case style of 
			(
				"Top":
				(
					ctrl.Anchor.Top
				)
				"Bottom":
				(
					ctrl.Anchor.Bottom
				)
				"Left":
				(
					ctrl.Anchor.Left
				)
				"Right":
				(
					ctrl.Anchor.Right
				)
				"None":
				(
					ctrl.Anchor.None
				)
			)
			if anchorStyle == -1 then anchorStyle = actualStyle
			else anchorStyle = dotnet.combineEnums (anchorStyle) (actualStyle)
		)
		if anchorStyle != -1 then ctrl.Anchor = anchorStyle
	)
	if Layout.Left != undefined then ctrl.left= Layout.Left
	if Layout.Right != undefined then ctrl.right= Layout.Right
	if Layout.Top != undefined then ctrl.top= Layout.Top
	if Layout.Bottom != undefined then ctrl.bottom= Layout.Bottom
	
	if Layout.BackColor != undefined then ctrl.backcolor = Layout.BackColor
	if Layout.ForeColor != undefined then ctrl.forecolor = Layout.ForeColor
)

fn SetClickHandler ctrl func =
(
	
	dotNet.setLifetimeControl ctrl #dotnet
	dotNet.addEventHandler ctrl "Click" func
)

fn SetupTabs form labels:#() Layout:undefined =
(
	tabs = dotNetObject "system.windows.forms.tabControl"
	
	SetControlLayout tabs Layout
	
	
	tabs.tabPages.clear()
	if Layout.SizeMode != undefined then tabs.sizeMode=Layout.SizeMode
	else tabs.sizeMode=tabs.sizeMode.fixed
	tabs.itemSize = dotnetObject "System.Drawing.Size" ((tabs.width/labels.count)-1) 25
	if Layout.MultiLine != undefined then tabs.multiline = Layout.MultiLine
	else tabs.multiline = false
	
	--tabs.backColor = tabs.backColor.FromARGB 255  60 60 60
	
	for x in labels do tabs.tabPages.add x
	--showProps tabs.tabPages.Item[0] 
	
	if Layout.Disabled != Undefined do for i = 1 to Layout.Disabled.count do
	(
		tabs.tabPages.Item[i-1].enabled = Layout.Disabled[i]
	)
	
	form.Controls.Add tabs
	tabs
)
fileIn "CRToolsNewUI.ms"
fileIn "CRToolsUI_ImportTabs.ms"
fileIn "CRToolsUI_ExportTabs.ms"
fileIn "CRToolsUI_Tools.ms"
fn LoadFunsizeLaunchSettings iniPath = (

	global FunsizeLaunchInfo, CarmaSettings
	
	FunsizeLaunchInfo = CarmaSettings.FunsizeSettings
	/*
	if FunsizeLaunchInfo == undefined then (
		FunsizeLaunchInfo = FunsizePackAndLaunchDetails()
	)
	if hasINISetting iniPath "Funsize" then (
		FunsizeLaunchInfo.ADB = getINISetting iniPath "Funsize" "ADB"
		FunsizeLaunchInfo.DeviceIP = getINISetting iniPath "Funsize" "DeviceIP"
		FunsizeLaunchInfo.GibbedPacker = getINISetting iniPath "Funsize" "GibbedPacker"
		FunsizeLaunchInfo.ObbPacker = getINISetting iniPath "Funsize" "ObbPacker"
		FunsizeLaunchInfo.WorkingFolder = getINISetting iniPath "Funsize" "WorkingFolder"
		if FunsizeLaunchInfo.WorkingFolder[FunsizeLaunchInfo.WorkingFolder.Count] != "\\" then FunsizeLaunchInfo.WorkingFolder = FunsizeLaunchInfo.WorkingFolder +"\\"

		FunsizeLaunchInfo.DataFolder = getINISetting iniPath "Funsize" "DataFolder"
		if FunsizeLaunchInfo.DataFolder[FunsizeLaunchInfo.DataFolder.Count] != "\\" then FunsizeLaunchInfo.DataFolder = FunsizeLaunchInfo.DataFolder +"\\"
		
		FunsizeLaunchInfo.ObbName = getINISetting iniPath "Funsize" "ObbName"
		FunsizeLaunchInfo.WadName = getINISetting iniPath "Funsize" "WadName"

		if (getINISetting iniPath "Funsize" "AutoLaunchGame") == "true" then (
			FunsizeLaunchInfo.AutoLaunchGame = true
		)
		else (
			FunsizeLaunchInfo.AutoLaunchGame = false
		)
		if (getINISetting iniPath "Funsize" "AutoDeployObb") == "true" then (
			FunsizeLaunchInfo.AutoDeployObb = true
		)
		else (
			FunsizeLaunchInfo.AutoDeployObb = false
		)
		if (getINISetting iniPath "Funsize" "AutoBuild") == "true" then (
			FunsizeLaunchInfo.AutoBuild = true
		)
		else (
			FunsizeLaunchInfo.AutoBuild = false
		)
	)
	else (
		FunsizeLaunchInfo.ADB = ""
		FunsizeLaunchInfo.DeviceIP = ""
		FunsizeLaunchInfo.GibbedPacker = ""
		FunsizeLaunchInfo.ObbPacker = ""
		FunsizeLaunchInfo.WorkingFolder = ""
		FunsizeLaunchInfo.DataFolder = ""
		FunsizeLaunchInfo.ObbName = "main.507.com.stainlessgames.carmageddon.obb"
		FunsizeLaunchInfo.WadName = "Data_Android.wad"

		FunsizeLaunchInfo.AutoLaunchGame = false
		FunsizeLaunchInfo.AutoDeployObb = false
		FunsizeLaunchInfo.AutoBuild = false
		
	)
	*/
)
fn ToolsStartup = 
(
	global CRToolsUI
		currentScriptFileName = getThisScriptFilename()
		currentScriptFolder = getFilenamePath currentScriptFileName

		global CarmaSettings = CRSettings()
		CarmaSettings.Load (currentScriptFolder+"CarmaReincarnationToolsSettings.ini")
		/*
		CarmaSettings.GamePath = getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "GamePath"
		if (getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "AllowSeperateDataCore") == "true" then
		(	
			CarmaSettings.AllowSeperateDataCore = true
			CarmaSettings.DataCorePath = getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "DataCorePath"
		)
		else
		(
			CarmaSettings.AllowSeperateDataCore = false
			CarmaSettings.DataCorePath = CarmaSettings.GamePath+"\\Data_Core"
		)
		--CarmaSettings.DataCorePath = getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "DataCorePath"
		if (getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "ConvertTexturesInPlace") == "true" then
			CarmaSettings.ConvertTexturesInPlace = true
		else
			CarmaSettings.ConvertTexturesInPlace = false
		if (getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Transforms" "SetupForUE4") == "true" then
			CarmaSettings.SetupForUE4 = true
		else
			CarmaSettings.SetupForUE4 = false	
		CarmaSettings.TexturePath = getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "TextureConversionPath"
		CarmaSettings.GibbedTools = getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "GibbedTools"
		CarmaSettings.LOLDecoder = getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "LOLDecoder"
		CarmaSettings.MaxResolution = getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Textures" "MaxResolution"
		
		if (getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "UI" "UseNewUI") == "true" then
			CarmaSettings.UseNewUI = true
		else
			CarmaSettings.UseNewUI = false

		if (getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Import" "ImportTextures") == "true" then
			CarmaSettings.ImportSettings.ImportTextures = true
		else if (hasINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Import" "ImportTextures") then
			CarmaSettings.ImportSettings.ImportTextures = false

		if (getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Import" "UserPrepData") == "true" then
			CarmaSettings.ImportSettings.UsePrepData = true
		else if (hasINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Import" "UserPrepData") then
			CarmaSettings.ImportSettings.UsePrepData = false

		if (getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Import" "UseTriStrips") == "true" then
			CarmaSettings.ImportSettings.UseTriStrips = true
		else if (hasINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Import" "UseTriStrips") then
			CarmaSettings.ImportSettings.UseTriStrips = false

		if (getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Import" "MergeSplits") == "true" then
			CarmaSettings.ImportSettings.MergeSplits = true
		else if (hasINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Import" "MergeSplits") then
			CarmaSettings.ImportSettings.MergeSplits = false


		if (getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Export" "ExportTextures") == "true" then
			CarmaSettings.ExportSettings.ExportTextures = true
		else if (hasINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Export" "ExportTextures") then
			CarmaSettings.ExportSettings.ExportTextures = false

		if (getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Export" "ExportMaterials") == "true" then
			CarmaSettings.ExportSettings.ExportMaterials = true
		else if (hasINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Export" "ExportMaterials") then
			CarmaSettings.ExportSettings.ExportMaterials = false

		if (getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Export" "ExportMTL") == "true" then
			CarmaSettings.ExportSettings.ExportMTL = true
		else if (hasINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Export" "ExportMTL") then
			CarmaSettings.ExportSettings.ExportMTL = false
	

*/

		LoadFunsizeLaunchSettings currentScriptFolder


		if CarmaSettings.MaxResolution != undefined then CarmaSettings.MaxResolution = CarmaSettings.MaxResolution as Integer
		else CarmaSettings.MaxResolution = 0
		if CarmaSettings.MaxResolution < 64 do CarmaSettings.MaxResolution=128
		for i=1 to MaxTextureResolutionOptions.count do
		(
			if (MaxTextureResolutionOptions[i] as Integer) == CarmaSettings.MaxResolution do
			(
				CarmaSettings.MaxResolutionID = i
				i=MaxTextureResolutionOptions.count+1
			)
		)
		if CarmaSettings.MaxResolutionID==undefined do CarmaSettings.MaxResolutionID=6
		
		if CarmaSettings.GibbedTools == "" then CarmaSettings.GibbedTools = (currentScriptFolder+"Gibbed.Duels.FileFormats.dll")
		if CarmaSettings.LOLDecoder == "" then CarmaSettings.LOLDecoder = (currentScriptFolder+"LOLDecoderLib.dll")
			
				dllpath = GetFilenamePath CarmaSettings.GibbedTools
				local gibbedAssembly = dotNet.loadAssembly (dllpath+"Gibbed.Duels.FileFormats.dll")
				local gibbedIOAssembly = dotNet.loadAssembly (dllpath+"Gibbed.IO.dll")
				local gibbedSquishAssembly = dotNet.loadAssembly (dllpath+"Gibbed.Squish.dll")
				local imgAssembly = dotNet.loadAssembly (dllpath+"IMGToolLib.dll")
				--local gibbedAssembly = dotNet.loadAssembly CarmaSettings.GibbedTools
				local dotNetType = gibbedAssembly.GetType "Gibbed.Stainless.TDXConvertLib.ConvertTDX"
				local gibbedConvertClass = (dotnetClass "System.Activator").CreateInstance dotNetType
		
				loldecdllpath = GetFilenamePath CarmaSettings.LOLDecoder
				local gibbedAssembly = dotNet.loadAssembly (loldecdllpath+"LOLDecoderLib.dll")
				local LDdotNetType = gibbedAssembly.GetType "LOLDecoder.LOLDecoderLib"
				local lolDecoderClass = (dotnetClass "System.Activator").CreateInstance LDdotNetType

				
				local imgtooldotNetType = imgAssembly.GetType "IMGToolLib.IMGTool"
				local imgConvertClass = (dotnetClass "System.Activator").CreateInstance imgtooldotNetType

				local toxicRagersAssembly = dotnet.loadAssembly (dllpath+"toxicragers.dll")
				local toxicRagersAssembly = dotnet.loadAssembly (dllpath+"CMDControls.dll")
		format "GamePath: %\nTexturePath: %\n GibbedTools: %\nToxicRages: %\n" CarmaSettings.GamePath CarmaSettings.TexturePath CarmaSettings.GibbedTools (dllpath+"toxicragers.dll")
		if CarmaSettings.GamePath == undefined or CarmaSettings.GamePath == "" then
		(
			--parentDialogs = windows.getChildrenHWND #max
			--PrintArrayInFull parentDialogs "Dialogs"
			--parentDialog = windows.getChildHWND #max "Carmageddon Reincarnation Tools"
			createDialog carma_reincarnation_settings 300 790 parent:CRToolsUI.handle
		)
)

fn CloseUI =
(
	global CRToolsUI
	
	try(
		if carma_reincarnation_dockfloater.dialogbar then cui.UnRegisterDialogBar carma_reincarnation_dockfloater
	) catch()
	
	destroydialog carma_reincarnation_dockfloater
	if CRToolsUI != undefined then
	(
		--CRToolsUI.close()
		CRToolsUI = undefined
		--gc light:true
	)
)

fn CreateUI =
(
	global CRToolsUI
	global CRToolsFloater
	ToolsStartup()

	global CarmaSettings
	if CarmaSettings.UISettings.UseNewUI then (
		CreateNewUI()
	)
	else (
		if CRToolsUI != undefined then
		(
			--CRToolsUI = undefined
			--CRToolsUI.close()
			--CRToolsUI.dispose()
			--gc()
		)
		try(
			if carma_reincarnation_dockfloater.dialogbar then cui.UnRegisterDialogBar carma_reincarnation_dockfloater
		) catch()
		destroydialog carma_reincarnation_dockfloater
		CRToolsFloater = createDialog carma_reincarnation_dockfloater style:#(#style_titlebar, #style_border, #style_sysmenu, #style_resizing)
		cui.RegisterDialogBar carma_reincarnation_dockfloater style:#(#cui_floatable,#cui_dock_left,#cui_handles) minSize:[470,500] maxSize:[-1,-1]
		--cui.DockDialogBar carma_reincarnation_dockfloater #cui_dock_left
		--CRToolsUI	= dotNetObject "maxCustomControls.maxForm"
		--CRToolsUI.Width = 405
		--CRToolsUI.Height = 500
		--CRToolsUI.Text = "Carmageddon Reincarnation Tools"
		
		maxHandlePointer=(Windows.GetMAXHWND())
		sysPointer = DotNetObject "System.IntPtr" maxHandlePointer
			
		--maxHwnd = (dotnetclass "System.Windows.Forms.Control").fromHandle sysPointer --DotNetObject "MaxCustomControls.Win32HandleWrapper" sysPointer
		--CRToolsUI.show(maxHwnd)
			
			tabs = SetupTabs CRToolsUI labels:#("Import", "Export", "Tools", "About") Layout:(DN_ControlLayout AnchorStyles:#("Left","Right","Top","Bottom") BackColor:(CRToolsUI.backColor.FromARGB 255  60 60 60) Height:500 Width:(CRToolsUI.Width))
			--showProps tabs doClearListener:true
		CR_SetupImportTab tabs.tabPages.Item[0]
		CR_SetupExportTab tabs.tabPages.Item[1]
		CR_SetupToolsTab tabs.tabPages.Item[2]
				
				
			
		CRToolsUI
	)
)
