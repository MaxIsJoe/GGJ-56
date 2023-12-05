class_name MonsterWinGamblePopup
extends Control

@onready var monster_icon: TextureRect = $ColorRect/Info/MonsterIcon
@onready var youve_won_a: RichTextLabel = $ColorRect/Info/YouveWonA
@onready var rich_text_label: RichTextLabel = $ColorRect/Info/RichTextLabel

func ShowPrize(monsterData : Monster) -> void:
	monster_icon.texture = monsterData.monsterGraphic
	youve_won_a.text = "[font_size=9][center]You've won: " + monsterData.monsterName
	var finalInfoText = "[center][font_size=6]"
	finalInfoText += "Rating: " + str(monsterData.monsterRating) + "\n"
	finalInfoText += "Type: " + str(monsterData.monsterType) + "\n"
	finalInfoText += "Size: " + str(snapped(monsterData.tiedToNPC.scale.x, 0.01)) + "\n"
	rich_text_label.text = finalInfoText
	show()


func _on_button_button_down() -> void:
	hide()
