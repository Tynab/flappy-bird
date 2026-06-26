extends Area2D

# Các tín hiệu báo cáo trạng thái va chạm hoặc ghi điểm
signal hit
signal scored

# Hàm được kích hoạt khi chim chạm vào thân ống
func _on_body_entered(_body):
	hit.emit()

# Hàm được kích hoạt khi chim bay qua vùng trống giữa hai ống (ghi điểm)
func _on_score_area_body_entered(_body):
	scored.emit()
