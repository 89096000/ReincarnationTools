fn KeepMaxAlive =
(
	 if (MaxVersion())[1] >= 9000 do (dotnetClass "Application").doEvents()
)
fn InvLerp a b v = (
	va = v - a
	ba = b - a
	t = va / ba
	t
)
fn AddCustomModifier obj modifierName custattrib allowMultiple:false = (

	accessoryModifier = obj.modifiers[modifierName]
	if accessoryModifier == undefined or allowMultiple then (
		max modify mode
		accessoryModifier = emptyModifier()
		
		accessoryModifier.name = modifierName
		addModifier obj accessoryModifier
		custattributes.add accessoryModifier custattrib baseObject:false
	)
	accessoryModifier

)

fn Lerp a b t = (
	it = 1.0 - t
	v = it * a + b * t
	v
)
fn RenameDuplicateParts = (
	for obj in objects do (
		duplicateNames = 1
		for obj2 in objects do (
			if obj2.name == obj.name and obj2 != obj then ( 
				duplicateNames = duplicateNames + 1
				obj2.name = obj2.name + "_" + (duplicateNames as string)
				format "duplicate name of % found: %. renaming to %_%\n" obj.name obj2.name obj2.name duplicateNames
			)
		)
		if duplicateNames > 1 then (
			obj.name = obj.name + "_1"
			
		)
	)
)
fn GetFolderName filepath = (
	pathParts = filterstring (getFilenamePath filepath) "\\/"
	pathParts[pathParts.count]
)
fn DisableProcessWindowsGhosting =
(
    if classof (dotnet.GetType "DisableWindowsGhosting")!=dotNetObject do
    (
        local source = StringStream ("
            using System.Runtime.InteropServices;

public class DisableWindowsGhosting
{
    [DllImport(\"user32.dll\")]
    public static extern bool DisableProcessWindowsGhosting();
}")

        compilerParams = dotnetobject "System.CodeDom.Compiler.CompilerParameters"
        compilerParams.ReferencedAssemblies.Add("System.dll");
        compilerParams.GenerateInMemory = on
        csharpProvider = dotnetobject "Microsoft.CSharp.CSharpCodeProvider"
        compilerResults = csharpProvider.CompileAssemblyFromSource compilerParams #(source as String)
        flush source
        close source
        if (compilerResults.Errors.Count > 0 ) then
        (
            local errs = stringstream ""
            for i = 0 to (compilerResults.Errors.Count-1) do
            (
                local err = compilerResults.Errors.Item[i]
                format "Error:% Line:% Column:% %\n" err.ErrorNumber err.Line err.Column err.ErrorText to:errs
            )
            format "%\n" errs
            undefined
        )
        else
        (
            compilerResults.CompiledAssembly.CreateInstance "DisableWindowsGhosting"
        )
    )
)

fn buildcarmaindicesarray m = (
	indices = #()
	verts=#()
	t_verts=#()
	vertstrings=#()
	
	model = snapshotasmesh m
	mfaces = getNumFaces model
	tvcount = getnumtverts model
	if tvcount != 0 then
	(
		for i=1 to mfaces do (--build verts list
			faceverts = getFace model i
			faceuvs = gettvface model i
			newface = [1,1,1]
			for j=1 to 3 do (
				vert = getvert model faceverts[j]
				uv = gettvert model faceuvs[j]
				index = faceverts[j]
				vertstring = (#(vert,uv) as string)
				vertcheck = finditem vertstrings vertstring
				if vertcheck == 0 then (
					append verts vert
					append t_verts uv
					append indices index
					append vertstrings vertstring
				)
			)
		)
	)
	return indices
)

fn StopNullNodesRendering = (
	for obj in objects where (classof obj.baseObject) != CarmaHelper_WheelPlaceholder and (classof obj.baseObject) != CarmaHelper_AccessoryPlaceholder and (IsObjectANullCNT obj or (classof obj.baseObject) == CarmaHelper_JointHelper)  do ( 
		obj.castShadows=false
		obj.primaryVisibility=false
	)
)

fn ReplaceWheelsWithTempMeshes = (


)

fn ScatterObjectsOnMesh target objects count countIsPerArea:false = (
	
)

fn computeConvexHull theNode maxVerts:64 pushAmt:0.0 cleanup:true = (
	with redraw off (
		/*local rb = MassFX_RBody()
		select theNode
		local cmdMode = getCommandPanelTaskMode()		-- store previous mode
		setCommandPanelTaskMode #modify
		addModifier theNode rb
		rb.meshVerticesLimit  = maxVerts
		rb.meshType = 4  		-- 3 = capsule, 4 = convex
		rb.meshInflation = pushAmt
		rb.RBMeshRegenerate 1
		hull = rb.RBMeshConvertToCustomMesh 1
		if isValidNode hull then (
			hull.name += "_Hull"
		-- RBMeshCustomNodeExtract 
		)
		if cleanup then (
			deleteModifier theNode 1
			setCommandPanelTaskMode cmdMode		-- restore previous mode
		)*/
		hull = Editable_Mesh name:(theNode.name + "_hull")
		hull.mesh = nvpx.CreateBoundingConvex theNode maxVerts pushAmt
		hull.pivot = hull.center
		hull.pos = theNode.center
		hull.pivot = [0,0,0]
	)
	hull
)
fn SearchUniqueVerts pos vert = (
	if pos < vert.pos then -1
	else if pos > vert.pos then 1
	0
)
fn StringIsInt str = 
(
	(str as integer) as string == str
)
fn StringIsFloat str = 
(
	rx =  dotnetobject "System.Text.RegularExpressions.Regex" "^[-]?[0-9]+\.[0-9]+$"
	rx.isMatch str
)
fn StringIsPoint3 str = 
(
	
	rx =  dotnetobject "System.Text.RegularExpressions.Regex" "^[-]?[0-9]+\.[0-9]+[\s]*,[\s]*[-]?[0-9]+\.[0-9]+[\s]*,[\s]*[-]?[0-9]+\.[0-9]+$"
	rx.isMatch str
)
fn StringAsPoint3 str = 
(
	
	rx =  dotnetobject "System.Text.RegularExpressions.Regex" "^([-]?[0-9]+\.[0-9]+)[\s]*,[\s]*([-]?[0-9]+\.[0-9]+)[\s]*,[\s]*([-]?[0-9]+\.[0-9]+)$"
	matches = rx.Match str
	
	 [matches.Groups.Item[1].Value as float, matches.Groups.Item[2].Value as float, matches.Groups.Item[3].Value as float]
)
fn StringAsPoint2 str = 
(
	
	rx =  dotnetobject "System.Text.RegularExpressions.Regex" "^([-]?[0-9]+\.[0-9]+)[\s]*,[\s]*([-]?[0-9]+\.[0-9]+)"
	matches = rx.Match str
	
	 [matches.Groups.Item[1].Value as float, matches.Groups.Item[2].Value as float]
)
fn GetBonesFromSkin skinMod =
(
	boneArray = for o in objects where (refs.dependencylooptest skinMod o) collect o
	
	for i=1 to boneArray.count do
	(
		if boneArray[i].parent != undefined and (finditem boneArray boneArray[i].parent) == 0 then append boneArray boneArray[i].parent
	)
	 boneArray
)
fn GetRootBoneFromSkin skinMod =
(
	boneArray = for o in objects where (refs.dependencylooptest skinMod o) collect o
rootbone = undefined
	for i=1 to boneArray.count do
	(
		if boneArray[i].parent == undefined then rootbone = boneArray[i]
	)
	--return boneArray
	rootbone
)
fn showProps obj doClearListener:false=
	(
		if doClearListener then clearListener()
		format "Properties:\n"
		showProperties obj
		format "\nMethods:\n"
		showMethods obj
		format "\nEvents:\n"
		showEvents obj
	) 
fn FindObjectByPosition pos notTheseObjs:#() onlyPointHelpers:false =
(
	foundobjs = #()
	for obj in objects where ((distance pos obj.position) == 0 and (finditem notTheseObjs obj)==0) do
	(
		if onlyPointHelpers == false or (classof obj) == pointhelper then append foundobjs obj
	)
--	format "Ive FoundObjs: %\n" foundobjs
foundobj = undefined
	if foundobjs.count > 0 then foundobj = foundobjs[1]
	
	foundobj
)

fn quatdot q1 q2 =
(
	q1.w*q2.w + q1.x* q2.x + q1.y*q2.y + q1.z*q2.z
)
fn ConvertFromCRSpace pos noflip:false=
(
	if noflip then
		[pos.x,pos.z,pos.y]
	else
		[-pos.x,-pos.z,pos.y]
)
fn ConvertToCRSpace pos noflip:false =
(
	if noflip then
		[pos.x,pos.z,pos.y]
	else
		[-pos.x,pos.z,-pos.y]
)
fn ConvertQuatFromCRSpace q =
(
	 (quat q.y -q.x q.w q.z)
)
fn ConvertQuatToCRSpace q =
(
	 (quat -q.y q.x q.w q.z)
)

fn ConvertQuatFromCRSpace2 q =
(
	 (quat -q.x q.z -q.y q.w)
)
fn ConvertQuatToCRSpace2 q =
(
	 (quat -q.x -q.z q.y q.w)
)
fn GetAllChildren obj &arr:#() =
(
	for c in obj.children do
	(
		append arr c
		GetAllChildren c arr:arr
	)
	 arr
)
fn GetDescendantByName obj nodeName =
(

	foundobj = undefined
	if tolower(nodeName) == tolower(obj.name) then foundobj = obj
	else
	(
				allchildren = GetAllChildren obj arr:#()
				for c in allchildren do
				(
					if tolower(nodeName) == tolower(c.name) then foundobj = c
				)
	)
	foundobj
)
fn getNodeByName2 nodeName =
(
	foundobj = undefined
	for obj in objects do
	(
		if (stricmp obj.name nodeName) == 0 then 
		(
			--format "Found %\n" obj.name
			foundobj = obj
		)
	)
	--format "Didn't find object named %\n" nodeName
	foundobj
)
fn getBoneByName nodeName =
(
	foundobj = undefined
	for obj in objects do
	(
		if (stricmp obj.name nodeName) == 0 and (classof obj)== BoneGeometry then 
		(
			--format "Found %\n" obj.name
			foundobj = obj
		)
	)
	--format "Didn't find object named %\n" nodeName
	foundobj
)

fn DecodeLOLFile filename =
(
	decodedLOL = undefined
	if ((dotnetclass "System.IO.File").exists filename) then
	(
		LOLDecoder = dotnetclass "LOLDecoder.LOLDecoderLib"
		
		decodedLOL = LOLDecoder.DecodeLOLFile filename
		
	)
	decodedLOL
)

fn ReloadButton_Pressed sender arg =
(
	
		if carma_reincarnation_dockfloater.dialogbar then cui.UnRegisterDialogBar carma_reincarnation_dockfloater
	
	
	destroydialog carma_reincarnation_dockfloater
	filein "ReincarnationTools.ms"
)

fn Close_Pressed sender arg =
(
	
		if carma_reincarnation_dockfloater.dialogbar then cui.UnRegisterDialogBar carma_reincarnation_dockfloater
	
	
	destroydialog carma_reincarnation_dockfloater
)

struct BatchRouteTopType (Name, SubTypes, Values)
struct BatchRouteSubType (Name, Values)
fn BatchLevelRoutesButton_Pressed sender arg =
(
	global CarmaSettings
	
	levelsPath = CarmaSettings.DataCorePath+"/Content/Levels/"
	
	levelsList= getDirectories(levelsPath+"*")
	
	AILinkTypes = #()
	AINodeTypes = #()
	TopSectionTypes = #()
	
	
	for i=1 to levelsList.count do
	(
		if ((dotnetclass "System.IO.File").exists (levelsList[i]+"routes.txt")) then
		(
			splitDir = filterstring levelsList[i] "\/"
			levelName = splitDir[splitDir.count]
			routesText = openfile (levelsList[i]+"routes.txt") mode:"r"
			
			lineNum=0
			activeType=undefined
			activeSubType = undefined
			
			while not (eof routesText) do
			(
				lineNum += 1
				
				curline = trimLeft (trimRight (readline routesText))
				if curline[1] == "[" then
				(
					foundType = false
					for topType in TopSectionTypes where (toupper topType.Name) == (toupper curLine) do 
					(
						activeType = topType
						foundType = true
					)
					if not foundType then
					(
						activeType = BatchRouteTopType Name:curLine SubTypes:#() Values:#()
						append TopSectionTypes activeType
						activeSubType = undefined
					)
				)
				else if curline[1] == "<" then
				(
					foundType = false
					for subType in activeType.SubTypes where (toupper subType.Name) == (toupper curLine) do
					(
						foundType = true
						activeSubType = subType
					)
					if not foundType then
					(
						activeSubType = BatchRouteSubType Name:curLine Values:#()
						append activeType.SubTypes activeSubType
					)
				)
				else if activeSubType == undefined and activeType != undefined then
				(
					if StringIsInt curLine then appendIfUnique activeType.Values "INTEGER"
					else if StringIsFloat curLine then appendIfUnique activeType.Values "FLOAT"
					else if StringIsPoint3 curLine then appendIfUnique activeType.Values "POINT3"
					else appendIfUnique activeType.Values curLine
				)
				else if activeSubType != undefined then
				(
					if StringIsInt curLine then appendIfUnique activeSubType.Values "INTEGER"
					else if StringIsFloat curLine then appendIfUnique activeSubType.Values "FLOAT"
					else if StringIsPoint3 curLine then appendIfUnique activeSubType.Values "POINT3"
					else appendIfUnique activeSubType.Values curLine
				)
			)
			
		)
	)
			for topType in TopSectionTypes do
			(
				format "%\n" topType.Name
				if topType.SubTypes.count > 0 do format "Potential Sub Types:\n"
				for subType in topType.SubTypes do
				(
					format "\t%\n" subType.Name
					if subType.Values.count > 0 do format "\tPotential Values:\n"
					for val in subType.Values do
					(
						format "\t\t%\n" val
					)
				)
				if topType.Values.count > 0 do format "Potential Values:\n"
				for val in topType.Values do
				(
					format "\t%\n" val
				)
			)
)

fn BatchCarSetupLOLsButton_Pressed sender arg =
(
	global CarmaSettings
	
	vehiclesPath = CarmaSettings.DataCorePath+"/Content/Vehicles/"
	
	vehiclesList = getDirectories(vehiclesPath+"*")
	
	funcTypes = #()
	funcArgs = #()
	funcArgCars = #()
	for i=1 to vehiclesList.count do
	(
		if (dotnetclass "System.IO.File").exists (vehiclesList[i]+"setup.lol") then
		(
			splitDir = filterstring vehiclesList[i] "\/"
			carName = splitDir[splitDir.count]
			lolscript = StringStream (DecodeLOLFile (vehiclesList[i]+"setup.lol"))
				lineNum = 0
			while (eof lolscript) == false do
			(
				lineNum += 1
				curline = trimLeft (trimRight (readline lolscript))
				splitLine = filterstring curline "()"
				--format "%\n" splitline
				--format "Line %: % \n" lineNum curline
				if curline=="" or splitLine[1] == undefined or splitLine[2] == undefined then continue
					
				funcPos = finditem funcTypes (trimLeft (trimRight splitLine[1]))
				if funcPos == 0 then
				(
					append funcTypes (trimLeft (trimRight splitLine[1]))
					append funcArgs #(splitline[2])
					append funcArgCars #(carName)
				)
				else
				(
					argPos = findItem funcArgs[funcPos] (trimLeft (trimRight splitline[2]))
					if argPos == 0 then
					(
						append funcArgs[funcPos] (trimLeft (trimRight splitline[2]))
						append funcArgCars[funcPos] carName
					)
					else
					(
						funcArgCars[funcPos][argPos] = funcArgCars[funcPos][argPos] + ", " + carName
					)
				)
			)
		)
	)
	
	outputtext = ""
	attribText = "CarSetupLOLAttrib = attributes CarSetuLOLAttrib_Def  attribID:"+(genclassid() as string)+" version:1\n(\n"
	attribText += "\tparameters"
	
	for i=1 to funcTypes.count do
	(
		if funcTypes[i] == undefined then continue
		outputtext = outputtext+ "\nFunc #"+(i as string)+": "+funcTypes[i]+"\n"
		
		for j=1 to 1 do -- funcArgs[i].count do
		(
			outputtext = outputtext + "\t Args for car(s): "+funcArgCars[i][j]+"\n\t\t"+funcArgs[i][j]+"\n"
		)
	)
	attribText = ")\n"
	format "\n\n\n%" outputtext
)

fn BatchCarStructureParseCData cdata carName &funcTypes &funcArgs &funcArgCars =
(
	lineNum = 0
	lolscript = StringStream cdata
	while (eof lolscript) == false do
	(
		lineNum += 1
		curline = trimLeft (trimRight (readline lolscript))
		splitLine = filterstring curline "()"
		--format "%\n" splitline
		--format "Line %: % \n" lineNum curline
		if curline=="" or (curLine[1] == "-" and curLine[2]=="-") or splitLine[1] == undefined or splitLine[2] == undefined then continue
			
		funcPos = finditem funcTypes (trimLeft (trimRight splitLine[1]))
		if funcPos == 0 then
		(
			append funcTypes (trimLeft (trimRight splitLine[1]))
			append funcArgs #(splitline[2])
			append funcArgCars #(carName)
		)
		else
		(
			argPos = findItem funcArgs[funcPos] (trimLeft (trimRight splitline[2]))
			if argPos == 0 then
			(
				append funcArgs[funcPos] (trimLeft (trimRight splitline[2]))
				append funcArgCars[funcPos] carName
			)
			else
			(
				funcArgCars[funcPos][argPos] = funcArgCars[funcPos][argPos] + ", " + carName
			)
		)
	)
)
fn BatchCarStructuresGetCData xmlnode =
(
	foundobj = ""
	for i=1 to xmlnode.childnodes.count do
	(
		child = xmlnode.childnodes.item ( i-1)
		
		if child.nodetype == child.nodetype.cdata then
		(
			foundobj = child.value
			i = xmlnode.childnodes.count + 1
		)
		--format "childnod type: %\nchildnode data:%\n\n" child.nodetype child.value
	)
	foundobj
)

fn BatchCarStructuresParseNodes xmlnode carName &partTypes &partArgs &partArgCars &weldTypes &weldArgs &weldArgCars &jointTypes &jointArgs &jointArgCars =
(
	
	CData = BatchCarStructuresGetCData xmlnode
	if CData != "" then
	(
		if xmlnode.name == "PART" or xmlnode.name == "ROOT" then
		(
			BatchCarStructureParseCData CData carName &partTypes &partArgs &partArgCars
		)
		
		else if xmlnode.name == "WELD" then
		(
			BatchCarStructureParseCData CData carName &weldTypes &weldArgs &weldArgCars
		)
		
		else if xmlnode.name == "JOINT" then
		(
			BatchCarStructureParseCData CData carName &jointTypes &jointArgs &jointArgCars
		)
	)
	
	for i=1 to xmlnode.childnodes.count do
	(
		child = xmlnode.childnodes.item ( i-1)
		if child.nodetype == child.nodetype.cdata then
		(
			
		)
		else
		(
			BatchCarStructuresParseNodes child carName &partTypes &partArgs &partArgCars &weldTypes &weldArgs &weldArgCars &jointTypes &jointArgs &jointArgCars
		)

	)
) 
fn BatchCarStructuresButton_Pressed sender arg =
(
	global CarmaSettings
	
	vehiclesPath = CarmaSettings.DataCorePath+"/Content/Vehicles/"
	
	vehiclesList = getDirectories(vehiclesPath+"*")
	
	charTypes = #()
	charArgs = #()
	charArgCars = #()
	partTypes = #()
	partArgs = #()
	partArgCars = #()
	weldTypes = #()
	weldArgs = #()
	weldArgCars = #()
	jointTypes = #()
	jointArgs = #()
	jointArgCars = #()
	
	for i=1 to vehiclesList.count do
	(
		if (dotnetclass "System.IO.File").exists (vehiclesList[i]+"structure.xml") then
		(
			splitDir = filterstring vehiclesList[i] "\/"
			carName = splitDir[splitDir.count]
			structureFileName = vehiclesList[i]+"structure.xml"
			
			dotnet.loadAssembly "system.xml"
			xmlDoc=dotNetObject "system.xml.xmlDocument"
			
			xmlDoc.load (structureFileName)
		
			characteristicsBlock = (xmlDoc.GetElementsByTagName "CHARACTERISTICS").item 0
			
			charCData = BatchCarStructuresGetCData characteristicsBlock
			BatchCarStructureParseCData charCData carName &charTypes &charArgs &charArgCars
			
			xmlRootNode = (xmlDoc.GetElementsByTagName "ROOT").item 0
			
			BatchCarStructuresParseNodes xmlRootNode carName &partTypes &partArgs &partArgCars &weldTypes &weldArgs &weldArgCars &jointTypes &jointArgs &jointArgCars
				
			
		)
	)
	
	outputtext = ""
	attribText = "CarSetupLOLAttrib = attributes CarSetuLOLAttrib_Def  attribID:"+(genclassid() as string)+" version:1\n(\n"
	attribText += "\tparameters"
	
	outputtext = outputtext + "Vehicle Characteristics:\n"
	for i=1 to charTypes.count do
	(
		if charTypes[i] == undefined then continue
		outputtext = outputtext+ "\nFunc #"+(i as string)+": "+charTypes[i]+"\t\t"+charArgs[i][1]+"\t\t"
		
		for j=1 to charArgCars[i].count do
		(
			outputtext = outputtext + charArgCars[i][j]+","
		)
	)
	
	outputtext = outputtext + "\n\nVehicle PART:\n"
	for i=1 to partTypes.count do
	(
		if partTypes[i] == undefined then continue
		outputtext = outputtext+ "\nFunc #"+(i as string)+": "+partTypes[i]+"\t\t"+partArgs[i][1]+"\t\t"
		
		for j=1 to partArgCars[i].count do
		(
			outputtext = outputtext + partArgCars[i][j]+","
		)
	)
	outputtext = outputtext + "\n\nVehicle WELD:\n"
	for i=1 to weldTypes.count do
	(
		if weldTypes[i] == undefined then continue
		outputtext = outputtext+ "\nFunc #"+(i as string)+": "+weldTypes[i]+"\t\t"+weldArgs[i][1]+"\t\t"
		
		for j=1 to weldArgCars[i].count do
		(
			outputtext = outputtext + weldArgCars[i][j]+","
		)
	)
	outputtext = outputtext + "n\nVehicle JOINT:\n"
	for i=1 to jointTypes.count do
	(
		if jointTypes[i] == undefined then continue
		outputtext = outputtext+ "\nFunc #"+(i as string)+": "+jointTypes[i]+"\t\t"+jointArgs[i][1]+"\t\t"
		
		for j=1 to jointArgCars[i].count do
		(
			outputtext = outputtext + jointArgCars[i][j]+","
		)
	)
	attribText = ")\n"
	format "\n\n\n%" outputtext
)
/********************************************
*** ATTRIBUTE HELPERS
********************************************/



/********************************************
*** IMPORT EXPORT HELPERS
********************************************/

fn ReadQuotedString f = (
	skipToString f "\""
	local str = readDelimitedString f "\""
	while str[str.count] == "\\" do (
		str = str + "\"" + readDelimitedString f "\""
	)
	str
)
fn ReadNonBlankLine f = (
	if not eof f then (
	curline = trimRight (trimLeft (readline f))
	while (curline == undefined or curline == "") and not eof f do
		curline = trimRight (trimLeft (readline f))
	)
	curline 
) 

fn writestring2 f string =
(
	writestring f string
	fseek f -1 #seek_cur
)
fn ReadString2 f fixedLen =
(
    local str = ""
    for i = 1 to fixedLen do
    (
        str0 = ReadByte f #unsigned
        if str0!=0xFD AND str0!=0xFC do str+= bit.intAsChar str0
    )
    str
)
fn witepaddedstring f str =
(
	str_length =  str.count
	str_div4 = str_length / 4
	str_plus1 = 0
	if (mod str_length 4) > 0 do
	(
		str_plus1=1
	)
	str_added = str_div4 + str_plus1
	str_padding = (str_added * 4) - str_length + 4
	writelong f str_length #unsigned
	writestring2 f str
	for i = 1 to str_padding do
	(
		writebyte f 0
	)
)
fn readpaddedstring f version61OrLess:false=
(
	str_length =  readlong f #unsigned
	str_div4 = str_length / 4
	str_plus1 = 0
	if (mod str_length 4) > 0 do
	(
		str_plus1=1
	)
	str_added = str_div4 + str_plus1
	extraPadding = 4
	if version61OrLess do extraPadding=0
	str_padding = (str_added * 4) - str_length + extraPadding
	newString = readstring2 f str_length
	for i = 1 to str_padding do
	(
		readbyte f
	)
	 newString
)


fn CheckBitIsSet flags bitNum =
(
	result = false
	if bitNum==0 then
	(
		if (bit.and flags 1)==1 then result = true
	)
	else if (bit.and flags (bit.shift 1 bitNum))==(bit.shift 1 bitNum) then result = true
	result
)
fn printFlagBits flags numBits fieldName =
(
	format "% has value of % -  " fieldName flags
	for i = (numBits-1) to 0 by -1 do
	(
		if (CheckBitIsSet flags i) then format "%" 1
		else format "%" 0
	)
	format "\n"
	
)


fn PrintArrayInFull arrayToPrint arrayName ignoreUndefined:false =
(
	txt = "\n"+arrayName+" size: "+(arrayToPrint.count as string)+" \n contents:\n"
	
	for i=1 to arrayToPrint.count do
	(
		if ignoreUndefined == false or arrayToPrint[i] != undefined do
		(
			txt += (i as string)+": "+(arrayToPrint[i] as string)+"\n"
		)
	)
	format "%\n-------------\n" txt
)
fn PrintArrayInFull2 arrayToPrint arrayName ignoreUndefined:false =
(
	format "\n\n% size: % \n" arrayName arrayToPrint.count
	format "% contents:\n" arrayName
	for i=1 to arrayToPrint.count do
	(
		if ignoreUndefined == false or arrayToPrint[i] != undefined do
		(
			format "%: %\n" i arrayToPrint[i]
		)
	)
	format "\n-------------\n"
)


fn calcMeshBoundingBox verts =
(
	local vmin = undefined
	local vmax = undefined
	for vert in verts do
	(
		if vmin == undefined then vmin = [vert.x, vert.y, vert.z]
		else
		(
			if vmin.x > vert.x do vmin.x = vert.x
			if vmin.y > vert.y do vmin.y = vert.y
			if vmin.z > vert.z do vmin.z= vert.z
		)
		if vmax == undefined then vmax = [vert.x, vert.y, vert.z]
		else
		(
			if vmax.x < vert.x do vmax.x = vert.x
			if vmax.y < vert.y do vmax.y = vert.y
			if vmax.z < vert.z do vmax.z= vert.z
		)
			
	)
	vhalfDist = (length (vmax - vmin)) / 2
	vcenter = vmin + ((vmax - vmin) / 2)
	 (mbbox vmin: vmin vmax: vmax center: vcenter halfdist: vhalfDist)
)


fn bboxHasVert bboxVerts vert =
(
	result = false
	for i=1 to bboxVerts.count do
	(
		if bboxVerts[i].x == vert.x and bboxVerts[i].y == vert.y and bboxVerts[i].z == vert.z do 
		(
			result = true
			i = bboxVerts.count + 1
		)
	)
	result
)



fn PrintMeshScript msh =
(
	m = snapshotasmesh msh
	numVerts = getNumVerts m
	numFaces = getNumFaces m
	
	format "m = mesh vertices:#("
	
	
	for i=1 to numVerts do
	(
		vert = getVert m i
		spacer=""
		if i > 1 do spacer=","
		format "%[%, %, %]" spacer vert.x vert.y vert.z
	)
	format ") faces:#("
	
	for i=1 to numFaces do
	(
		face = getFace m i
		spacer=""
		if i > 1 do spacer=","
		format "%[%, %, %]" spacer face.x face.y face.z
		
	)
	
	format ")\n"
	for i=1 to numFaces do
	(
		smoothingGroup = getFaceSmoothGroup m i
		matID = getfacematid m i
		
		format "setFaceSmoothGroup m % %\n" i smoothingGroup
		format "setFaceMatID m % %\n" i matID
		
	)
	
)

fn SplitVertexNormals =
(
	oldTransform = selection[1].transform
	selection[1].transform = matrix3 1
	m = snapshotasmesh selection[1]
	
	newVertsList = #()
	faceNewVertInds = #()
	
	vertNormals = #()
	faceIndicesForNormals =#()
	for i=1 to (getNumFaces m) do
	(
		verts = getFace m i
		rNorms = meshop.getFaceRNormals m i
		
		if(vertNormals[verts.x] == undefined) do
		(
			vertNormals[verts.x] = #()
			faceIndicesForNormals[verts.x] = #()
		)
		if(vertNormals[verts.y] == undefined) do 
		(
			vertNormals[verts.y] = #()
			faceIndicesForNormals[verts.y] = #()
		)
		if(vertNormals[verts.z] == undefined) do 
		(
			vertNormals[verts.z] = #()
			faceIndicesForNormals[verts.z] = #()
		)
		
		if (finditem vertNormals[verts.x] rNorms[1])==0 then
		(	
			append vertNormals[verts.x] rNorms[1]
			faceIndicesForNormals[verts.x][vertNormals[verts.x].count] = #(i)
		)
		else
		(
			
			append faceIndicesForNormals[verts.x][(finditem vertNormals[verts.x] rNorms[1])] i
		)
		if (finditem vertNormals[verts.y] rNorms[2])==0 then
		(
			append vertNormals[verts.y] rNorms[2]
			faceIndicesForNormals[verts.y][vertNormals[verts.y].count] = #(i)
		)
		else
		(
			
			append faceIndicesForNormals[verts.y][(finditem vertNormals[verts.y] rNorms[2])] i
		)
		if (finditem vertNormals[verts.z] rNorms[3])==0 then
		(
			append vertNormals[verts.z] rNorms[3]
			faceIndicesForNormals[verts.z][vertNormals[verts.z].count] = #(i)
		)
		else
		(
			
			append faceIndicesForNormals[verts.z][(finditem vertNormals[verts.z] rNorms[3])] i
		)
	)
	
	for i=1 to (getNumVerts m) do
	(
		
		pos = getVert m i
		normalsForThisVert = vertNormals[i]
		faceIndicesForThisVert = faceIndicesForNormals[i]
		--facesForVert = meshop.getFacesUsingVert m #(i)
		
		for j=1 to normalsForThisVert.count do
		(
			currentVertNormal = normalsForThisVert[j]
			faceIndicesForThisNormal = faceIndicesForThisVert[j]
			append newVertsList #(pos,currentVertNormal)
			for k=1 to faceIndicesForThisNormal.count do
			(
				oldFaceVerts = getFace m faceIndicesForThisNormal[k]
				if(faceNewVertInds[faceIndicesForThisNormal[k]] == undefined) do faceNewVertInds[faceIndicesForThisNormal[k]] = #()
				faceNewVertInds[faceIndicesForThisNormal[k]][i] = newVertsList.count
			)
		)
	)
	format "FaceNewVertInds:\n\n"
	for i=1 to faceNewVertInds.count do
	(
		format "%: #(   " i
		for j=1 to faceNewVertInds[i].count where faceNewVertInds[i][j] != undefined do
		(
			format "%: %    " j faceNewVertInds[i][j]
		)
		format ") \n"
	)
	format "\n\n\n\n"
	
		--selection[1].transform = oldTransform 
		--return 0
		newM = trimesh()
		setNumVerts newM newVertsList.count
		for i=1 to newVertsList.count do
		(
			setVert newM i newVertsList[i][1]
			setNormal newM i newVertsList[i][2]
			--setNormal m i uniqueVerts[i].norm
		)
		
		setNumFaces newM (getNumFaces m)
		for i=1 to (getNumFaces m) do
		(
			oldVertInds = getFace m i
			setFace newM i faceNewVertInds[i][oldVertInds.x] faceNewVertInds[i][oldVertInds.y] faceNewVertInds[i][oldVertInds.z]
			setEdgeVis newM i 1 true
			setEdgeVis newM i 2 true
			setEdgeVis newM i 3 true
			setFaceNormal newM i (getFaceNormal m i)
			setFaceMatID newM i (getFaceMatID m i)
			setFaceSmoothGroup newM i (getFaceSmoothGroup m i)
		)
		finalMesh = mesh mesh:newM
		finalMesh.transform = oldTransform
		selection[1].transform = oldTransform 
)


fn IsObjectAPedBonesList obj =
(
	 (obj.modifiers["Ped Bones List"] != undefined)
)

fn SetMeshVertColoursToGrey obj = (
	verts = obj.verts as bitarray
	for v in verts do setVertColor obj v (color 127 127 127)
)

fn BeginEditMesh obj = (

	mods = #()
	for m in obj.modifiers do (
		append mods m
	)
	for m in mods do(
		deletemodifier obj m
	)
	
	mods
)
fn EndEditMesh obj mods = (
	for m in mods do(
		addmodifier obj m
	)
	

)
fn RotatePivotOnly obj rotation = (
	local rotValInv=inverse (rotation as quat)
	animate off in coordsys local obj.rotation*=RotValInv
	obj.objectoffsetpos*=RotValInv
	obj.objectoffsetrot*=RotValInv
)
fn scaleMesh obj scale = (
	oldMods = BeginEditMesh obj
	numVerts = getNumVerts obj
	in coordsys obj (
	for i =1 to numverts do (
		v = getvert obj i
		v = v * scale
		setvert obj i v
	)
	)	
	update obj
	EndEditMesh obj oldMods
)

fn flipMesh obj = (
	oldMods = BeginEditMesh obj
	numVerts = getNumVerts obj
	in coordsys obj (
	for i =1 to numverts do (
		v = getvert obj i
		v.x = -v.x
		setvert obj i v
	)
	
	numfaces = getnumfaces obj
	for i = 1 to numfaces do (
		f = getface obj i
		v1 = f.x
		f.x = f.y
		f.y = v1
		setface obj i f
		tvf = gettvface obj i
		v1 = tvf.x
		tvf.x = tvf.y
		tvf.y = v1
		settvface obj i tvf
	)
	
	)	
	update obj
	EndEditMesh obj oldMods
	
)
