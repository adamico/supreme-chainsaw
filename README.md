# Supreme Chainsaw - Godot Player Script

A 2D player controller for Godot 4 with movement, interaction, and state management.

## Features

### Player Movement
- **WASD** or **Arrow Keys** for movement
- Smooth acceleration and deceleration
- Normalized diagonal movement for consistent speed
- Physics-based movement using CharacterBody2D

### Interaction System
- **E** or **Spacebar** to interact
- Extensible interaction system ready for objects, NPCs, items
- State-based interaction handling

### State Machine
- **IDLE**: Player is stationary
- **MOVING**: Player is moving
- **INTERACTING**: Player is performing an interaction (0.5s duration)

### Animation System
- Sprite flipping based on movement direction
- Animation support for idle, walk, and interact states
- Fallback system when no AnimationPlayer is present

## Project Structure

- `project.godot` - Main project configuration with input mappings
- `Player.gd` - Main player controller script
- `Player.tscn` - Player scene with CharacterBody2D, Sprite2D, CollisionShape2D, and AnimationPlayer
- `Main.tscn` - Example scene with player positioned in center

## Input Mappings

| Action | Keys |
|--------|------|
| move_left | A, Left Arrow |
| move_right | D, Right Arrow |
| move_up | W, Up Arrow |
| move_down | S, Down Arrow |
| interact | E, Space |

## Usage

1. Open the project in Godot 4
2. Run the project (Main.tscn will load automatically)
3. Use WASD or arrow keys to move
4. Press E or Space to interact
5. Check the console for state changes and interaction messages

## Extending the Player

The `Player.gd` script is designed to be easily extensible:

- Add new states to the `PlayerState` enum
- Implement state-specific behavior in `_enter_state()` and `_exit_state()`
- Extend `_check_for_interactables()` to detect nearby objects
- Add animations to the AnimationPlayer node
- Customize movement constants (SPEED, ACCELERATION, FRICTION)

## Public Methods

- `get_current_state()` - Returns the current player state
- `is_moving()` - Returns true if player is moving
- `can_interact()` - Returns true if player can interact
- `force_state_change(state)` - Forces a state change (useful for cutscenes)