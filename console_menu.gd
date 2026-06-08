extends Control

@onready var panel = $Panel
@onready var output = $Panel/Output
@onready var input = $Panel/Input

var commands = {
    "help": {
        "cheats": false,
        "description": "Print all commands and their descriptions",
        "function": help,
        "args": []
    },
    "enable_cheats": {
        "cheats": false,
        "description": "Allow executing any cheat command",
        "function": enable_cheats,
        "args": []
    },
    "test": {
        "cheats": false,
        "description": "Print \"test\" message n times. n default to 1",
        "function": test,
        "args": ["n"]
    },
    "test_cheats": {
        "cheats": true,
        "description": "Just like `test`, but requires cheats to be enabled",
        "function": test,
        "args": ["n"]
    }
}

func _ready() -> void:
    log_output("[wobble]Welcome to Shapekilla v%s dev console! Type `help` to get started[/wobble]" % ProjectSettings.get_setting("application/config/version"))
    warning_output("Some commands are marked as cheats and cannot be executed by default. You can enable them by entering `enable_cheats` command, but doing so will disable progress from current run")

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_console"):
        Game.hud.click_sfx_player.play()

        var tween = create_tween()
        tween.set_trans(Tween.TRANS_SINE)
        tween.set_ease(Tween.EASE_IN_OUT)

        if panel.visible:
            tween.tween_property(panel, "global_position", Vector2(240.0, -810.0), 1.0)

            await tween.finished

            panel.visible = false
        else:
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

func help(_args):
    for command in commands.keys():
        var args_str = ""

        for arg in commands[command]["args"]:
            args_str += " <%s>" % arg

        log_output("%s%s - %s" % [
            command,
            args_str,
            commands[command]["description"]
        ])

func enable_cheats(_args) -> void:
    if not Game.player.cheats_enabled:
        Game.player.cheats_enabled = true

        warning_output("Cheats have been enabled. All the progress from current run will not be saved")

func disable_cheats(_args) -> void:
    if Game.player.cheats_enabled:
        Game.player.cheats_enabled = false

        warning_output("Cheats have been disabled. Run progress is currently allowed to be saved")

func test(args):
    var amount = int(args[0]) if args.size() > 0 else 1

    for i in range(amount):
        log_output("test")
