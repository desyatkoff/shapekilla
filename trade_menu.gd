extends Control

@onready var panel = $Panel
@onready var slots = $Panel/CardSlots.get_children()
@onready var item_card_scene = preload("res://trade_item_card.tscn")

@export var scenes: Array[PackedScene]

func _ready() -> void:
    load_menu_items()

func _on_item_purchased() -> void:
    for slot in slots:
        if slot.get_child_count() != 0:
            slot.get_child(0).check_availability()

func _on_close_button_pressed() -> void:
    Game.hud.click_sfx_player.play()

    hide_menu()

func load_menu_items() -> void:
    for slot in slots:
        for child in slot.get_children():
            child.queue_free()

    var free_slots = []

    for slot in slots:
        free_slots.append(slot)

    var pool = scenes.duplicate()
    pool.shuffle()

    while not free_slots.is_empty():
        for fslot in free_slots:
            if pool.is_empty():
                break

            var scene = pool.pick_random()

            if scene:
                var is_unique = true

                var instance = scene.instantiate()
                var item_card = item_card_scene.instantiate()

                for slot in slots:
                    if slot.get_child_count() != 0:
                        if instance.get_script() == slot.get_child(0).item.get_script():
                            is_unique = false

                if is_unique:
                    instance._ready()

                    if instance is Item:
                        if instance is Key:
                            instance.item_tier = instance.pick_tier()

                        if instance.item_tier == pick_tier():
                            item_card.item = instance
                            fslot.add_child(item_card)
                            free_slots.erase(fslot)
                            item_card.connect("purchased", _on_item_purchased)
                    elif instance is PlayerUpgrade:
                        if instance.upgrade_tier == pick_tier():
                            item_card.item = instance
                            fslot.add_child(item_card)
                            free_slots.erase(fslot)
                            item_card.connect("purchased", _on_item_purchased)

func pick_tier() -> int:
    var weights = [50, 30, 15, 4, 1]

    var total = 0

    for w in weights:
        total += w

    var roll = randi_range(1, total)

    var sum = 0

    for i in range(weights.size()):
        sum += weights[i]

        if roll <= sum:
            return i

    return 0

func show_menu() -> void:
    for slot in slots:
        if slot.get_child_count() != 0:
            slot.get_child(0).check_availability()

    Game.player.can_play = false

    Game.player.velocity = Vector2.ZERO
    Game.player.direction = Vector2.ZERO

    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

    var tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)

    tween.tween_property(panel, "global_position", Vector2(320.0, 124.0), 1.0)

func hide_menu() -> void:
    var tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)

    tween.tween_property(panel, "global_position", Vector2(320.0, -832.0), 1.0)

    await tween.finished

    Game.player.can_play = true

    Game.player.velocity = Vector2.ZERO
    Game.player.direction = Vector2.ZERO

    Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
