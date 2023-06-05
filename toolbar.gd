extends HBoxContainer

@onready var slot_scene = preload("res://toolbar_slot.tscn")

#todo: add support for more than 9 slots + custom keybindings for slots
@export var slots = 8

var current_slot_selected = null

func _ready():
	set_slots(slots)

func set_slots(num: int):
	slots = num
	while get_child_count() >= num:
		get_child(get_child_count()-1).queue_free()
	while get_child_count() < num:
		var newslot = slot_scene.instantiate()
		add_child(newslot)
		newslot.selected.connect(slot_selected.bind(newslot))
		var index = newslot.get_index()
		newslot.name = str(index+1)
		newslot.hotkey = str(index+1)

func slot_selected(slot):
	if current_slot_selected == slot:
		slot.set_selected(false)
		current_slot_selected = null
		return
	if current_slot_selected:
		current_slot_selected.set_selected(false)
	slot.set_selected(true)
	current_slot_selected = slot
