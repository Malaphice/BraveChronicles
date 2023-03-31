extends WindowDialog

onready var schlToggleButton = [
	$"MarginContainer/VBoxContainer/HBoxContainer/Button",
	$"MarginContainer/VBoxContainer/HBoxContainer/Button2",
	$"MarginContainer/VBoxContainer/HBoxContainer/Button3",
	$"MarginContainer/VBoxContainer/HBoxContainer/Button4",
	$"MarginContainer/VBoxContainer/HBoxContainer/Button5",
	$"MarginContainer/VBoxContainer/HBoxContainer/Button6",
	$"MarginContainer/VBoxContainer/HBoxContainer/Button7",
	$"MarginContainer/VBoxContainer/HBoxContainer/Button8",
	$"MarginContainer/VBoxContainer/HBoxContainer/Button9",
	$"MarginContainer/VBoxContainer/HBoxContainer2/Button",
	$"MarginContainer/VBoxContainer/HBoxContainer2/Button2",
	$"MarginContainer/VBoxContainer/HBoxContainer2/Button3",
	$"MarginContainer/VBoxContainer/HBoxContainer2/Button4",
	$"MarginContainer/VBoxContainer/HBoxContainer2/Button5",
	$"MarginContainer/VBoxContainer/HBoxContainer2/Button6",
	$"MarginContainer/VBoxContainer/HBoxContainer2/Button7",
	$"MarginContainer/VBoxContainer/HBoxContainer2/Button8",
	$"MarginContainer/VBoxContainer/HBoxContainer2/Button9"]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var skillButtonList = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#$MainMenuButton.get_popup().add_item("Quit")
	print("window opened")
	schlToggleButton[GlobalData.abilityTabSelectedSchl].pressed = true;
	#schlToggleButton[0].pressed = true;
	var button1 = Button.new()
	#button1.connect("button_down", self, _on_SkillButton_Pressed())
	
	for n in 5:
		skillButtonList.append(Button.new())
		skillButtonList[n].text = "Skill " + String(n + 1)
		skillButtonList[n].toggle_mode = true
		skillButtonList[n].connect("button_down", self, "_on_SkillButton_Pressed", [n])
		$MarginContainer/VBoxContainer/HBoxContainer3/ScrollContainer/VBoxContainer.add_child(skillButtonList[n])
		#skillButtonList[n].pressed.connect(_on_SkillButton_Pressed)
	


func _on_SkillButton_Pressed(id):
	print("skill button :" + String(id) + " pressed")
	pass # Replace with function body.

