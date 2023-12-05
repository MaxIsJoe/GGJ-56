class_name GUNTER
extends CharacterBody2D


@onready var fire_delay: Timer = $FireDelay
@onready var agent: NavigationAgent2D = $agent
@onready var attack_raidus: Area2D = $AttackRaidus
@export var speed : float = 450

var health : int = 100

var target : MonsterNPC = null
var attacking : bool = false
var fireOnDelay : bool = false
var workinator = null

func _ready() -> void:
	workinator = get_tree().get_nodes_in_group("worknaitor")[0]

func _physics_process(delta: float) -> void:
	if(target == null): 
		agent.target_position = workinator.position
		velocity = (agent.get_next_path_position() - global_position).normalized() * speed * 1.75 * delta
		move_and_slide()
		return
	if(target.isDead or target.atWork):
		target = null
		return
	if(attacking):
		if(target.position.distance_to(position) > 100):
			attacking = false
			return
		if(fireOnDelay == true): return
		target.Damage(randi_range(3,5))
		fireOnDelay = true
		fire_delay.start()
		return
	agent.target_position = target.position
	velocity = (agent.get_next_path_position() - global_position).normalized() * speed * delta
	move_and_slide()

func SearchForTarget() -> void:
	if(MonsterManage.InWorld.get_child_count() == 0): return
	var possibleTarget : MonsterNPC = null
	for monster in MonsterManage.InWorld.get_children() as Array[Monster]:
		if(possibleTarget == null):
			possibleTarget = monster.tiedToNPC
			continue
		if(monster.tiedToNPC.position.distance_to(position) < possibleTarget.position.distance_to(position)): 
			possibleTarget = monster.tiedToNPC
	
	target = possibleTarget

func Damage(dmg : int) -> void:
	health -= dmg
	CorpManage.SpawnNumberIndicator(-dmg, global_position, self)
	if(health <= 0): queue_free()


func _on_task_timer_timeout() -> void:
	for body in attack_raidus.get_overlapping_bodies():
		if(body is MonsterNPC == false): continue
		attacking = true
		target = body as MonsterNPC
	if(target == null):
		SearchForTarget()


func _on_fire_delay_timeout() -> void:
	fireOnDelay = false
