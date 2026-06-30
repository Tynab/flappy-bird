## Điều khiển logic chính của game Flappy Bird.
## Quản lý vòng đời game: khởi tạo, cuộn nền, sinh ống nước, tính điểm và kết thúc.
extends Node

# --- Thuộc tính export ---
## Scene ống nước, gán từ Inspector trong editor.
@export var pipe_scene: PackedScene

# --- Hằng số ---
## Tốc độ cuộn nền và di chuyển ống (pixel/frame).
const SCROLL_SPEED: int = 4
## Khoảng cách thêm khi sinh ống nước so với mép phải màn hình (pixel).
const PIPE_DELAY: int = 100
## Biên dao động ngẫu nhiên theo trục Y khi sinh ống nước (pixel).
const PIPE_RANGE: int = 200

# --- Tham chiếu node ---
## Tham chiếu đến node chim.
@onready var bird: CharacterBody2D = $Bird
## Tham chiếu đến node mặt đất.
@onready var ground: Area2D = $Ground
## Tham chiếu đến label hiển thị điểm số.
@onready var score_label: Label = $ScoreLabel
## Tham chiếu đến màn hình Game Over.
@onready var game_over_screen: CanvasLayer = $GameOver
## Tham chiếu đến Timer sinh ống nước.
@onready var pipe_timer: Timer = $PipeTimer

# --- Biến trạng thái ---
## Cờ game đang chạy (chim đang bay, ống đang di chuyển).
var game_running: bool
## Cờ game đã kết thúc (chim va chạm).
var game_over: bool
## Kích thước viewport, dùng để tính vị trí sinh ống.
var screen_size: Vector2i
## Chiều cao texture mặt đất, dùng để tính toạ độ Y ống nước.
var ground_height: int
## Mảng chứa các ống nước đang hiển thị trên màn hình.
var pipes: Array = []
## Giá trị cuộn mặt đất hiện tại (pixel).
var scroll: int = 0
## Điểm số hiện tại.
var score: int = 0

## Khởi tạo: lấy kích thước màn hình, chiều cao mặt đất và bắt đầu ván mới.
func _ready() -> void:
	screen_size = get_tree().root.content_scale_size
	ground_height = ground.get_node("Sprite2D").texture.get_height()
	new_game()

## Xử lý input: click chuột trái để bắt đầu game hoặc vỗ cánh.
func _input(event: InputEvent) -> void:
	if game_over:
		return
	# Chỉ phản hồi click chuột trái
	if not (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		return
	if not game_running:
		# Lần click đầu tiên: bắt đầu game
		game_running = true
		bird.flying = true
		bird.flap()
		pipe_timer.start()
	else:
		if bird.flying:
			bird.flap()
			# Nếu chim bay vượt mép trên màn hình thì kết thúc
			if bird.position.y < 0:
				bird.falling = true
				stop_game()

## Mỗi frame: cuộn mặt đất và di chuyển các ống nước sang trái.
func _process(_delta: float) -> void:
	if not game_running:
		return
	# Cuộn nền mặt đất
	scroll += SCROLL_SPEED
	if scroll >= screen_size.x:
		scroll = 0
	ground.position.x = -scroll
	# Di chuyển tất cả ống nước sang trái
	for pipe in pipes:
		pipe.position.x -= SCROLL_SPEED

## Callback Timer: sinh ống nước mới theo chu kỳ.
func _on_pipe_timer_timeout() -> void:
	generate_pipes()

## Callback khi chim chạm đất: dừng trạng thái rơi và kết thúc game.
func _on_ground_hit() -> void:
	bird.falling = false
	stop_game()

## Callback nút Restart trên màn hình Game Over: bắt đầu ván mới.
func _on_game_over_restart() -> void:
	new_game()

## Khởi tạo ván mới: reset trạng thái, xoá ống cũ, sinh ống đầu tiên.
func new_game() -> void:
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	score_label.text = "SCORE: " + str(score)
	game_over_screen.hide()
	# Xoá toàn bộ ống nước từ ván trước
	get_tree().call_group("pipes", "queue_free")
	pipes.clear()
	generate_pipes()
	bird.reset()

## Sinh một cặp ống nước mới tại vị trí Y ngẫu nhiên.
func generate_pipes() -> void:
	var pipe := pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2.0 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)

## Dừng game: tắt Timer, hiện màn hình Game Over, cập nhật trạng thái.
func stop_game() -> void:
	pipe_timer.stop()
	game_over_screen.show()
	bird.flying = false
	game_running = false
	game_over = true

## Xử lý khi chim va chạm ống nước: chuyển sang trạng thái rơi và dừng game.
func bird_hit() -> void:
	bird.falling = true
	stop_game()

## Xử lý khi ghi điểm: tăng điểm và cập nhật label.
func scored() -> void:
	score += 1
	score_label.text = "SCORE: " + str(score)