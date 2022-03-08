extends Control

onready var strong = $VBoxContainer/HBoxContainer/Strong
onready var weak = $VBoxContainer/HBoxContainer/Weak
onready var connection = $VBoxContainer/Connection
onready var duration = $VBoxContainer/Vibration/Duration
onready var length = $VBoxContainer/Stick/Length
onready var length2 = $VBoxContainer/Stick/Length2
onready var set = $VBoxContainer/HBoxContainer2/Set


func _ready():
	$VBoxContainer/Vibration/Duration.grab_focus()
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	
	var already_connected = Input.get_connected_joypads()
	if already_connected and already_connected[0] == 0:
		_on_joy_connection_changed(0, true)
	
	
func _on_joy_connection_changed(device, connected):
	if device == 0:
		connection.pressed = connected
		connection.text = Input.get_joy_name(device)


func _unhandled_input(event):
	var stick = Input.get_vector("left", "right", "down", "up")
	var stick2 = Input.get_vector("left2", "right2", "down2", "up2")
	
	# 1 + log(0-1) = natural deadzone at 0.3678793 and natural (muscle) motor curve
	stick *= clamp(1 + log(stick.length()), 0, 1)
	stick2 *= clamp(1 + log(stick2.length()), 0, 1)
	
	length.value = stick.length()
	length2.value = stick2.length()
	
	if not set.pressed:
		if event.is_action("strong_vibration"):
			strong.value = 1 + log(Input.get_action_strength("strong_vibration")) 
		if event.is_action("weak_vibration"):
			weak.value = 1 + log(Input.get_action_strength("weak_vibration"))


func _on_Vibrate_pressed():
	Input.start_joy_vibration(0, weak.value, strong.value, duration.value)


func _on_Stop_pressed():
	Input.stop_joy_vibration(0)
