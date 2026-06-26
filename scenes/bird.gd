extends CharacterBody2D

# Các hằng số vật lý của chim
const GRAVITY : int = 1000
const MAX_VEL : int = 600
const FLAP_SPEED : int = -500
const START_POS = Vector2(100, 400)

# Trạng thái bay và rơi
var flying : bool = false
var falling : bool = false

# Hàm được gọi lần đầu tiên khi node bắt đầu hoạt động
func _ready():
	reset()

# Hàm tính toán vật lý, chạy ở mỗi khung hình vật lý
func _physics_process(delta):
	if flying or falling:
		# Áp dụng trọng lực
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
			
		# Xử lý xoay góc và hiệu ứng đập cánh
		if flying:
			# Chúi đầu theo vận tốc bay
			set_rotation(deg_to_rad(velocity.y * .05))
			$AnimatedSprite2D.play()
		elif falling:
			# Rơi thẳng đứng khi chạm chướng ngại vật
			set_rotation(PI / 2)
			$AnimatedSprite2D.stop()
			
		# Di chuyển chim dựa trên vận tốc
		move_and_collide(velocity * delta)
	else:
		$AnimatedSprite2D.stop()

# Hàm khôi phục lại vị trí và trạng thái ban đầu của chim
func reset():
	falling = false
	flying = false
	position = START_POS
	set_rotation(0)

# Hàm cho chim đập cánh bay lên
func flap():
	velocity.y = FLAP_SPEED
