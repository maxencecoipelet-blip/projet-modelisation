extends Node

var all_questions = [
	{"q": "Quelle est la valeur approximative de la constante de Planck ?", "a": "6.63e-34", "b": "9.81e-67", "correct": "a"},
	{"q": "Quel est le resultat de 2^10 ?", "a": "1024", "b": "512", "correct": "a"},
	{"q": "Quel est le pH d'une solution neutre ?", "a": "7", "b": "0", "correct": "a"},
	{"q": "Quelle particule a une charge negative ?", "a": "Electron", "b": "Proton", "correct": "a"},
	{"q": "Quelle est la formule de la vitesse ?", "a": "distance / temps", "b": "masse x vitesse", "correct": "a"},
	{"q": "Combien de chromosomes a un humain ?", "a": "46", "b": "67", "correct": "a"},
	{"q": "Quel gaz est majoritaire dans l'air ?", "a": "Azote", "b": "Oxygene", "correct": "a"},
	{"q": "Quelle est la derivee de x^2 ?", "a": "2x", "b": "x", "correct": "a"},
	{"q": "Quel organe produit l'insuline ?", "a": "Pancreas", "b": "Foie", "correct": "a"},
	{"q": "Quelle est la vitesse de la lumiere ?", "a": "300000 km/s", "b": "150000 km/s", "correct": "a"},
	{"q": "Quel est le symbole chimique du sodium ?", "a": "Na", "b": "So", "correct": "a"},
	{"q": "Quel est le resultat de 7x8 ?", "a": "56", "b": "67", "correct": "a"},
	{"q": "Quel est le plus grand organe du corps humain ?", "a": "Peau", "b": "Foie", "correct": "a"},
	{"q": "Quelle est l'unite de la force ?", "a": "Newton", "b": "Joule", "correct": "a"},
	{"q": "Quel est le resultat de la racine carre de 144 ?", "a": "12", "b": "14", "correct": "a"},
	{"q": "Quel est le nom de la galaxie ou nous sommes ?", "a": "Voie lactee", "b": "Andromede", "correct": "a"},
	{"q": "Quel est le resultat de 5! (factorielle) ?", "a": "120", "b": "60", "correct": "a"},
	{"q": "Quelle est la formule de l'eau ?", "a": "H2O", "b": "CO2", "correct": "a"},
	{"q": "Quel est le plus petit nombre premier ?", "a": "2", "b": "1", "correct": "a"},
	{"q": "Quelle est la derivee de sin(x) ?", "a": "cos(x)", "b": "-sin(x)", "correct": "a"},
	{"q": "Quel est l'unite de l'energie ?", "a": "Joule", "b": "Watt", "correct": "a"},
	{"q": "Quel est le resultat de 9^2 ?", "a": "81", "b": "72", "correct": "a"},
	{"q": "Quel est le nom du processus de division cellulaire ?", "a": "Mitose", "b": "Photosynthese", "correct": "a"},
	{"q": "Quel est le symbole du fer ?", "a": "Fe", "b": "Fr", "correct": "a"},
	{"q": "Quelle est la formule de l'energie cinetique ?", "a": "1/2 mv^2", "b": "mgh", "correct": "a"},
	{"q": "Quel est le nombre de planetes dans le systeme solaire ?", "a": "8", "b": "9", "correct": "a"},
	{"q": "Quel est le resultat de 3^4 ?", "a": "81", "b": "64", "correct": "a"},
	{"q": "Quelle est la charge d'un neutron ?", "a": "Neutre", "b": "Positive", "correct": "a"},
	{"q": "Quel est le nom de la reaction des plantes avec la lumiere ?", "a": "Photosynthese", "b": "Respiration", "correct": "a"},
	{"q": "Quelle est l'unite de la puissance ?", "a": "Watt", "b": "Joule", "correct": "a"},
	{"q": "Qui a ecrit Les Fleurs du mal ?", "a": "Baudelaire", "b": "Hugo", "correct": "a"},
	{"q": "Qui a ecrit Madame Bovary ?", "a": "Flaubert", "b": "Zola", "correct": "a"},
	{"q": "Qui a ecrit Candide ?", "a": "Voltaire", "b": "Rousseau", "correct": "a"},
	{"q": "Qui a ecrit Germinal ?", "a": "Zola", "b": "Maupassant", "correct": "a"},
	{"q": "Quelle bataille met fin a Napoleon ?", "a": "Waterloo", "b": "Austerlitz", "correct": "a"},
	{"q": "Qui etait le premier empereur romain ?", "a": "Auguste", "b": "Cesar", "correct": "a"},
	{"q": "Quelle est la date de la prise de la Bastille ?", "a": "14 juillet 1789", "b": "1792", "correct": "a"},
	{"q": "Qui a ecrit Le Petit Prince ?", "a": "Saint-Exupery", "b": "Camus", "correct": "a"},
	{"q": "Qui a ecrit L'Etranger ?", "a": "Camus", "b": "Sartre", "correct": "a"},
	{"q": "Qui a ecrit Dom Juan ?", "a": "Moliere", "b": "Racine", "correct": "a"},
	{"q": "Qui a ecrit Le Cid ?", "a": "Corneille", "b": "Nasdas", "correct": "a"},
	{"q": "Qui a ecrit Phèdre ?", "a": "Racine", "b": "Corneille", "correct": "a"},
	{"q": "Quel roi etait appele le Roi Soleil ?", "a": "Louis XIV", "b": "Louis XVI", "correct": "a"},
	{"q": "Quelle guerre a dure de 1939 a 1945 ?", "a": "Seconde Guerre mondiale", "b": "Premiere Guerre mondiale", "correct": "a"},
	{"q": "Quel pays a lance Spoutnik ?", "a": "URSS", "b": "USA", "correct": "a"},
	{"q": "Quelle civilisation a invente l'ecriture cuneiforme ?", "a": "Sumeriens", "b": "Romains", "correct": "a"},
	{"q": "Qui a decouvert la penicilline ?", "a": "Fleming", "b": "Pasteur", "correct": "a"},
	{"q": "Quel est le plus grand desert chaud ?", "a": "Sahara", "b": "Gobi", "correct": "a"},
	{"q": "Quel est le plus long fleuve du monde ?", "a": "Nil", "b": "Amazone", "correct": "a"},
	{"q": "Qui est le plus fort ?", "a": "Arsene", "b": "Axel", "correct": "b"},
	{"q": "Quelle est la capitale de l'empire byzantin ?", "a": "Constantinople", "b": "Rome", "correct": "a"}
]

const TOTAL_QUESTIONS = 10

var current_questions = []
var current_index = 0
var game_finished = false

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
	game_finished = false
	emit_signal("question_changed", get_current())

func get_current():
	if current_questions.is_empty():
		return {}
	if current_index < 0 or current_index >= current_questions.size():
		return {}
	return current_questions[current_index]

func answer(choice: String):
	if game_finished:
		return

	var current = get_current()
	if current.is_empty():
		return

	if choice == current.correct:
		current_index += 1
		if current_index >= TOTAL_QUESTIONS:
			game_finished = true
			GameState.complete_minigame_and_disable_robot("culture_g")
			emit_signal("game_won")
		else:
			emit_signal("question_changed", get_current())
	else:
		start_new_game()
		emit_signal("game_restarted")
