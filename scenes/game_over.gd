## Màn hình kết thúc game (Game Over).
## Chứa nút Restart và phát tín hiệu để yêu cầu bắt đầu ván mới.
extends CanvasLayer

# --- Tín hiệu ---
## Phát ra khi người chơi nhấn nút Restart để chơi lại.
signal restart

## Callback nút Restart: phát tín hiệu restart về main.gd.
func _on_restart_button_pressed() -> void:
	restart.emit()