extends Tabs


### Equipment Variables
onready var searchBar = $"MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer/LineEdit"
onready var equipBox = $"MarginContainer/HBoxContainer/ScrollContainer/VBoxContainer"
onready var itemSortByList = $"MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer2/OptionButton"
onready var itemTypeList = $"MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer3/OptionButton"
var addEquipButtonList = []
var descriptionEquipList = []
var equipIcon = "res://icon.png"
var equipFilePath = "res://BraveChronicles_Weapons.json"
var equipData
var equipButtonList = []
var equipTypeList = []
var equipTypeID = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	load_data()
	loadEquipment()
	#sortList
	##sortList.add_item(schl, num)
	var num = 0
	for itemType in equipTypeList:
		itemTypeList.add_item(itemType, num)
		num += 1

func load_data():
	
	var file = File.new()
	
	file.open(equipFilePath, File.READ)
	
	var data = parse_json(file.get_as_text())
	
	file.close()
	
	equipData = data

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


func itemOptionPress(id):
	#print(str(schlFilterList.get_item_text(id)))
	if(id == 0):
		unFilterEquipment();
	else:
		equipTypeID = id
		filterEquipment()

func filterEquipment():
	var n = 0
	for equip in equipData:
		if(equip.Type != equipTypeList[equipTypeID]):
			equipButtonList[n].pressed = false
			equipButtonList[n].hide();
			addEquipButtonList[n].hide()
			descriptionEquipList[n].hide()
		else:
			equipButtonList[n].show();
		n +=1

func unFilterEquipment():
	for n in equipData.size():
		equipButtonList[n].show()

func addToInventory(item):
#	get_node("../../SomeNode/SomeOtherNode")
#	get_parent().get_parent().get_node("SomeNode")
#	get_tree().get_root().get_node("SomeNode/SomeOtherNode")
	#print(get_tree().get_root().get_node("Control/PanelContainer2/AbilityTab/Inventory/HBoxContainer/ScrollContainer/VBoxContainer"))
	
	var itemBox = get_tree().get_root().get_node("Control/PanelContainer2/AbilityTab/Inventory/HBoxContainer/VBoxContainer/ScrollContainer/VBoxContainer")
	
	var itemCount = 1
	var newItem = true
	
	for invItem in GlobalData.current_data.Item.Inventory:
		if (invItem == item.Name):
			itemCount +=1
			newItem = false
	
	if(newItem == false):
		#for invItem in itemBox.get_children():
		#	print(invItem)
		var invItem = itemBox.get_node(item.Name)
		#invItem.text = String(itemCount)
		var invItemCountLabel = invItem.get_node(item.Name + "Label")
		print(invItemCountLabel)
		invItemCountLabel.text = "x" + String(itemCount)
	else:
		var itemBar = HBoxContainer.new()
		var itemButton = Button.new()
		var itemCountLabel = Label.new()
		itemBar.name = item.Name
		itemButton.text = item.Name
		itemCountLabel.text = "x" + String(itemCount)
		itemCountLabel.name = item.Name + "Label"
		itemBar.add_child(itemButton)
		itemBar.add_child(itemCountLabel)
		itemBox.add_child(itemBar);
		
	GlobalData.current_data.Item.Inventory.append(item.Name)
	#print(GlobalData.current_data.Item.Inventory)

#func _on_TabContainer_tab_selected(tab):
#	pass # Replace with function body.
