extends Panel


func _ready():
    self.hide()

func _on_deck_info_open_button_pressed():
    self.show()

func _on_button_pressed():
    self.hide()