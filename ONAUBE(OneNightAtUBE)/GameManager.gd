extends Node

var all_questions = [
	{"q": "Quelle est la capitale de l'Australie ?", "a": "Sydney", "b": "Canberra", "correct": "b"},
	{"q": "Qui a peint la Joconde ?", "a": "Leonard de Vinci", "b": "Michel-Ange", "correct": "a"},
	{"q": "Combien de continents y a-t-il ?", "a": "5", "b": "7", "correct": "b"},
	{"q": "Quelle est la plus grande planete du systeme solaire ?", "a": "Jupiter", "b": "Saturne", "correct": "a"},
	{"q": "En quelle annee a eu lieu la Revolution francaise ?", "a": "1789", "b": "1815", "correct": "a"},
	{"q": "Quel est l'element chimique de symbole O ?", "a": "Or", "b": "Oxygene", "correct": "b"},
	{"q": "Combien de joueurs sur le terrain au foot ?", "a": "11", "b": "10", "correct": "a"},
	{"q": "Quel ocean est le plus grand ?", "a": "Atlantique", "b": "Pacifique", "correct": "b"},
	{"q": "Qui a ecrit Les Miserables ?", "a": "Victor Hugo", "b": "Emile Zola", "correct": "a"},
	{"q": "Quelle est la monnaie du Japon ?", "a": "Yuan", "b": "Yen", "correct": "b"},
	{"q": "Combien de cotes a un hexagone ?", "a": "6", "b": "8", "correct": "a"},
	{"q": "Quel est le plus long fleuve du monde ?", "a": "Amazone", "b": "Nil", "correct": "b"},
	{"q": "Qui a invente l'ampoule electrique ?", "a": "Edison", "b": "Tesla", "correct": "a"},
	{"q": "Quelle planete est la plus proche du soleil ?", "a": "Venus", "b": "Mercure", "correct": "b"},
	{"q": "En quelle annee l'homme a marche sur la Lune ?", "a": "1969", "b": "1975", "correct": "a"},
	{"q": "Quel est le plus grand desert chaud du monde ?", "a": "Sahara", "b": "Gobi", "correct": "a"},
	{"q": "Qui a peint la Nuit etoilee ?", "a": "Van Gogh", "b": "Monet", "correct": "a"},
	{"q": "Combien de touches sur un piano standard ?", "a": "76", "b": "88", "correct": "b"},
	{"q": "Qui a decouvert la penicilline ?", "a": "Pasteur", "b": "Fleming", "correct": "b"},
	{"q": "Quel est le plus haut sommet du monde ?", "a": "K2", "b": "Everest", "correct": "b"},
]

const TOTAL_QUESTIONS = 10

var current_questions = []
var current_index = 0

signal question_changed(question_data)
signal game_won
signal game_restarted

func _ready():
	randomize()
	start_new_game()

func start_new_game():
	current_questions = all_questions.duplicate()
	current_questions.shuffle()
	current_questions = current_questions.slice(0, TOTAL_QUESTIONS)
	current_index = 0
	emit_signal("question_changed", get_current())

func get_current():
	return current_questions[current_index]

func answer(choice: String):
	var current = get_current()
	if choice == current.correct:
		current_index += 1
		if current_index >= TOTAL_QUESTIONS:
			emit_signal("game_won")
		else:
			emit_signal("question_changed", get_current())
	else:
		start_new_game()
		emit_signal("game_restarted")
