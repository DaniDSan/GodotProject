extends RichTextLabel

var health = 4
# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(health)
	
func _process(_delta): # Replace with function body.
	if health > 0:
		text = str(health)
	else:
		text = "PIERDES"
