extends Control

@onready var panel = $Panel
@onready var slots = $Panel/CardSlots.get_children()
@onready var wizard_texture = $Panel/WizardTexture
@onready var message_label = $Panel/MessageLabel
@onready var close_button = $Panel/CloseButton
@onready var item_card_scene = preload("res://trade_item_card.tscn")

@export var scenes: Array[PackedScene]

var greeting_messages = [
    "Ahh... another wanderer seeks my wares. Step closer",
    "Welcome, traveler. Fortune has guided you to my humble collection",
    "The arcane market is open. Spend wisely",
    "Every trinket tells a tale. Which shall become yours?",
    "Browse as long as you wish. Time flows strangely",
    "Greetings, seeker. Power comes at a price",
    "My shelves are filled with curiosities...",
    "Come, come! Magic grows dull if left unsold"
]

var purchase_messages = [
    "A wise investment. May it serve you well.",
    "The deal is sealed. The magic is now yours",
    "Excellent choice. Even the stars approve",
    "Our bargain is complete",
    "May this gift bend fate in your favor",
    "The enchantment answers to a new master",
    "Gold fades, but power endures",
    "Another satisfied customer. Delightful"
]

var out_of_stock_messages = [
    "Well now... you've bought every last item I possessed",
    "You've left me with nothing but empty shelves and fond memories",
    "The shop is bare. I must gather more curiosities before your next visit",
    "You have claimed all my wares. Even I did not foresee that",
    "Nothing remains for sale, traveler. My inventory is exhausted",
    "You've purchased my entire collection. Business has been... exceptionally good",
    "You really bought everything? I wasn't expecting that",
    "Congratulations. You are now the proud owner of my entire inventory"
]

var goodbye_messages = [
    "May the winds of fate guide your path",
    "Until our paths cross beneath another moon",
    "Farewell, traveler. Spend your strength wisely",
    "Go now. My shelves shall remember you",
    "The arcane doors remain open to worthy souls",
    "May your enemies regret letting you leave alive",
    "Return whenever destiny calls",
    "Safe travels... and may your luck outlive your courage"
]

var is_out_of_stock = false

func _ready() -> void:
    load_menu_items()

    var tween = create_tween()
    tween.set_loops()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(wizard_texture, "rotation_degrees", 5.0, 5.0)
    tween.tween_property(wizard_texture, "rotation_degrees", -5.0, 5.0)

func _on_item_purchased() -> void:
    message_label.text = ""
    message_label.text = "[type speed=100]%s[/type]" % purchase_messages.pick_random()

    var sold_slots = []

    for slot in slots:
        if slot.get_child_count() != 0:
            slot.get_child(0).check_availability()

            await get_tree().process_frame

            if slot.get_child(0).out_of_stock_label.modulate != Color.TRANSPARENT:
                sold_slots.append(slots)

    if sold_slots.size() == slots.size():
        is_out_of_stock = true

        message_label.text = "[type speed=100]%s[/type]" % out_of_stock_messages.pick_random()

func _on_close_button_pressed() -> void:
    Game.hud.click_sfx_player.play()

    hide_menu()

func load_menu_items() -> void:
    for slot in slots:
        for child in slot.get_children():
            child.queue_free()

    var pool = scenes.duplicate()
    pool.shuffle()

    for slot in slots:
        if pool.is_empty():
            break

        var eligible_scenes: Array[PackedScene] = []
        var matching_scenes: Array[PackedScene] = []

        var preferred_tier = Game.pick_tier()

        for scene in pool:
            if not is_scene_eligible(scene):
                continue

            eligible_scenes.append(scene)

            var instance = scene.instantiate()
            var tier = -1

            if instance is Item:
                tier = instance.item_tier
            elif instance is PlayerUpgrade:
                tier = instance.upgrade_tier

            instance.free()

            if tier == preferred_tier:
                matching_scenes.append(scene)

        var candidates = matching_scenes if not matching_scenes.is_empty() else eligible_scenes

        if candidates.is_empty():
            break

        var scene: PackedScene = candidates.pick_random()
        pool.erase(scene)

        var instance = scene.instantiate()

        if instance is Key:
            instance.item_tier = -1

        instance._ready()

        var item_card = item_card_scene.instantiate()
        item_card.item = instance
        slot.add_child(item_card)
        item_card.connect("purchased", _on_item_purchased)

func is_scene_eligible(scene: PackedScene) -> bool:
    var instance = scene.instantiate()
    var eligible = true

    if instance is PlayerUpgrade:
        if Game.player.upgrades.size() >= Game.player.max_upgrades:
            eligible = false

        var current_stacks = 0

        for upgrade in Game.player.upgrades:
            if upgrade.get_script() == instance.get_script():
                current_stacks += 1

        if instance.max_stacks != -1 and current_stacks >= instance.max_stacks:
            eligible = false

    instance.free()

    return eligible

func show_menu() -> void:
    message_label.text = ""

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

    await tween.finished

    close_button.disabled = false

    if is_out_of_stock:
        message_label.text = "[type speed=100]%s[/type]" % out_of_stock_messages.pick_random()
    else:
        message_label.text = "[type speed=100]%s[/type]" % greeting_messages.pick_random()

func hide_menu() -> void:
    close_button.disabled = true

    message_label.text = "[type speed=100]%s[/type]" % goodbye_messages.pick_random()

    await get_tree().create_timer(1.0).timeout

    var tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)

    tween.tween_property(panel, "global_position", Vector2(320.0, -832.0), 1.0)

    await tween.finished

    Game.player.can_play = true

    Game.player.velocity = Vector2.ZERO
    Game.player.direction = Vector2.ZERO

    Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
