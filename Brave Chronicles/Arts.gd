extends Tabs

onready var artList = $"MarginContainer/VBoxContainer/HBoxContainer2/ScrollContainer/VBoxContainer"
onready var artDetail = $"MarginContainer/VBoxContainer/HBoxContainer2/ScrollContainer2/VBoxContainer/RichTextLabel"
onready var artLearn = $"MarginContainer/VBoxContainer/HBoxContainer2/ScrollContainer2/VBoxContainer/LearnArt"

onready var schlFilterList = $"MarginContainer/VBoxContainer/HBoxContainer/OptionButton"
onready var artLearnedButton = $"MarginContainer/VBoxContainer/HBoxContainer/Learned Arts"

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


# Called when the node enters the scene tree for the first time.
func _ready():
	#$MainMenuButton.get_popup().add_item("Quit")
	
	schoolButtonID = GlobalData.abilityTabSelectedSchl
	
	var num = 1
	
	schlFilterList.add_item("All Schools", 0)
	
	schlFilterList.selected = 0;
	
	for schl in GlobalData.schoolList:
		schlFilterList.add_item(schl, num)
		if(num == schoolButtonID):
			schlFilterList.selected = num + 1
		num += 1
	
	num = 0
	
	leanedArtLimit = GlobalData.current_data.Art.LearnLimit
	#var button1 = Button.new()
	
	load_data()
	#getArts()
#	artLearn.hide()
#	print(artData.size())
	
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
	
	if (GlobalData.abilityTabSelectedSchl > 0 && GlobalData.abilityTabSelectedSchl < 18):
		filterArts()


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
	

func _on_TabContainer_tab_selected(tab):
	pass # Replace with function body.
