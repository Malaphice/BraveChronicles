extends Node


var playerFilePath = "user://player_data.json"
var conpendiumTabSelected = 0
var abilityTabSelectedSchl = -1

var default_data := {
	"name" : "New Player",
	"Attribute":
		{
			"lv" : 1,
			"vit" : 10,
			"mnd" : 10,
			"str" : 10,
			"pwr" : 10,
			"def" : 10,
			"res" : 10,
			"spd" : 10,
			"tch" : 10,
			"AttributePoints" : 10
		},
	"School":
		{
			"Abduration" : 0,
			"Conjuration" : 0,
			"Divination": 0,
			"Enchantment" : 0,
			"Evocation" : 0,
			"Illusion" : 0,
			"Necromancy": 0,
			"Restoration" : 0,
			"Transmutation" : 0,
			"Alchemy": 0,
			"Armours" : 0,
			"Artillery" : 0,
			"Machinery" : 0,
			"Medics" : 0,
			"MeleeArms" : 0,
			"RangedArms" : 0,
			"Stealth": 0,
			"Unarmed" : 0,
			"SchoolPoints" : 3
		},
	"Art":
		{
			"Equipped": ["Test 1"],
			"Learned": ["Test 1"],
			"EquipLimit": 2,
			"LearnLimit" : 2
		},
	"Action":
		{
			"Endure": 0,
			"Strike" : 0,
			"Craft": 0,
			"Traverse": 0,
			"Command": 0,
			"Study": 0,
			"Sneak": 0,
			"Perceive": 0,
			"Charm": 0,
			"Finesse": 0,
			"ActionPoints": 0
		},
	"Specialty": "",
	"Item":
		{
			"Equipped": ["Test 1"],
			"Inventory": ["Test 1"]
		}
}

var schoolList = [
	"Abduration",
	"Conjuration",
	"Divination",
	"Enchantment",
	"Evocation",
	"Illusion",
	"Necromancy",
	"Restoration",
	"Transmutation",
	"Alchemy",
	"Armours",
	"Artillery",
	"Machinery",
	"Medics",
	"MeleeArms",
	"RangedArms",
	"Stealth",
	"Unarmed"
]

var playerStats := {
	"PhysicalAttack" : 0,
	"MagicAttack" : 0,
	"AttackSpeed" : 0,
	"PhysicalArmour" : 0,
	"MagicArmour" : 0,
	"Evasion" : 0,
	"Movement" : 0,
	}

var current_data = default_data

func _ready():
	current_data = default_data
	abilityTabSelectedSchl = 0
	print(OS.get_user_data_dir())

func reset_data():
	current_data.clear()
	current_data = default_data.duplicate(true)
	

func save_data(path : String):
	var file
	
	var save := JSON.print(current_data)
	
	file = File.new()
	file.open(path, File.WRITE)
	file.store_string(save)
	file.close()

func load_data(path : String):
	
	var file = File.new()
	
	file.open(path, File.READ)
	
	var data: Dictionary = JSON.parse(file.get_as_text()).result
	
	file.close()
	
	current_data = data

