extends Control

@onready var collected_number: RichTextLabel = $"TabContainer/Collected Monsters/CollectedNumber"
@onready var profits: Graph2D = $TabContainer/Profits
@onready var monsterVList : VBoxContainer = $"TabContainer/Collected Monsters/ScrollContainer/MonsterVList"
var profitsPlot : Graph2D.PlotItem
var resoucesPlot : Graph2D.PlotItem

const MONSTER_DATA_ITEM = preload("res://Scenes/Instances/UI/monster_data.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CorpManage.OnResourcesChange.connect(UpdateInfo)
	profitsPlot = profits.add_plot_item("Money", Color.GREEN)
	resoucesPlot = profits.add_plot_item("Resources", Color.DARK_RED)


func UpdateInfo() -> void:
	profitsPlot.add_point(Vector2(Time.get_ticks_msec() / 1000, CorpManage.Money))
	resoucesPlot.add_point(Vector2(Time.get_ticks_msec() / 1000, CorpManage.Resources))
	profits.update_graph()
	profitsPlot.redraw()
	resoucesPlot.redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	profits.x_max = Time.get_ticks_msec() / 1000


func _on_visibility_changed() -> void:
	profits.update_plots()
	profits.update_graph()
	profitsPlot.redraw()
	resoucesPlot.redraw()
	if(monsterVList.get_child_count() > 0):
		for m in monsterVList.get_children():
			m.queue_free()
	
	var detected_names : Array[String] = []
	var allNames : int = MonsterManage.MonsterNames.size()
			
	for monster in MonsterManage.OwnedMonsters:
		var n : UIData_Monster = MONSTER_DATA_ITEM.instantiate()
		n.Setup(monster)
		monsterVList.add_child(n)
		if(detected_names.has(monster.monsterName) == false):
			detected_names.append(monster.monsterName)
	
	collected_number.text = "[center]Unique Monsters Collected: " + str(detected_names.size()) + "/" + str(allNames)
