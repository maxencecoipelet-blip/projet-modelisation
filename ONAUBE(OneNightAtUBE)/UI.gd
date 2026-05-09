extends CanvasLayer

@onready var question_label: Label = $QuestionLabel
@onready var answer_a_label: Label = $AnswerALabel
@onready var answer_b_label: Label = $AnswerBLabel
@onready var counter_label: Label = $CounterLabel
@onready var message_label: Label = $MessageLabel

var message_timer: float = 0.0

func _ready():
	GameManager.question_changed.connect(_on_question_changed)
	GameManager.game_won.connect(_on_game_won)
	GameManager.game_restarted.connect(_on_game_restarted)
	_on_question_changed(GameManager.get_current())

func _process(delta):
	if message_timer > 0:
		message_timer -= delta
		if message_timer <= 0:
			message_label.text = ""

func _on_question_changed(q):
	question_label.text = q.q
	answer_a_label.text = "Porte A (gauche) : " + q.a
	answer_b_label.text = "Porte B (droite) : " + q.b
	counter_label.text = "Question %d / %d" % [GameManager.current_index + 1, GameManager.TOTAL_QUESTIONS]
	# Teleporte le joueur au debut du couloir a chaque nouvelle question
	get_tree().call_group("culture_player", "reset_position")

func _on_game_won():
	$uiroot/fin.visible = true
	
	question_label.text = "VICTOIRE ! Tu as repondu juste 10 fois !"
	answer_a_label.text = ""
	answer_b_label.text = ""
	counter_label.text = ""
	message_label.text = "Appuie sur Echap pour quitter"

func _on_game_restarted():
	message_label.text = "Mauvaise reponse ! On recommence avec de nouvelles questions..."
	message_timer = 2.5
