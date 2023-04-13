extends WindowDialog

onready var artList = $"TabContainer/Arts/MarginContainer/VBoxContainer/HBoxContainer2/ScrollContainer/VBoxContainer"
onready var artDetail = $"TabContainer/Arts/MarginContainer/VBoxContainer/HBoxContainer2/ScrollContainer2/VBoxContainer/RichTextLabel"
onready var artLearn = $"TabContainer/Arts/MarginContainer/VBoxContainer/HBoxContainer2/ScrollContainer2/VBoxContainer/LearnArt"

onready var schlFilterList = $"TabContainer/Arts/MarginContainer/VBoxContainer/HBoxContainer/OptionButton"
onready var artLearnedButton = $"TabContainer/Arts/MarginContainer/VBoxContainer/HBoxContainer/Learned Arts"

var artButtonList = []
var artNameList = []

var equipButtonList = []

var schoolButtonID;

var artData
var equipData
var selectedArt

var artsFilePath = "res://CombatArtsSample.json"
var equipFilePath = "res://BraveChronicles_Weapons.json"
var playerFilePath = "user://player_data.json"
var learnedArtList = []
var leanedArtLimit

var equipIcon = "res://icon.png"

### Equipment Variables
onready var searchBar = $"TabContainer/Equipment/MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer/LineEdit"
onready var equipBox = $"TabContainer/Equipment/MarginContainer/HBoxContainer/ScrollContainer/VBoxContainer"
var addEquipButtonList = []
var descriptionEquipList = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#$MainMenuButton.get_popup().add_item("Quit")
	
	schoolButtonID = GlobalData.abilityTabSelectedSchl
	
	var num = 0
	
	schlFilterList.add_item("All Schools", -1)
	
	for schl in GlobalData.schoolList:
		schlFilterList.add_item(schl, num)
		if(num == GlobalData.abilityTabSelectedSchl):
			schlFilterList.selected = num + 1
		num += 1
	
	num = 0
	
	leanedArtLimit = GlobalData.current_data.Art.LearnLimit
	var button1 = Button.new()
	
	load_data()
	getArts()
	artLearn.hide()
	print(artData.size())
	
	var artName = ""
	#var selectedart = schlToggleButton[schoolButtonID].text
	for art in artData:
		artButtonList.append(Button.new())
		artButtonList[num].text = art.Name
		artNameList.append(art.Name)
		artButtonList[num].toggle_mode = true
		artButtonList[num].connect("button_down", self, "_on_artButton_Pressed", [num, art])
		artList.add_child(artButtonList[num])
		num += 1
	filterArts()
	
	loadEquipment()


func _on_artButton_Pressed(num, art):
	for n in artData.size():
		if (artButtonList[n].text != art.Name):
			artButtonList[n].pressed = false
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
		if(schlFilterList.get_item_text(schoolButtonID + 1) != art.School):
			artButtonList[num].hide()
		else:
			artButtonList[num].show()
		num += 1
	
	if(artLearnedButton.pressed == true):
		for n in artButtonList.size():
			if(learnedArtList.find(artButtonList[n].text) == -1):
				artButtonList[n].hide()
	
	artDetail.text = ""
	selectedArt = ""
	artLearn.hide()
	
	for n in artData.size():
		artButtonList[n].pressed = false

func schoolOptionPress(id):
	print(str(schlFilterList.get_item_text(id)))
	if(id == 0):
		unfilterArts()
	else:
		schoolButtonID = id - 1
		filterArts()

func _on_itemButton_Pressed(num, item):
	for n in equipData.size():
		if (equipButtonList[n].text != item.Name):
			#equipButtonList[n].pressed = false
			addEquipButtonList[n].hide()
			descriptionEquipList[n].hide()
		else:
			if(equipButtonList[n].pressed == false):
				addEquipButtonList[n].show()
				descriptionEquipList[n].show()
				print(descriptionEquipList[n].text)
			else:
				addEquipButtonList[n].hide()
				descriptionEquipList[n].hide()

func load_data():
	
	var file = File.new()
	
	file.open(artsFilePath, File.READ)
	
	var data = parse_json(file.get_as_text())
	
	file.close()
	
	artData = data
	
	file.open(equipFilePath, File.READ)
	
	data = parse_json(file.get_as_text())
	
	file.close()
	
	equipData = data

func getArts():
	var learnedSkills = String(GlobalData.current_data.Art.Learned)
	learnedArtList = learnedSkills.split(",")


func _on_LearnArt_pressed():
	var i = 0
	if(artLearn.pressed == false):
		artLearn.pressed = true
		i = learnedArtList.find(selectedArt)
		learnedArtList.remove(i)
		i = artNameList.find(selectedArt)
		artButtonList[i].icon = null
		print("unlearned " + selectedArt)
	elif(learnedArtList.size() > leanedArtLimit):
		print("Max Number of Arts learned" + selectedArt)
	else:
		learnedArtList.append(selectedArt)
		i = artNameList.find(selectedArt)
		artButtonList[i].icon = ResourceLoader.load(equipIcon)
		artButtonList[i].color
		artLearn.pressed = false
		print("learned" + selectedArt)
	
	print("Number of Arts Known" + String(learnedArtList.size()))

func loadEquipment():
	var num = 0
#	var textLabel: RichTextLabel = RichTextLabel.new()
#	textLabel.rect_size = Vector2(400,400)
#	textLabel.rect_min_size = Vector2(400,400)
#	textLabel.SIZE_SHRINK_CENTER
#	textLabel.SIZE_EXPAND_FILL
#	textLabel.text = "X"
#	var textLabel1: Label = Label.new()
#	textLabel1.text = "X"
	#add_child(textLabel)
	for item in equipData:
		equipButtonList.append(Button.new())
		equipButtonList[num].text = item.Name
		equipButtonList[num].toggle_mode = true
		equipButtonList[num].connect("button_down", self, "_on_itemButton_Pressed", [num, item])
		#equipBox.add_child(equipButtonList[num])
		descriptionEquipList.append(RichTextLabel.new())
		#descriptionEquipList.append(Label.new())
		#var x = Button.new()
		descriptionEquipList[num].rect_min_size = Vector2(400,100)
		#descriptionEquipList[num].SIZE_EXPAND_FILL
		#descriptionEquipList[num].SIZE_FILL
		descriptionEquipList[num].text = "Item Content"
		descriptionEquipList[num].hide()
		addEquipButtonList.append(Button.new())
		addEquipButtonList[num].text = "Add Item to Inventory"
		addEquipButtonList[num].hide()
		equipBox.add_child(equipButtonList[num])
		equipBox.add_child(descriptionEquipList[num])
		equipBox.add_child(addEquipButtonList[num])
		num += 1
	#equipBox
	pass


func _on_TabContainer_tab_selected(tab):
	pass # Replace with function body.
