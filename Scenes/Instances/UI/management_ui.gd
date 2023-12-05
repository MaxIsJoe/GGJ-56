extends Control

@onready var pages = $Background/Pages
@onready var helpPage = $Background/Pages/HelpPage
@onready var shopPage = $Background/Pages/Shop
@onready var dataPage = $Background/Pages/Data
@onready var button_quit: Button = $Background/Buttons/ButtonQuit

var numberOfTimesSwitched : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(OS.get_name() == "Web"):
		button_quit.hide()
		CorpManage.PISS.ShowInfo("You're playing on the web version, which is unplayable at the moment.")
		
func _process(delta: float) -> void:
	if(OS.get_name() == "Web"): 
		self.queue_redraw()
		for child in pages.get_children(true):
			child.queue_redraw()

func HideAllPages() -> void:
	helpPage.hide()
	shopPage.hide()
	dataPage.hide()

func _on_button_quit_button_down() -> void:
	get_tree().quit(111)


func _on_button_shop_button_down() -> void:
	HideAllPages()
	shopPage.show()


func _on_button_data_button_down() -> void:
	HideAllPages()
	dataPage.show()
	

func _on_button_help_button_down() -> void:
	HideAllPages()
	helpPage.show()


