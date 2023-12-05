extends Control

func _on_button_food_button_down() -> void:
	if(HasEnoughMoney(50.990) == false): return
	CorpManage.ChangeMoney(-50.990)
	var newItem = CorpManage.FOOD.instantiate()
	newItem.position = get_tree().get_nodes_in_group("spawnpos")[0].get_children().pick_random().position
	get_tree().get_nodes_in_group("nav")[0].get_parent().add_child(newItem)
	CorpManage.PISS.ShowInfo("[center]Food bought.")


func _on_button_lot_button_down() -> void:
	if(HasResourcesMoney(33.666) == false): return
	CorpManage.fuckshit.StartLootbox()
	CorpManage.ChangeResources(-33.666)


func _on_button_toys_button_down() -> void:
	if(HasEnoughMoney(111.111) == false): return
	CorpManage.ChangeMoney(-111.111)
	var newItem = CorpManage.TOY.instantiate()
	newItem.position = get_tree().get_nodes_in_group("spawnpos")[0].get_children().pick_random().position
	get_tree().get_nodes_in_group("nav")[0].get_parent().add_child(newItem)
	CorpManage.PISS.ShowInfo("[center]Toy bought.")


func HasEnoughMoney(money : float) -> bool:
	if(CorpManage.Money < money): 
		CorpManage.PISS.ShowInfo("[center]Not enough money.")
		return false
	return true

func HasResourcesMoney(money : float) -> bool:
	if(CorpManage.Resources < money): 
		CorpManage.PISS.ShowInfo("[center]Not enough exploited resources.")
		return false
	return true
