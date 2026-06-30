## Quản lý mặt đất.
## Phát tín hiệu hit khi chim rơi chạm xuống mặt đất.
extends Area2D

# --- Tín hiệu ---
## Phát ra khi phát hiện chim va chạm với mặt đất.
signal hit

## Callback khi có body (chim) đi vào vùng va chạm: phát tín hiệu hit.
func _on_body_entered(_body: Node2D) -> void:
	hit.emit()