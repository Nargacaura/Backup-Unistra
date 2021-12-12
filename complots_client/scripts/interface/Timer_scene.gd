extends Control

var chrono_time: float

func _ready():
	pass

func trigger(time: int):
	if time > 3:
		chrono_time = float(time)
		print("chrono_time ", chrono_time)
		$TextureProgress.set_max(chrono_time*100)
		$Timer.start(chrono_time)
		set_process(true)
		show()

func stop():
	hide()
	set_process(false)
	$Timer.stop()
	chrono_time = 0

func _process(_delta):
	if chrono_time > 0:
		$TextureProgress.value = 100*$Timer.time_left
