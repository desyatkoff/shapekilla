@tool

extends RichTextEffect
class_name RichTextTypeTextEffect

var bbcode = "type"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var delay: float = char_fx.env.get("delay", 0.0)
	var speed: float = char_fx.env.get("speed", 10.0)
	
	var index = char_fx.relative_index
	var progress = char_fx.elapsed_time * speed - delay
	
	char_fx.visible = false
	
	if progress >= index:
		char_fx.visible = true
	
	return true
