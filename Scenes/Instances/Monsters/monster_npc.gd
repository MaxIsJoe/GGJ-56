class_name MonsterNPC
extends CharacterBody2D

enum MonsterGoal
{
	SEARCH,
	ATTACK,
	EAT,
}

@export_range(5,30) var speed : float = 15.0
@onready var status_display: Control = $StatusDisplay
@onready var nav : NavigationAgent2D = $NavigationAgent2D
@onready var sprite : Sprite2D = $Sprite2D
@onready var happiness_bar: TextureProgressBar = $StatusDisplay/HappinessBar
@onready var food_search: Area2D = $FoodSearch
@onready var attack_delay: Timer = $AttackDelay
@onready var goal_decider: Timer = $GoalDecider



var monsterData : Monster = null

var happiness : int = 100
var health : int = 100

var navNode = null
var dest : Vector2 = Vector2(0,0)
var stuckClock = 0
var currentTask : MonsterGoal = MonsterGoal.SEARCH
var currentAttackTarget = null
var currentEatTarget : Node2D = null

var selected : bool = false
var atWork : bool = false
var isDead : bool = false
var canAttack : bool = true

func _ready() -> void:
	navNode = get_tree().get_nodes_in_group("nav")[0]
	if(monsterData != null): CreateMonsterNPC(monsterData)
	status_display.modulate.a = 0.04
	Wander()
	
func Kill():
	isDead = true
	get_parent().remove_child(self)
	MonsterManage.graveyard.add_child(self)
	position = Vector2(0,0)
	goal_decider.stop()
	set_process(false)
	
func Damage(dmg : int) -> void:
	health -= dmg
	ChangeHappiness(-5)
	CorpManage.SpawnNumberIndicator(-dmg, global_position, self)
	currentTask = MonsterGoal.ATTACK
	DoTask()
	if(health <= 0): Kill()
	
func ChangeHappiness(newHap : float) -> void:
	happiness += newHap
	happiness_bar.value = happiness
	
func CreateMonsterNPC(data : Monster) -> void:
	monsterData = data
	sprite.texture = data.monsterGraphic
	status_display.get_child(0).text = "[center]" + data.monsterName

func _physics_process(delta: float) -> void:
	if (atWork or isDead): return
	if (selected):
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
		return
	stuckClock += 1
	if(stuckClock > 700): DoTask()
	if(currentAttackTarget != null):
		nav.target_position = currentAttackTarget.position
		if(currentAttackTarget.position.distance_to(self.position) < 95 and canAttack):
			currentAttackTarget.Damage(randi_range(8, 22))
			canAttack = false
			attack_delay.start()
	if(currentEatTarget != null):
		if(currentEatTarget.position.distance_to(self.position) < 95):
			if(currentEatTarget.is_in_group("food")):
				health += 50
				health = clamp(health, 0, 100)
			if(currentEatTarget.is_in_group("toy")):
				ChangeHappiness(50)
				CorpManage.ChangeStability(-25)
				CorpManage.ChangeResources(15)
			currentEatTarget.queue_free()
			currentTask = MonsterGoal.SEARCH
			DoTask()
			return
	velocity = (nav.get_next_path_position() - global_position).normalized() * speed
	move_and_slide()

func GetRandomTarget() -> Vector2:
	return position + Vector2(randf_range(-65,65), randf_range(-65,65))

func DoTask():
	match currentTask:
		MonsterGoal.SEARCH:
			Wander()
		MonsterGoal.ATTACK:
			Attack()
		MonsterGoal.EAT:
			Wander()

func Wander():
	stuckClock = 0
	dest = GetRandomTarget()
	nav.target_position = dest
	
func Attack():
	if(isDead or atWork):
		currentAttackTarget = null
		return
	if(currentAttackTarget != null):
		if(food_search.get_overlapping_bodies().has(currentAttackTarget) == false):
			currentAttackTarget = null
			currentTask = MonsterGoal.SEARCH
			DoTask()
			return
	for possibleTarget in food_search.get_overlapping_bodies():
		if (possibleTarget == self):
			continue
		if(possibleTarget is GUNTER):
			currentAttackTarget = possibleTarget
			break
		if(possibleTarget is MonsterNPC):
			currentAttackTarget = possibleTarget
			break
			
func Eat():
	if(currentEatTarget != null):
		if(food_search.get_overlapping_bodies().has(currentEatTarget) == false):
			currentEatTarget = null
			currentTask = MonsterGoal.SEARCH
			DoTask()
			return
	nav.target_position = currentEatTarget.position


func _on_navigation_agent_2d_target_reached() -> void:
	await get_tree().create_timer(3).timeout
	DoTask()
	if(randf_range(0, 100) < 50): ChangeHappiness(-8)


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if(event.is_action_pressed("mouseDown")):
		selected = !selected


func _on_area_2d_mouse_entered() -> void:
	var t = create_tween()
	t.tween_property(status_display, "modulate:a", 0.98, 0.4)
	t.play()


func _on_area_2d_mouse_exited() -> void:
	var t = create_tween()
	t.tween_property(status_display, "modulate:a", 0.04, 0.4)
	t.play()


func _on_goal_decider_timeout() -> void:
	if(isDead or atWork): return
	if(happiness < 25 or (monsterData.monsterType == Monster.MonsterType.PAIN and randi_range(0, 100) > 90)):
		currentTask = MonsterGoal.ATTACK
		CorpManage.PISS.ShowInfo("[center]" + monsterData.monsterName + " has gone on a rampage..")
		return
	for cow in food_search.get_overlapping_bodies():
		if(cow is GUNTER):
			currentTask = MonsterGoal.ATTACK
			return
		if(cow.is_in_group("food") and health < 95):
			currentTask = MonsterGoal.EAT
			currentEatTarget = cow
			return
		if(cow.is_in_group("toy") and happiness < 95):
			currentTask = MonsterGoal.EAT
			currentEatTarget = cow
			return
	currentTask = MonsterGoal.SEARCH


func _on_attack_delay_timeout() -> void:
	canAttack = true
	if(food_search.get_overlapping_bodies().has(currentAttackTarget) == false):
		currentAttackTarget = null
		currentTask = MonsterGoal.SEARCH
		DoTask()
