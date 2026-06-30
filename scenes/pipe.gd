## Quản lý ống nước (chướng ngại vật).
## Phát tín hiệu va chạm (hit) khi chim chạm thân ống,
## và tín hiệu ghi điểm (scored) khi chim bay qua khe giữa hai ống.
extends Area2D

# --- Tín hiệu ---
## Phát ra khi chim va chạm vào thân ống.
signal hit
## Phát ra khi chim bay qua vùng ghi điểm giữa hai ống.
signal scored

## Xử lý va chạm thân ống: phát tín hiệu hit.
func _on_body_entered(_body: Node2D) -> void:
	hit.emit()

## Xử lý khi chim bay qua vùng ghi điểm: phát tín hiệu scored.
func _on_score_area_body_entered(_body: Node2D) -> void:
	scored.emit()