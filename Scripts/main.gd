extends Node

func _on_player_andar_sound():
	$AudioContainer/Andar.play()

func _on_player_dash_sound():
	$AudioContainer/Dash.play()

func _on_tree_talar_sound():
	$AudioContainer/Talar.play()
