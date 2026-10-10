extends CanvasLayer

@onready var hitstop = $Hitstop

@onready var debug = $DebugHUD

@onready var debug_info_label = $DebugHUD/DebugInfoLabel

@onready var main = $MainHUD

@onready var run_time_label = $MainHUD/RunTimeLabel

@onready var run_score_label = $MainHUD/RunScoreLabel
@onready var run_points_label = $MainHUD/RunPointsLabel

@onready var run_kills_label = $MainHUD/RunKillsLabel
@onready var run_rooms_cleared_label = $MainHUD/RunRoomsClearedLabel
@onready var run_floors_cleared_label = $MainHUD/RunFloorsClearedLabel

@onready var item_icon = $MainHUD/ItemIcon
@onready var item_name = $MainHUD/ItemIcon/Name

@onready var upgrades_container = $MainHUD/UpgradesContainer

@onready var deadly_speedometer_bg = $MainHUD/DeadlySpeedometerBG
@onready var deadly_speedometer_label = $MainHUD/DeadlySpeedometerBG/DeadlySpeedometerLabel

@onready var health_bar = $MainHUD/HealthBar
@onready var health_value_label = $MainHUD/HealthBar/HealthValueLabel

@onready var effects_container = $MainHUD/EffectsContainer

@onready var trade_menu = $MainHUD/TradeMenu

@onready var click_sfx_player = $ClickSFXPlayer

var previous_score = 0.0
var previous_points = 0.0

var previous_player_item: Item

func _ready() -> void:
    visible = true
    debug.visible = OS.is_debug_build()
    main.visible = false

func _process(delta: float) -> void:
    if Input.is_action_just_pressed("toggle_hud"):
        visible = not visible

    if Input.is_action_just_pressed("toggle_debug_hud"):
        debug.visible = not debug.visible

    if Input.is_action_just_pressed("toggle_main_hud"):
        main.visible = not main.visible

    debug_info_label.text = \
"""fps = %s
delta = %s
run_seed = %s
states = %s
previous_state = %s
state = %s
max_health = %s
health = %s
max_speed = %s
acceleration = %s
friction = %s
weapon = %s
weapon_damage = %s
effects = %s
upgrades = %s
item = %s
velocity = %s
direction = %s
current_room_slot = %s
current_room_slot_id = %s
can_play = %s
timer_enabled = %s
cheats_enabled = %s
noclip = %s
is_tutorial_complete = %s
is_wizard_killed = %s
run_time = %s
run_score = %s
run_points = %s
run_points_earned = %s
run_points_spent = %s
run_kills = %s
run_rooms_cleared = %s
run_floors_cleared = %s
run_items_used = %s
floor_time = %s
floor_kills = %s
floor_rooms_cleared = %s
floor_items_used = %s
current_floor = %s
""" % \
    [
        Engine.get_frames_per_second(),
        delta,
        Game.run_seed,
        Game.player.fsm.states,
        Game.player.fsm.previous_state,
        Game.player.fsm.state,
        Game.player.max_health,
        Game.player.health,
        Game.player.speed_multi * Game.player.max_speed,
        Game.player.speed_multi * Game.player.acceleration,
        Game.player.friction,
        Game.player.weapon,
        Game.player.weapon.damage * Game.player.damage_multi * Game.player.weapon.damage_multi if Game.player.weapon else 0.0,
        Game.player.effects,
        Game.player.upgrades,
        Game.player.item,
        Game.player.velocity,
        Game.player.direction,
        Game.player.current_room_slot,
        Game.player.current_room_slot_id,
        Game.player.can_play,
        Game.player.timer_enabled,
        Game.player.cheats_enabled,
        Game.player.noclip,
        Game.data["is_tutorial_complete"],
        Game.player.is_wizard_killed,
        Game.player.run_time,
        Game.player.run_score,
        Game.player.run_points,
        Game.player.run_points_earned,
        Game.player.run_points_spent,
        Game.player.run_kills,
        Game.player.run_rooms_cleared,
        Game.player.run_floors_cleared,
        Game.player.run_items_used,
        Game.player.floor_time,
        Game.player.floor_kills,
        Game.player.floor_rooms_cleared,
        Game.player.floor_items_used,
        Game.player.current_floor
    ]

    run_time_label.text = "%02d:%02d.%03d" % format_time(Game.player.run_time)

    run_score_label.text = "Score: %s" % Game.player.run_score
    run_points_label.text = "Points: %s" % Game.player.run_points

    if Game.player.run_score != previous_score:
        var scale_tween = create_tween()
        scale_tween.set_trans(Tween.TRANS_SINE)
        scale_tween.set_ease(Tween.EASE_IN_OUT)
        scale_tween.tween_property(run_score_label, "scale", Vector2(1.5, 1.5), 0.1)
        scale_tween.tween_property(run_score_label, "scale", Vector2.ONE, 0.1)

        await scale_tween.finished

    await get_tree().create_timer(0.1).timeout

    if Game.player.run_points != previous_points:
        var color_tween = create_tween()
        color_tween.set_trans(Tween.TRANS_SINE)
        color_tween.set_ease(Tween.EASE_IN_OUT)
        color_tween.tween_property(run_points_label, "modulate", Color.GREEN if Game.player.run_points > previous_points else Color.RED, 0.1)
        color_tween.tween_property(run_points_label, "modulate", Color.WHITE, 0.1)

        var scale_tween = create_tween()
        scale_tween.set_trans(Tween.TRANS_SINE)
        scale_tween.set_ease(Tween.EASE_IN_OUT)
        scale_tween.tween_property(run_points_label, "scale", Vector2(1.5, 1.5), 0.1)
        scale_tween.tween_property(run_points_label, "scale", Vector2.ONE, 0.1)

        await color_tween.finished
        await scale_tween.finished

    previous_score = Game.player.run_score
    previous_points = Game.player.run_points

    run_kills_label.text = "%s Kill%s" % [Game.player.run_kills, "s" if Game.player.run_kills == 0 or Game.player.run_kills > 1 else ""]
    run_rooms_cleared_label.text = "%s Room%s Cleared" % [Game.player.run_rooms_cleared, "s" if Game.player.run_rooms_cleared == 0 or Game.player.run_rooms_cleared > 1 else ""]
    run_floors_cleared_label.text = "%s Floor%s Cleared" % [Game.player.run_floors_cleared, "s" if Game.player.run_floors_cleared == 0 or Game.player.run_floors_cleared > 1 else ""]

    run_score_label.visible = Game.data["is_tutorial_complete"]
    run_points_label.visible = Game.data["is_tutorial_complete"]

    run_kills_label.visible = Game.data["is_tutorial_complete"]
    run_rooms_cleared_label.visible = Game.data["is_tutorial_complete"]
    run_floors_cleared_label.visible = Game.data["is_tutorial_complete"]

    if Game.player.item:
        item_icon.texture.atlas = Game.player.item.sprite.texture
        item_icon.texture.region = Game.player.item.sprite.region_rect

        item_name.text = Game.player.item.item_name

        if Game.player.item != previous_player_item:
            var tween = item_icon.create_tween()
            tween.set_trans(Tween.TRANS_SINE)
            tween.set_ease(Tween.EASE_IN_OUT)
            tween.tween_property(item_icon, "scale", Vector2(1.5, 1.5), 0.1)
            tween.tween_property(item_icon, "scale", Vector2.ONE, 0.1)
    else:
        item_icon.texture.atlas = null
        item_icon.texture.region = Rect2(0.0, 0.0, 0.0, 0.0)

        item_name.text = ""

    previous_player_item = Game.player.item

    var player_has_deadly_speedometer = false

    for upgrade in Game.player.upgrades:
        if upgrade is DeadlySpeedometerUpgrade:
            player_has_deadly_speedometer = true

            break

    deadly_speedometer_bg.visible = player_has_deadly_speedometer

    if Game.player.weapon:
        deadly_speedometer_label.text = "%s px/s - x%.1f Damage" % [int(Game.player.velocity.length()), Game.player.weapon.damage_multi]

    var health_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).tween_property(health_bar, "value", Game.player.health, 0.1)
    var max_health_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).tween_property(health_bar, "max_value", Game.player.max_health, 0.1)

    health_value_label.text = "%s / %s" % [Game.player.health, Game.player.max_health]

    await health_tween.finished
    await max_health_tween.finished

func format_time(t: float) -> Array:
    var total_ms = round(t * 1000)
    var minutes = total_ms / 60000
    var seconds = int(total_ms / 1000) % 60
    var milliseconds = int(total_ms) % 1000

    return [int(minutes), int(seconds), int(milliseconds)]
