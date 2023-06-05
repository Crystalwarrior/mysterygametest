extends PanelContainer

const STYLE_DESELECTED = preload("res://toolbar_slot.tres")
const STYLE_SELECTED = preload("res://toolbar_slot_selected.tres")

@onready var label = $IndexLabel
@onready var image = $Image

signal selected

@export var hotkey = "":
	set(value):
		hotkey = value
		if label.text != hotkey:
			label.text = hotkey
	get:
		return hotkey


func _unhandled_key_input(event):
	if event.pressed and not event.echo and OS.get_keycode_string(event.keycode) == hotkey:
		# handle selecting process in our parent
		selected.emit()


func set_selected(tog: bool):
	remove_theme_stylebox_override("panel")
	add_theme_stylebox_override("panel", STYLE_SELECTED if tog else STYLE_DESELECTED)
