extends TextureButton

@onready var progress_bar = $"../Panel3/VBoxContainer/ProgressBar"
@onready var label = $"../Panel3/VBoxContainer/DoneText"


func _on_button_up():
	progress_bar.hide()
	label.hide()
