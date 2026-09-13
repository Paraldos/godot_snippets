extends Node
class_name SaveManager

# Static manager for creating, saving, and loading game data.
#
# Assumes:
# - Save data uses a Resource class named GameData.
# - The active GameData instance is stored in Utils.game_data.
# - Save files are stored in Godot's user:// directory.
#
# Example:
# SaveManager.new_game()
# SaveManager.save_game(0)
# SaveManager.load_game(0)

const SAVE_GAME_PATH := "user://save_%s.tres"
const SAVE_INFO_PATH := "user://save_%s_info.tres"

# ================================================== controlls
static func new_game():
	Utils.game_data = GameData.new()

static func save_game(slot_number: int) -> void:
	var error := ResourceSaver.save(Utils.game_data, get_save_path(slot_number))
	if error != OK:
		push_error("Save slot %s could not be saved: %s" % [slot_number, error_string(error)])

static func load_game(slot_number: int) -> void:
	if not save_exists(slot_number):
		push_error("Save slot %s does not exist." % slot_number)
		return
	var save := ResourceLoader.load(
		get_save_path(slot_number),
		"",
		ResourceLoader.CACHE_MODE_IGNORE,
	) as GameData
	if save == null:
		push_error("Save slot %s could not be loaded." % slot_number)
		return
	Utils.game_data = save

# ================================================== helper
static func get_save_path(slot_number: int) -> String:
	return SAVE_GAME_PATH % slot_number

static func save_exists(slot_number: int) -> bool:
	return ResourceLoader.exists(get_save_path(slot_number))
