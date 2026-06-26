extends Area2D

# Tín hiệu khi chim rơi chạm xuống đất
signal hit

# Hàm kích hoạt tín hiệu khi phát hiện va chạm với mặt đất
func _on_body_entered(_body):
	hit.emit()
