extends Area2D

@onready var number_of_workers: RichTextLabel = $Control/NumberOfWorkers
@onready var send_to_work_button: Button = $Control/KILLButton
@onready var release_button: Button = $Control/ReleaseButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	release_button.hide()
	send_to_work_button.hide()
	await get_tree().create_timer(0.4).timeout
	MonsterManage.OnMonsterMoveFromCatagory.connect(UpdateLabel)
	UpdateLabel()


func _on_body_entered(body: Node2D) -> void:
	if(body is GUNTER):
		OS.alert("GAME OVER", "HF enemies have stolen their tech.")
		await get_tree().create_timer(1).timeout
		get_tree().quit(666)
		return
	var ki = body as MonsterNPC
	if(ki != null): MonsterManage.MoveMonsterToWork(ki)
	

func UpdateLabel() -> void:
	var count = MonsterManage.AtWork.get_child_count()
	number_of_workers.text = str(count) + " working"
	if(count > 0):
		release_button.show()
		send_to_work_button.show()
	else:
		release_button.hide()
		send_to_work_button.hide()


func _on_release_button_button_down() -> void:
	for gamer in MonsterManage.AtWork.get_children():
		gamer.atWork = false
		MonsterManage.AtWork.remove_child(gamer)
		get_parent().get_parent().add_child(gamer)
	
	MonsterManage.OnMonsterMoveFromCatagory.emit()


func _on_kill_button_button_down() -> void:
	var count = MonsterManage.AtWork.get_child_count()
	var resource_comp = 0
	for aaaaaaaaa in MonsterManage.AtWork.get_children():
		resource_comp += 18.5
		aaaaaaaaa.Kill()
	
	CorpManage.PISS.ShowInfo("[center]" + str(count) + " monsters have been decommissioned. Total compensation: " + str(resource_comp) + "R" )
	CorpManage.ChangeResources(resource_comp)
	MonsterManage.OnMonsterMoveFromCatagory.emit()
