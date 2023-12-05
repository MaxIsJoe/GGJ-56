class_name GAMBLE
extends Control

@onready var HBC1 = $Wheel/HBC1
@onready var HBC2 = $Wheel/HBC2
@onready var HBC3 = $Wheel/HBC3
@onready var pointer = $Wheel/ColorRect
@onready var winnerText : RichTextLabel = $Winner

var startingSpeed = 90
var currentSpeed = 0
var restpos = 1770
var buttons : Array[ColorRect]
var buttonsData : Array[LootPoint]
var winner : LootPoint
var possibleWinner : Area2D
var winnerAnnounced = false

func _ready() -> void:
	buttons.append_array(HBC1.get_children())
	buttons.append_array(HBC2.get_children())
	buttons.append_array(HBC3.get_children())
	for child in buttons:
		buttonsData.append(child.get_child(0))
	RefreshSlots()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(currentSpeed > 0): Spin()

func Spin():
	currentSpeed -= 0.1
	HBC1.position.x = lerpf(HBC1.position.x, HBC1.position.x + currentSpeed, 0.5)
	HBC2.position.x = lerpf(HBC2.position.x, HBC2.position.x + currentSpeed, 0.5)
	HBC3.position.x = lerpf(HBC3.position.x, HBC3.position.x + currentSpeed, 0.5)
	if (HBC1.position.x > restpos): HBC1.position.x = -restpos
	if (HBC2.position.x > restpos): HBC2.position.x = -restpos
	if (HBC3.position.x > restpos): HBC3.position.x = -restpos
	if (currentSpeed < 0): AnnounceWinner()

func AnnounceWinner():
	winner = possibleWinner.get_parent().get_child(0)
	if(winner == null): return
	winnerText.text = winner.monster.monsterName
	winnerAnnounced = true
	MonsterManage.AddMonsterToWorld(winner.monster)
	CorpManage.fuckshit.block_screen_switch = false
	CorpManage.fuckshit.win_monster_popup.ShowPrize(winner.monster)
	hide()

func StartSpining() -> void:
	CorpManage.fuckshit.block_screen_switch = true
	RefreshSlots()
	winner = null
	winnerText.text = ""
	winnerAnnounced = false
	currentSpeed = startingSpeed
	show()
	
func RefreshSlots():
	for child in buttonsData:
		child.Set(MonsterManage.InStock.get_children().pick_random())


func _on_button_button_down() -> void:
	StartSpining()


func _on_area_2d_area_entered(area: Area2D) -> void:
	possibleWinner = area
	$SlotSound.play()
