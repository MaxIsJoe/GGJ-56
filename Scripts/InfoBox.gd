class_name InfoBoxGameplay
extends ColorRect

@onready var rich_text_label: RichTextLabel = $RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CorpManage.PISS = self
	hide()

func ShowInfo(text: String) -> void:
	show()
	rich_text_label.text = text
	await get_tree().create_timer(5).timeout
	hide()
