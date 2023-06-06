extends WindowDialog

onready var artList = $"TabContainer/Arts/MarginContainer/VBoxContainer/HBoxContainer2/ScrollContainer/VBoxContainer"
onready var artDetail = $"TabContainer/Arts/MarginContainer/VBoxContainer/HBoxContainer2/ScrollContainer2/VBoxContainer/RichTextLabel"
onready var artLearn = $"TabContainer/Arts/MarginContainer/VBoxContainer/HBoxContainer2/ScrollContainer2/VBoxContainer/LearnArt"

onready var schlFilterList = $"TabContainer/Arts/MarginContainer/VBoxContainer/HBoxContainer/OptionButton"
onready var artLearnedButton = $"TabContainer/Arts/MarginContainer/VBoxContainer/HBoxContainer/Learned Arts"

onready var windowTab = $"TabContainer"

var artButtonList = []
var artNameList = []

var schoolButtonID;

var artData
var selectedArt

var artsFilePath = "res://CombatArtsSample.json"
var playerFilePath = "user://player_data.json"
var learnedArtList = []
var leanedArtLimit


### Equipment Variables
onready var searchBar = $"TabContainer/Equipment/MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer/LineEdit"
onready var equipBox = $"TabContainer/Equipment/MarginContainer/HBoxContainer/ScrollContainer/VBoxContainer"
onready var itemSortByList = $"TabContainer/Equipment/MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer2/OptionButton"
onready var itemTypeList = $"TabContainer/Equipment/MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer3/OptionButton"
var addEquipButtonList = []
var descriptionEquipList = []
var equipIcon = "res://icon.png"
var equipFilePath = "res://BraveChronicles_Weapons.json"
var equipData
var equipButtonList = []
var equipTypeList = []


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
	#var button1 = Button.new()
	
	load_data()
	#getArts()
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
	
	num = 0
	
	if (GlobalData.abilityTabSelectedSchl > -1 && GlobalData.abilityTabSelectedSchl < 18):
		filterArts()
	
	if (GlobalData.abilityTabSelectedSchl == 18):
		windowTab.current_tab = 1
	
	loadEquipment()
	#itemTypeList
	for itemType in equipTypeList:
		itemTypeList.add_item(itemType, num)
		num += 1


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
	#learnedArtList = learnedSkills.split(",")
	#learnedArtList = GlobalData.current_data.Art.Learned
	#print(learnedArtList[1])


func _on_LearnArt_pressed():
	var i = 0
	if(artLearn.pressed == false):
		#artLearn.pressed = true
		i = learnedArtList.find(selectedArt)
		learnedArtList.remove(i)
		i = artNameList.find(selectedArt)
		#artButtonList[i].icon = null
		#artButtonList[i].Color.font_outline_color = Color(1, 0, 1, 0)
		updateArtData()
		print("unlearned " + selectedArt)
	elif(learnedArtList.size() > leanedArtLimit):
		print("Max Number of Arts learned" + selectedArt)
	else:
		learnedArtList.append(selectedArt)
		i = artNameList.find(selectedArt)
		#artButtonList[i].icon = ResourceLoader.load(equipIcon)
		#artButtonList[i].Color.font_outline_color = Color(1, 1, 1, 1)
		#artLearn.pressed = false
		updateArtData()
		print("learned" + selectedArt)
	
	print("Number of Arts Known" + String(learnedArtList.size()))

func updateArtData():
	GlobalData.current_data.Art.Learned = learnedArtList
	#for a in learnedArtList:
		

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
	equipTypeList.append("All Types")
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
		addEquipButtonList[num].connect("button_down", self, "addToInventory", [item])
		addEquipButtonList[num].hide()
		equipBox.add_child(equipButtonList[num])
		equipBox.add_child(descriptionEquipList[num])
		equipBox.add_child(addEquipButtonList[num])
		
		if(!equipTypeList.has(String(item.Type))):
			equipTypeList.append(String(item.Type))
		
		num += 1
	#equipBox
	pass

func _on_itemButton_Pressed(num, item):
	for n in equipData.size():
		if (equipButtonList[n].text != item.Name):
			equipButtonList[n].pressed = false
			addEquipButtonList[n].hide()
			descriptionEquipList[n].hide()
		else:
			if(equipButtonList[n].pressed == false):
				addEquipButtonList[n].show()
				descriptionEquipList[n].show()
				print(descriptionEquipList[n].text)
			else:
				#equipButtonList[n].pressed = false
				addEquipButtonList[n].hide()
				descriptionEquipList[n].hide()

func addToInventory(item):
	GlobalData.current_data.Item.Inventory.append(item.Name)
#	get_node("../../SomeNode/SomeOtherNode")
#	get_parent().get_parent().get_node("SomeNode")
#	get_tree().get_root().get_node("SomeNode/SomeOtherNode")
	#print(get_tree().get_root().get_node("Control/PanelContainer2/AbilityTab/Inventory/HBoxContainer/ScrollContainer/VBoxContainer"))
	var itemBar = HBoxContainer.new()
	var itemButton = Button.new()
	var itemCount = Label.new()
	itemButton.text = item.Name
	itemCount.text = "x1"
	itemBar.add_child(itemButton)
	itemBar.add_child(itemCount)
	#CBInventoryList.add_child(itemBar);
	get_tree().get_root().get_node("Control/PanelContainer2/AbilityTab/Inventory/HBoxContainer/VBoxContainer/ScrollContainer/VBoxContainer").add_child(itemBar);
	print(GlobalData.current_data.Item.Inventory)

func _on_TabContainer_tab_selected(tab):
	pass # Replace with function body.
