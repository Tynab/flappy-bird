## Điều khiển chuyển động và vật lý của chim.
## Xử lý trọng lực, vỗ cánh, xoay góc theo vận tốc và animation.
extends CharacterBody2D

# --- Hằng số vật lý ---
## Gia tốc trọng lực kéo chim xuống (pixel/giây²).
const GRAVITY: int = 1000
## Vận tốc rơi tối đa (pixel/giây).
const MAX_VEL: int = 600
## Vận tốc vỗ cánh (âm = hướng lên, pixel/giây).
const FLAP_SPEED: int = -500
## Vị trí xuất phát của chim trên màn hình.
const START_POS := Vector2(100, 400)

# --- Hằng số xoay ---
## Hệ số chuyển đổi vận tốc sang góc xoay khi đang bay (độ/vận tốc).
const ROTATION_FACTOR: float = 0.05

# --- Tham chiếu node ---
## Sprite animation vỗ cánh của chim.
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

# --- Biến trạng thái ---
## Cờ chim đang bay (phản hồi input, áp dụng trọng lực và xoay mượt).
var flying: bool = false
## Cờ chim đang rơi (sau va chạm, quay đầu thẳng xuống).
var falling: bool = false

## Khởi tạo: đặt chim về trạng thái ban đầu.
func _ready() -> void:
	reset()

## Cập nhật vật lý mỗi frame: trọng lực, xoay góc, di chuyển.
func _physics_process(delta: float) -> void:
	if flying or falling:
		# Áp dụng trọng lực, giới hạn vận tốc rơi tối đa
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		# Xử lý xoay góc và animation tuỳ trạng thái
		if flying:
			# Xoay theo vận tốc: chúi đầu lên khi bay lên, xuống khi rơi
			set_rotation(deg_to_rad(velocity.y * ROTATION_FACTOR))
			anim_sprite.play()
		elif falling:
			# Rơi thẳng đứng: xoay 90° và dừng animation
			set_rotation(PI / 2)
			anim_sprite.stop()
		# Di chuyển chim dựa trên vận tốc
		move_and_collide(velocity * delta)
	else:
		anim_sprite.stop()

## Khôi phục vị trí và trạng thái ban đầu (khi bắt đầu ván mới).
func reset() -> void:
	falling = false
	flying = false
	position = START_POS
	set_rotation(0)

## Vỗ cánh: đặt vận tốc hướng lên để chim bay lên.
func flap() -> void:
	velocity.y = FLAP_SPEED