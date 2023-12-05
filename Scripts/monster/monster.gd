class_name Monster
extends Node

enum MonsterType
{
	PEACFUL,
	RESOURCE,
	FEAR,
	PAIN
}

@export var monsterName : String = "Unknown"
@export var monsterRating : float = GetRandomRating()
@export var monsterType : MonsterType = MonsterType.PEACFUL
@export var monsterGraphic : Texture2D 

var isInWorld : bool = false
var tiedToNPC : MonsterNPC = null

func GetRandomRating() -> float:
	return snapped(randf_range(0.000, 1.000), 0.001)

func Generate(genSpcificType = false, spcificType = MonsterType.RESOURCE) -> void:
	monsterName = MonsterManage.MonsterNames.pick_random()
	monsterGraphic = load(MonsterManage.monsterSprites.pick_random())
	monsterRating = GetRandomRating()
	if (genSpcificType):
		monsterType = spcificType
	else:
		monsterType = MonsterType.values().pick_random()
