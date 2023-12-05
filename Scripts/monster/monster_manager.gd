class_name MonsterManager
extends Node

@export var MonsterScene : PackedScene
@export var MonsterNPCScene : PackedScene

@onready var InWorld : Node  = $InWorld
@onready var InStock : Node  = $InStock
@onready var AtWork  : Node2D  = $AtWork
@onready var graveyard: Node2D = $Graveyard

var OwnedMonsters : Array[Monster] = []

signal OnMonsterMoveFromCatagory

var MonsterNames : Array = [
	"Ashpest",
	"Emberstep",
	"Dawnsnare",
	"Phantomvine",
	"The Haunting Plant",
	"The Cruel Deviation",
	"The Monstrous Entity",
	"The Greater Shadow Hippo",
	"The Black-Eyed Moon Vermin",
	"The Obsidian Terror Boar",
	"Trancemask",
	"Rustbrood",
	"Viletalon",
	"Mournpest",
	"The Gruesome Hag",
	"The Feline Brute",
	"The Dreary Teeth",
	"The Tusked Bone Lizard",
	"The Diabolical Dire Serpent",
	"The Tusked Preying Anaconda",
	"Decayling",
	"Toxinwing",
	"Viletooth",
	"Mournhound",
	"The False Abomination",
	"The Canine Hag",
	"The Lonely Ooze",
	"The Jade Horror Hog",
	"The Feathered Mist Lizard",
	"The Blind Skeleton Fiend",
	"Shadescream",
	"Fogpaw",
	"Boulderling",
	"Umbrabrute",
	"The Electric Lich",
	"The Colossal Freak",
	"The Electric Wraith",
	"The Diabolical Terror Lynx",
	"The Bloodthirsty Thunder Vermin",
	"The Barb-Tailed Ash Leviathan",
	"Vexpod",
	"Bowelserpent",
	"Voodooman",
	"Slagflayer",
	"The Cruel Hunter",
	"The Blue Eyes",
	"The Cold Fiend",
	"The Giant Tomb Spider",
	"The Bloodthirsty Grieve Gorilla",
	"Taintfreak",
	"Stenchwing",
	"Soulpod",
	"Grieveseeker",
	"The FAKE Mutant",
	"The Electric Presence",
	"Killer Queen",
	"The champion of Captalism",
	"Station Assistant",
	"Greytide",
	"Station Clown",
	"The Blood Brother",
	"The Developer with many masks",
	"Chainsaw",
	"Gobbler",
	"College Gremlin",
	"A short person",
	"Debt",
	"A politician",
	"???",
	"Germfigure, The Rotten Serpent",
	"Dawnjester, The Eternal Spirit",
	"Auramorph, The Phantom-Dreams Seeker",
	"Deadfigure, The Quiet Critter",
	"Live-Service Subscription",
	"Ad-Trackers",
	"Emberbug, The Nightmare Man",
	"Brineword, The Quiet Feline",
	"A STRAIGHT, WHITE, MALE.",
	"Mucktree, The Sunshine Spider",
	"Brazil",
	"A French Man",
	"The friendly tall man in your walls",
	"Deceptive Long-Haired Woman",
	"Dream Eater",
	"Angelo, The Feeder of Sarrow",
]

var monsterSprites : Array = [
	"res://Resources/Sprites/Monsters/monster1.png", 
	"res://Resources/Sprites/Monsters/monster2.png", 
	"res://Resources/Sprites/Monsters/monster3.png", 
	"res://Resources/Sprites/Monsters/monster4.png", 
	"res://Resources/Sprites/Monsters/monster5.png", 
	"res://Resources/Sprites/Monsters/monster6.png", 
	"res://Resources/Sprites/Monsters/monster7.png", 
	"res://Resources/Sprites/Monsters/monster8.png", 
	"res://Resources/Sprites/Monsters/monster9.png", 
	"res://Resources/Sprites/Monsters/monster10.png"
]

func _ready() -> void:
	GenerateMonsters(450)

func GenerateMonsters(numberToGenerate: float):
	var i = 0
	while i < numberToGenerate:
		var Instance : Monster = MonsterScene.instantiate()
		Instance.Generate()
		InStock.add_child(Instance)
		i += 1

func GenerateNPCsDebug():
	for monster in get_children():
		AddMonsterToWorld(monster)
		
func AddMonsterToWorld(newMon : Monster):
	var newNPC : MonsterNPC = MonsterNPCScene.instantiate()
	var newScale = randf_range(1.5, 4)
	newNPC.scale = Vector2(newScale, newScale)
	newNPC.monsterData = newMon
	newNPC.position = get_tree().get_nodes_in_group("spawnpos")[0].get_children().pick_random().position
	get_tree().get_nodes_in_group("nav")[0].get_parent().add_child(newNPC)
	InStock.remove_child(newMon)
	InWorld.add_child(newMon)
	newMon.tiedToNPC = newNPC
	OwnedMonsters.append(newMon)
	OnMonsterMoveFromCatagory.emit()

func MoveMonsterToWork(body : MonsterNPC):
	if(body.selected == false or body.atWork): return
	body.selected = false
	body.atWork = true
	var bodyParent = body.get_parent()
	bodyParent.remove_child(body)
	AtWork.add_child(body)
	OnMonsterMoveFromCatagory.emit()
