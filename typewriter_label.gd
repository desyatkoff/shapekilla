extends RichTextLabel
class_name TypewriterLabel

@export var wait_time = 0.0
@export var typing_speed = 12
@export var start_visible_characters = 0
@export var end_visible_characters = -1

var time = 0.0

func _ready():
	visible_characters = start_visible_characters

func _process(delta):
	wait_time -= delta
	
	if wait_time <= 0.0:
		time += delta
	
	if visible_characters != end_visible_characters:
		visible_characters = int(time * typing_speed)
