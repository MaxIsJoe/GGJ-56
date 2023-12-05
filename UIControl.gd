class_name GameUIControl
extends CanvasLayer

@onready var general_ui: Control = $GeneralUI
@onready var lootbox: GAMBLE = $Lootbox
@onready var management_ui: Control = $ManagementUI
@onready var win_monster_popup: MonsterWinGamblePopup = $WinMonsterPopup
@onready var jumpscare: TextureRect = $Jumpscare

var timesTabbed : = 0

var timesToJumpsacer = [12, 42, 69, 91, 124, 200, 220, 280, 355, 415, 700]


var block_screen_switch : bool = false

func _ready() -> void:
	CorpManage.fuckshit = self

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("switchscreens") and block_screen_switch == false):
		timesTabbed += 1
		ShowManagementUI()

func HideEverything() -> void:
	#general_ui.hide()
	lootbox.hide()
	management_ui.hide()
	
func StartLootbox() -> void:
	HideEverything()
	lootbox.StartSpining()
	if(timesToJumpsacer.has(timesTabbed)): jumpscare.show()

func ShowManagementUI() -> void:
	if(management_ui.visible):
		management_ui.hide()
		if(timesToJumpsacer.has(timesTabbed)): jumpscare.show()
		return
	HideEverything()
	management_ui.show()
	if(timesToJumpsacer.has(timesTabbed + 1)):
		CorpManage.PISS.ShowInfo("[center]The abyss stares at you..")
	if(jumpscare.visible):
		jumpscare.hide()
