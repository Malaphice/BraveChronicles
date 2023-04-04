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
	$"MarginContainer/VBoxContainer/ScrollContainer2/HBoxContainer/Button",
	$"MarginContainer/VBoxContainer/ScrollContainer2/HBoxContainer/Button2",
	$"MarginContainer/VBoxContainer/ScrollContainer2/HBoxContainer/Button3",
	$"MarginContainer/VBoxContainer/ScrollContainer2/HBoxContainer/Button4",
	$"MarginContainer/VBoxContainer/ScrollContainer2/HBoxContainer/Button5",
	$"MarginContainer/VBoxContainer/ScrollContainer2/HBoxContainer/Button6",
	$"MarginContainer/VBoxContainer/ScrollContainer2/HBoxContainer/Button7",
	$"MarginContainer/VBoxContainer/ScrollContainer2/HBoxContainer/Button8",
	$"MarginContainer/VBoxContainer/ScrollContainer2/HBoxContainer/Button9"]

onready var artList = $"MarginContainer/VBoxContainer/HBoxContainer2/ScrollContainer/VBoxContainer"
onready var artDetail = $"MarginContainer/VBoxContainer/HBoxContainer2/ScrollContainer2/VBoxContainer/RichTextLabel"
onready var artLearn = $"MarginContainer/VBoxContainer/HBoxContainer2/ScrollContainer2/VBoxContainer/LearnArt"

onready var schlFilterList = $"MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/OptionButton"
onready var artLearnedButton = $"MarginContainer/VBoxContainer/Learned Arts"

var artButtonList = []

var schoolButtonID;

var artData
var selectedArt

var artsFilePath = "res://CombatArtsSample.json"
var playerFilePath = "user://player_data.json"
var learnedArtList = []
var leanedArtLimit



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
	
	var num = 0
	
	schlFilterList.add_item("All Schools", -1)
	
	for schl in GlobalData.schoolList:
		schlFilterList.add_item(schl, num)
		if(num == GlobalData.abilityTabSelectedSchl):
			schlFilterList.selected = num + 1
		num += 1
	
	#schlFilterList.connect("button_down", self, "schoolOptionPress" [schlFilterList.get_index()])
	#schlFilterList.connect("button_down", self, "schoolOptionPress")
	
	num = 0
	
	schlToggleButton[GlobalData.abilityTabSelectedSchl].pressed = true;
	#schlToggleButton[0].pressed = true;
	leanedArtLimit = GlobalData.current_data.Art.LearnLimit
	var button1 = Button.new()
	#button1.connect("button_down", self, _on_artButton_Pressed())
	
	load_data()
	getArts()
	artLearn.hide()
	print(artData.size())
	
	var artName = ""
	#var selectedart = schlToggleButton[schoolButtonID].text
	for art in artData:
		artButtonList.append(Button.new())
		artButtonList[num].text = art.Name
		artButtonList[num].toggle_mode = true
		artButtonList[num].connect("button_down", self, "_on_artButton_Pressed", [num, art])
		artList.add_child(artButtonList[num])
		if(schlToggleButton[schoolButtonID].text != art.School):
			artButtonList[num].hide()
		num += 1
		#artName = String(art.School)
#		if(schlToggleButton[schoolButtonID].text in art.School):
#			artButtonList.append(Button.new())
#			artButtonList[num].text = art.Name
#			artButtonList[num].toggle_mode = true
#			artButtonList[num].connect("button_down", self, "_on_artButton_Pressed", [num, art])
#			artList.add_child(artButtonList[num])
#			num += 1
	
#	for n in artData.size():
#		artButtonList.append(Button.new())
#		#artButtonList[n].text = "art " + String(n + 1)
#		artButtonList[n].text = artData[n]
#		artButtonList[n].toggle_mode = true
#		artButtonList[n].connect("button_down", self, "_on_artButton_Pressed", [n])
#		$MarginContainer/VBoxContainer/HBoxContainer3/ScrollContainer/VBoxContainer.add_child(artButtonList[n])
#		#artButtonList[n].pressed.connect(_on_artButton_Pressed)
	


func _on_artButton_Pressed(num, art):
	for n in artData.size():
		if (artButtonList[n].text != art.Name):
			artButtonList[n].pressed = false
	#print("art button :" + String(id + 1) + " pressed")
	artDetail.text = "Name: " + art.Name + "\n" + "School:" + art.School + " " + art.Cost + "\n" + art.Cost + "\n" + art.Description + "\n" + art.Effect
	selectedArt = art.Name
	artLearn.show()
	if (learnedArtList.has(art.Name)):
		artLearn.pressed = true
	else:
		artLearn.pressed = false

func unfilterArts():
	for n in artData.size():
		artButtonList[n].show()

func filterArts():
	var num = 0
	for art in artData:
		if(schlToggleButton[schoolButtonID].text != art.School):
			artButtonList[num].hide()
		else:
			artButtonList[num].show()
		num += 1
	
	artDetail.text = ""
	selectedArt = ""
	artLearn.hide()
	
	for n in artData.size():
		artButtonList[n].pressed = false

func filterLeanedArts():
	var num = 0
	
	if(artLearnedButton.pressed == true):
		for art in artData:
			if(learnedArtList.find(artButtonList[num].text) == -1):
				artButtonList[num].hide()
			elif (art.school == GlobalData.schoolList[num]):
				artButtonList[num].show()
			else:
				artButtonList[num].hide()
			num += 1
	else:
		filterArts()
	
	artDetail.text = ""
	selectedArt = ""
	artLearn.hide()
	
	for n in artData.size():
		artButtonList[n].pressed = false

func schoolButtonPress(id):
	schoolButtonID = id
	filterArts()

func schoolOptionPress(id):
	print(str(schlFilterList.get_item_text(id)))
	if(id == 0):
		unfilterArts()
	else:
		schoolButtonID = id - 1
		filterArts()

func load_data():
	
	var file = File.new()
	
	file.open(artsFilePath, File.READ)
	#file.open(playerFilePath, File.READ)
	
	#var data: Dictionary = JSON.parse(file.get_as_text()).result
	var data = parse_json(file.get_as_text())
	#talk_data = parse_json(file.get_as_text())
	
	file.close()
	
	artData = data

func getArts():
	var learnedSkills = String(GlobalData.current_data.Art.Learned)
	learnedArtList = learnedSkills.split(",")


func _on_LearnArt_pressed():
	if(artLearn.pressed == false):
		artLearn.pressed = true
		#learnedArtList.erase(selectedArt)
		var i = learnedArtList.find(selectedArt)
		learnedArtList.remove(i)
		print("unlearned " + selectedArt)
	elif(learnedArtList.size() > leanedArtLimit):
		print("Max Number of Arts learned" + selectedArt)
	else:
		learnedArtList.append(selectedArt)
		print("learned" + selectedArt)
	#leanedArtNum -= learnedArtList.size()
	
	print("Number of Arts Known" + String(learnedArtList.size()))
	
