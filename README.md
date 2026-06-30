# FLAPPY BIRD GAME

Dự án game Flappy Bird được xây dựng bằng **Godot Engine 4.2**, sử dụng **GDScript** và renderer **GL Compatibility**. Phù hợp cho cả người chơi lẫn nhà phát triển muốn học lập trình game 2D.

## DEMO TRỰC TUYẾN

<div align='center'>

[Nhấn vào đây để chơi game](https://tynab.github.io/Flappy-Bird/build)

</div>

## HÌNH ẢNH MINH HỌA

<p align='center'>
<img src='pic/0.jpg'></img>
</p>

## CẤU TRÚC DỰ ÁN

```
flappy-bird/
├── assets/                # Tài nguyên đồ hoạ (sprite chim, ống nước, nền, mặt đất, nút restart)
├── build/                 # Bản build web (HTML5) đã export sẵn
├── pic/                   # Ảnh minh hoạ cho README
├── scenes/                # Các scene (.tscn) và script GDScript (.gd)
│   ├── main.gd / .tscn    # Logic chính: vòng đời game, cuộn nền, sinh ống, tính điểm
│   ├── bird.gd / .tscn    # Vật lý chim: trọng lực, vỗ cánh, xoay góc, animation
│   ├── pipe.gd / .tscn    # Ống nước: phát tín hiệu va chạm và ghi điểm
│   ├── ground.gd / .tscn  # Mặt đất: phát tín hiệu khi chim chạm đất
│   └── game_over.gd/.tscn # Màn hình kết thúc: nút Restart
├── project.godot          # Cấu hình project Godot
├── icon.png               # Biểu tượng ứng dụng
└── README.md
```

## ĐIỂM NỔI BẬT KỸ THUẬT

### Kiến trúc tổng quan

Dự án sử dụng kiến trúc **scene-based** của Godot 4.2 với viewport `864×936` pixel, chế độ stretch `viewport` và renderer `GL Compatibility` để tương thích rộng rãi trên nhiều nền tảng.

### Các kỹ thuật chính

- **CharacterBody2D** (`bird.gd`): Mô phỏng vật lý chim với trọng lực (`1000 px/s²`), vận tốc vỗ cánh (`-500 px/s`), giới hạn tốc độ rơi (`600 px/s`). Xoay góc tỷ lệ với vận tốc khi bay (`velocity.y * 0.05`), xoay thẳng đứng (`PI/2`) khi rơi. Sử dụng `move_and_collide()` để phát hiện va chạm chính xác.

- **Area2D** (`pipe.gd`, `ground.gd`): Ống nước và mặt đất đều là `Area2D` với tín hiệu `body_entered` để phát hiện va chạm với chim (`CharacterBody2D`). Ống nước có thêm `ScoreArea` (Area2D con) để xác định vùng ghi điểm khi chim bay qua khe giữa.

- **Signal (tín hiệu)**: Giao tiếp lỏng lẻo (loose coupling) giữa các node — ống nước phát `hit`/`scored`, mặt đất phát `hit`, màn hình Game Over phát `restart`, tất cả được kết nối về `main.gd` để xử lý tập trung thông qua signal connections trong scene.

- **Timer** (`main.tscn`): Sử dụng `Timer` node (chu kỳ `1.5s`) để sinh ống nước mới đều đặn, thay vì tính toán khoảng cách thủ công.

- **Cuộn mặt đất** (`main.gd`): Mặt đất được cuộn bằng cách dịch `position.x` theo `SCROLL_SPEED` (4 px/frame), reset khi vượt quá chiều rộng viewport. Ống nước cũng di chuyển cùng tốc độ.

- **Quản lý ống nước** (`main.gd`): Ống được sinh động (dynamically instantiated) từ `PackedScene` export, vị trí Y ngẫu nhiên trong biên `±200px`. Nhóm `"pipes"` cho phép xoá nhanh toàn bộ ống khi bắt đầu ván mới qua `call_group()`.

- **Collision hình dạng** (`bird.tscn`, `pipe.tscn`, `ground.tscn`): Chim sử dụng `CapsuleShape2D`, ống nước dùng nhiều `RectangleShape2D` (bao gồm phần thân và đầu ống), mặt đất dùng `RectangleShape2D` rộng bao phủ toàn bộ chiều ngang.

### Đoạn code mẫu — Sinh ống nước

```gdscript
## Sinh một cặp ống nước mới tại vị trí Y ngẫu nhiên.
func generate_pipes() -> void:
    var pipe := pipe_scene.instantiate()
    pipe.position.x = screen_size.x + PIPE_DELAY
    pipe.position.y = (screen_size.y - ground_height) / 2.0 + randi_range(-PIPE_RANGE, PIPE_RANGE)
    pipe.hit.connect(bird_hit)
    pipe.scored.connect(scored)
    add_child(pipe)
    pipes.append(pipe)
```

## CÁCH CHẠY DỰ ÁN

1. Cài đặt [Godot Engine 4.2+](https://godotengine.org/download).
2. Clone repository:
   ```bash
   git clone https://github.com/Tynab/Flappy-Bird.git
   ```
3. Mở project bằng Godot Editor → chọn `project.godot`.
4. Nhấn **F5** hoặc nút **Play** để chạy game.

## CÁCH CHƠI

- **Click chuột trái** để bắt đầu game và vỗ cánh.
- Tránh va chạm vào ống nước và mặt đất.
- Nếu chim bay vượt mép trên màn hình cũng sẽ thua.
- Mỗi lần bay qua khe ống sẽ được **+1 điểm**.
- Khi thua, nhấn nút **Restart** để chơi lại.