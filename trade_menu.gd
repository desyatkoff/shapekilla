extends Control

@onready var panel = $Panel
@onready var slots = $Panel/CardSlots.get_children()
@onready var message_label = $Panel/WizardTexture/MessageLabel
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
                    if instance is Key:
                        instance.item_tier = -1

                    instance._ready()

                    if instance is Item:
                        if instance.item_tier == Game.pick_tier():
                            item_card.item = instance
                            fslot.add_child(item_card)
                            free_slots.erase(fslot)
                            item_card.connect("purchased", _on_item_purchased)
                    elif instance is PlayerUpgrade:
                        if instance.upgrade_tier == Game.pick_tier():
                            var current_stacks = 0

                            for upgrade in Game.player.upgrades:
                                if upgrade.get_script() == instance.get_script():
                                    current_stacks += 1

                            if current_stacks < instance.max_stacks or instance.max_stacks == -1:
                                item_card.item = instance
                                fslot.add_child(item_card)
                                free_slots.erase(fslot)
                                item_card.connect("purchased", _on_item_purchased)

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
