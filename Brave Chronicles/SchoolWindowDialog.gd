extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#$MainMenuButton.get_popup().add_item("Quit")
	var button1 = Button.new()
	$MarginContainer/VBoxContainer/HBoxContainer2/ScrollContainer/VBoxContainer.add_child(button1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
