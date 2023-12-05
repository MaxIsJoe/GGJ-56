class_name CorpManager
extends Node

var Money : float = 50
var Resources : float = 150
var Stability : float = 0.0

var fuckshit : GameUIControl
var PISS : InfoBoxGameplay

const NUMBER_INDICATOR = preload("res://Scenes/Instances/damage_indiactor.tscn")
const FOOD = preload("res://Scenes/Instances/food.tscn")
const TOY = preload("res://Scenes/Instances/toy.tscn")
const GUNTER_THE_SEXY = preload("res://Scenes/Instances/Monsters/gunter.tscn")

signal OnResourcesChange

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	OnResourcesChange.emit()

func GenResources() -> void:
	var monsters : Array = MonsterManage.AtWork.get_children()
	if (monsters.size() == 0): return
	var finalMoney : int = 0
	var finalStability : float = 0.0
	var numberOfUnhappyMonsters : int = 0 
	for monster in monsters:
		var npc = monster as MonsterNPC
		npc.ChangeHappiness(snapped(randf_range(-2.0,-4.0), 0.1))
		if(npc.happiness < 25): 
			finalStability += 3.15
			numberOfUnhappyMonsters += 1
		match npc.monsterData.monsterType:
			Monster.MonsterType.PEACFUL:
				finalMoney += 1
				finalStability -= 1 * npc.monsterData.monsterRating + clamp(npc.happiness / 2, 2, 100)
			Monster.MonsterType.PAIN:
				finalMoney += 15 + npc.monsterData.monsterRating
				finalStability += 2.5
				npc.ChangeHappiness(15)
			Monster.MonsterType.RESOURCE:
				ChangeResources(8 + npc.monsterData.monsterRating)
				npc.ChangeHappiness(10)
			Monster.MonsterType.FEAR:
				finalMoney += 5 + npc.monsterData.monsterRating
				ChangeResources(3 + npc.monsterData.monsterRating)
				finalStability += 1 + npc.monsterData.monsterRating
				if(randf_range(0, 100) > 50): Resources += randf_range(0.250, 3.000)
				
	ChangeMoney(finalMoney)
	ChangeStability(finalStability)
	OnResourcesChange.emit()
	if(numberOfUnhappyMonsters >= 2): 
		print(finalStability, "->", Stability)
		PISS.ShowInfo("[center]Multiple monsters have been detected to be unhappy at work. 
		Release them to avoid their anger and stability getting reduced.")

func ChangeMoney(amount : float) -> void:
	Money += amount
	Money = snapped(Money, 0.001)
	OnResourcesChange.emit()

func ChangeResources(amount : float) -> void:
	Resources += amount
	Resources = snapped(Resources, 0.001)
	OnResourcesChange.emit()
	
func ChangeStability(amount : float) -> void:
	Stability += amount
	Stability = clamp(Stability, -5, 100)
	OnResourcesChange.emit()
	
func SpawnNumberIndicator(number : int, position : Vector2, target : Node) -> void:
	var num = NUMBER_INDICATOR.instantiate() as NumberIndicator
	target.add_child(num)
	num.rich_text_label.text = str(number)
	num.global_position = position
	num.anim.play("shownum")
	
func SpawnWave():
	var numberToSpawn : int = 0
	if(Stability >= 35): numberToSpawn += 1
	if(Stability >= 60): numberToSpawn += 2
	if(Stability >= 85): numberToSpawn += 3
	var newNPC : GUNTER = GUNTER_THE_SEXY.instantiate()
	newNPC.position = get_tree().get_nodes_in_group("spawnpos2")[0].get_children().pick_random().position
	get_tree().get_nodes_in_group("nav")[0].get_parent().add_child(newNPC)


func _on_timer_timeout() -> void:
	if(Stability > 0): ChangeStability(-0.5)
	if(Stability >= 35): SpawnWave()
	GenResources()
