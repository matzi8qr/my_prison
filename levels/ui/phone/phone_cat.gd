extends Node2D


# screed up my architecture for the minigame im sure


signal close_phone

var phone_visible = false
@onready var root = find_parent("Phone")

func _on_phone_visibility_changed() -> void:
	if root:
		phone_visible = root.visible
		if not phone_visible:
			close_phone.emit()
