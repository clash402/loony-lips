extends Control

# UI
onready var DisplayLabel = $Margin/VBox/DisplayLabel
onready var PlayerInput = $Margin/VBox/HBox/PlayerInput
onready var SubmitBtn = $Margin/VBox/HBox/SubmitBtn

const PATH = "res://assets/data/stories.json"
const REPLAY_BTN_NORM = "res://assets/gfx/replay-button-normal.png"
const REPLAY_BTN_PRES = "res://assets/gfx/replay-button-pressed.png"

var player_words = []
var story


# DEFAULTS
func _ready():
	choose_random_story()
	welcome_player()
	prompt_player()


# SIGNALS
func _on_PlayerInput_text_entered(new_text):
	var _err = new_text
	append_to_player_words()
	prompt_player()


func _on_SubmitBtn_pressed():
	if story_is_done():
		restart_game()
	else:
		append_to_player_words()
		prompt_player()


# CUSTOM
func load_data(PATH):
	var file = File.new()
	file.open(PATH, File.READ)
	var text = file.get_as_text()
	var data = parse_json(text)
	file.close()
	return data


func choose_random_story():
	var stories = load_data(PATH)
	randomize()
	story = stories[randi() % stories.size()]


func welcome_player():
	DisplayLabel.text = "Hello! Welcome to Loony Lips. We're going to have a wonderful time. "


func prompt_player():
	if story_is_done():
		tell_story()
		end_game()
	else:
		if player_words != []:
			DisplayLabel.text = ""
		DisplayLabel.text += "May I have " + story["prompts"][player_words.size()] + " please?"
		PlayerInput.clear()
		PlayerInput.grab_focus()


func append_to_player_words():
	if PlayerInput.text != "":
		player_words.append(PlayerInput.text)
	else:
		DisplayLabel.text = "(Please enter something) "


func story_is_done():
	return player_words.size() == story["prompts"].size()


func tell_story():
	DisplayLabel.text = story["story"] % player_words


func update_btn_textures():
	SubmitBtn.texture_normal = load(REPLAY_BTN_NORM)
	SubmitBtn.texture_pressed = load(REPLAY_BTN_PRES)


func end_game():
	PlayerInput.queue_free()
	update_btn_textures()


func restart_game():
	var _err = get_tree().reload_current_scene()

