extends Control

onready var playerNameLabel = $"PanelContainer/Attributes/Name/Name LineEdit"
onready var lvLabel = $"PanelContainer/Attributes/Level/Level LineEdit"
onready var lvDiff =  $"PanelContainer/Attributes/Level/Level Change"

onready var SchoolWindow: = preload("res://SchoolWindowDialog.tscn")

onready var attributeLabelList = [
	$"PanelContainer/Attributes/Vitality/Vitality Value",
	$"PanelContainer/Attributes/Mind/Mind Value",
	$"PanelContainer/Attributes/Strength/Strength Value",
	$"PanelContainer/Attributes/Power/Power Value",
	$"PanelContainer/Attributes/Defense/Defense Value",
	$"PanelContainer/Attributes/Resistance/Resistance Value",
	$"PanelContainer/Attributes/Speed/Speed Value",
	$"PanelContainer/Attributes/Technique/Technique Value"
]

onready var attributeLabel = $"PanelContainer/Attributes/Attribute Points/Attribute Value"
onready var schoolLabel = $"PanelContainer/Attributes/School Points/School Value"
onready var confirmButton = $"PanelContainer/Attributes/HBoxContainer3/Confirm"
onready var revertButton = $"PanelContainer/Attributes/HBoxContainer3/Revert"

onready var attributeNumList = [0,0,0,0,0,0,0,0]

onready var schlLabelList = [
	$"PanelContainer2/AbilityTab/Schools/VBoxContainer/Magic School 1/Magic School 1 Level",
	$"PanelContainer2/AbilityTab/Schools/VBoxContainer/Magic School 2/Magic School 2 Level",
	$"PanelContainer2/AbilityTab/Schools/VBoxContainer/Magic School 3/Magic School 3 Level",
	$"PanelContainer2/AbilityTab/Schools/VBoxContainer/Magic School 4/Magic School 4 Level",
	$"PanelContainer2/AbilityTab/Schools/VBoxContainer/Magic School 5/Magic School 5 Level",
	$"PanelContainer2/AbilityTab/Schools/VBoxContainer/Magic School 6/Magic School 6 Level",
	$"PanelContainer2/AbilityTab/Schools/VBoxContainer/Magic School 7/Magic School 7 Level",
	$"PanelContainer2/AbilityTab/Schools/VBoxContainer/Magic School 8/Magic School 8 Level",
	$"PanelContainer2/AbilityTab/Schools/VBoxContainer/Magic School 9/Magic School 9 Level",
	$"PanelContainer2/AbilityTab/Schools/VBoxContainer2/Physical School 1/Physical School 1 Level",
	$"PanelContainer2/AbilityTab/Schools/VBoxContainer2/Physical School 2/Physical School 2 Level",
	$"PanelContainer2/AbilityTab/Schools/VBoxContainer2/Physical School 3/Physical School 3 Level",
	$"PanelContainer2/AbilityTab/Schools/VBoxContainer2/Physical School 4/Physical School 4 Level",
	$"PanelContainer2/AbilityTab/Schools/VBoxContainer2/Physical School 5/Physical School 5 Level",
	$"PanelContainer2/AbilityTab/Schools/VBoxContainer2/Physical School 6/Physical School 6 Level",
	$"PanelContainer2/AbilityTab/Schools/VBoxContainer2/Physical School 7/Physical School 7 Level",
	$"PanelContainer2/AbilityTab/Schools/VBoxContainer2/Physical School 8/Physical School 8 Level",
	$"PanelContainer2/AbilityTab/Schools/VBoxContainer2/Physical School 9/Physical School 9 Level"]

var playerName
var lvNum
var AttributeNum

var tempAttList = [0,0,0,0,0,0,0,0]

var tempLv = 1

var schoolPoints = 0
var schoolRanks = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
var tempSchoolRanks = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$MainMenuButton.get_popup().add_item("New Character")
	$MainMenuButton.get_popup().add_item("Open Character")
	$MainMenuButton.get_popup().add_item("Save Character")
	$MainMenuButton.get_popup().add_item("Quit")
	$MainMenuButton.get_popup().connect("id_pressed", self, "_on_MainMenuButton_pressed")
	
	#$SchoolWindowDialog.popup()
	#$FileDialog.popup()
	
	playerName = playerNameLabel.text
	lvNum = int(lvLabel.text)
	attributeNumList[0] = int(attributeLabelList[0].text)
	attributeNumList[1] = int(attributeLabelList[1].text)
	attributeNumList[2] = int(attributeLabelList[2].text)
	attributeNumList[3] = int(attributeLabelList[3].text)
	attributeNumList[4] = int(attributeLabelList[4].text)
	attributeNumList[5] = int(attributeLabelList[5].text)
	attributeNumList[6] = int(attributeLabelList[6].text)
	attributeNumList[7] = int(attributeLabelList[7].text)
	AttributeNum = int(attributeLabel.text)
	schoolPoints = int(schoolLabel.text)
	confirmButton.disabled = true
	revertButton.disabled = true
	
	CalculateAttributes(lvNum)
	CalculateSchoolPoints(lvNum)
	UpdateCharacterDetails()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Name_LineEdit_text_changed(new_text):
	playerName = playerNameLabel.text

func onAttributeButtonPressPlus(plus, id):
	if(plus == true):
		if(AttributeNum > 0 && !AttributeLevelCap(attributeNumList[id])):
			attributeNumList[id] += 1
			attributeLabelList[id].text = String(attributeNumList[id])
			tempAttList[id] += 1
			AttributeNum -= 1
			attributeLabel.text = String(AttributeNum)
			confirmButton.disabled = false
			revertButton.disabled = false
	else:
		if(tempAttList[id] > 0 || (AttributeNum < 0 && attributeNumList[id] > 10) || AttributeLevelCap(attributeNumList[id])):
			attributeNumList[id] -= 1
			tempAttList[id] -= 1
			attributeLabelList[id].text = String(attributeNumList[id])
			AttributeNum += 1
			attributeLabel.text = String(AttributeNum)
			revertButton.disabled = false

func _on_Level_LineEdit_text_changed(new_text):
	if(new_text.is_valid_integer()):
		if(int(new_text) == 0 || int(new_text) == 1):
			lvLabel.text = "1"
		tempLv = GlobalData.current_data.Attribute.lv
		lvNum = int(lvLabel.text)
		CalculateAttributes(lvNum)
		CalculateSchoolPoints(lvNum)
		SchoolLimit(lvNum)
		if(tempLv != lvNum):
			lvDiff.text = str(tempLv) + " -> " + str(lvNum)
		else:
			lvDiff.text = ""
	else:
		lvLabel = lvNum


func _on_Save_Button_pressed():
	GlobalData.save_data(GlobalData.playerFilePath)


func _on_Load_Button_pressed():
	GlobalData.load_data(GlobalData.playerFilePath)
	UpdateCharacterDetails()

func UpdateCharacterDetails():
	
	lvDiff.text = ""
	playerName = GlobalData.current_data.name
	lvNum = GlobalData.current_data.Attribute.lv
	attributeNumList[0] = GlobalData.current_data.Attribute.vit
	attributeNumList[1] = GlobalData.current_data.Attribute.mnd
	attributeNumList[2] = GlobalData.current_data.Attribute.str
	attributeNumList[3] = GlobalData.current_data.Attribute.pwr
	attributeNumList[4] = GlobalData.current_data.Attribute.def
	attributeNumList[5] = GlobalData.current_data.Attribute.res
	attributeNumList[6] = GlobalData.current_data.Attribute.spd
	attributeNumList[7] = GlobalData.current_data.Attribute.tch
	AttributeNum = GlobalData.current_data.Attribute.AttributePoints
	
	schoolRanks[0] = GlobalData.current_data.School.Abduration
	schoolRanks[1] = GlobalData.current_data.School.Conjuration
	schoolRanks[2] = GlobalData.current_data.School.Enchantment
	schoolRanks[3] = GlobalData.current_data.School.Evocation
	schoolRanks[4] = GlobalData.current_data.School.Illusion
	schoolRanks[5] = GlobalData.current_data.School.Mysticism
	schoolRanks[6] = GlobalData.current_data.School.Necromancy
	schoolRanks[7] = GlobalData.current_data.School.Restoration
	schoolRanks[8] = GlobalData.current_data.School.Transmutation
	schoolRanks[9] = GlobalData.current_data.School.Alchemy
	schoolRanks[10] = GlobalData.current_data.School.Armours
	schoolRanks[11] = GlobalData.current_data.School.Artillery
	schoolRanks[12] = GlobalData.current_data.School.Machinery
	schoolRanks[13] = GlobalData.current_data.School.Medics
	schoolRanks[14] = GlobalData.current_data.School.MeleeArms
	schoolRanks[15] = GlobalData.current_data.School.RangedArms
	schoolRanks[16] = GlobalData.current_data.School.Stealth
	schoolRanks[17] = GlobalData.current_data.School.Unarmed
	schoolPoints  = GlobalData.current_data.School.SchoolPoints
	
	playerNameLabel.text = playerName
	lvLabel.text = String(lvNum)
	
#	for n in attributeNumList:
#		attributeLabelList[n].text = String(attributeNumList[n])
	
	attributeLabelList[0].text = String(attributeNumList[0])
	attributeLabelList[1].text = String(attributeNumList[1])
	attributeLabelList[2].text = String(attributeNumList[2])
	attributeLabelList[3].text = String(attributeNumList[3])
	attributeLabelList[4].text = String(attributeNumList[4])
	attributeLabelList[5].text = String(attributeNumList[5])
	attributeLabelList[6].text = String(attributeNumList[6])
	attributeLabelList[7].text = String(attributeNumList[7])
	
	attributeLabel.text = String(AttributeNum)
	confirmButton.disabled = true
	
#	for n in schlLabelList:
#		schlLabelList[n].text = String(schoolRanks[n])
	schlLabelList[0].text = String(schoolRanks[0])
	schlLabelList[1].text = String(schoolRanks[1])
	schlLabelList[2].text = String(schoolRanks[2])
	schlLabelList[3].text = String(schoolRanks[3])
	schlLabelList[4].text = String(schoolRanks[4])
	schlLabelList[5].text = String(schoolRanks[5])
	schlLabelList[6].text = String(schoolRanks[6])
	schlLabelList[7].text = String(schoolRanks[7])
	schlLabelList[8].text = String(schoolRanks[8])
	schlLabelList[9].text = String(schoolRanks[9])
	schlLabelList[10].text = String(schoolRanks[10])
	schlLabelList[11].text = String(schoolRanks[11])
	schlLabelList[12].text = String(schoolRanks[12])
	schlLabelList[13].text = String(schoolRanks[13])
	schlLabelList[14].text = String(schoolRanks[14])
	schlLabelList[15].text = String(schoolRanks[15])
	schlLabelList[16].text = String(schoolRanks[16])
	schlLabelList[17].text = String(schoolRanks[17])
	

func _on_MainMenuButton_pressed(id):
	var itemName = $MainMenuButton.get_popup().get_item_text(id)
	
	match itemName:
		"New Character":
			GlobalData.current_data = GlobalData.default_data
			UpdateCharacterDetails()
		"Open Character":
			$FileDialog.popup()
		"Save Character":
			$SaveFileDialog.popup()
		"Quit":
			get_tree().quit()
			

func _on_FileDialog_file_selected(path):
	print(path)
	var f = File.new()
	f.open(path, 1)
	GlobalData.load_data(f.get_path())
	UpdateCharacterDetails()
	f.close()
	

func _on_SaveFileDialog_file_selected(path):
	_on_Confirm_pressed()
	GlobalData.save_data(path + ".json")

func AttributeLevelCap(att):
	var levelCap = lvNum + 14
	if(att >= levelCap):
		return true
	else:
		return false

func CalculateAttributes(level):
	var newPoints = (level - 1) * 5 + 10
	var currentAttPoints = - 80
	for element in attributeNumList:
		currentAttPoints += element
	AttributeNum = newPoints - currentAttPoints
	attributeLabel.text = String(AttributeNum)


func _on_Confirm_pressed():
	tempLv = 0
	
	for n in tempAttList:
		tempAttList[n] = 0
	
	lvDiff.text = ""
	UpdateCurrentData()
	confirmButton.disabled = true
	revertButton.disabled = true

func UpdateCurrentData():
	GlobalData.current_data.name = playerName
	GlobalData.current_data.Attribute.lv = lvNum
	GlobalData.current_data.Attribute.vit = attributeNumList[0]
	GlobalData.current_data.Attribute.mnd = attributeNumList[1]
	GlobalData.current_data.Attribute.str = attributeNumList[2]
	GlobalData.current_data.Attribute.pwr = attributeNumList[3]
	GlobalData.current_data.Attribute.def = attributeNumList[4]
	GlobalData.current_data.Attribute.res = attributeNumList[5]
	GlobalData.current_data.Attribute.spd = attributeNumList[6]
	GlobalData.current_data.Attribute.tch = attributeNumList[7]
	GlobalData.current_data.Attribute.AttributePoints = AttributeNum
	
	GlobalData.current_data.School.Abduration = schoolRanks[0]
	GlobalData.current_data.School.Conjuration = schoolRanks[1]
	GlobalData.current_data.School.Enchantment = schoolRanks[2]
	GlobalData.current_data.School.Evocation = schoolRanks[3]
	GlobalData.current_data.School.Illusion = schoolRanks[4]
	GlobalData.current_data.School.Mysticism = schoolRanks[5]
	GlobalData.current_data.School.Necromancy = schoolRanks[6]
	GlobalData.current_data.School.Restoration = schoolRanks[7]
	GlobalData.current_data.School.Transmutation = schoolRanks[8]
	GlobalData.current_data.School.Alchemy = schoolRanks[9]
	GlobalData.current_data.School.Armours = schoolRanks[10]
	GlobalData.current_data.School.Artillery = schoolRanks[11]
	GlobalData.current_data.School.Machinery = schoolRanks[12]
	GlobalData.current_data.School.Medics = schoolRanks[13]
	GlobalData.current_data.School.MeleeArms = schoolRanks[14]
	GlobalData.current_data.School.RangedArms = schoolRanks[15]
	GlobalData.current_data.School.Stealth = schoolRanks[16]
	GlobalData.current_data.School.Unarmed = schoolRanks[17]
	GlobalData.current_data.School.SchoolPoints = schoolPoints


func _on_Revert_pressed():
	UpdateCharacterDetails()
	revertButton.disabled = true

###############
### Schools ###
###############

func onSchoolButtonPressPlus(plus, id):
	if(plus == true):
		if(schoolPoints > 0 && !SchoolLimit(schoolRanks[id])):
			schoolRanks[id] += 1
			tempSchoolRanks[id] += 1
			schoolPoints -= 1
			schoolLabel.text = String(schoolPoints)
			schlLabelList[id].text = String(schoolRanks[id])
			confirmButton.disabled = false
			revertButton.disabled = false
	else:
		if(tempSchoolRanks[id] > 0):
			schoolRanks[id] -= 1
			schlLabelList[id].text = String(schoolRanks[id])
			tempSchoolRanks[id] -= 1
			schoolPoints += 1
			schoolLabel.text = String(schoolPoints)

func SchoolLimit(val):
	var levelCap = 2 + lvNum / 3
	if(val >= levelCap):
		return true
	else:
		return false

func CalculateSchoolPoints(level):
	var newPoints = 2 + (level - 1) / 2
	var currentSchlPoints = 0 #schoolRanks
	for element in schoolRanks:
		currentSchlPoints += element
	schoolPoints = newPoints - currentSchlPoints
	schoolLabel.text = String(schoolPoints)


func MagicSchoolButtonPressed(id):
	GlobalData.abilityTabSelectedSchl = id
	var dialog = SchoolWindow.instance()
	add_child(dialog)
	dialog.popup()
	#pass # Replace with function body.
