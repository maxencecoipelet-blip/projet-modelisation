extends Node

var all_questions = [
	{"q": "Quelle est la valeur approximative de la constante de Planck ?", "a": "6.63e-34", "b": "9.81e-67", "correct": "a"},
	{"q": "Quel est le resultat de 2^10 ?", "a": "512", "b": "1024", "correct": "b"},
	{"q": "Quel est le pH d'une solution neutre ?", "a": "7", "b": "0", "correct": "a"},
	{"q": "Quelle particule a une charge negative ?", "a": "Proton", "b": "Electron", "correct": "b"},
	{"q": "Quelle est la formule de la vitesse ?", "a": "distance / temps", "b": "masse x vitesse", "correct": "a"},
	{"q": "Combien de chromosomes a un humain ?", "a": "67", "b": "46", "correct": "b"},
	{"q": "Quel gaz est majoritaire dans l'air ?", "a": "Azote", "b": "Oxygene", "correct": "a"},
	{"q": "Quelle est la derivee de x^2 ?", "a": "x", "b": "2x", "correct": "b"},
	{"q": "Quel organe produit l'insuline ?", "a": "Pancreas", "b": "Foie", "correct": "a"},
	{"q": "Quelle est la vitesse de la lumiere ?", "a": "150000 km/s", "b": "300000 km/s", "correct": "b"},
	{"q": "Quel est le symbole chimique du sodium ?", "a": "Na", "b": "So", "correct": "a"},
	{"q": "Quel est le resultat de 7x8 ?", "a": "56", "b": "67", "correct": "a"},
	{"q": "Quel est le plus grand organe du corps humain ?", "a": "Foie", "b": "Peau", "correct": "b"},
	{"q": "Quelle est l'unite de la force ?", "a": "Newton", "b": "Joule", "correct": "a"},
	{"q": "Quel est le resultat de la racine carre de 144 ?", "a": "12", "b": "14", "correct": "a"},
	{"q": "Quel est le nom de la galaxie ou nous sommes ?", "a": "Voie lactee", "b": "Andromede", "correct": "a"},
	{"q": "Quel est le resultat de 5! (factorielle) ?", "a": "60", "b": "120", "correct": "b"},
	{"q": "Quelle est la formule de l'eau ?", "a": "H2O", "b": "CO2", "correct": "a"},
	{"q": "Quel est le plus petit nombre premier ?", "a": "2", "b": "1", "correct": "a"},
	{"q": "Quelle est la derivee de sin(x) ?", "a": "cos(x)", "b": "-sin(x)", "correct": "a"},
	{"q": "Quel est l'unite de l'energie ?", "a": "Joule", "b": "Watt", "correct": "a"},
	{"q": "Quel est le resultat de 9^2 ?", "a": "72", "b": "81", "correct": "b"},
	{"q": "Quel est le nom du processus de division cellulaire ?", "a": "Mitose", "b": "Photosynthese", "correct": "a"},
	{"q": "Quel est le symbole du fer ?", "a": "Fr", "b": "Fe", "correct": "b"},
	{"q": "Quelle est la formule de l'energie cinetique ?", "a": "1/2 mv^2", "b": "mgh", "correct": "a"},
	{"q": "Quel est le nombre de planetes dans le systeme solaire ?", "a": "9", "b": "8", "correct": "b"},
	{"q": "Quel est le resultat de 3^4 ?", "a": "64", "b": "81", "correct": "b"},
	{"q": "Quelle est la charge d'un neutron ?", "a": "Neutre", "b": "Positive", "correct": "a"},
	{"q": "Quel est le nom de la reaction des plantes avec la lumiere ?", "a": "Photosynthese", "b": "Respiration", "correct": "a"},
	{"q": "Quelle est l'unite de la puissance ?", "a": "Watt", "b": "Joule", "correct": "a"},
	{"q": "Qui a ecrit Les Fleurs du mal ?", "a": "Hugo", "b": "Baudelaire", "correct": "b"},
	{"q": "Qui a ecrit Madame Bovary ?", "a": "Flaubert", "b": "Zola", "correct": "a"},
	{"q": "Qui a ecrit Candide ?", "a": "Rousseau", "b": "Voltaire", "correct": "b"},
	{"q": "Qui a ecrit Germinal ?", "a": "Zola", "b": "Maupassant", "correct": "a"},
	{"q": "Quelle bataille met fin a Napoleon ?", "a": "Austerlitz", "b": "Waterloo", "correct": "b"},
	{"q": "Qui etait le premier empereur romain ?", "a": "Auguste", "b": "Cesar", "correct": "a"},
	{"q": "Quelle est la date de la prise de la Bastille ?", "a": "1792", "b": "14 juillet 1789", "correct": "b"},
	{"q": "Qui a ecrit Le Petit Prince ?", "a": "Saint-Exupery", "b": "Camus", "correct": "a"},
	{"q": "Qui a ecrit L'Etranger ?", "a": "Sartre", "b": "Camus", "correct": "b"},
	{"q": "Qui a ecrit Dom Juan ?", "a": "Moliere", "b": "Racine", "correct": "a"},
	{"q": "Qui a ecrit Le Cid ?", "a": "Corneille", "b": "Nasdas", "correct": "a"},
	{"q": "Qui a ecrit Phèdre ?", "a": "Corneille", "b": "Racine", "correct": "b"},
	{"q": "Quel roi etait appele le Roi Soleil ?", "a": "Louis XIV", "b": "Louis XVI", "correct": "a"},
	{"q": "Quelle guerre a dure de 1939 a 1945 ?", "a": "Premiere Guerre mondiale", "b": "Seconde Guerre mondiale", "correct": "b"},
	{"q": "Quel pays a lance Spoutnik ?", "a": "URSS", "b": "USA", "correct": "a"},
	{"q": "Quelle civilisation a invente l'ecriture cuneiforme ?", "a": "Romains", "b": "Sumeriens", "correct": "b"},
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
