extends Node3D

@onready var bar = $SubViewport/CanvasLayer/TextureProgressBar
var tween

func update_health(current, maximum):
	if not tween or not tween.is_running():
		tween = get_tree().create_tween()
		tween.tween_property(bar, "value", current, 0.25).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(bar, "max_value", maximum, 0.25).set_trans(Tween.TRANS_LINEAR)
		
		tween.bind_node(self)


func set_values():
	var component_current_health = get_parent().get_node("HealthComponent").health
	var component_max_health = get_parent().get_node("HealthComponent").max_health
	
	bar.value = component_current_health
	bar.max_value = component_max_health


# Called when the node enters the scene tree for the first time.
func _ready():
	var component_current_health = get_parent().get_node("HealthComponent").health
	var component_max_health = get_parent().get_node("HealthComponent").max_health
	
	hide()
	
	bar.value = component_current_health
	bar.max_value = component_max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var component_current_health = get_parent().get_node("HealthComponent").health
	var component_max_health = get_parent().get_node("HealthComponent").max_health
	
	if (
		component_current_health != bar.value
		or component_max_health != bar.max_value
	):
		update_health(component_current_health, component_max_health)
	
	if bar.value == bar.max_value:
		hide()
	elif not is_visible() and $SetUpTimer.is_stopped():
		show()
		pass
