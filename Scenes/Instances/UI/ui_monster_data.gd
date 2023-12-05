class_name UIData_Monster
extends Control

func Setup(monsterData : Monster):
	$HBoxContainer/TextureRect.texture = monsterData.monsterGraphic
	$HBoxContainer/MonsterName.text = monsterData.monsterName
	$HBoxContainer/MonsterRating.text = str(monsterData.monsterRating)
	$HBoxContainer/MonsterType.text = str(monsterData.monsterType)
	var alive = false
	if(monsterData.tiedToNPC):
		if(monsterData.tiedToNPC.isDead == false): alive = true
	else:
		alive = false
	var textAlive = ""
	if(alive):
		textAlive = "Alive"
	else:
		textAlive = "Dead"
	$HBoxContainer/MonsterAlive.text = textAlive
