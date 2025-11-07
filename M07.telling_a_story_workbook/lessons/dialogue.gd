extends Control

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var next_button: Button = %NextButton
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var body: TextureRect = %Body
@onready var expression: TextureRect = %Expression

var expressions := {
	"happy": preload ("res://assets/emotion_happy.png"),
	"regular": preload ("res://assets/emotion_regular.png"),
	"sad": preload ("res://assets/emotion_sad.png"),
}

var bodies := {
	"sophia": preload ("res://assets/sophia.png"),
	"pink": preload ("res://assets/pink.png")
}

var dialogue_items: Array[Dictionary] = [
	{
		"expression": expressions["regular"],
		"text": "[wave]Hello[/wave], I'm Jayden's Assistant.",
		"character": bodies["sophia"],
	},
	{
		"expression": expressions["regular"],
		"text": "Oh why hello there. I'm looking for [i]Jayden[/i], do you know where he's at?",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["sad"],
		"text": "Oh! I'm so sorry about that, he's not here right now.",
		"character": bodies["sophia"],
	},
	{
		"expression": expressions["sad"],
		"text": "[shake]Aw man[/shake], I was hoping he'd be here today.",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["happy"],
		"text": "Although he isn't here, how may I be of assistance to you today?",
		"character": bodies["sophia"],
	},
	{
		"expression": expressions["happy"],
		"text": "I just want to schedule an appointment with him because he can solve all my problems.",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["regular"],
		"text": "Ooh I think I can help you with that.",
		"character": bodies["sophia"],
	},
	{
		"expression": expressions["regular"],
		"text": "Really? Okay, let's go.",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["happy"],
		"text": "Alright, come with me!",
		"character": bodies["sophia"],
	},
	{
		"expression": expressions["happy"],
		"text": "[tornado freq=3.0][rainbow val=1.0]Yippee![/rainbow][/tornado]",
		"character": bodies["pink"],
	},
]

var current_item_index := 0

func _ready() -> void:
	show_text()
	next_button.pressed.connect(advance)

func show_text() -> void:
	var current_item := dialogue_items[current_item_index]
	rich_text_label.text = current_item["text"]
	expression.texture = current_item["expression"]
	rich_text_label.visible_ratio = 0.0
	var tween := create_tween()
	var text_appearing_duration: float = current_item["text"].length() / 30.0
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)
	var sound_max_offset := audio_stream_player.stream.get_length() - text_appearing_duration
	var sound_start_position := randf() * sound_max_offset
	audio_stream_player.play(sound_start_position)
	tween.finished.connect(audio_stream_player.stop)
	slide_in()
	rich_text_label.text = current_item["text"]
	expression.texture = current_item["expression"]
	body.texture = current_item["character"]
	next_button.disabled = true
	tween.finished.connect(func() -> void:
		next_button.disabled = false
	)

func advance() -> void:
	current_item_index += 1
	if current_item_index == dialogue_items.size():
		get_tree().quit()
	else:
		show_text()

func slide_in() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	body.position.x = 200.0
	tween.tween_property(body, "position:x", 0.0, 0.3)
	body.modulate.a = 0.0
	tween.parallel().tween_property(body, "modulate:a", 1.0, 0.2)
