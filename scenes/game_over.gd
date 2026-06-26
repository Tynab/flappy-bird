extends CanvasLayer

# Tín hiệu để yêu cầu bắt đầu màn chơi mới
signal restart

# Hàm được gọi khi người chơi bấm nút "Chơi lại"
func _on_restart_button_pressed():
	restart.emit()
