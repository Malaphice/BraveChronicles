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


# Called when the node enters the scene tree for the first time.
func _ready():
	#$MainMenuButton.get_popup().add_item("Quit")
	print("window opened")
	schlToggleButton[GlobalData.abilityTabSelectedSchl].pressed = true;
	#schlToggleButton[0].pressed = true;
	var button1 = Button.new()
	$MarginContainer/VBoxContainer/HBoxContainer3/ScrollContainer/VBoxContainer.add_child(button1)


func _on_Button_toggled(button_pressed):
	pass # Replace with function body.

