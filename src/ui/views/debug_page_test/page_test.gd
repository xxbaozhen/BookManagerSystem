@tool
extends Control

@export var window_size := Vector2(0, 0);

func _ready() -> void:
    custom_minimum_size = window_size