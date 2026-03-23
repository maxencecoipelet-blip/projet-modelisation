extends Node
var time=0
var night_duration=60
var win=false
var IG=false
var on_pc=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if time<=night_duration:
		if IG==true:
			time+=delta*2
		else:
			time+=delta
	else:
		win_game()
		
	
	
	
	
	
	
		
func get_current_hour():
	var ratio = time / night_duration
	var hour = int(ratio * 6)
	return clamp(hour, 0, 6)
	
	
	
func win_game():
	win=true
	
