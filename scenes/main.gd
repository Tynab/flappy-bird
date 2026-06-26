extends Node

# Scene chứa chướng ngại vật (ống nước)
@export var pipe_scene : PackedScene

# Hằng số điều chỉnh tốc độ và khoảng cách
const SCROLL_SPEED : int = 4
const PIPE_DELAY : int = 100
const PIPE_RANGE : int = 200

# Trạng thái trò chơi và các thông số
var game_running : bool
var game_over : bool
var screen_size : Vector2i
var ground_height : int
var pipes : Array = []
var scroll : int = 0
var score : int = 0

# Hàm khởi tạo: được gọi lần đầu tiên khi node được thêm vào scene tree
func _ready():
	screen_size = get_tree().root.content_scale_size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()

# Hàm bắt sự kiện người dùng (chuột, phím)
func _input(event):
	# Bắt đầu hoặc tiếp tục trò chơi khi nhấn chuột trái
	if not game_over and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not game_running:
			game_running = true
			$Bird.flying = true
			$Bird.flap()
			$PipeTimer.start()
		else:
			if $Bird.flying:
				$Bird.flap()
				# Dừng game nếu chim bay vượt khỏi mép trên của màn hình
				if $Bird.position.y < 0:
					$Bird.falling = true
					stop_game()

# Hàm chạy mỗi frame: cập nhật vị trí màn hình và chướng ngại vật
func _process(_delta):
	if game_running:
		# Cuộn nền mặt đất
		scroll += SCROLL_SPEED
		if scroll >= screen_size.x:
			scroll = 0
		$Ground.position.x = -scroll
		
		# Di chuyển các ống nước sang trái
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED

# Sự kiện khi Timer tạo ống kết thúc
func _on_pipe_timer_timeout():
	generate_pipes()

# Sự kiện khi chim chạm đất
func _on_ground_hit():
	$Bird.falling = false
	stop_game()

# Sự kiện nhấn nút khởi động lại trò chơi
func _on_game_over_restart():
	new_game()

# Hàm làm mới trạng thái để chơi ván mới
func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$ScoreLabel.text = "SCORE: " + str(score)
	$GameOver.hide()
	# Xóa tất cả các ống nước cũ
	get_tree().call_group("pipes", "queue_free")
	pipes.clear()
	generate_pipes()
	$Bird.reset()

# Hàm tạo một cặp ống nước mới ở vị trí ngẫu nhiên
func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2.0 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)

# Hàm dừng game khi người chơi thua
func stop_game():
	$PipeTimer.stop()
	$GameOver.show()
	$Bird.flying = false
	game_running = false
	game_over = true

# Hàm xử lý khi chim va chạm ống nước
func bird_hit():
	$Bird.falling = true
	stop_game()
	
# Hàm cộng điểm cho người chơi
func scored():
	score += 1
	$ScoreLabel.text = "SCORE: " + str(score)
