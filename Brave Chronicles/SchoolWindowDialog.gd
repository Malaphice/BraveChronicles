extends WindowDialog

onready var schlToggleButton = [
	$"MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/Button",
	$"MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/Button2",
	$"MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/Button3",
	$"MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/Button4",
	$"MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/Button5",
	$"MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/Button6",
	$"MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/Button7",
	$"MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/Button8",
	$"MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/Button9",
	$"MarginContainer/VBoxContainer/ScrollContainer2/HBoxContainer2/Button",
	$"MarginContainer/VBoxContainer/ScrollContainer2/HBoxContainer2/Button2",
	$"MarginContainer/VBoxContainer/ScrollContainer2/HBoxContainer2/Button3",
	$"MarginContainer/VBoxContainer/ScrollContainer2/HBoxContainer2/Button4",
	$"MarginContainer/VBoxContainer/ScrollContainer2/HBoxContainer2/Button5",
	$"MarginContainer/VBoxContainer/ScrollContainer2/HBoxContainer2/Button6",
	$"MarginContainer/VBoxContainer/ScrollContainer2/HBoxContainer2/Button7",
	$"MarginContainer/VBoxContainer/ScrollContainer2/HBoxContainer2/Button8",
	$"MarginContainer/VBoxContainer/ScrollContainer2/HBoxContainer2/Button9"]

onready var skillDetail = $"MarginContainer/VBoxContainer/HBoxContainer3/ScrollContainer2/VBoxContainer/RichTextLabel"

var skillButtonList = []

var schoolButtonID;

var skillData

var artsFilePath = "res://CombatArtsSample.json"
var playerFilePath = "user://player_data.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	#$MainMenuButton.get_popup().add_item("Quit")
	
	schoolButtonID = GlobalData.abilityTabSelectedSchl
	
	schlToggleButton[0].text = "Abduration"
	schlToggleButton[1].text = "Conjuration"
	schlToggleButton[2].text = "Enchantment"
	schlToggleButton[3].text = "Evocation"
	schlToggleButton[4].text = "Illusion"
	schlToggleButton[5].text = "Mysticism"
	schlToggleButton[6].text = "Necromancy"
	schlToggleButton[7].text = "Restoration"
	schlToggleButton[8].text = "Transmutation"
	schlToggleButton[9].text = "Alchemy"
	schlToggleButton[10].text = "Armours"
	schlToggleButton[11].text = "Artillery"
	schlToggleButton[12].text = "Machinery"
	schlToggleButton[13].text = "Medics"
	schlToggleButton[14].text = "MeleeArms"
	schlToggleButton[15].text = "RangedArms"
	schlToggleButton[16].text = "Stealth"
	schlToggleButton[17].text = "Unarmed"
	
	schlToggleButton[GlobalData.abilityTabSelectedSchl].pressed = true;
	#schlToggleButton[0].pressed = true;
	var button1 = Button.new()
	#button1.connect("button_down", self, _on_SkillButton_Pressed())
	
	load_data()
	
	print(skillData.size())
	
	var num = 0
	var skillName = ""
	var selectedSkill = schlToggleButton[schoolButtonID].text
	for skill in skillData:
		skillName = String(skill.School)
		if(selectedSkill in skillName):
			skillButtonList.append(Button.new())
			skillButtonList[num].text = skill.Name
			skillButtonList[num].toggle_mode = true
			skillButtonList[num].connect("button_down", self, "_on_SkillButton_Pressed", [num, skill])
			$MarginContainer/VBoxContainer/HBoxContainer3/ScrollContainer/VBoxContainer.add_child(skillButtonList[num])
			num += 1
	
#	for n in skillData.size():
#		skillButtonList.append(Button.new())
#		#skillButtonList[n].text = "Skill " + String(n + 1)
#		skillButtonList[n].text = skillData[n]
#		skillButtonList[n].toggle_mode = true
#		skillButtonList[n].connect("button_down", self, "_on_SkillButton_Pressed", [n])
#		$MarginContainer/VBoxContainer/HBoxContainer3/ScrollContainer/VBoxContainer.add_child(skillButtonList[n])
#		#skillButtonList[n].pressed.connect(_on_SkillButton_Pressed)
	


func _on_SkillButton_Pressed(num, skill):
	for n in skillData.size():
		if (skillButtonList[n].text != skill.Name):
			skillButtonList[n].pressed = false
	#print("skill button :" + String(id + 1) + " pressed")
	skillDetail.text = "Name: " + skill.Name + "\n" + "School:" + skill.School + " " + skill.Cost + "\n" + skill.Cost + "\n" + skill.Description + "\n" + skill.Effect

func load_data():
	
	var file = File.new()
	
	file.open(artsFilePath, File.READ)
	#file.open(playerFilePath, File.READ)
	
	#var data: Dictionary = JSON.parse(file.get_as_text()).result
	var data = parse_json(file.get_as_text())
	#talk_data = parse_json(file.get_as_text())
	
	file.close()
	
	skillData = data
