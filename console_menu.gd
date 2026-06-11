extends Control

@onready var panel = $Panel
@onready var output = $Panel/Output
@onready var input = $Panel/Input

var commands = {
    "help": {
        "cheats": false,
        "description": "Print all commands and their descriptions",
        "function": cmd_help,
        "args": []
    },
    "clear": {
        "cheats": false,
        "description": "Clear console output",
        "function": cmd_clear,
        "args": []
    },
    "cheats": {
        "cheats": false,
        "description": "Print current state of cheats (enabled/disabled)",
        "function": cmd_cheats,
        "args": []
    },
    "enable_cheats": {
        "cheats": false,
        "description": "Allow executing any cheat command",
        "function": cmd_enable_cheats,
        "args": []
    },
    "restart": {
        "cheats": false,
        "description": "Restart run",
        "function": cmd_restart,
        "args": []
    },
    "get_seed": {
        "cheats": false,
        "description": "Print current run seed",
        "function": cmd_get_seed,
        "args": []
    },
    "set_seed": {
        "cheats": true,
        "description": "Set a custom run seed and restart immediately to that seeded run",
        "function": cmd_set_seed,
        "args": ["custom_seed"]
    },
    "get_max_health": {
        "cheats": false,
        "description": "Print current maximum health",
        "function": cmd_get_max_health,
        "args": []
    },
    "set_max_health": {
        "cheats": true,
        "description": "Set maximum health value",
        "function": cmd_set_max_health,
        "args": ["new_max_health"]
    },
    "get_health": {
        "cheats": false,
        "description": "Print current health",
        "function": cmd_get_health,
        "args": []
    },
    "set_health": {
        "cheats": true,
        "description": "Set health value",
        "function": cmd_set_health,
        "args": ["new_health"]
    },
    "get_max_speed": {
        "cheats": false,
        "description": "Print current maximum speed",
        "function": cmd_get_max_speed,
        "args": []
    },
    "set_max_speed": {
        "cheats": true,
        "description": "Set maximum speed value",
        "function": cmd_set_max_speed,
        "args": ["new_max_speed"]
    },
    "get_acceleration": {
        "cheats": false,
        "description": "Print current acceleration",
        "function": cmd_get_acceleration,
        "args": []
    },
    "set_acceleration": {
        "cheats": true,
        "description": "Set acceleration value",
        "function": cmd_set_acceleration,
        "args": ["new_acceleration"]
    },
    "get_friction": {
        "cheats": false,
        "description": "Print current friction",
        "function": cmd_get_friction,
        "args": []
    },
    "set_friction": {
        "cheats": true,
        "description": "Set friction value",
        "function": cmd_set_friction,
        "args": ["new_friction"]
    },
    "get_weapon_damage": {
        "cheats": false,
        "description": "Print current weapon damage",
        "function": cmd_get_weapon_damage,
        "args": []
    },
    "set_weapon_damage": {
        "cheats": true,
        "description": "Set weapon damage value",
        "function": cmd_set_weapon_damage,
        "args": ["new_weapon_damage"]
    }
}

func _ready() -> void:
    Game.console = self

    log_output("[wobble]Welcome to Shapekilla v%s dev console! Type `help` to get started[/wobble]" % ProjectSettings.get_setting("application/config/version"))
    warning_output("Some commands are marked as cheats and cannot be executed by default. You can enable them by entering `enable_cheats` command, but doing so will disable progress from current run")

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_console"):
        Game.hud.click_sfx_player.play()

        var tween = create_tween()
        tween.set_trans(Tween.TRANS_SINE)
        tween.set_ease(Tween.EASE_IN_OUT)

        if panel.visible:
            Input.mouse_mode = Input.MOUSE_MODE_HIDDEN if Game.player.can_play and not get_tree().paused else Input.MOUSE_MODE_VISIBLE

            tween.tween_property(panel, "global_position", Vector2(240.0, -810.0), 1.0)

            await tween.finished

            panel.visible = false
        else:
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

            tween.tween_property(panel, "global_position", Vector2(240.0, 135.0), 1.0)

            panel.visible = true

func _on_input_text_submitted(new_text: String) -> void:
    if new_text.length() > 0:
        log_output("> " + new_text)
        execute_command(new_text)
        input.text = ""

func execute_command(text: String) -> void:
    var parts = text.strip_edges().split(" ")
    var command = parts[0]
    var args = parts.slice(1, parts.size())

    if commands.has(command):
        if commands[command]["cheats"] and not Game.player.cheats_enabled:
            error_output("Cannot execute this command as it is considered a cheat. Enable cheats first and then try again")

            return

        commands[command]["function"].call(args)
    else:
        error_output("Command not found: " + command)

func log_output(text: String) -> void:
    output.text += str(text) + "\n"

func warning_output(text: String) -> void:
    output.text += "[color=#fb8c00][ Warning ][/color] " + str(text) + "\n"

func error_output(text: String) -> void:
    output.text += "[color=#dd191d][  Error  ][/color] " + str(text) + "\n"

func cmd_help(_args):
    for command in commands.keys():
        var args_str = ""

        for arg in commands[command]["args"]:
            args_str += " <%s>" % arg

        log_output("%s%s - %s" % [
            command,
            args_str,
            commands[command]["description"]
        ])

func cmd_clear(_args):
    output.text = ""

func cmd_cheats(_args) -> void:
    log_output(str(Game.player.cheats_enabled))

func cmd_enable_cheats(_args) -> void:
    if not Game.player.cheats_enabled:
        Game.player.cheats_enabled = true

        warning_output("Cheats have been enabled. All the progress from current run will not be saved")

func cmd_disable_cheats(_args) -> void:
    if Game.player.cheats_enabled:
        Game.player.cheats_enabled = false

        warning_output("Cheats have been disabled. Run progress is currently allowed to be saved")

func cmd_restart(_args) -> void:
    Game.reload_world()
    Game.reload_player()

    Game.player.revive()

    cmd_disable_cheats(PackedStringArray([]))

    Game.player.run_time = 0.0
    Game.player.run_kills = 0
    Game.player.run_rooms_cleared = 0
    Game.player.run_floors_cleared = 0

    Game.player.current_floor = 1

func cmd_get_seed(_args) -> void:
    log_output(str(Game.run_seed))

func cmd_set_seed(args) -> void:
    if args.size() > 0:
        var custom_seed = args[0]

        if custom_seed.is_valid_int():
            Game.custom_seed = int(custom_seed)

            cmd_restart(PackedStringArray([]))
            cmd_enable_cheats(PackedStringArray([]))
        else:
            error_output("<custom_seed> arg must be a valid `int` value")
    else:
        error_output("<custom_seed> arg is required")

func cmd_get_max_health(_args) -> void:
    log_output(str(Game.player.max_health))

func cmd_set_max_health(args) -> void:
    if args.size() > 0:
        var new_max_health = args[0]

        if new_max_health.is_valid_int():
            Game.player.max_health = int(new_max_health)
        else:
            error_output("<new_max_health> arg must be a valid `int` value")
    else:
        error_output("<new_max_health> arg is required")

func cmd_get_health(_args) -> void:
    log_output(str(Game.player.health))

func cmd_set_health(args) -> void:
    if args.size() > 0:
        var new_health = args[0]

        if new_health.is_valid_int():
            Game.player.health = int(new_health)
        else:
            error_output("<new_health> arg must be a valid `int` value")
    else:
        error_output("<new_health> arg is required")

func cmd_get_max_speed(_args) -> void:
    log_output(str(Game.player.max_speed))

func cmd_set_max_speed(args) -> void:
    if args.size() > 0:
        var new_max_speed = args[0]

        if new_max_speed.is_valid_int():
            Game.player.max_speed = int(new_max_speed)
        else:
            error_output("<new_max_speed> arg must be a valid `int` value")
    else:
        error_output("<new_max_speed> arg is required")

func cmd_get_acceleration(_args) -> void:
    log_output(str(Game.player.acceleration))

func cmd_set_acceleration(args) -> void:
    if args.size() > 0:
        var new_acceleration = args[0]

        if new_acceleration.is_valid_int():
            Game.player.acceleration = int(new_acceleration)
        else:
            error_output("<new_acceleration> arg must be a valid `int` value")
    else:
        error_output("<new_acceleration> arg is required")

func cmd_get_friction(_args) -> void:
    log_output(str(Game.player.friction))

func cmd_set_friction(args) -> void:
    if args.size() > 0:
        var new_friction = args[0]

        if new_friction.is_valid_float():
            Game.player.friction = float(new_friction)
        else:
            error_output("<new_friction> arg must be a valid `float` value")
    else:
        error_output("<new_friction> arg is required")

func cmd_get_weapon_damage(_args) -> void:
    log_output(str(Game.player.weapon.damage))

func cmd_set_weapon_damage(args) -> void:
    if args.size() > 0:
        var new_weapon_damage = args[0]

        if new_weapon_damage.is_valid_float() and Game.player.weapon:
            Game.player.weapon.damage = float(new_weapon_damage)
        else:
            error_output("<new_weapon_damage> arg must be a valid `float` value")
    else:
        error_output("<new_weapon_damage> arg is required")
