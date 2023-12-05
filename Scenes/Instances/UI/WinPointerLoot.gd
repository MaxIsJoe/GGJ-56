class_name LootPoint
extends TextureRect

var monster : Monster

func Set(chosenMonster : Monster):
	monster = chosenMonster
	texture = chosenMonster.monsterGraphic
