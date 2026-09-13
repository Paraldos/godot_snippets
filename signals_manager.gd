extends Node

# Global signal bus for communication between unrelated systems.
# Register this script as an Autoload named SignalsManager.
#
# Example:
# The player emits a signal:
# SignalsManager.example.emit()
#
# The UI connects to it in _ready():
# SignalsManager.example.connect(_on_example)
#
# _on_example() is then called whenever the signal is emitted -> super simple

signal example
