@tool

extends RichTextEffect
class_name RichTextWobbleTextEffect

var bbcode = "wobble"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var t = Time.get_ticks_msec() / 1000.0
	
	var index = char_fx.range.x
	
	var amp = 2.0
	var speed = 4.0
	var freq = 1.0
	
	if char_fx.env.has("amp"):
		amp = float(char_fx.env["amp"])
	
	if char_fx.env.has("speed"):
		speed = float(char_fx.env["speed"])
	
	if char_fx.env.has("freq"):
		freq = float(char_fx.env["freq"])
	
	char_fx.offset.x = cos(t * speed + index * freq) * amp
	char_fx.offset.y = sin(t * speed + index * freq) * amp
	
	return true
