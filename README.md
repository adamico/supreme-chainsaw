# Supreme Chainsaw - Godot Game with Room System

A 2D game for Godot 4 featuring player movement, interaction, state management, and an extensible room system with different room types and features.

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

### Room System
- **Extensible Room Architecture**: Base Room class that can be extended for different room types
- **BattleRoom**: Combat-focused rooms with enemies, obstacles, and health packs
- **TreasureRoom**: Exploration-focused rooms with treasure chests, collectibles, and special items
- **Dynamic Feature Spawning**: Smart placement of room features avoiding player spawn points
- **Room Management**: Automatic or manual switching between different room types

## Project Structure

### Core Files
- `project.godot` - Main project configuration with input mappings
- `player.gd` - Main player controller script
- `player.tscn` - Player scene with CharacterBody2D, Sprite2D, CollisionShape2D, and AnimationPlayer

### Room System
- `room.gd` - Base Room class with feature spawning capabilities
- `room.tscn` - Basic room scene with Room script attached
- `battle_room.gd` - BattleRoom implementation with combat features
- `battle_room.tscn` - BattleRoom scene
- `treasure_room.gd` - TreasureRoom implementation with collectible features
- `treasure_room.tscn` - TreasureRoom scene
- `room_manager.gd` - Manages switching between different room types
- `main_with_rooms.tscn` - Main scene that uses the RoomManager system

### Legacy Files
- `room.tscn` - Original simple room scene
- `main.tscn` - Original main scene that loads the simple Room scene

## Input Mappings

| Action | Keys | Description |
|--------|------|-------------|
| move_left | A, Left Arrow | Move player left |
| move_right | D, Right Arrow | Move player right |
| move_up | W, Up Arrow | Move player up |
| move_down | S, Down Arrow | Move player down |
| interact | E, Space | Interact with objects/features |
| ui_accept | Enter | Switch to random room (when using RoomManager) |

## Usage

### Basic Room System
1. Open the project in Godot 4
2. Run the project (`main.tscn` loads the basic room)
3. Use WASD or arrow keys to move
4. Press E or Space to interact with spawned features

### Advanced Room System
1. Set `main_with_rooms.tscn` as the main scene in project settings
2. Run the project to experience automatic room switching
3. Press Enter to manually switch rooms
4. Explore different room types and their unique features

## Room System Architecture

### Base Room Class
The `Room` class provides the foundation for all room types:
- **Feature Spawning**: Generates spawn points and places features strategically
- **Player Integration**: Automatically finds and integrates with the player
- **Extensible Design**: Virtual methods that can be overridden by specific room types
- **Feature Management**: Tracks spawned features and provides cleanup methods

### Room Types

#### BattleRoom
Combat-focused room with:
- **Enemies**: AI-controlled red squares that follow the player within detection range
- **Obstacles**: Gray barriers for tactical gameplay and cover
- **Health Packs**: Green cross items that heal the player when collected

#### TreasureRoom  
Exploration-focused room with:
- **Treasure Chests**: High-value brown chests with golden locks
- **Collectibles**: Coins (gold), gems (cyan), and rings (magenta) with different values
- **Special Items**: Rare purple glowing items with high value and visual effects
- **Progress Tracking**: Monitors collection progress and completion status

### Features

#### Spawning System
- **Smart Placement**: Features spawn at strategic points while avoiding the player
- **Configurable Density**: Adjustable number of features per room type
- **Collision Avoidance**: Prevents overlapping features and ensures playable space

#### Feature Types
- `ENEMY` - AI-controlled entities that interact with the player
- `OBSTACLE` - Static collision objects for tactical gameplay
- `TREASURE_CHEST` - High-value collectible containers
- `COLLECTIBLE` - Various valuable items (coins, gems, rings)
- `HEALTH_PACK` - Player healing items

## Extending the Player

The `Player.gd` script is designed to be easily extensible:

- Add new states to the `PlayerState` enum
- Implement state-specific behavior in `_enter_state()` and `_exit_state()`
- Extend `_check_for_interactables()` to detect nearby objects
- Add animations to the AnimationPlayer node
- Customize movement constants (SPEED, ACCELERATION, FRICTION)

## Extending the Room System

### Creating New Room Types
1. Create a new script extending the `Room` class
2. Override `_spawn_room_features()` to implement unique spawning logic
3. Override `_create_feature()` to add custom feature types
4. Create a corresponding `.tscn` scene file
5. Add the new room to the `RoomManager` if desired

### Adding New Features
1. Add new feature types to the `FeatureType` enum in `room.gd`
2. Implement creation logic in the room's `_create_feature()` method
3. Add any special interaction logic or visual effects
4. Configure spawn parameters in the room type's export variables

## Public Methods

### Player Methods
- `get_current_state()` - Returns the current player state
- `is_moving()` - Returns true if player is moving
- `can_interact()` - Returns true if player can interact
- `force_state_change(state)` - Forces a state change (useful for cutscenes)

### Room Methods
- `get_room_type()` - Returns the room's type
- `get_spawned_features()` - Returns array of all spawned features
- `clear_features()` - Removes all features from the room
- `respawn_features()` - Clears and respawns all features

### TreasureRoom Specific Methods
- `is_treasure_room_complete()` - Returns true if all treasure collected
- `get_collection_progress()` - Returns completion percentage (0.0 to 1.0)

### RoomManager Methods
- `load_room_by_type(type)` - Loads a specific room type
- `switch_to_battle_room()` - Switches to BattleRoom
- `switch_to_treasure_room()` - Switches to TreasureRoom
- `get_current_room()` - Returns the current room instance