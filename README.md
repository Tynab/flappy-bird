# FLAPPY BIRD GAME
Dự án game Flappy Bird được xây dựng bằng Godot Engine linh hoạt, hoàn hảo cho cả người chơi và những nhà phát triển game đam mê học hỏi.

## DEMO TRỰC TUYẾN
<div align='center'>

[Nhấn vào đây để chơi game](https://tynab.github.io/Flappy-Bird/build)

</div>

## HÌNH ẢNH MINH HỌA
<p align='center'>
<img src='pic/0.jpg'></img>
</p>

## ĐIỂM NỔI BẬT KỸ THUẬT VÀ MÃ NGUỒN
Dự án được xây dựng bằng **Godot 4.2**, sử dụng GDScript với các kỹ thuật chính:
- **CharacterBody2D**: Ứng dụng để mô phỏng vật lý và chuyển động của chim.
- **Area2D & CollisionShape2D**: Quản lý va chạm giữa chim, ống nước và mặt đất, cũng như cơ chế ghi điểm.
- **Tín hiệu (Signals)**: Được tối ưu để giao tiếp linh hoạt giữa các đối tượng (như ghi điểm, kết thúc game).
- **Lập trình hướng đối tượng cơ bản**: Mã nguồn được chia thành các file rõ ràng (`main.gd`, `bird.gd`, `pipe.gd`, v.v.).

```gdscript
# Hàm sinh ống nước ngẫu nhiên
func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2.0 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)
```
