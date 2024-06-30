extends CharacterBody2D

var health = 4
var health_text

func _ready():
	health_text = $HealthText
	health_text.text = "[center]" + str(health) + "[/center]"
	
func _process(delta):
	#get_parent().progress += 200 * delta
	pass
	
func _on_hit_area_body_entered(body):
	body.queue_free()
	health -= 1
	health_text.text = "[center]" + str(health) + "[/center]"
	if health == 0:
		queue_free()
