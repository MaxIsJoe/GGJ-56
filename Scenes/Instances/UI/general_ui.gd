extends Control


@onready var money: RichTextLabel = $ResourceMonitor/Money
@onready var resource: RichTextLabel = $ResourceMonitor/Resource
@onready var progress_bar: ProgressBar = $ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CorpManage.OnResourcesChange.connect(UpdateUI)


func UpdateUI() -> void:
	money.text = "Money: " + str(CorpManage.Money)
	resource.text = "Resources: " + str(CorpManage.Resources)
	var t = create_tween()
	t.tween_property(progress_bar, "value", clamp(CorpManage.Stability, 0.0, 100.0), 0.4)
	t.play()
